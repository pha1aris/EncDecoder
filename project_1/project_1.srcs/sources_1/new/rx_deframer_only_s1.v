`timescale 1ns/1ps
`include "global_defines.vh"

module rx_deframer_only_s1 #(
    parameter integer W             = 32,
    parameter integer PAYLOAD_WORDS = 16,
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
    output wire             frame_locked_core,
    output wire [15:0]      o_frame_index,
    output wire [15:0]      o_block_id,
    output wire [15:0]      o_frame_in_block
);
    wire rst = ~rst_n;

    // ---- cfg（与你原 fec_rx 保持一致）
    localparam integer VERIFY_CNT_MAX    = 4;
    localparam integer ERR_TH            = 2;
    localparam integer LOCK_LOSS_TIMEOUT = 4096;
    localparam integer FRAME_TIMEOUT_MAX = 64;

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

    // ---- 1) bit_aligner
    wire [W-1:0] aligned_data;
    wire         aligned_valid;
    wire         realign_req;
    wire         o_bit_locked;

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

    // bit_locked sync to core
    reg [1:0] bit_locked_sync;
    always @(posedge core_clk or negedge rst_n) begin
        if (!rst_n) bit_locked_sync <= 2'b00;
        else       bit_locked_sync <= {bit_locked_sync[0], o_bit_locked};
    end
    assign bit_locked_core = bit_locked_sync[1];

    // ---- 2) async fifo line->core (FWFT)
    wire [W-1:0] rx32_fifo_dout;
    wire         rx32_fifo_empty, rx32_fifo_full;
    wire         rx32_fifo_wr_rst_busy, rx32_fifo_rd_rst_busy;
    wire         rx32_fifo_rd_en;

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

    // ---- 2.1) prefetch/skid
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

    // ---- 3) deframer
    wire [W-1:0] df_m_tdata;
    wire [1:0]   df_m_tuser;
    wire         df_m_tvalid;
    wire         df_m_tready;
    wire         frame_locked;

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
        .o_frame_start         (),
        .o_frame_index         (o_frame_index),
        .o_block_id            (o_block_id),
        .o_frame_in_block      (o_frame_in_block),
        .o_blk_soft_rst        (),
        .o_frame_locked        (frame_locked),
        .o_block_aligned       (),

        .cfg_frame_timeout_max (cfg_frame_to),
        .cfg_crc_bad_th        (cfg_crc_bad_th),
        .cfg_pre_bad_th        (cfg_pre_bad_th),
        .cfg_realign_or        (cfg_realign_mode)
    );
    assign frame_locked_core = frame_locked;

    // ---- 4) deframer 后保险 FIFO（保持你原结构）
    wire [W:0] fifo_s_tdata  = {df_m_tuser[0], df_m_tdata};
    wire       fifo_s_tvalid = df_m_tvalid;
    wire       fifo_s_tready;
    wire [W:0] fifo_m_tdata;
    wire       fifo_m_tvalid;
    wire       fifo_m_tready;

    assign df_m_tready = fifo_s_tready;

    axis_fifo_sync #(
        .WIDTH (W+1),
        .DEPTH (DF_AXIS_FIFO_DEPTH)
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

    // ---- 5) 32->8 gearbox，直接输出 payload 字节
    wire [7:0] gb8_data;
    wire       gb8_valid;
    wire       gb8_sync_rst;
    wire       gb8_ready;
    wire       gb32_in_ready;

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

    assign gb8_ready = i_data_ready;
    assign o_data    = gb8_data;
    assign o_valid   = gb8_valid;

endmodule
