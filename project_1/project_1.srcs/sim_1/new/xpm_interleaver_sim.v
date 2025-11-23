`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/17 14:35:59
// Design Name: 
// Module Name: xpm_interleaver_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module xpm_interleaver_sim();

    // ================= 参数定义 =================
    parameter CORE_CLK_PERIOD = 10.0;
    parameter CODEWORD_SIZE_IN_32 = 65;
    parameter NUM_CODEWORDS = 4;
    localparam BLOCK_SIZE = CODEWORD_SIZE_IN_32 * NUM_CODEWORDS; // 260
    localparam NUM_BLOCKS_TO_TEST = 20;                         // 测试3个数据块，以验证乒乓操作
    localparam TOTAL_WORDS = BLOCK_SIZE * NUM_BLOCKS_TO_TEST; // 780

    // ================= 时钟与复位 =================
    reg core_clk;
    reg rst;

    initial begin
        core_clk = 0;
    end

    // 复位序列
    initial begin
        rst = 1;
        #(CORE_CLK_PERIOD * 4);
        rst = 0;
    end

    // 时钟生成
    always #(CORE_CLK_PERIOD/2) core_clk = ~core_clk;
    //prbs 数据
    wire [7:0] prbs_data;
    wire [7:0] prbs_error_to_gth;
    wire       prbs_match;
    assign   prbs_match = ~|prbs_error_to_gth;

    wire xpm_intv_ready;
    wire xpm_last;

    reg [7:0] cnt_8;
    reg [7:0] data_8;       // 真正作为激励的数据
    reg       data_8_valid;

    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            cnt_8        <= 8'd0;
            data_8       <= 8'd0;
            data_8_valid <= 1'b0;
        end else if (xpm_intv_ready) begin
            data_8_valid <= 1'b1;
            data_8       <= cnt_8;          // 先输出当前计数值

            if (cnt_8 == 8'd255)           // 覆盖 0~254
                cnt_8 <= 8'd1;
            else
                cnt_8 <= cnt_8 + 1'b1;      // 再自增，给下一拍用

        end else begin
            data_8_valid <= 1'b0;
        end
    end


    wire [7:0] xpm_intv_data_o;
    wire xpm_intv_dvalid;
    wire xpm_deintv_ready;
    wire [7:0] xpm_deintv_data;
    wire xpm_deintv_dvalid;

    wire blk_soft_rst;
    wire block_start;

    rs_interleaver_xpm #(
        .D(4), // 目标交织深度（行数），实际有效为 D_eff
        .N(255)   // 每行符号数（RS(255,229) → 255）
    )xpm_interleaver(
        .clk                (core_clk),
        .rst                (rst),      

        .in_valid           (data_8_valid),
        .in_data            (cnt_8),   //计数器数据输入
        // .in_data            (prbs_data),   //prbs7数据输入
        .in_ready           (xpm_intv_ready),

        .out_block_start    (out_block_start),
        .out_valid          (xpm_intv_dvalid),
        .out_data           (xpm_intv_data_o)
    );

    rs_deinterleaver_xpm #(
        .D(4),    // 目标交织深度（行数），实际有效为 D_EFF
        .N(255)   // 每行符号数（RS(255,229) → 255）
    )xpm_deinterleaver(
        .clk        (core_clk),
        .rst        (rst),      

        .blk_soft_rst(blk_soft_rst),
        .in_valid   (xpm_intv_dvalid),
        .in_data    (xpm_intv_data_o),
        .in_ready   (xpm_deintv_ready),

        .block_start (block_start),
        .out_valid  (xpm_deintv_dvalid),
        .out_data   (xpm_deintv_data) 
    );

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE               (0),
        .INV_PATTERN            (1),
        .POLY_LENGHT            (7),
        .POLY_TAP               (6),
        .NBITS                  (8)
    ) prbs_any_gen_inst (
        .RST                    (rst),
        .CLK                    (core_clk),
        .DATA_IN                ('d0),
        .EN                     (xpm_intv_ready && data_8_valid),
        .DATA_OUT               (prbs_data)
    );


    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE               (1),
        .INV_PATTERN            (1),
        .POLY_LENGHT            (7),
        .POLY_TAP               (6),
        .NBITS                  (8)
    ) prbs_checker_inst1 (
        .RST                    (rst),
        .CLK                    (core_clk), // 假设 tx_clk 与 rd_clk 同步用于此测试
        .DATA_IN                (xpm_deintv_data),
        .EN                     (xpm_deintv_dvalid),
        .DATA_OUT               (prbs_error_to_gth)
    );





endmodule
