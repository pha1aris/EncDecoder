`timescale 1ns/1ps
`include "global_defines.vh"

module fec_rx #(
    parameter integer W             = 32,
    parameter integer PAYLOAD_WORDS = 16,
    parameter integer RS_N          = 255,
    parameter integer INTLV_D       = 4808,
    parameter integer INTLV_N       = 255,

    // deframer -> gearbox 的保险缓冲：单位=payload 32bit word
    parameter integer DF_AXIS_FIFO_DEPTH = 1024
)(
    input  wire             line_clk,
    input  wire             core_clk,
    input  wire             rst_n,

    input  wire [W-1:0]     i_rx_data,
    input  wire             i_rx_valid,
    input  wire             rx_reset_done,
    input  wire             rx_cdr_stable,
    input  wire             scrambler_en,

    output wire [7:0]       o_data,
    output wire             o_valid,
    input  wire             i_data_ready,

    output wire             o_rxslide,
    output wire             bit_locked_core,
    output wire [15:0]      o_frame_index,
    output wire [15:0]      o_block_id,
    output wire [15:0]      o_frame_in_block
);

    wire rst = ~rst_n;

    // ------------------------------------------------------------
    // 0) VIO cfg（保持你原逻辑）
    // ------------------------------------------------------------
    parameter integer VERIFY_CNT_MAX    = 4;
    parameter integer ERR_TH            = 2;
    parameter integer LOCK_LOSS_TIMEOUT = 4096;
    parameter integer FRAME_TIMEOUT_MAX = 64;

    wire [5:0]  cfg_err_th;
    wire [7:0]  cfg_verify_cnt_max;
    wire [15:0] cfg_lock_loss_to;

    wire [15:0] cfg_frame_to;
    wire [7:0]  cfg_crc_win;
    wire [7:0]  cfg_crc_bad_th;
    wire [7:0]  cfg_pre_win;
    wire [7:0]  cfg_pre_bad_th;
    wire        cfg_realign_mode;

`ifdef SIM
    assign cfg_err_th         = ERR_TH[5:0];
    assign cfg_verify_cnt_max = VERIFY_CNT_MAX[7:0];
    assign cfg_lock_loss_to   = LOCK_LOSS_TIMEOUT[15:0];

    assign cfg_frame_to       = FRAME_TIMEOUT_MAX[15:0];
    assign cfg_crc_win        = 8'd64;
    assign cfg_crc_bad_th     = 8'd16;
    assign cfg_pre_win        = 8'd64;
    assign cfg_pre_bad_th     = 8'd16;
    assign cfg_realign_mode   = 1'b0;
`else
    vio_frame_cfg u_vio_frame_cfg (
        .clk        (core_clk),
        .probe_out0 (cfg_err_th),
        .probe_out1 (cfg_verify_cnt_max),
        .probe_out2 (cfg_lock_loss_to),
        .probe_out3 (cfg_frame_to),
        .probe_out4 (cfg_crc_win),
        .probe_out5 (cfg_crc_bad_th),
        .probe_out6 (cfg_pre_win),
        .probe_out7 (cfg_pre_bad_th),
        .probe_out8 (cfg_realign_mode)
    );
