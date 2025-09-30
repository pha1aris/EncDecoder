`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Module Name: pre_interleaver_v3_robust
//
// Description:
//   v3 最终健壮版 - 发送端块交织器 (pre-interleaver)
//   特点：
//     - my_clog2 (安全处理小参数)
//     - Verilog-2001 兼容的一维平展内存 (便于 BRAM 推断)
//     - 写/读逻辑合并到时序块（BRAM 友好）
//     - s_axis_tready 注册化（握手更稳）
//     - 保持“列写 / 行读”语义（写: wr_ram_sel 快, wr_addr慢；读: rd_addr 快, rd_ram_sel 慢）
//
//////////////////////////////////////////////////////////////////////////////////
module pre_interleaver_v2 #(
    parameter integer FRAME_SIZE_IN_WORDS = 70,
    parameter integer NUM_CODEWORDS       = 4
)(
    input  wire                          clk,
    input  wire                          rst,

    // 输入接口 (AXIS-like, from Sync module)
    input  wire [31:0]                   s_axis_tdata,
    input  wire                          s_axis_tvalid,
    output wire                          s_axis_tready,

    // 输出接口 (AXIS-like, to DDR4 Interleaver)
    output reg  [31:0]                   m_axis_tdata,
    output reg                           m_axis_tvalid,
    input  wire                          m_axis_tready
);

    // -------------------------
    // Safe clog2 function
    // -------------------------
    function integer my_clog2;
        input integer value;
        integer i;
        begin
            my_clog2 = 0;
            for (i = value - 1; i > 0; i = i >> 1)
                my_clog2 = my_clog2 + 1;
        end
    endfunction

    // -------------------------
    // widths and derived params
    // -------------------------
    localparam ADDR_W   = (FRAME_SIZE_IN_WORDS < 2) ? 1 : my_clog2(FRAME_SIZE_IN_WORDS);
    localparam RAMSEL_W = (NUM_CODEWORDS       < 2) ? 1 : my_clog2(NUM_CODEWORDS);
    localparam TOTAL_WORDS = FRAME_SIZE_IN_WORDS * NUM_CODEWORDS;
    localparam IDX_W = (TOTAL_WORDS < 2) ? 1 : my_clog2(TOTAL_WORDS);

    // -------------------------
    // Flattened memory (Verilog-2001 friendly)
    // -------------------------
    reg [31:0] mem_flat [0:TOTAL_WORDS-1];

    // -------------------------
    // State & pointers
    // -------------------------
    // ping/pong buffers: 0=ping, 1=pong
    reg wr_ping, rd_ping;
    reg ping_full, pong_full;
    reg ping_ready_to_read, pong_ready_to_read;

    reg [ADDR_W-1:0]   wr_addr;
    reg [RAMSEL_W-1:0] wr_ram_sel;
    reg [ADDR_W-1:0]   rd_addr;
    reg [RAMSEL_W-1:0] rd_ram_sel;

    // -------------------------
    // Registered ready (improves timing)
    // -------------------------
    reg s_axis_tready_r;
    assign s_axis_tready = s_axis_tready_r;

    wire wr_fire = s_axis_tvalid && s_axis_tready_r;
    wire rd_fire = m_axis_tvalid && m_axis_tready;

    // -------------------------
    // Linear indices:
    // For column-write: wr_ram_sel changes fastest, then wr_addr
    // -> linear index = wr_ram_sel * FRAME_SIZE + wr_addr
    // For row-read: rd_addr changes fastest, then rd_ram_sel
    // -> linear index = rd_ram_sel * FRAME_SIZE + rd_addr
    // -------------------------
    wire [IDX_W-1:0] wr_idx = (wr_ram_sel * FRAME_SIZE_IN_WORDS) + wr_addr;
    wire [IDX_W-1:0] rd_idx = (rd_ram_sel * FRAME_SIZE_IN_WORDS) + rd_addr;

    // -------------------------
    // s_axis_tready register update
    // -------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            s_axis_tready_r <= 1'b0;
        end else begin
            s_axis_tready_r <= (wr_ping == 1'b0) ? ~ping_full : ~pong_full;
        end
    end

    // -------------------------
    // Write logic (column-write)
    // - writer: for each address (wr_addr), write to ram_sel=0..NUM-1 (wr_ram_sel fast)
    // - when all NUM_CODEWORDS written for a given address, increment wr_addr
    // - when wr_addr reaches FRAME_SIZE_IN_WORDS-1 and wr_ram_sel loops, mark buffer full and switch ping/pong
    // -------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_addr    <= {ADDR_W{1'b0}};
            wr_ram_sel <= {RAMSEL_W{1'b0}};
            wr_ping    <= 1'b0;
            ping_full  <= 1'b0;
            pong_full  <= 1'b0;
        end else begin
            if (wr_fire) begin
                // write incoming word into flattened memory
                mem_flat[wr_idx] <= s_axis_tdata;

                // update write selectors: wr_ram_sel is fastest
                if (wr_ram_sel == NUM_CODEWORDS - 1) begin
                    wr_ram_sel <= {RAMSEL_W{1'b0}};
                    // finished writing all codewords for current wr_addr
                    if (wr_addr == FRAME_SIZE_IN_WORDS - 1) begin
                        wr_addr <= {ADDR_W{1'b0}};
                        // mark buffer full (use old wr_ping), then switch
                        if (wr_ping == 1'b0) ping_full <= 1'b1;
                        else                 pong_full <= 1'b1;
                        wr_ping <= ~wr_ping;
                    end else begin
                        wr_addr <= wr_addr + 1;
                    end
                end else begin
                    wr_ram_sel <= wr_ram_sel + 1;
                end
            end
        end
    end

    // -------------------------
    // Read logic (row-read)
    // - reader: for each codeword (rd_ram_sel), read FRAME_SIZE words (rd_addr fast)
    // - rd_addr changes fastest so output is row-wise
    // -------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_addr <= {ADDR_W{1'b0}};
            rd_ram_sel <= {RAMSEL_W{1'b0}};
            rd_ping <= 1'b0;
            ping_ready_to_read <= 1'b0;
            pong_ready_to_read <= 1'b0;
            m_axis_tvalid <= 1'b0;
            m_axis_tdata <= 32'h0;
        end else begin
            // when writer marks buffer full, mark ready-to-read
            if (ping_full) ping_ready_to_read <= 1'b1;
            if (pong_full) pong_ready_to_read <= 1'b1;

            if (rd_fire) begin
                // after successful handshake, deassert tvalid
                m_axis_tvalid <= 1'b0;

                // advance read pointers: rd_addr is fastest
                if (rd_addr == FRAME_SIZE_IN_WORDS - 1) begin
                    rd_addr <= {ADDR_W{1'b0}};
                    if (rd_ram_sel == NUM_CODEWORDS - 1) begin
                        rd_ram_sel <= {RAMSEL_W{1'b0}};
                        // finished reading an entire buffer, switch ping/pong
                        rd_ping <= ~rd_ping;
                        // mark buffer empty (use old rd_ping)
                        if (rd_ping == 1'b0) begin
                            ping_ready_to_read <= 1'b0;
                            ping_full <= 1'b0;
                        end else begin
                            pong_ready_to_read <= 1'b0;
                            pong_full <= 1'b0;
                        end
                    end else begin
                        rd_ram_sel <= rd_ram_sel + 1;
                    end
                end else begin
                    rd_addr <= rd_addr + 1;
                end
            end

            // present next word if buffer ready and no current valid outstanding
            if (((rd_ping == 1'b0 && ping_ready_to_read) || (rd_ping == 1'b1 && pong_ready_to_read)) && !m_axis_tvalid) begin
                m_axis_tdata  <= mem_flat[rd_idx];
                m_axis_tvalid <= 1'b1;
            end
        end
    end

endmodule
