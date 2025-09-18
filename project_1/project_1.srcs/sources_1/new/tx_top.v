`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/18 19:35:35
// Design Name: 
// Module Name: tx_top
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


module tx_top(
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

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE               (0),
        .INV_PATTERN            (1),
        .POLY_LENGHT            (31),
        .POLY_TAP               (28),
        .NBITS                  (32)
    ) prbs_any_gen_inst (
        .RST                    (rst),
        .CLK                    (wr_clk),
        .DATA_IN                ('d0),
        .EN                     (encoder_fifo_wrrdy),
        .DATA_OUT               (prbs_data)
    );

    Encoder Encoder(
        .rst                    (rst), 
        .input_fifo_clk         (wr_clk),
        .core_clk               (core_clk),           
        .data_i                 (prbs_data),
        .data_valid_i           (encoder_fifo_wrrdy),
        .input_fifo_wrrdy       (encoder_fifo_wrrdy), 
        .m_axis_output_tdata    (M_AXIS_OUTPUT_TDATA ),
        .m_axis_output_tvalid   (M_AXIS_OUTPUT_TVALID),
        .m_axis_output_tready   (M_AXIS_OUTPUT_TREADY ),
        .m_axis_output_tlast    (M_AXIS_OUTPUT_TLAST)
    );

    Sync Sync(
        .rst                    (rst),
        .core_clk               (core_clk),
        .s_axis_input_tdata     (M_AXIS_OUTPUT_TDATA),
        .s_axis_input_tvalid    (M_AXIS_OUTPUT_TVALID),
        .s_axis_input_tlast     (M_AXIS_OUTPUT_TLAST),
        .s_axis_input_tready    (M_AXIS_OUTPUT_TREADY),
        .sync_data_o            (sync_data_o),
        .sync_valid_o           (sync_valid_o)
    );

endmodule