`endif

    // ------------------------------------------------------------
    // 1) bit_aligner（line_clk）
    // ------------------------------------------------------------
    wire [W-1:0] aligned_data;
    wire         aligned_valid;
    wire         realign_req;

    bit_aligner_ind #(
        .W                 (W),
        .IDLE_WORD         (32'h0707_0707),
        .LOCK_LOSS_TIMEOUT (LOCK_LOSS_TIMEOUT)
    ) u_bit_aligner_ind (
        .clk                (line_clk),
        .rst_n              (rst_n),
        .rx_reset_done      (rx_reset_done),
        .rx_cdr_stable      (rx_cdr_stable),

        .i_rx_data          (i_rx_data),
        .i_rx_valid         (i_rx_valid),

        .i_realign_req      (realign_req),

        .cfg_err_th         (cfg_err_th),
        .cfg_verify_cnt_max (cfg_verify_cnt_max),
        .cfg_lock_loss_to   (cfg_lock_loss_to),

        .o_rxslide          (o_rxslide),
        .o_aligned_valid    (aligned_valid),
        .o_bit_locked       (o_bit_locked),
        .o_data_aligned     (aligned_data)
    );

    reg [1:0] bit_locked_sync;
    always@(posedge core_clk or negedge rst_n) begin
      if (!rst_n)begin
        bit_locked_sync <= 2'b00;
      end else begin
        bit_locked_sync <= {bit_locked_sync[0], o_bit_locked};
      end
    end
    assign bit_locked_core = bit_locked_sync[1];

    // ------------------------------------------------------------
    // 2) async FIFO：line_clk -> core_clk  (FWFT)
    // ------------------------------------------------------------
    wire [W-1:0] rx32_fifo_dout;
    wire         rx32_fifo_empty;
    wire         rx32_fifo_full;
    wire         rx32_fifo_wr_rst_busy;
    wire         rx32_fifo_rd_rst_busy;
    wire rx32_fifo_rd_en;

    // ★关键修复：full/busy 时不允许继续 wr_en（避免 FIFO 溢出后全链路错位）
    wire aligned_fire = aligned_valid && !rx32_fifo_full && !rx32_fifo_wr_rst_busy;

    async_fifo_32w_32r u_rx_fifo (
        .rst        (rst),
        .wr_clk     (line_clk),
        .rd_clk     (core_clk),
        .din        (aligned_data),
        .wr_en      (aligned_fire),
        .rd_en      (rx32_fifo_rd_en),
        .dout       (rx32_fifo_dout),
        .full       (rx32_fifo_full),
        .empty      (rx32_fifo_empty),
        .wr_rst_busy(rx32_fifo_wr_rst_busy),
        .rd_rst_busy(rx32_fifo_rd_rst_busy)
    );

    wire [31:0] rx32_fifo_drop_cnt;
    reg [31:0] rx32_drop_cnt;
    assign rx32_fifo_drop_cnt = rx32_drop_cnt;

    always @(posedge line_clk or posedge rst) begin
        if (rst)
            rx32_drop_cnt <= 0;
        else if (aligned_valid && !aligned_fire)
            rx32_drop_cnt <= rx32_drop_cnt + 1;
    end

    // ------------------------------------------------------------
    // 2.1) FWFT 1-word prefetch/skid：把 FIFO dout 寄存后再喂给 deframer
    // ------------------------------------------------------------
    wire [W-1:0] df_s_tdata;
    wire         df_s_tvalid;
    wire         df_s_tready;

    reg  [W-1:0] df_s_tdata_r;
    reg          df_s_tvalid_r;

    wire fifo_has_data = (~rx32_fifo_empty) & (~rx32_fifo_rd_rst_busy);

    wire df_s_fire = df_s_tvalid_r & df_s_tready;
    wire df_prefetch = fifo_has_data & (~df_s_tvalid_r | df_s_fire);

    assign rx32_fifo_rd_en = df_prefetch;

    assign df_s_tvalid = df_s_tvalid_r;
    assign df_s_tdata  = df_s_tdata_r;

    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            df_s_tvalid_r <= 1'b0;
            df_s_tdata_r  <= {W{1'b0}};
        end else begin
            if (df_s_fire && !df_prefetch)
                df_s_tvalid_r <= 1'b0;

            if (df_prefetch) begin
                df_s_tdata_r  <= rx32_fifo_dout;
                df_s_tvalid_r <= 1'b1;
            end
        end
    end

    // ------------------------------------------------------------
    // deframer 输出 payload AXIS
    // ------------------------------------------------------------
    wire [W-1:0] df_m_tdata;
    wire [1:0]   df_m_tuser;   // [0]=blk_soft_rst_on_word0
    wire         df_m_tvalid;
    wire         df_m_tready;
    wire        frame_start;
    wire [15:0] frame_index_rx;
    wire [15:0] block_id_rx;
    wire [15:0] frame_in_block_rx;
    wire        frame_locked;

    fso_deframer #(
        .W                 (W),
        .PAYLOAD_WORDS     (PAYLOAD_WORDS),
        .FRAME_TIMEOUT_MAX (FRAME_TIMEOUT_MAX)
    ) u_fso_deframer (
        .clk                   (core_clk),
        .rst_n                 (rst_n),

        .i_link_up             (bit_locked_core),

        .s_axis_tdata          (df_s_tdata),
        .s_axis_tvalid         (df_s_tvalid),
        .s_axis_tready         (df_s_tready),

        .scrambler_en          (scrambler_en),

        .m_axis_tdata          (df_m_tdata),
        .m_axis_tuser          (df_m_tuser),
        .m_axis_tvalid         (df_m_tvalid),
        .m_axis_tready         (df_m_tready),

        .o_realign_req         (realign_req),
        .o_frame_start         (frame_start),
        .o_frame_index         (frame_index_rx),
        .o_block_id            (block_id_rx),
        .o_frame_in_block      (frame_in_block_rx),
        .o_blk_soft_rst        (),
        .o_frame_locked        (frame_locked),
        .o_block_aligned       (),

        .cfg_frame_timeout_max (cfg_frame_to),
        .cfg_crc_bad_th        (cfg_crc_bad_th),
        .cfg_pre_bad_th        (cfg_pre_bad_th),
        .cfg_realign_or        (cfg_realign_mode)
    );

    assign o_frame_index    = frame_index_rx;
    assign o_block_id       = block_id_rx;
    assign o_frame_in_block = frame_in_block_rx;

    // ------------------------------------------------------------
    // 4.5) deframer 后保险 FIFO：边界随数据一起缓冲
    // ------------------------------------------------------------
    (* MARK_DEBUG="true" *) wire [W:0] fifo_s_tdata  = {df_m_tuser[0], df_m_tdata};
    (* MARK_DEBUG="true" *) wire       fifo_s_tvalid = df_m_tvalid;
    (* MARK_DEBUG="true" *) wire       fifo_s_tready;
    (* MARK_DEBUG="true" *) wire [W:0] fifo_m_tdata;
    (* MARK_DEBUG="true" *) wire       fifo_m_tvalid;
    (* MARK_DEBUG="true" *) wire       fifo_m_tready;

    assign df_m_tready = fifo_s_tready;

    axis_fifo_sync #(
        .WIDTH         (W+1),
        .DEPTH         (DF_AXIS_FIFO_DEPTH)
    ) u_df_axis_fifo (
        .clk           (core_clk),
        .rst           (rst),

        .s_axis_tdata  (fifo_s_tdata),
        .s_axis_tvalid (fifo_s_tvalid),
        .s_axis_tready (fifo_s_tready),

        .m_axis_tdata  (fifo_m_tdata),
        .m_axis_tvalid (fifo_m_tvalid),
        .m_axis_tready (fifo_m_tready)
    );

    // ------------------------------------------------------------
    // 5) 32->8 gearbox
    // ------------------------------------------------------------
    (* MARK_DEBUG="true" *) wire [7:0] gb8_data;
    (* MARK_DEBUG="true" *) wire       gb8_valid;
    (* MARK_DEBUG="true" *) wire       gb8_sync_rst;
    (* MARK_DEBUG="true" *) wire       gb8_ready;
    (* MARK_DEBUG="true" *) wire       gb32_in_ready;
    assign fifo_m_tready = gb32_in_ready;

    gearbox_32to8 u_gb_32to8 (
        .clk         (core_clk),
        .rst         (rst),

        .in_sync_rst (fifo_m_tdata[W]),
        .in_data     (fifo_m_tdata[W-1:0]),
        .in_valid    (fifo_m_tvalid),
        .in_ready    (gb32_in_ready),

        .out_data    (gb8_data),
        .out_sync_rst(gb8_sync_rst),
        .out_valid   (gb8_valid),
        .out_ready   (gb8_ready)
    );

    // ------------------------------------------------------------
    // 6) 去交织器
    // ------------------------------------------------------------
    (* MARK_DEBUG="true" *) wire        deintlv_valid;
    (* MARK_DEBUG="true" *) wire [7:0]  deintlv_data;
    (* MARK_DEBUG="true" *) wire        deintlv_block_start;
    (* MARK_DEBUG="true" *) wire        rs_in_ready;
    (* MARK_DEBUG="true" *) wire gb8_blk_rst_req = gb8_valid && gb8_sync_rst;

    rs_deinterleaver_xpm #(
        .D (INTLV_D),
        .N (INTLV_N)
    ) u_deinterleaver (
        .clk         (core_clk),
        .rst         (rst),
        .blk_soft_rst(gb8_blk_rst_req),

        .in_valid    (gb8_valid),
        .in_data     (gb8_data),
        .in_ready    (gb8_ready),

        .out_valid   (deintlv_valid),
        .out_data    (deintlv_data),
        .block_start (deintlv_block_start),
        .out_ready   (rs_in_ready)
    );

    // ------------------------------------------------------------
    // 6.1) rs_tlast 计数
    // ------------------------------------------------------------
    (* MARK_DEBUG="true" *) reg  [7:0] rs_byte_cnt;
    (* MARK_DEBUG="true" *) wire       rs_fire  = deintlv_valid && rs_in_ready;
    (* MARK_DEBUG="true" *) wire       rs_tlast = rs_fire && (rs_byte_cnt == RS_N-1);
    // (* MARK_DEBUG="true" *) wire [7:0] rs_idx_cur = deintlv_block_start ? 8'd0 : rs_byte_cnt;

    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            rs_byte_cnt <= 8'd0;
        end else if (rs_fire) begin
            if (deintlv_block_start)
                rs_byte_cnt <= 8'd1;
            else if (rs_byte_cnt == RS_N-1)
                rs_byte_cnt <= 8'd0;
            else
                rs_byte_cnt <= rs_byte_cnt + 1'b1;
        end
    end

    // ------------------------------------------------------------
    // 7) RS 解码后端（
    // ------------------------------------------------------------
    (* MARK_DEBUG="true" *) wire [7:0] dec_data;
    (* MARK_DEBUG="true" *) wire       dec_valid;

    rs_decode_backend u_rs_decode_backend (
        .rst                 (rst),
        .core_clk            (core_clk),
        .output_clk          (core_clk),

        .s_axis_input_tdata  (deintlv_data),
        .s_axis_input_tvalid (deintlv_valid),
        .s_axis_input_tlast  (rs_tlast),
        .s_axis_input_tready (rs_in_ready),

        .output_tdata        (dec_data),
        .output_tvalid       (dec_valid),
        .output_tready       (i_data_ready)
    );

    assign o_data  = dec_data;
    assign o_valid = dec_valid;

// ila probe 8,1 

endmodule
