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
    output reg          block_start   // 修正：端口名为 block_start
);

    // ============================================================
    // 1. 参数定义
    // ============================================================
    localparam integer MEM_ADDR_W = 20;
    localparam integer MAX_DEPTH  = (1 << MEM_ADDR_W); 
    localparam integer MEM_SIZE   = MAX_DEPTH * 8;      
    localparam integer MAX_D      = MAX_DEPTH / N;      
    localparam integer D_EFF      = (D > MAX_D) ? MAX_D : D;
    localparam integer TOTAL_SYM  = D_EFF * N;          

    localparam integer ROW_W      = $clog2(D_EFF);
    localparam integer COL_W      = $clog2(N);
    localparam integer SYM_IDX_W  = MEM_ADDR_W;

    // ============================================================
    // 2. 写逻辑 (Master - 控制乒乓切换)
    // ============================================================
    reg  [ROW_W-1:0]     wr_row;
    reg  [COL_W-1:0]     wr_col;
    
    wire [SYM_IDX_W-1:0] wr_row_mul_255 = (wr_row << 8) - wr_row;
    wire [SYM_IDX_W-1:0] wr_sym_idx     = wr_row_mul_255 + wr_col;

    reg  [SYM_IDX_W-1:0] wr_cnt;     
    reg                  wr_bank;    
    reg                  rd_bank;    
    reg                  kick_read;  

    assign in_ready = !rst; 
    wire   wr_fire  = in_valid && in_ready;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_row    <= {ROW_W{1'b0}};
            wr_col    <= {COL_W{1'b0}};
            wr_cnt    <= {SYM_IDX_W{1'b0}};
            wr_bank   <= 1'b0; 
            rd_bank   <= 1'b1; 
            kick_read <= 1'b0;
        end else if (blk_soft_rst) begin
            wr_row    <= {ROW_W{1'b0}};
            wr_col    <= {COL_W{1'b0}};
            wr_cnt    <= {SYM_IDX_W{1'b0}};
            wr_bank   <= 1'b0;
            rd_bank   <= 1'b1;
            kick_read <= 1'b0;
        end else begin
            kick_read <= 1'b0; 

            if (wr_fire) begin
                if (wr_row == D_EFF-1) begin
                    wr_row <= {ROW_W{1'b0}};
                    if (wr_col == N-1) 
                        wr_col <= {COL_W{1'b0}};
                    else 
                        wr_col <= wr_col + 1'b1;
                end else begin
                    wr_row <= wr_row + 1'b1;
                end

                if (wr_cnt == TOTAL_SYM-1) begin
                    wr_cnt <= {SYM_IDX_W{1'b0}};
                    wr_bank    <= ~wr_bank;
                    rd_bank    <= ~rd_bank;
                    kick_read <= 1'b1; 
                end else begin
                    wr_cnt <= wr_cnt + 1'b1;
                end
            end
        end
    end

    wire wea0 = wr_fire && (wr_bank == 1'b0);
    wire wea1 = wr_fire && (wr_bank == 1'b1);

    // ============================================================
    // 3. 读逻辑 (Slave - 单次触发，读完自动停机)
    // ============================================================
    reg [SYM_IDX_W-1:0] rd_sym_idx; 
    reg                 rd_busy;    
    wire rd_fire = rd_busy; 

    reg block_start_raw;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_sym_idx      <= {SYM_IDX_W{1'b0}};
            rd_busy         <= 1'b0;
            block_start_raw <= 1'b0;
        end else if (blk_soft_rst) begin
            rd_sym_idx      <= {SYM_IDX_W{1'b0}};
            rd_busy         <= 1'b0; 
            block_start_raw <= 1'b0;
        end else begin
            block_start_raw <= 1'b0;

            if (kick_read) begin
                rd_busy    <= 1'b1;
                rd_sym_idx <= {SYM_IDX_W{1'b0}};
            end 
            else if (rd_busy) begin
                if (rd_sym_idx == 0) begin
                    block_start_raw <= 1'b1; // 标记第一个数
                end

                if (rd_sym_idx == TOTAL_SYM-1) begin
                    rd_busy    <= 1'b0; 
                    rd_sym_idx <= {SYM_IDX_W{1'b0}};
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
        .MEMORY_SIZE(MEM_SIZE),    .READ_LATENCY_B(1),
        .WRITE_DATA_WIDTH_A(8),    .READ_DATA_WIDTH_B(8)
    ) u_ram0 (
        .clka(clk), .addra(wr_sym_idx), .dina(in_data), .wea(wea0), .ena(1'b1),
        .clkb(clk), .addrb(rd_sym_idx), .doutb(doutb0), .enb(rd_fire && (rd_bank == 1'b0)), 
        .rsta(rst), .rstb(rst), .regcea(1'b1), .regceb(1'b1), .web(1'b0)
    );

    xpm_memory_tdpram #(
        .ADDR_WIDTH_A(MEM_ADDR_W), .ADDR_WIDTH_B(MEM_ADDR_W),
        .MEMORY_SIZE(MEM_SIZE),    .READ_LATENCY_B(1),
        .WRITE_DATA_WIDTH_A(8),    .READ_DATA_WIDTH_B(8)
    ) u_ram1 (
        .clka(clk), .addra(wr_sym_idx), .dina(in_data), .wea(wea1), .ena(1'b1),
        .clkb(clk), .addrb(rd_sym_idx), .doutb(doutb1), .enb(rd_fire && (rd_bank == 1'b1)),
        .rsta(rst), .rstb(rst), .regcea(1'b1), .regceb(1'b1), .web(1'b0)
    );

    // ============================================================
    // 5. 输出流水线对齐 (Latency = 2 cycles)
    // ============================================================
    reg rd_fire_d1;
    reg rd_bank_d1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_fire_d1  <= 1'b0;
            rd_bank_d1  <= 1'b0;
            out_valid   <= 1'b0; 
            out_data    <= 8'd0; 
            block_start <= 1'b0; 
        end else begin
            rd_fire_d1 <= rd_fire;
            
            rd_bank_d1 <= rd_bank;
            
            block_start <= block_start_raw;

            if (rd_fire_d1) 
               out_data <= (rd_bank_d1 == 1'b0) ? doutb0 : doutb1;
            else 
               out_data <= 8'd0;

            out_valid <= rd_fire_d1; 
        end
    end

endmodule