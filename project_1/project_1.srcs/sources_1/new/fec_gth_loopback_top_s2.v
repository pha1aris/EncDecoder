`timescale 1ns/1ps
`include "global_defines.vh"

//==============================================================
// Stage2 Top: bit align + frame sync + RS(255,229) + PRBS verify
//  - 结构尽量贴近已通过验证的 S1：
//    * TX 不做 rate_gate/hold，持续流更利于 bit_aligner
//    * PRBS checker：只推进LFSR，不用 frame_locked gate；统计用 meas_ok gate
//    * meas_ok = bit_locked & frame_locked
//==============================================================
module fec_gth_loopback_top_s2 #(
    parameter integer W                = 32,
    parameter integer PAYLOAD_WORDS    = 16,

    parameter integer RS_K             = 229,
    parameter integer RS_N             = 255,

    // 推荐：INTLV_D=64, RS_N=255 时 BLK_OUT_BYTES=16320，与 16*4*255 对齐
    parameter integer INTLV_D          = 64,
    parameter integer INTLV_N          = 255,

    parameter integer FRAMES_PER_BLOCK = 255,
    parameter integer LOCK_THRESH      = 1024,

    parameter integer TEST_PRBS        = 1,
    parameter integer IGNORE_SFP_LOSS  = 0
)(
    input  wire         sys_clk_p,
    input  wire         sys_clk_n,
    input  wire         sys_rst_n,

    input  wire         mgtrefclk0_x1y1_p,
    input  wire         mgtrefclk0_x1y1_n,

    input  wire         gthrxp_in,
    input  wire         gthrxn_in,
    output wire         gthtxp_out,
    output wire         gthtxn_out,

    input  wire [1:0]   sfp_loss,
    output wire [1:0]   tx_disable
);
    assign tx_disable = 2'b00;

    //==========================================================
    // 1) clocks & logic reset
    //==========================================================
    wire freerun_clk, core_clk, axi_clk, clk_locked;

    clk_wiz_sys u_clk_wiz (
        .clk_out1 (freerun_clk),
        .clk_out2 (core_clk),
        .clk_out3 (axi_clk),
        .reset    (~sys_rst_n),
        .locked   (clk_locked),
        .clk_in1_p(sys_clk_p),
        .clk_in1_n(sys_clk_n)
    );

    wire logic_rst_n = sys_rst_n & clk_locked;
    wire logic_rst   = ~logic_rst_n;

    //==========================================================
    // 2) VIO controls（贴近 S1）
    //==========================================================
    wire        ber_clr;
    wire        scrambler_en;
    wire [2:0]  loop_backmode;
    wire        tx_pattern_prbs_vio;
    wire [31:0] ber_result_to_vio;

    wire gth_reset_all = ~sys_rst_n | ~clk_locked;

    // loop_backmode CDC -> freerun_clk
    reg [2:0] loopback_fr1, loopback_fr2;
    always @(posedge freerun_clk) begin
        if (gth_reset_all) begin
            loopback_fr1 <= 3'b000;
            loopback_fr2 <= 3'b000;
        end else begin
            loopback_fr1 <= loop_backmode;
            loopback_fr2 <= loopback_fr1;
        end
    end
    wire [2:0] loop_backmode_fr = loopback_fr2;

`ifdef SIM
    assign loop_backmode        = 3'b000;
    assign scrambler_en         = 1'b0;             // 与 S1 一致：Stage bring-up 建议关
    assign ber_clr              = 1'b0;
    assign tx_pattern_prbs_vio  = (TEST_PRBS != 0);
`else
    vio_2 u_vio_ctrl (
        .clk        (core_clk),
        .probe_out0 (ber_clr),
        .probe_out1 (scrambler_en),
        .probe_out2 (loop_backmode),
        .probe_out3 (tx_pattern_prbs_vio),
        .probe_in0  (ber_result_to_vio)
    );
