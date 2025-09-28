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
    output wire                  ch0_gthtxp_out,

    // --- DDR4 物理接口 ---
    output                      c0_ddr4_act_n,
    output [16:0]               c0_ddr4_adr,
    output [1:0]                c0_ddr4_ba,
    output [0:0]                c0_ddr4_bg,
    output [0:0]                c0_ddr4_cke,
    output [0:0]                c0_ddr4_odt,
    output [0:0]                c0_ddr4_cs_n,
    output [0:0]                c0_ddr4_ck_t,
    output [0:0]                c0_ddr4_ck_c,
    output                      c0_ddr4_reset_n,
    inout  [3:0]                c0_ddr4_dm_dbi_n,
    inout  [31:0]               c0_ddr4_dq,
    inout  [3:0]                c0_ddr4_dqs_c,
    inout  [3:0]                c0_ddr4_dqs_t
);


    parameter MATRIX_COL = 8;
    parameter MATRIX_ROW = 8;
    parameter WR_BRUST_LEN  = 8;
    parameter RD_BRUST_LEN  = 64;
    
    wire[31:0] prbs_data;
    wire prbs_data_valid;
    wire        wr_clk;
    wire [7:0]  M_AXIS_OUTPUT_TDATA ;
    wire        M_AXIS_OUTPUT_TVALID;
    wire        M_AXIS_OUTPUT_TREADY;
    wire        M_AXIS_OUTPUT_TLAST ;
    wire [31:0] sync_data_o;
    wire        sync_valid_o;
    wire        intv_tready;
    wire [31:0] intv_tdata_o;
    wire        intv_tvalid_o;
    wire        intv_tready_o;
    wire        ddr_init_calib_complete;
    wire        ddr_uiclk_50M;
    wire        ddr_wr_fifo_wclk;
    wire        ddr_rd_fifo_rclk;
    wire [31:0] rd_fifo_rdata;
    wire        rd_fifo_rvalid;

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
        .m_axis_output_tlast    (M_AXIS_OUTPUT_TLAST )
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


    pre_interleaver #(
        .CODEWORD_SIZE          (256),   // 每个码字256 words (1024B)
        .NUM_CODEWORDS          (4)    // 4个码字
    )pre_interleaver(
        .rst                    (rst),
        .clk                    (core_clk),
        .s_axis_tdata           (sync_data_o),
        .s_axis_tvalid          (sync_valid_o),
        .s_axis_tready          (intv_tready),
        .m_axis_tdata           (intv_tdata_o),
        .m_axis_tvalid          (intv_tvalid_o),
        .m_axis_tready          (intv_tready_o)
    );

    ddr4_controler_clean #(
        .MATRIX_COL             (8), 
        .MATRIX_ROW             (8)
    ) ddr_interleaver (
        .sys_clk_p              (sys_clk_p), 
        .sys_clk_n              (sys_clk_n), 
        .rst_n                  (sys_rst_n),
        .c0_ddr4_adr            (c0_ddr4_adr),
        .c0_ddr4_ba             (c0_ddr4_ba),
        .c0_ddr4_bg             (c0_ddr4_bg),
        .c0_ddr4_cke            (c0_ddr4_cke),
        .c0_ddr4_odt            (c0_ddr4_odt),
        .c0_ddr4_cs_n           (c0_ddr4_cs_n),
        .c0_ddr4_act_n          (c0_ddr4_act_n),
        .c0_ddr4_reset_n        (c0_ddr4_reset_n),
        .c0_ddr4_ck_t           (c0_ddr4_ck_t),
        .c0_ddr4_ck_c           (c0_ddr4_ck_c),
        .c0_ddr4_dm_dbi_n       (c0_ddr4_dm_dbi_n),
        .c0_ddr4_dq             (c0_ddr4_dq),
        .c0_ddr4_dqs_c          (c0_ddr4_dqs_c),
        .c0_ddr4_dqs_t          (c0_ddr4_dqs_t),
        .ui_clkout              (ddr_uiclk_50M), 
        .c0_init_calib_complete (ddr_init_calib_complete),
        .wr_bust_len            (8),
        .rd_bust_len            (64),
    //prbs data mode
        .wr_fifo_wclk           (ddr_wr_fifo_wclk), 
        .wr_fifo_wdata          (intv_tdata_o),    //input 
        .wr_fifo_wen            (intv_tready_o),       //input 
        .rd_fifo_rclk           (ddr_rd_fifo_rclk), 
        .rd_fifo_rvalid         (rd_fifo_rvalid),   //output
        .rd_fifo_rdata          (rd_fifo_rdata_u1)  //ouptut
    );

    
endmodule
