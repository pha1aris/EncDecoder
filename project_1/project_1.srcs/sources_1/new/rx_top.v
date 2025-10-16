`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// (头部注释同你原文件)
// rx_top - 保持你原始结构，仅修正错误统计部分为可综合实现
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
    parameter [63:0]   SYNC_MARKER       = 64'hB1699558A53333A8;
    parameter integer  SYNC_REPETITION = 3;
    parameter integer  PAYLOAD_LEN     = 64;
    parameter integer  PACKAGE_LEN      = SYNC_REPETITION * 64 + PAYLOAD_LEN;
    parameter integer  ERROR_THRESHOLD = 10;
    parameter integer  HAMMING_WIDTH   = 8;
    parameter integer  SCORE_HIGH      = 4;
    parameter integer  SCORE_MED       = 2;
    parameter integer  HAMM_HIGH       = 2;
    parameter integer  HAMM_MED        = 5;
    parameter integer  SCORE_THRESHOLD = 6;
    parameter integer  TEMPORAL_DEPTH  = 8;
    parameter integer  TEMPORAL_VOTE   = 6;
    parameter integer  K_GOOD          = 3;
    parameter integer  K_BAD           = 4;
    parameter integer  BUF_DEPTH_BITS  = 8;// 缓冲区深度 = 2^8 = 256
    // ---------------- 原有信号（保持不变） ----------------
    wire [31:0] gth_rx_data;
    wire gth_rx_valid;
    wire de_intv_tready;
    wire [31:0] de_intv_tdata_o ;
    wire        de_intv_tvalid_o;
    wire        de_intv_tready_o;

    parameter READ_DELAY_CYCLES = 30; 
    assign Decoder_output_ready = 1;
    reg [$clog2(READ_DELAY_CYCLES)-1:0] empty_dly_sr;
    reg     output_buf_empty_neg0,output_buf_empty_neg1;
    wire    output_buf_empty_neg;
    reg     output_buf_rd_r;
    assign  output_buf_empty_neg = !output_buf_empty_neg0 && output_buf_empty_neg1;
    reg     obuf_rden;

    wire        ddr_init_calib_complete;
    wire        ddr_uiclk_50M;
    wire        ddr_wr_fifo_wclk;
    wire        ddr_rd_fifo_rclk;
    wire [31:0] rd_fifo_rdata;
    wire        rd_fifo_rvalid;
    wire        deintv_valid_o;
    wire        read_start;


    wire [31:0] data_from_gth;
    wire [7:0]  data_from_fifo;
    wire        fifo_rd_ready;
    wire frame_sync_tready;

    wire [7:0] frame_sync_data_o;
    wire frame_sync_valid_o;
    wire frame_sync_ready_o;

    wire        start_of_frame;
    wire        locked_o;

     frame_synchronizer_circular #(
        .SYNC_MARKER            (SYNC_MARKER     ),
        .SYNC_REPETITION        (SYNC_REPETITION ),
        .PAYLOAD_LEN            (PAYLOAD_LEN     ),
        .PACKAGE_LEN            (PACKAGE_LEN     ),
        .ERROR_THRESHOLD        (ERROR_THRESHOLD ),
        .HAMMING_WIDTH          (HAMMING_WIDTH   ),
        .SCORE_HIGH             (SCORE_HIGH      ),
        .SCORE_MED              (SCORE_MED       ),
        .HAMM_HIGH              (HAMM_HIGH       ),
        .HAMM_MED               (HAMM_MED        ),
        .SCORE_THRESHOLD        (SCORE_THRESHOLD ),
        .TEMPORAL_DEPTH         (TEMPORAL_DEPTH  ),
        .TEMPORAL_VOTE          (TEMPORAL_VOTE   ),
        .K_GOOD                 (K_GOOD          ),
        .K_BAD                  (K_BAD           ),
        .BUF_DEPTH_BITS         (BUF_DEPTH_BITS  )    // 缓冲区深度 = 2^8 = 256
    )frame_synchronizer_circular(
        .clk                    (clk),
        .rst                    (rst),
        // AXI-Stream 输入
        .m_axis_output_tdata    (data_from_fifo),
        .s_axis_input_tvalid    (fifo_rd_ready),
        .s_axis_input_tready    (frame_sync_tready),
        // AXI-Stream 输出 (来自回读缓冲区)
        .m_axis_output_tdata    (frame_sync_data_o),
        .m_axis_output_tvalid   (frame_sync_valid_o),
        .m_axis_output_tready   (frame_sync_ready_o),
        // 状态输出
        .start_of_frame_o       (start_of_frame),
        .locked_o               (locked_o)
    );

    ddr4_controler_deintv #(
        .MATRIX_COL             (8), 
        .MATRIX_ROW             (8)
    ) De_Interleaver (
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

        .start_of_frame         (start_of_frame),

        .wr_bust_len            (8),
        .rd_bust_len            (64),
        .wr_fifo_wclk           (ddr_wr_fifo_wclk), 
        .wr_fifo_wen            (rd_fifo_rvalid), 
        .wr_fifo_wdata          (rd_fifo_rdata_u1),
        .rd_fifo_rclk           (ddr_rd_fifo_rclk), 
        .data_valid_o           (deintv_valid_o),
        .rd_fifo_rdata          (rd_fifo_rdata),
        .read_start             (read_start)
    );

    // pre_deinterleaver / DeSync / Decoder / output_buf ... 保持原样
    pre_deinterleaver #(
        .CODEWORD_SIZE          (256),
        .NUM_CODEWORDS          (4)
    ) pre_deinterleaver (
        .clk                    (ddr_rd_fifo_rclk),
        .rst                    (rst),
        .s_axis_tdata           (rd_fifo_rdata),
        .s_axis_tvalid          (deintv_valid_o),
        .s_axis_tready          (de_intv_tready),

        .start_of_frame         (start_of_frame),

        .m_axis_tdata           (de_intv_tdata_o),
        .m_axis_tvalid          (de_intv_tvalid_o),
        .m_axis_tready          (de_intv_tready_o)
    );

    DeSync DeSync(
        .rst                    (rst),
        .core_clk               (core_clk),
    // --- MODIFICATION 1: 将输入接口修改为AXI-Stream slave接口 ---
    // input wire [31:0]   data_i,
    // input wire          data_valid_i,
    // output wire         fifo_input_rdy,
        .s_axis_input_tdata     (de_intv_tdata_o),
        .s_axis_input_tvalid    (de_intv_tvalid_o),
        .s_axis_input_tready    (de_intv_tready_o),
    // --- END of MODIFICATION 1 ---
        .m_axis_output_tdata    (decoder_sync_tdata ),
        .m_axis_output_tvalid   (decoder_sync_tvalid),
        .m_axis_output_tlast    (decoder_sync_tlast ),
        .m_axis_output_tready   (decoder_sync_tready)
    );

    Decoder Decoder (
        .core_clk               (core_clk),
        .rst                    (rst),
        .s_axis_input_tdata     (decoder_sync_tdata),
        .s_axis_input_tvalid    (decoder_sync_tvalid),
        .s_axis_input_tlast     (decoder_sync_tlast),
        .s_axis_input_tready    (decoder_sync_tready),
        .output_tdata           (decoder_output_tdata),
        .output_tvalid          (decoder_output_tvalid),
        .output_tready          (Decoder_output_ready)
    );

    wr_gth_fifo output_buf (
        .srst                   (reset_sync),
        .wr_clk                 (core_clk),
        .rd_clk                 (rd_clk),
        .din                    (decoder_output_tdata),
        .wr_en                  (decoder_output_tvalid),
        .rd_en                  (obuf_rden && !output_buf_empty),
        .dout                   (data_to_gth),
        .full                   (output_buf_full),
        .empty                  (output_buf_empty),
        .wr_rst_busy            (obuf_wrst_busy),
        .rd_rst_busy            (obuf_rrst_busy)
    );

    // PRBS checker (保持原样)
    wire [31:0] prbs_error_to_gth;
    wire        prbs_match_out1;

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE       (1),
        .INV_PATTERN    (1),
        .POLY_LENGHT    (31),
        .POLY_TAP       (28),
        .NBITS          (32)
    ) prbs_checker_inst1 (
        .RST            (reset_sync_chk),
        .CLK            (rd_clk),
        .DATA_IN        (data_to_gth),
        .EN             (obuf_rden && !output_buf_empty),
        .DATA_OUT       (prbs_error_to_gth)
    );

    assign prbs_match_out1 = ~|prbs_error_to_gth;

    function [5:0] popcount32;
        input [31:0] v;
        integer k;
        begin
            popcount32 = 6'd0;
            for (k = 0; k < 32; k = k + 1) begin
                popcount32 = popcount32 + v[k];
            end
        end
    endfunction

    wire [5:0] perr_cnt;
    assign perr_cnt = popcount32(prbs_error_to_gth);

    reg [63:0] err_count;
    reg        err_clr; // 如果需要外部清零，请将其改为 input 并驱动它
    always @(posedge rd_clk) begin
        if (reset_sync_chk) begin
            err_count <= 64'd0;
        end else if (err_clr) begin
            err_count <= 64'd0;
        end else if (obuf_rden && !output_buf_empty) begin
            err_count <= err_count + perr_cnt;
        end
    end

    reg [63:0] total_bits;
    always @(posedge rd_clk) begin
        if (reset_sync_chk) begin
            total_bits <= 64'd0;
        end else if (err_clr) begin
            total_bits <= 64'd0;
        end else if (obuf_rden && !output_buf_empty) begin
            total_bits <= total_bits + 32;
        end
    end

     wire [127:0]  M_AXIS_TDATA;
     wire          M_AXIS_TVALID;
     wire          M_AXIS_TREADY;
     wire          M_AXIS_TVLAST;

    BER_axis_packager#(
        .CYCLES_PER_PAK (10_000_000)
    )axis_packager(
        .clk(core_clk),//100Mhz - 10ns
        .rst(rst),
        .data_i0(total_bits),
        .data_i1(err_count),
        .M_AXIS_TDATA (M_AXIS_TDATA),
        .M_AXIS_TVALID(M_AXIS_TVALID),
        .M_AXIS_TREADY(M_AXIS_TREADY),
        .M_AXIS_TVLAST(M_AXIS_TVLAST)
    );


endmodule
