`timescale 1ns/1ps

module rs_interleaver_xpm #(
    parameter integer D = 4808, 
    parameter integer N = 255   
)(
    input  wire         clk,
    input  wire         rst,

    input  wire         in_valid,
    input  wire [7:0]   in_data,  
    output wire         in_ready, 

    output reg          out_valid,
    output reg  [7:0]   out_data, 
    output reg          out_block_start
);

    // ... 参数计算保持不变 ...
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
    // 2. 写逻辑 (保持不变：线性写入 / 行写入)
    // ============================================================
    reg  [SYM_IDX_W-1:0] wr_sym_idx;
    reg                  wr_bank;     
    reg                  rd_bank;     
    reg                  kick_read;   

    assign in_ready = !rst;
    wire   wr_fire  = in_valid && in_ready;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_sym_idx <= {SYM_IDX_W{1'b0}};
            wr_bank    <= 1'b0; 
            rd_bank    <= 1'b1; 
            kick_read  <= 1'b0;
        end else begin
            kick_read <= 1'b0; 

            if (wr_fire) begin
                if (wr_sym_idx == TOTAL_SYM-1) begin
                    wr_sym_idx <= {SYM_IDX_W{1'b0}};
                    wr_bank    <= ~wr_bank;
                    rd_bank    <= ~rd_bank;
                    kick_read  <= 1'b1; 
                end else begin
                    wr_sym_idx <= wr_sym_idx + 1'b1;
                end
            end
        end
    end

    // RAM 写使能
    wire wea0 = wr_fire && (wr_bank == 1'b0);
    wire wea1 = wr_fire && (wr_bank == 1'b1);

    // ============================================================
    // 3. 读逻辑 (★★★ 关键修改：改为列优先读出 ★★★)
    // ============================================================
    reg [ROW_W-1:0] rd_row;
    reg [COL_W-1:0] rd_col;
    reg             rd_busy; 

    wire rd_fire = rd_busy; 

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_row  <= {ROW_W{1'b0}};
            rd_col  <= {COL_W{1'b0}};
            rd_busy <= 1'b0;
        end else begin
            if (kick_read) begin
                rd_busy <= 1'b1;
                rd_row  <= {ROW_W{1'b0}};
                rd_col  <= {COL_W{1'b0}};
            end 
            else if (rd_busy) begin
                // ★★★ 修改点：Row 变化快，Col 变化慢 ★★★
                // 这样读出的顺序是：
                // (Row0,Col0), (Row1,Col0), (Row2,Col0) ... (RowD,Col0) -> 完成第0列
                // (Row0,Col1), (Row1,Col1) ...                          -> 完成第1列
                
                if (rd_row == D_EFF-1) begin
                    rd_row <= {ROW_W{1'b0}}; // 一列读完，Row归零
                    
                    if (rd_col == N-1) begin
                        rd_col  <= {COL_W{1'b0}}; // 所有列读完
                        rd_busy <= 1'b0; 
                    end else begin
                        rd_col <= rd_col + 1'b1; // 换下一列
                    end
                end else begin
                    rd_row <= rd_row + 1'b1; // 继续读当前列的下一行
                end
            end
        end
    end

    // ============================================================
    // 4. 输出逻辑与对齐 
    // ============================================================
    
    // 生成 Block Start 标记 (逻辑修正：现在是读出的第一个数才是 start)
    reg block_start_raw;
    always @(posedge clk or posedge rst) begin
        if (rst) block_start_raw <= 1'b0;
        else begin
            // 第一列的第一行才是 Block Start
            if (rd_fire && (rd_row == 0) && (rd_col == 0))
                block_start_raw <= 1'b1;
            else
                block_start_raw <= 1'b0;
        end
    end

    // 计算读地址: row * 255 + col
    // 注意：这里地址会跳变（例如 0, 255, 510...），这是正确的交织行为
    wire [SYM_IDX_W-1:0] row_mul_255 = (rd_row << 8) - rd_row;
    wire [SYM_IDX_W-1:0] rd_sym_idx  = row_mul_255 + rd_col;

    // RAM 实例化与输出打拍逻辑保持完全一致，不需要修改
    // ... (XPM instantiation and Output pipeline code) ...
    
    wire [7:0] doutb0, doutb1;
    // Bank 0
    xpm_memory_tdpram #(
        .ADDR_WIDTH_A(MEM_ADDR_W), .ADDR_WIDTH_B(MEM_ADDR_W),
        .MEMORY_SIZE(MEM_SIZE),    .READ_LATENCY_B(1),
        .WRITE_DATA_WIDTH_A(8),    .READ_DATA_WIDTH_B(8)
    ) u_ram0 (
        .clka(clk), .addra(wr_sym_idx), .dina(in_data), .wea(wea0), .ena(1'b1),
        .clkb(clk), .addrb(rd_sym_idx), .doutb(doutb0), .enb(rd_fire && (rd_bank == 1'b0)), 
        .rsta(rst), .rstb(rst), .regcea(1'b1), .regceb(1'b1), .web(1'b0)
    );
    // Bank 1
    xpm_memory_tdpram #(
        .ADDR_WIDTH_A(MEM_ADDR_W), .ADDR_WIDTH_B(MEM_ADDR_W),
        .MEMORY_SIZE(MEM_SIZE),    .READ_LATENCY_B(1),
        .WRITE_DATA_WIDTH_A(8),    .READ_DATA_WIDTH_B(8)
    ) u_ram1 (
        .clka(clk), .addra(wr_sym_idx), .dina(in_data), .wea(wea1), .ena(1'b1),
        .clkb(clk), .addrb(rd_sym_idx), .doutb(doutb1), .enb(rd_fire && (rd_bank == 1'b1)),
        .rsta(rst), .rstb(rst), .regcea(1'b1), .regceb(1'b1), .web(1'b0)
    );

    // 输出流水线对齐
    reg rd_fire_d1;
    reg rd_bank_d1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_fire_d1 <= 1'b0; 
            rd_bank_d1 <= 1'b0;
            out_valid <= 1'b0; out_data <= 8'd0; 
            out_block_start <= 1'b0;
        end else begin
            rd_fire_d1 <= rd_fire;
            rd_bank_d1 <= rd_bank;
            
            out_block_start <= block_start_raw;

            if (rd_fire_d1) 
               out_data <= (rd_bank_d1 == 1'b0) ? doutb0 : doutb1;
            else 
               out_data <= 8'd0;

            out_valid <= rd_fire_d1; 
        end
    end

endmodule