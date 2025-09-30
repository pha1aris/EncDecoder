`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Module Name: pre_interleaver_v3_robust
//
// Description:
//   v3 最终健壮版 - 发送端块交织器 (pre-interleaver)
//   - 特点: my_clog2, 注册化tready, 显式双缓冲, BRAM友好
//   - 核心功能: "列写 / 行读" (Column-Write / Row-Read)
//   - [优化] 采用同步读取方式，提高时序性能
//
//////////////////////////////////////////////////////////////////////////////////
module pre_interleaver_v3_robust #(
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

    // =========================
    // Safe clog2 function
    // =========================
    function integer my_clog2;
        input integer value;
        integer i;
        begin
            my_clog2 = 0;
            for (i = value - 1; i > 0; i = i >> 1)
                my_clog2 = my_clog2 + 1;
        end
    endfunction

    // =========================
    // Derived widths and sizes
    // =========================
    localparam ADDR_W      = (FRAME_SIZE_IN_WORDS < 2) ? 1 : my_clog2(FRAME_SIZE_IN_WORDS);
    localparam RAMSEL_W    = (NUM_CODEWORDS < 2) ? 1 : my_clog2(NUM_CODEWORDS);
    localparam WORDS_PER_BUFFER = FRAME_SIZE_IN_WORDS * NUM_CODEWORDS;
    localparam TOTAL_WORDS = WORDS_PER_BUFFER * 2;
    localparam IDX_W       = (TOTAL_WORDS < 2) ? 1 : my_clog2(TOTAL_WORDS);

    // --- 内存与地址 ---
    reg [31:0] mem_flat [0:TOTAL_WORDS-1];
    wire [IDX_W-1:0] wr_linear_idx;
    wire [IDX_W-1:0] rd_linear_idx;

    // --- 状态与指针 ---
    reg wr_ping, rd_ping;
    reg ping_full, pong_full;
    reg ping_ready_to_read, pong_ready_to_read;
    reg [ADDR_W-1:0]       wr_addr;
    reg [RAMSEL_W-1:0]     wr_ram_sel;
    reg [ADDR_W-1:0]       rd_addr;
    reg [RAMSEL_W-1:0]     rd_ram_sel;
    
    // --- 注册化的 s_axis_tready ---
    reg s_axis_tready_r;
    assign s_axis_tready = s_axis_tready_r;
    always @(posedge clk or posedge rst) begin
        if (rst) s_axis_tready_r <= 1'b0;
        else     s_axis_tready_r <= (wr_ping == 0) ? !ping_full : !pong_full;
    end
    
    wire wr_fire = s_axis_tvalid && s_axis_tready_r;
    wire rd_fire = m_axis_tvalid && m_axis_tready;

    // --- 地址计算 ---
    wire [IDX_W-1:0] wr_buffer_base = wr_ping ? WORDS_PER_BUFFER : 0;
    wire [IDX_W-1:0] rd_buffer_base = rd_ping ? WORDS_PER_BUFFER : 0;
    assign wr_linear_idx = wr_buffer_base + (wr_ram_sel * FRAME_SIZE_IN_WORDS) + wr_addr;
    assign rd_linear_idx = rd_buffer_base + (rd_ram_sel * FRAME_SIZE_IN_WORDS) + rd_addr;
    
    // --- 写入逻辑 ("列写") ---
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_addr <= 0; wr_ram_sel <= 0; wr_ping <= 1'b0;
            ping_full <= 1'b0; pong_full <= 1'b0;
        end else if (wr_fire) begin
            mem_flat[wr_linear_idx] <= s_axis_tdata;
            if (wr_ram_sel == NUM_CODEWORDS - 1) begin
                wr_ram_sel <= 0;
                if (wr_addr == FRAME_SIZE_IN_WORDS - 1) begin
                    wr_addr <= 0;
                    if (wr_ping == 0) ping_full <= 1'b1;
                    else              pong_full <= 1'b1;
                    wr_ping <= ~wr_ping;
                end else begin
                    wr_addr <= wr_addr + 1;
                end
            end else begin
                wr_ram_sel <= wr_ram_sel + 1;
            end
        end
    end
    
    // --- [优化] 同步读取逻辑 ---
    reg [IDX_W-1:0] mem_rd_addr;
    reg [31:0]      mem_out;
    reg             mem_out_valid;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mem_out_valid <= 1'b0;
        end else begin
            if (rd_fire) begin
                mem_out_valid <= 1'b0;
            end
            
            if (((rd_ping == 0 && ping_ready_to_read) || (rd_ping == 1 && pong_ready_to_read)) && !mem_out_valid) begin
                mem_rd_addr <= rd_linear_idx;
                mem_out_valid <= 1'b1;
            end
        end
    end
    
    // BRAM的同步读输出寄存器
    always @(posedge clk) begin
        mem_out <= mem_flat[mem_rd_addr];
    end

    // --- 读出指针与AXI输出逻辑 ---
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_addr <= 0; rd_ram_sel <= 0; rd_ping <= 1'b0;
            ping_ready_to_read <= 1'b0; pong_ready_to_read <= 1'b0;
            m_axis_tvalid <= 1'b0; m_axis_tdata <= 32'h0;
        end else begin
            if (ping_full) ping_ready_to_read <= 1'b1;
            if (pong_full) pong_ready_to_read <= 1'b1;

            if (rd_fire) begin
                m_axis_tvalid <= 1'b0;
                // "行读": rd_addr最快
                if (rd_addr == FRAME_SIZE_IN_WORDS - 1) begin
                    rd_addr <= 0;
                    if (rd_ram_sel == NUM_CODEWORDS - 1) begin
                        rd_ram_sel <= 0;
                        rd_ping <= ~rd_ping;
                        if (rd_ping == 0) begin ping_ready_to_read <= 1'b0; ping_full <= 1'b0; end
                        else              begin pong_ready_to_read <= 1'b0; pong_full <= 1'b0; end
                    end else begin
                        rd_ram_sel <= rd_ram_sel + 1;
                    end
                end else begin
                    rd_addr <= rd_addr + 1;
                end
            end

            if (mem_out_valid && !m_axis_tvalid) begin
                m_axis_tdata  <= mem_out;
                m_axis_tvalid <= 1'b1;
            end
        end
    end
endmodule

