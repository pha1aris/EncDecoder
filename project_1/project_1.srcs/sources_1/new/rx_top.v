`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/18 19:36:55
// Design Name: 
// Module Name: rx_top
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


module rx_top(
    // --- System Inputs ---
    input  wire                  sys_clk_p,
    input  wire                  sys_clk_n,
    input  wire                  sys_rst_n,
    // --- GTH Interface ---
    input  wire                  mgtrefclk0_x0y1_p,
    input  wire                  mgtrefclk0_x0y1_n,
    input  wire                  ch0_gthrxn_in,
    input  wire                  ch0_gthrxp_in,
    output wire                  ch0_gthtxn_out,
    output wire                  ch0_gthtxp_out
);

wire [31:0] gth_rx_data;
wire gth_rx_valid;
wire de_intv_tready;
wire [31:0] de_intv_tdata_o ;
wire        de_intv_tvalid_o;
wire        de_intv_tready_o;

    de_interleaver  #(
        .CODEWORD_SIZE(256),   // 每个码字256 words (1024B)
        .NUM_CODEWORDS(4)    // 4个码字
    )de_interleaver(
        .clk(core_clk),
        .rst(rst),
        // 输入接口
        .s_axis_tdata(gth_rx_data),
        .s_axis_tvalid(gth_rx_valid),
        .s_axis_tready(de_intv_tready),
        // 输出接口
        .m_axis_tdata (de_intv_tdata_o ),
        .m_axis_tvalid(de_intv_tvalid_o),
        .m_axis_tready(de_intv_tready_o)
    );

    DeSync DeSync(
        // --- 时钟和复位 ---
        .rst                    (rst),
        .core_clk               (core_clk),
        // --- 输入 (32-bit, 来自解交织器) ---
        .data_i                 (sync_data_o),
        .data_valid_i           (sync_valid_o),
        // --- AXI-Stream 主接口输出 (8-bit, 送往 decoder 模块) ---
        .m_axis_output_tdata    (decoder_sync_tdata ),
        .m_axis_output_tvalid   (decoder_sync_tvalid),
        .m_axis_output_tlast    (decoder_sync_tlast ),
        .m_axis_output_tready   (decoder_sync_tready)
    );

    Decoder Decoder(
        .rst            (rst),
        .core_clk       (core_clk),
        // AXIS Slave 接口 (输入)
        .s_axis_input_tdata (decoder_sync_tdata ),
        .s_axis_input_tvalid(decoder_sync_tvalid),
        .s_axis_input_tlast (decoder_sync_tlast ),
        .s_axis_input_tready(decoder_sync_tready),
        // AXIS Master 接口 (输出)
        .output_tdata(decoder_output_tdata),
        .output_tvalid(decoder_output_tvalid),
        .output_tready(Decoder_output_ready) 
    );


    parameter READ_DELAY_CYCLES = 30; 
    assign Decoder_output_ready = 1;
    reg [$clog2(READ_DELAY_CYCLES)-1:0] empty_dly_sr;
    reg output_buf_empty_neg0,output_buf_empty_neg1;
    wire output_buf_empty_neg;
    reg output_buf_rd_r;
    assign output_buf_empty_neg = !output_buf_empty_neg0 && output_buf_empty_neg1;
    always @(posedge rd_clk or posedge rst) begin
        if(rst) begin
            output_buf_empty_neg0 <= 0;
            output_buf_empty_neg1 <= 0;
        end else begin
            output_buf_empty_neg0 <= output_buf_empty;
            output_buf_empty_neg1 <= output_buf_empty_neg0;
        end
    end

    always @(posedge rd_clk or posedge rst) begin
        if(rst) begin
            empty_dly_sr <= 0;
        end else if(output_buf_rd_r && empty_dly_sr < READ_DELAY_CYCLES) begin
            empty_dly_sr <= empty_dly_sr + 1;
        end else if(empty_dly_sr == READ_DELAY_CYCLES)begin
            empty_dly_sr <= empty_dly_sr;
        end
    end

    always @(posedge rd_clk or posedge rst) begin
        if(rst) begin
            output_buf_rd_r <= 0;
        end else if(output_buf_empty_neg) begin
            output_buf_rd_r <= 1;
        end
    end
    reg obuf_rden;
    always @(posedge rd_clk or posedge rst) begin
        if(rst) begin
           obuf_rden <= 0;
        end else if(empty_dly_sr == READ_DELAY_CYCLES && output_buf_rd_r <= 1) begin
            obuf_rden <= 1;
        end
    end

    wire [31:0] data_to_gth;

    wr_gth_fifo output_buf (
      .srst         (reset_sync),                           // input wire srst
      .wr_clk       (core_clk),                             // input wire wr_clk
      .rd_clk       (rd_clk),                               // input wire rd_clk
      .din          (decoder_output_tdata),                 // input wire [31 : 0] din
      .wr_en        (decoder_output_tvalid),                // input wire wr_en
      .rd_en        (obuf_rden && !output_buf_empty),                // input wire rd_en
      .dout         (data_to_gth),                          // output wire [31 : 0] dout
      .full         (output_buf_full),                      // output wire full
      .empty        (output_buf_empty),                     // output wire empty
      .wr_rst_busy  (obuf_wrst_busy),                       // output wire wr_rst_busy
      .rd_rst_busy  (obuf_rrst_busy)                        // output wire rd_rst_busy
    );

    // 直接例化PRBS检查器，检查解码出的数据 (用于环回测试)
    wire [31:0] prbs_error_to_gth;
    wire prbs_match_out1;

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (1),
        .INV_PATTERN (1),
        .POLY_LENGHT (31),
        .POLY_TAP    (28),
        .NBITS       (32)
    ) prbs_checker_inst1 (
        .RST      (reset_sync_chk),
        .CLK      (rd_clk), // 假设 tx_clk 与 rd_clk 同步用于此测试
        .DATA_IN  (data_to_gth),
        .EN       (obuf_rden && !output_buf_empty),
        .DATA_OUT (prbs_error_to_gth)
    );

    assign prbs_match_out1 = ~|prbs_error_to_gth;

endmodule
