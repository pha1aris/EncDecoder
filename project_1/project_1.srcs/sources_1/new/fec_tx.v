`timescale 1ns/1ps

module fec_tx #(
    parameter integer W             = 32,
    parameter integer PAYLOAD_WORDS = 16,
    parameter integer RS_K          = 229,
    parameter integer RS_N          = 255,
    parameter integer INTLV_D       = 4808,
    parameter integer INTLV_N       = 255
)(
    input  wire             core_clk,
    input  wire             rst_n,

    // 上游原始 8bit 数据（也可以内部接 PRBS）
    input  wire [7:0]       i_data,
    input  wire             i_valid,
    output wire             i_ready,

    // 输出给 GTH TX 的 32bit 数据
    output wire [W-1:0]     o_tx_data,
    output wire             o_tx_valid,
    output wire [15:0]      o_tx_frame_index
);

    wire rst = ~rst_n;

    // ================= RS 编码 =================
    wire [7:0] enc_data;
    wire       enc_valid;

    rs_encode_frontend #(
        .RS_K (RS_K)
    ) u_rs_encode_frontend (
        .clk    (core_clk),
        .rst    (rst),
        .i_data (i_data),
        .i_valid(i_valid),
        .i_ready(i_ready),
        .o_data (enc_data),
        .o_valid(enc_valid),
        .o_ready(1'b1)      // 下游交织器当前不反压
    );

    // ================= 交织器 ==================
    wire        intlv_valid;
    wire [7:0]  intlv_data;
    wire        intlv_block_start;

    rs_interleaver_xpm #(
        .D (INTLV_D),
        .N (INTLV_N)
    ) u_interleaver (
        .clk            (core_clk),
        .rst            (rst),
        .in_valid       (enc_valid),
        .in_data        (enc_data),
        .in_ready       (),          // 模块内部 assign 1'b1
        .in_tlast       (1'b0),
        .out_valid      (intlv_valid),
        .out_data       (intlv_data),
        .out_block_start(intlv_block_start)
    );

    // =============== 8bit → 32bit 打包 + 块起始 ===============
    wire [31:0] payload_word;
    wire        payload_word_valid;
    wire        block_start_word;

    gearbox_8to32_bs u_gb_8to32 (
        .clk             (core_clk),
        .rst             (rst),
        .in_data         (intlv_data),
        .in_valid        (intlv_valid),
        .in_block_start  (intlv_block_start),
        .out_data        (payload_word),
        .out_valid       (payload_word_valid),
        .out_block_start (block_start_word)
    );

    // ================= 帧封装器 =================
    fso_framer #(
        .W             (W),
        .PAYLOAD_WORDS (PAYLOAD_WORDS)
    ) u_fso_framer (
        .clk              (core_clk),
        .rst_n            (rst_n),
        .i_payload_data   (payload_word),
        .i_payload_valid  (payload_word_valid),
        .i_block_start_word(block_start_word),
        .o_payload_ready  (),            // 目前没有往回反压
        .o_tx_data        (o_tx_data),
        .o_tx_valid       (o_tx_valid),
        .o_frame_index    (o_tx_frame_index)
    );

    // 这里 o_tx_data / o_tx_valid 就可以直接连到 GTH TX
endmodule
