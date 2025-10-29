// File: rx_chain.v
`timescale 1ns / 1ps

module rx_chain (
    input  wire         clk,
    input  wire         rst,

    input  wire [31:0]  s_axis_tdata,
    input  wire         s_axis_tvalid,
    output wire         s_axis_tready,
    input wire          sync_tlast,
    input wire          encoder_tlast,

    // 误码统计输出
    output wire        prbs_match,
    output reg [63:0]  total_bits_o,
    output reg [63:0]  error_count_o
);

    // 内部连线
    wire        pre_deintv_tready;
    wire [31:0] deintv_tdata;
    wire        deintv_tvalid;
    wire        deintv_tready;
    wire [7:0]  desync_tdata;
    wire        desync_tvalid;
    wire        desync_tlast;
    wire        desync_tready;
    wire [31:0] decoder_tdata;
    wire        decoder_tvalid;
    wire [31:0] prbs_error_vector;

    // 3. 解码器
    Decoder Decoder (
        .core_clk               (clk),
        .rst                    (rst),
        .s_axis_input_tdata     (desync_tdata ),
        .s_axis_input_tvalid    (desync_tvalid),
        .s_axis_input_tlast     (desync_tlast ),
        .s_axis_input_tready    (desync_tready),
        .output_tdata           (decoder_tdata),
        .output_tvalid          (decoder_tvalid),
        .output_tready          (1'b1) // 假设解码器后级总能接收数据
    );


    sid_1 sid_1 (
        .aclk                     (aclk),                                      // input wire aclk
        .aresetn                  (aresetn),                                // input wire aresetn
        .s_axis_data_tdata        (s_axis_data_tdata),            // input wire [7 : 0] s_axis_data_tdata
        .s_axis_data_tvalid       (s_axis_data_tvalid),          // input wire s_axis_data_tvalid
        .s_axis_data_tlast        (s_axis_data_tlast),            // input wire s_axis_data_tlast
        .s_axis_data_tready       (s_axis_data_tready),          // output wire s_axis_data_tready
        .m_axis_data_tdata        (m_axis_data_tdata),            // output wire [7 : 0] m_axis_data_tdata
        .m_axis_data_tuser        (m_axis_data_tuser),            // output wire [1 : 0] m_axis_data_tuser
        .m_axis_data_tvalid       (m_axis_data_tvalid),          // output wire m_axis_data_tvalid
        .m_axis_data_tlast        (m_axis_data_tlast),            // output wire m_axis_data_tlast
        .m_axis_data_tready       (m_axis_data_tready),          // input wire m_axis_data_tready
        .event_tlast_unexpected   (event_tlast_unexpected),  // output wire event_tlast_unexpected
        .event_tlast_missing      (event_tlast_missing),        // output wire event_tlast_missing
        .event_halted             (event_halted)                      // output wire event_halted
    );


    // 4. PRBS-31 校验器
    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (0),
        .INV_PATTERN (1),
        .POLY_LENGHT (31),
        .POLY_TAP    (28),
        .NBITS       (32)
    ) prbs_checker_inst (
        .RST       (rst),
        .CLK       (clk),
        .DATA_IN   (decoder_tdata),
        .EN        (decoder_tvalid),
        .DATA_OUT  (prbs_error_vector)
    );

    // wire prbs_match;

    assign prbs_match = ~|prbs_error_vector;

    // 5. 误码统计逻辑
    // function [5:0] popcount32;
    //     input [31:0] v;
    //     integer k;
    //     begin
    //         popcount32 = 6'd0;
    //         for (k = 0; k < 32; k = k + 1) begin
    //             popcount32 = popcount32 + v[k];
    //         end
    //     end
    // endfunction


    // wire [5:0] perr_cnt = popcount32(prbs_error_vector);

    // always @(posedge clk or posedge rst) begin
    //     if (rst) begin
    //         error_count_o <= 64'd0;
    //         total_bits_o  <= 64'd0;
    //     end else if (decoder_tvalid) begin
    //         error_count_o <= error_count_o + perr_cnt;
    //         total_bits_o  <= total_bits_o + 32;
    //     end
    // end



endmodule