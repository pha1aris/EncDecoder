`timescale 1ns/1ps

module rs_deinterleaver_xpm #(
    parameter integer D = 4808, 
    parameter integer N = 255   
)(
    input  wire         clk,
    input  wire         rst,          // 高有效全局复位
    input  wire         blk_soft_rst, // 块级软复位

    // 输入接口
    input  wire         in_valid,
    input  wire [7:0]   in_data,
    output wire         in_ready,     

    // 输出接口
    output reg          out_valid,
    output reg  [7:0]   out_data,    
    output reg          block_start
);

    // ============================================================
    // 1. 参数定义
    // ============================================================
    localparam integer MEM_ADDR_W = 20;
    localparam integer MAX_DEPTH  = (1 << MEM_ADDR_W); 
    localparam integer MAX_D      = MAX_DEPTH / N;      
    localparam integer D_EFF      = (D > MAX_D) ? MAX_D : D;
    localparam integer TOTAL_SYM  = D_EFF * N;          

    localparam integer ROW_W      = $clog2(D_EFF);
    localparam integer COL_W      = $clog2(N);
    localparam integer SYM_IDX_W  = MEM_ADDR_W;

   // ============================================================
    // 2. 写逻辑 (只管写 bank，读 bank 由读侧自己锁存)
    // ============================================================
    reg  [ROW_W-1:0]     wr_row;
    reg  [COL_W-1:0]     wr_col;
    wire [SYM_IDX_W-1:0] wr_row_mul_255 = (wr_row << 8) - wr_row;
    wire [SYM_IDX_W-1:0] wr_sym_idx     = wr_row_mul_255 + wr_col;

    reg  [SYM_IDX_W-1:0] wr_cnt;       // 0..TOTAL_SYM-1
    reg                  wr_bank;      // 当前正在写的 bank
    reg                  kick_read;    // 写满一整块后的“通知读侧”脉冲

    assign in_ready = !rst;
    wire   wr_fire  = in_valid && in_ready;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_row    <= 0;
            wr_col    <= 0;
            wr_cnt    <= 0;
            wr_bank   <= 1'b0;
            kick_read <= 1'b0;
        end else if (blk_soft_rst) begin
            wr_row    <= 0;
            wr_col    <= 0;
            wr_cnt    <= 0;
            wr_bank   <= 1'b0;
            kick_read <= 1'b0;
        end else begin
            kick_read <= 1'b0;  // 默认拉低

            if (wr_fire) begin
                // 按列写：Row 变快，Col 变慢
                if (wr_row == D_EFF-1) begin
                    wr_row <= 0;
                    if (wr_col == N-1)
                        wr_col <= 0;
                    else
                        wr_col <= wr_col + 1'b1;
                end else begin
                    wr_row <= wr_row + 1'b1;
                end

                // 计数：写满一整块时产生 kick_read，并翻写 bank
                if (wr_cnt == TOTAL_SYM-1) begin
                    wr_cnt    <= 0;
                    kick_read <= 1'b1;          // 通知读端：某个 bank 写满
                    wr_bank   <= ~wr_bank;      // 准备写下一块到另一侧 bank
                end else begin
                    wr_cnt <= wr_cnt + 1'b1;
                end
            end
        end
    end

    wire wea0 = wr_fire && (wr_bank == 1'b0);
    wire wea1 = wr_fire && (wr_bank == 1'b1);
// ============================================================
// 3. 读逻辑：被动，根据 kick_read 启动一次整块读取
// ============================================================
    reg [SYM_IDX_W-1:0] rd_sym_idx;
    reg                 rd_busy;
    wire rd_fire = rd_busy;

    // 哪个 bank 正在被读（锁存）：
    reg rd_bank_latch;

    // 在写侧产生 kick_read 的那一拍，
    // 刚刚被“写满”的 bank 其实是 ~wr_bank（因为上面那拍 toggled wr_bank 准备下一块）
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_bank_latch <= 1'b0;
        end else if (blk_soft_rst) begin
            rd_bank_latch <= 1'b0;
        end else if (kick_read) begin
            rd_bank_latch <= ~wr_bank;  // ★ 这一拍 ~wr_bank 就是刚刚写满的 bank
        end
    end

    // 地址 & block_start
    reg block_start_addr;
    wire block_end_addr = (rd_sym_idx == TOTAL_SYM-1);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_sym_idx       <= 0;
            rd_busy          <= 1'b0;
            block_start_addr <= 1'b0;
        end else if (blk_soft_rst) begin
            rd_sym_idx       <= 0;
            rd_busy          <= 1'b0;
            block_start_addr <= 1'b0;
        end else begin
            block_start_addr <= 1'b0;

            if (kick_read) begin
                // 有整块数据可读：启动一次线性读
                rd_busy    <= 1'b1;
                rd_sym_idx <= 0;
            end else if (rd_busy) begin
                if (rd_sym_idx == 0)
                    block_start_addr <= 1'b1;

                if (rd_sym_idx == TOTAL_SYM-1) begin
                    rd_busy    <= 1'b0;
                    rd_sym_idx <= 0;
                end else begin
                    rd_sym_idx <= rd_sym_idx + 1'b1;
                end
            end
        end
    end

    // ============================================================
    // 4. XPM 存储器实例化
    // ============================================================
    wire [7:0] doutb0, doutb1;

    xpm_memory_tdpram #(
        .ADDR_WIDTH_A(MEM_ADDR_W), .ADDR_WIDTH_B(MEM_ADDR_W),
        .MEMORY_SIZE(MAX_DEPTH * 8),    .READ_LATENCY_B(1),
        .WRITE_DATA_WIDTH_A(8),    .READ_DATA_WIDTH_B(8)
    ) u_ram0 (
        .clka(clk), .addra(wr_sym_idx), .dina(in_data), .wea(wea0), .ena(1'b1),
        .clkb(clk), .addrb(rd_sym_idx),    .doutb(doutb0), .enb(rd_fire && (rd_bank_latch==1'b0)), 
        .rsta(rst), .rstb(rst), .regcea(1'b1), .regceb(1'b1), .web(1'b0)
    );

    xpm_memory_tdpram #(
        .ADDR_WIDTH_A(MEM_ADDR_W), .ADDR_WIDTH_B(MEM_ADDR_W),
        .MEMORY_SIZE(MAX_DEPTH * 8),    .READ_LATENCY_B(1),
        .WRITE_DATA_WIDTH_A(8),    .READ_DATA_WIDTH_B(8)
    ) u_ram1 (
        .clka(clk), .addra(wr_sym_idx), .dina(in_data), .wea(wea1), .ena(1'b1),
        .clkb(clk), .addrb(rd_sym_idx),    .doutb(doutb1), .enb(rd_fire && (rd_bank_latch==1'b1)),
        .rsta(rst), .rstb(rst), .regcea(1'b1), .regceb(1'b1), .web(1'b0)
    );

    // ============================================================
    // 5. 输出流水线对齐 (Latency = 1 cycle)
    // ============================================================
    reg rd_fire_d1;
    reg block_start_addr_d1;
    reg block_end_addr_d1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_fire_d1          <= 1'b0;
            block_start_addr_d1 <= 1'b0;
            block_end_addr_d1   <= 1'b0;
            out_valid           <= 1'b0; 
            out_data            <= 8'd0; 
            block_start         <= 1'b0; 
        end else begin
            rd_fire_d1          <= rd_fire;
            block_start_addr_d1 <= block_start_addr;
            block_end_addr_d1   <= block_end_addr;

            if (rd_fire_d1) 
                out_data <= (rd_bank_latch == 1'b0) ? doutb0 : doutb1;
            else 
                out_data <= 8'd0;

            block_start <= block_start_addr;
            out_valid   <= rd_fire_d1; 
        end
    end

    // 简单监控
    always @(posedge clk) begin
        if (wr_fire)
            $display("DEINT IN : data=%0d", in_data);
        if (out_valid)
            $display("DEINT OUT: data=%0d", out_data);
    end

endmodule
