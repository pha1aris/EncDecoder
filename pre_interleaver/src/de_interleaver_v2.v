`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Module Name: de_interleaver_v3_robust
//
// Description:
//   v3 最终健壮版 - 融合建议后的块解交织器 (接收端)
//   特点：
//     - my_clog2 (安全处理小参数)
//     - Verilog-2001 兼容的一维平展内存 (便于 BRAM 推断)
//     - 写地址与写数据合并为单 always（BRAM 友好）
//     - s_axis_tready 注册化（握手更稳）
//     - sync_reset_i 用作来自同步模块的“帧对齐脉冲” —— 仅复位写指针
//     - 语义：行写 (writer fills rows across codewords) / 列读 (reader reads column-wise)
//
//////////////////////////////////////////////////////////////////////////////////
module de_interleaver_v2 #(
    parameter integer FRAME_SIZE_IN_WORDS = 70,
    parameter integer NUM_CODEWORDS       = 4
)(
    input  wire                          clk,
    input  wire                          rst,
    input  wire                          sync_reset_i,     // 上游同步检测模块的对齐脉冲（one-cycle pulse at frame boundary）

    // 输入 (From sync detector)
    input  wire [31:0]                   s_axis_tdata,
    input  wire                          s_axis_tvalid,
    output wire                          s_axis_tready,

    // 输出 (To downstream)
    output reg  [31:0]                   m_axis_tdata,
    output reg                           m_axis_tvalid,
    input  wire                          m_axis_tready
);

    // -------------------------
    // Safe clog2 function (handles value <= 1)
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
    // Widths and derived params
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
    reg wr_ping, rd_ping;              // 0 = ping, 1 = pong
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

    // -------------------------
    // Handshake wires
    // -------------------------
    wire wr_fire = s_axis_tvalid && s_axis_tready_r;
    wire rd_fire = m_axis_tvalid && m_axis_tready;

    // -------------------------
    // Index computations (linear addresses)
    // For row-write: writer fills WR_ADDR across FRAME, then increments WR_RAM_SEL.
    // For column-read: reader iterates RD_RAM_SEL rapidly, RD_ADDR slowly.
    // -------------------------
    // Note: multiplication and addition are synthesis-friendly for index calculations.
    wire [IDX_W-1:0] wr_idx = (wr_ram_sel * FRAME_SIZE_IN_WORDS) + wr_addr;
    wire [IDX_W-1:0] rd_idx = (rd_ram_sel * FRAME_SIZE_IN_WORDS) + rd_addr;

    // -------------------------
    // s_axis_tready register update
    // -------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            s_axis_tready_r <= 1'b0;
        end else begin
            // if current write buffer is ping, ready if ping not full; else check pong
            s_axis_tready_r <= (wr_ping == 1'b0) ? ~ping_full : ~pong_full;
        end
    end

    // -------------------------
    // Write logic (row-write) -- single always block writing mem_flat
    // - sync_reset_i resets write pointers (wr_addr, wr_ram_sel) to align to new frame
    // - sync_reset_i DOES NOT clear ping_full/pong_full so already-completed blocks are preserved
    // -------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // complete reset
            wr_addr    <= {ADDR_W{1'b0}};
            wr_ram_sel <= {RAMSEL_W{1'b0}};
            wr_ping    <= 1'b0;
            ping_full  <= 1'b0;
            pong_full  <= 1'b0;
        end else begin
            if (sync_reset_i) begin
                // frame-alignment pulse: restart writing at frame boundary
                // Keep ping_full/pong_full so reader can still drain filled buffers.
                wr_addr    <= {ADDR_W{1'b0}};
                wr_ram_sel <= {RAMSEL_W{1'b0}};
                // do not alter wr_ping/ping_full/pong_full here
            end else if (wr_fire) begin
                // write incoming word into flattened memory
                mem_flat[wr_idx] <= s_axis_tdata;

                // update write address/selector
                if (wr_addr == FRAME_SIZE_IN_WORDS - 1) begin
                    wr_addr <= {ADDR_W{1'b0}};
                    if (wr_ram_sel == NUM_CODEWORDS - 1) begin
                        // just finished writing last ram of this buffer -> mark buffer full and switch
                        wr_ram_sel <= {RAMSEL_W{1'b0}};
                        if (wr_ping == 1'b0) begin
                            ping_full <= 1'b1;
                        end else begin
                            pong_full <= 1'b1;
                        end
                        wr_ping <= ~wr_ping;
                    end else begin
                        wr_ram_sel <= wr_ram_sel + 1;
                    end
                end else begin
                    wr_addr <= wr_addr + 1;
                end
            end
        end
    end

    // -------------------------
    // Read logic (column-read)
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
            // once a buffer is marked full by writer, mark it ready to read (1-cycle later implicitly)
            if (ping_full) ping_ready_to_read <= 1'b1;
            if (pong_full) pong_ready_to_read <= 1'b1;

            if (rd_fire) begin
                // after handshake complete, deassert tvalid
                m_axis_tvalid <= 1'b0;

                // update read pointers
                if (rd_ram_sel == NUM_CODEWORDS - 1) begin
                    rd_ram_sel <= {RAMSEL_W{1'b0}};
                    if (rd_addr == FRAME_SIZE_IN_WORDS - 1) begin
                        rd_addr <= {ADDR_W{1'b0}};
                        // finished reading one buffer -> switch
                        rd_ping <= ~rd_ping;
                        // mark the buffer as read/empty (use old rd_ping)
                        if (rd_ping == 1'b0) begin
                            ping_ready_to_read <= 1'b0;
                            ping_full <= 1'b0;
                        end else begin
                            pong_ready_to_read <= 1'b0;
                            pong_full <= 1'b0;
                        end
                    end else begin
                        rd_addr <= rd_addr + 1;
                    end
                end else begin
                    rd_ram_sel <= rd_ram_sel + 1;
                end
            end

            // if current read buffer is ready and downstream is free, present next word
            if (((rd_ping == 1'b0 && ping_ready_to_read) || (rd_ping == 1'b1 && pong_ready_to_read)) && !m_axis_tvalid) begin
                m_axis_tdata  <= mem_flat[rd_idx];
                m_axis_tvalid <= 1'b1;
            end
        end
    end

endmodule
