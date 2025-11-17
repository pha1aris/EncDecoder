`timescale 1ns/1ps

module fec_rx #(
    parameter integer W             = 32,
    parameter integer PAYLOAD_WORDS = 16,
    parameter integer RS_N          = 255,
    parameter integer INTLV_D       = 4808,
    parameter integer INTLV_N       = 255
)(
    input  wire             core_clk,
    input  wire             rst_n,

    // 来自 GTH RX 的并行数据（已经是 parallel data）
    input  wire [W-1:0]     i_rx_data,
    input  wire             i_rx_valid,
    input  wire             rx_reset_done,
    input  wire             rx_cdr_stable,

    // 解码后的 8bit 数据
    output wire [7:0]       o_data,
    output wire             o_valid,

    // 调试信号
    output wire             o_rxslide,
    output wire             o_bit_locked,
    output wire [15:0]      o_frame_index,
    output wire [15:0]      o_block_id,
    output wire [15:0]      o_frame_in_block
);

    wire rst = ~rst_n;

    // ==================== bit_aligner ====================
    wire [W-1:0] aligned_data;
    wire         aligned_valid;
    wire         realign_req;

    bit_aligner #(
        .W                 (W),
        .VERIFY_CNT_MAX    (8),
        .SLIDE_COOLDOWN    (5),
        .ERR_TH            (0),
        .CHECK_TIMEOUT_MAX (2048)
    ) u_bit_aligner (
        .clk            (core_clk),
        .rst_n          (rst_n),
        .rx_reset_done  (rx_reset_done),
        .rx_cdr_stable  (rx_cdr_stable),
        .i_rx_data      (i_rx_data),
        .i_rx_valid     (i_rx_valid),
        .i_realign_req  (realign_req),
        .o_rxslide      (o_rxslide),
        .o_aligned_valid(aligned_valid),
        .o_bit_locked   (o_bit_locked),
        .o_data_aligned (aligned_data)
    );

    // 只有在对齐后才喂给 deframer
    wire deframer_rx_valid = i_rx_valid & aligned_valid;

    // ==================== deframer =======================
    wire [W-1:0] rx_payload_data;
    wire         rx_payload_valid;

    wire [15:0]  frame_index_rx;
    wire [15:0]  block_id_rx;
    wire [15:0]  frame_in_block_rx;
    wire         blk_soft_rst;

    fso_deframer #(
        .W                 (W),
        .PAYLOAD_WORDS     (PAYLOAD_WORDS),
        .FRAME_TIMEOUT_MAX (64)
    ) u_fso_deframer (
        .clk              (core_clk),
        .rst_n            (rst_n),
        .i_link_up        (aligned_valid),
        .i_rx_data        (aligned_data),
        .i_rx_valid       (deframer_rx_valid),
        .o_realign_req    (realign_req),
        .o_frame_start    (),                 // 如果需要可以往下传
        .o_frame_index    (frame_index_rx),
        .o_block_id       (block_id_rx),
        .o_frame_in_block (frame_in_block_rx),
        .o_blk_soft_rst   (blk_soft_rst),
        .o_payload_data   (rx_payload_data),
        .o_payload_valid  (rx_payload_valid)
    );

    assign o_frame_index    = frame_index_rx;
    assign o_block_id       = block_id_rx;
    assign o_frame_in_block = frame_in_block_rx;

    // =============== 32bit → 8bit gearbox ===============
    wire [7:0]  gb8_data;
    wire        gb8_valid;

    gearbox_32to8 u_gb_32to8 (
        .clk      (core_clk),
        .rst      (rst),
        .in_data  (rx_payload_data),
        .in_valid (rx_payload_valid),
        .out_data (gb8_data),
        .out_valid(gb8_valid)
    );

    // 将 blk_soft_rst 同步一拍后送给去交织器
    reg blk_soft_rst_d;
    always @(posedge core_clk or posedge rst) begin
        if (rst)
            blk_soft_rst_d <= 1'b0;
        else
            blk_soft_rst_d <= blk_soft_rst;
    end

    // =================== 去交织器 ========================
    wire [7:0] deintlv_data;
    wire       deintlv_valid;
    wire       deintlv_block_start;

    rs_deinterleaver_xpm #(
        .D (INTLV_D),
        .N (INTLV_N)
    ) u_deinterleaver (
        .clk        (core_clk),
        .rst        (rst),
        .blk_soft_rst(blk_soft_rst_d),
        .in_valid   (gb8_valid),
        .in_data    (gb8_data),
        .in_ready   (),              // 模块内部 assign 1'b1
        .out_valid  (deintlv_valid),
        .out_data   (deintlv_data),
        .block_start(deintlv_block_start)
    );

    // =================== RS 解码 ========================
    wire [7:0] dec_data;
    wire       dec_valid;
    wire       dec_last;

    rs_decode_backend #(
        .RS_N (RS_N)
    ) u_rs_decode_backend (
        .clk    (core_clk),
        .rst    (rst),
        .i_data (deintlv_data),
        .i_valid(deintlv_valid),
        .i_ready(),      // 当前不反压
        .o_data (dec_data),
        .o_valid(dec_valid),
        .o_last (dec_last)
    );

    assign o_data  = dec_data;
    assign o_valid = dec_valid;

endmodule
