`timescale 1ns/1ps

module gearbox_32to8 (
    input  wire        clk,
    input  wire        rst,

    // 输入：32bit 数据 + 1bit 同步复位标志
    input  wire [31:0] in_data,
    input  wire        in_sync_rst, 
    input  wire        in_valid,
    
    // 输出：8bit 数据 + 1bit 同步复位标志
    output reg  [7:0]  out_data,
    output reg         out_sync_rst, 
    output reg         out_valid
);

    // ============================================================
    // 1. 内部 FIFO (Depth=32, Width=33)
    // ============================================================
    localparam DEPTH = 32;
    localparam AW    = $clog2(DEPTH);

    // Bit 32: Sync Reset Flag, Bit 31-0: Data
    reg [32:0] mem [0:DEPTH-1]; 
    reg [AW:0] wr_ptr;
    reg [AW:0] rd_ptr;

    wire [AW:0] count = wr_ptr - rd_ptr;
    wire        full  = (count == DEPTH);
    wire        empty = (count == 0);

    // 写逻辑
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= {(AW+1){1'b0}};
        end else if (in_valid && !full) begin
            // ★ 把 flag 和 data 绑在一起写入
            mem[wr_ptr[AW-1:0]] <= {in_sync_rst, in_data};
            wr_ptr <= wr_ptr + 1'b1;
        end
    end

    // ============================================================
    // 2. 读出与移位逻辑
    // ============================================================
    reg [32:0] shreg_bundle; // {flag, data32}
    
    wire [31:0] shreg_data = shreg_bundle[31:0];
    wire        shreg_flag = shreg_bundle[32];
    
    reg [1:0]  byte_cnt;
    reg        active; 

    wire fifo_pop = (!empty) && ( (!active) || (active && byte_cnt == 2'd3) );

    // FIFO 读指针
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_ptr <= {(AW+1){1'b0}};
        end else if (fifo_pop) begin
            rd_ptr <= rd_ptr + 1'b1;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shreg_bundle <= 33'd0;
            byte_cnt     <= 2'd0;
            active       <= 1'b0;
            out_data     <= 8'd0;
            out_sync_rst <= 1'b0;
            out_valid    <= 1'b0;
        end else begin
            out_valid    <= 1'b0;
            out_sync_rst <= 1'b0; // 默认不复位

            if (active) begin
                out_valid <= 1'b1; 
                
                // 如果当前 Word 带有复位标志，且当前是第 0 个字节，则输出复位
                // 这保证了复位刚好发生在第一个字节输出的时刻
                if (shreg_flag && byte_cnt == 2'd0) 
                    out_sync_rst <= 1'b1;

                case (byte_cnt)
                    2'd0: out_data <= shreg_data[7:0];
                    2'd1: out_data <= shreg_data[15:8];
                    2'd2: out_data <= shreg_data[23:16];
                    2'd3: out_data <= shreg_data[31:24];
                endcase

                if (byte_cnt == 2'd3) begin
                    if (!empty) begin
                        shreg_bundle <= mem[rd_ptr[AW-1:0]]; 
                        byte_cnt     <= 2'd0;
                        active       <= 1'b1; 
                    end else begin
                        active   <= 1'b0;
                        byte_cnt <= 2'd0;
                    end
                end else begin
                    byte_cnt <= byte_cnt + 1'b1;
                end

            end else begin
                if (!empty) begin
                    shreg_bundle <= mem[rd_ptr[AW-1:0]];
                    active       <= 1'b1;
                    byte_cnt     <= 2'd0;
                end
            end
        end
    end


    reg [7:0]  out_data_d0;
    reg        out_sync_rst_d0;
    reg        out_valid_d0;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out_data_d0 <= 'd0;
            out_sync_rst_d0 <= 'd0;
            out_valid_d0 <= 'd0;
        end else begin
            out_data_d0 <= out_data;
            out_sync_rst_d0 <= out_sync_rst;
            out_valid_d0 <= out_valid;
        end
    end


endmodule