`endif

    // PRBS/Counter 模式选择同步（贴近 S1）
    reg tx_pat_ff1, tx_pat_ff2, tx_pat_ff2_d;
    always @(posedge core_clk) begin
        if (logic_rst) begin
            tx_pat_ff1   <= tx_pattern_prbs_vio;
            tx_pat_ff2   <= tx_pattern_prbs_vio;
            tx_pat_ff2_d <= tx_pattern_prbs_vio;
        end else begin
            tx_pat_ff1   <= tx_pattern_prbs_vio;
            tx_pat_ff2   <= tx_pat_ff1;
            tx_pat_ff2_d <= tx_pat_ff2;
        end
    end
    wire use_prbs = tx_pat_ff2;
    wire use_cnt  = ~tx_pat_ff2;

    //==========================================================
    // 3) GTH raw top
    //==========================================================
    wire        tx_usr_clk, rx_usr_clk;
    wire        tx_rst_n,   rx_rst_n;
    wire        tx_done,    rx_done;
    wire        tx_active,  rx_active;
    wire        cdr_stable;
    wire [W-1:0] rx_data_from_gth;
    wire [W-1:0] tx_data_to_gth;
    wire         rx_slide_req;

    gth_raw_top #(.W(W)) u_gth_raw (
        .freerun_clk        (freerun_clk),
        .gth_reset_all      (gth_reset_all),

        .mgtrefclk0_x1y1_p  (mgtrefclk0_x1y1_p),
        .mgtrefclk0_x1y1_n  (mgtrefclk0_x1y1_n),
        .gthrxp_in          (gthrxp_in),
        .gthrxn_in          (gthrxn_in),
        .gthtxp_out         (gthtxp_out),
        .gthtxn_out         (gthtxn_out),

        .i_loopback         (loop_backmode_fr),
        .o_pll_locked       (),

        .o_tx_clk           (tx_usr_clk),
        .o_tx_rst_n         (tx_rst_n),
        .o_tx_done          (tx_done),
        .o_tx_active        (tx_active),
        .i_tx_data          (tx_data_to_gth),

        .o_rx_clk           (rx_usr_clk),
        .o_rx_rst_n         (rx_rst_n),
        .o_rx_done          (rx_done),
        .o_rx_active        (rx_active),
        .o_cdr_stable       (cdr_stable),
        .o_rx_data          (rx_data_from_gth),
        .i_rx_slide         (rx_slide_req)
    );

    // CDC: done/rst_n -> core_clk
    reg tx_done_cdc1, tx_done_cdc2;
    reg tx_rstn_cdc1, tx_rstn_cdc2;
    reg rx_done_cdc1, rx_done_cdc2;
    reg rx_rstn_cdc1, rx_rstn_cdc2;
    always @(posedge core_clk or posedge logic_rst) begin
        if (logic_rst) begin
            tx_done_cdc1 <= 1'b0; tx_done_cdc2 <= 1'b0;
            tx_rstn_cdc1 <= 1'b0; tx_rstn_cdc2 <= 1'b0;
            rx_done_cdc1 <= 1'b0; rx_done_cdc2 <= 1'b0;
            rx_rstn_cdc1 <= 1'b0; rx_rstn_cdc2 <= 1'b0;
        end else begin
            tx_done_cdc1 <= tx_done;  tx_done_cdc2 <= tx_done_cdc1;
            tx_rstn_cdc1 <= tx_rst_n; tx_rstn_cdc2 <= tx_rstn_cdc1;
            rx_done_cdc1 <= rx_done;  rx_done_cdc2 <= rx_done_cdc1;
            rx_rstn_cdc1 <= rx_rst_n; rx_rstn_cdc2 <= rx_rstn_cdc1;
        end
    end
    wire tx_done_core  = tx_done_cdc2;
    wire tx_rst_n_core = tx_rstn_cdc2;
    wire rx_done_core  = rx_done_cdc2;
    wire rx_rst_n_core = rx_rstn_cdc2;

    //==========================================================
    // 4) SFP loss gating（贴近 S1）
    //==========================================================
    reg [1:0] loss_core_ff1, loss_core_ff2;
    reg [1:0] loss_rx_ff1,   loss_rx_ff2;

    always @(posedge core_clk) begin
        if (logic_rst) begin
            loss_core_ff1 <= 2'b11;
            loss_core_ff2 <= 2'b11;
        end else begin
            loss_core_ff1 <= sfp_loss;
            loss_core_ff2 <= loss_core_ff1;
        end
    end

    always @(posedge rx_usr_clk) begin
        if (!rx_rst_n) begin
            loss_rx_ff1 <= 2'b11;
            loss_rx_ff2 <= 2'b11;
        end else begin
            loss_rx_ff1 <= sfp_loss;
            loss_rx_ff2 <= loss_rx_ff1;
        end
    end

    wire have_light_core = (IGNORE_SFP_LOSS != 0) ? 1'b1 : ~loss_core_ff2[0];
    wire have_light_line = (IGNORE_SFP_LOSS != 0) ? 1'b1 : ~loss_rx_ff2[0];

    //==========================================================
    // 5) TX: src(8b) -> fec_tx_s2 -> line（贴近 S1：不做 rate_gate/hold）
    //==========================================================
    // CDC tx_active -> core_clk
    reg tx_act_cdc1, tx_act_cdc2;
    always @(posedge core_clk or posedge logic_rst) begin
        if (logic_rst) begin
            tx_act_cdc1 <= 1'b0;
            tx_act_cdc2 <= 1'b0;
        end else begin
            tx_act_cdc1 <= tx_active;
            tx_act_cdc2 <= tx_act_cdc1;
        end
    end
    wire tx_active_core = tx_act_cdc2;

    // 与 S1 一致：tx_path_rst_n 不额外挂 hold
    wire tx_path_rst_n = logic_rst_n & tx_rst_n_core & tx_done_core;
    wire tx_path_rst   = ~tx_path_rst_n;

    wire src_ready;

    wire [7:0] prbs_tx_data;
    wire prbs_en = use_prbs & src_ready & tx_active_core;

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (0),
        .INV_PATTERN (0),
        .POLY_LENGHT (7),
        .POLY_TAP    (6),
        .NBITS       (8)
    ) u_prbs_gen_tx (
        .RST      (tx_path_rst),
        .CLK      (core_clk),
        .DATA_IN  (8'd0),
        .EN       (prbs_en),
        .DATA_OUT (prbs_tx_data)
    );

    // 与 S1 一致：Counter 简化为 8-bit 连续计数
    reg [7:0] cnt_data;
    wire cnt_en = use_cnt & src_ready & tx_active_core;

    always @(posedge core_clk) begin
        if (tx_path_rst) begin
            cnt_data <= 8'd0;
        end else if (cnt_en) begin
            cnt_data <= cnt_data + 1'b1;
        end
    end

    wire [7:0] src_data  = use_prbs ? prbs_tx_data : cnt_data;
    wire       src_valid = use_prbs ? prbs_en      : cnt_en;

    wire [31:0] fec_tx_data_line;
    wire        fec_tx_valid_line;
    wire [15:0] tx_frame_index;

    fec_tx_s2 #(
        .W(W),
        .PAYLOAD_WORDS(PAYLOAD_WORDS),
        .RS_K(RS_K),
        .RS_N(RS_N),
        .INTLV_D(INTLV_D),
        .FRAMES_PER_BLOCK(FRAMES_PER_BLOCK)
    ) u_fec_tx_s2 (
        .line_clk         (tx_usr_clk),
        .core_clk         (core_clk),
        .rst_n            (tx_path_rst_n),

        .i_data           (src_data),
        .i_valid          (src_valid),
        .i_ready          (src_ready),

        .scrambler_en     (scrambler_en),
        .o_tx_data_line   (fec_tx_data_line),
        .o_tx_valid_line  (fec_tx_valid_line),
        .o_tx_frame_index (tx_frame_index)
    );

    assign tx_data_to_gth = fec_tx_data_line;

    //==========================================================
    // 6) RX: line -> fec_rx_s2 -> 8b
    //==========================================================
    wire fec_rx_rst_n = logic_rst_n & rx_rst_n_core & rx_done_core;

    // rx_active/cdr_stable sync to rx_usr_clk（贴近 S1）
    reg rx_act_l1, rx_act_l2;
    reg cdr_st_l1, cdr_st_l2;
    always @(posedge rx_usr_clk or negedge rx_rst_n) begin
        if (!rx_rst_n) begin
            rx_act_l1 <= 1'b0; rx_act_l2 <= 1'b0;
            cdr_st_l1 <= 1'b0; cdr_st_l2 <= 1'b0;
        end else begin
            rx_act_l1 <= rx_active;  rx_act_l2 <= rx_act_l1;
            cdr_st_l1 <= cdr_stable; cdr_st_l2 <= cdr_st_l1;
        end
    end

    wire rx_active_line  = rx_act_l2;
    wire cdr_stable_line = cdr_st_l2;

    wire rx_word_valid_line = rx_active_line & cdr_stable_line & have_light_line;

    wire [7:0]  fec_rx_data;
    wire        fec_rx_valid;
    wire        bit_locked_core;
    wire        frame_locked_core;
    wire [15:0] rx_frame_index, rx_block_id, rx_frame_in_block;

    fec_rx_s2 #(
        .W(W),
        .PAYLOAD_WORDS(PAYLOAD_WORDS),
        .RS_N(RS_N)
    ) u_fec_rx_s2 (
        .line_clk          (rx_usr_clk),
        .core_clk          (core_clk),
        .rst_n             (fec_rx_rst_n),

        .i_rx_data         (rx_data_from_gth),
        .i_rx_valid        (rx_word_valid_line),
        .rx_reset_done     (rx_active_line),
        .rx_cdr_stable     (cdr_stable_line),

        .scrambler_en      (scrambler_en),

        .o_data            (fec_rx_data),
        .o_valid           (fec_rx_valid),
        .i_data_ready      (1'b1),

        .o_rxslide         (rx_slide_req),
        .bit_locked_core   (bit_locked_core),
        .frame_locked_core (frame_locked_core),

        .o_frame_index     (rx_frame_index),
        .o_block_id        (rx_block_id),
        .o_frame_in_block  (rx_frame_in_block)
    );

    //==========================================================
    // 7) PRBS checker + BER（按 S1 思路）
    //==========================================================
    localparam [31:0] BER_CODE_LINK_DOWN = 32'hFFFF_FFFF;
    localparam [31:0] BER_CODE_SEARCHING = 32'hFFFF_FFFE;

    // ber_clr sync
    reg ber_clr_ff1, ber_clr_ff2, ber_clr_ff2_d;
    always @(posedge core_clk) begin
        if (logic_rst) begin
            ber_clr_ff1 <= 1'b0; ber_clr_ff2 <= 1'b0; ber_clr_ff2_d <= 1'b0;
        end else begin
            ber_clr_ff1   <= ber_clr;
            ber_clr_ff2   <= ber_clr_ff1;
            ber_clr_ff2_d <= ber_clr_ff2;
        end
    end
    wire ber_clear_pulse = ber_clr_ff2 & ~ber_clr_ff2_d;

    // meas_ok：与 S1 一致：bit_locked + frame_locked
    wire prbs_meas_ok =
        have_light_core &
        use_prbs &
        tx_done_core & rx_done_core &
        bit_locked_core &
        frame_locked_core;

    wire        prbs_chk_rst = logic_rst;                 // 贴 S1：不要绑 ber_clear/模式切换
    wire        prbs_chk_en  = fec_rx_valid & use_prbs;   // 贴 S1
    wire        prbs_cnt_en  = fec_rx_valid & prbs_meas_ok;

    wire [7:0]  prbs_err_vec;

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (1),
        .INV_PATTERN (0),
        .POLY_LENGHT (7),
        .POLY_TAP    (6),
        .NBITS       (8)
    ) u_prbs_chk_rx (
        .RST      (prbs_chk_rst),
        .CLK      (core_clk),
        .DATA_IN  (fec_rx_data),
        .EN       (prbs_chk_en),
        .DATA_OUT (prbs_err_vec)
    );

    function integer popcount8;
        input [7:0] v;
        integer k;
        begin
            popcount8 = 0;
            for (k = 0; k < 8; k = k + 1)
                popcount8 = popcount8 + v[k];
        end
    endfunction

    reg [63:0] total_bits_cnt, total_err_cnt;
    always @(posedge core_clk) begin
        if (logic_rst || ber_clear_pulse || !prbs_meas_ok) begin
            total_bits_cnt <= 64'd0;
            total_err_cnt  <= 64'd0;
        end else if (prbs_cnt_en) begin
            total_bits_cnt <= total_bits_cnt + 64'd8;
            total_err_cnt  <= total_err_cnt + popcount8(prbs_err_vec);
        end
    end

    reg [31:0] ber_out;
    always @(posedge core_clk) begin
        if (logic_rst) begin
            ber_out <= BER_CODE_LINK_DOWN;
        end else if (!use_prbs) begin
            ber_out <= 32'd0;
        end else if (!have_light_core) begin
            ber_out <= BER_CODE_LINK_DOWN;
        end else if (!prbs_meas_ok) begin
            ber_out <= BER_CODE_SEARCHING;
        end else begin
            ber_out <= total_err_cnt[31:0];
        end
    end
    assign ber_result_to_vio = ber_out;

endmodule
