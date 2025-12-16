`timescale 1ns / 1ps
`include "global_defines.vh"

module fec_gth_loopback_top #(
    parameter integer W                = 32,
    parameter integer PAYLOAD_WORDS    = 16,
    parameter integer RS_K             = 229,
    parameter integer RS_N             = 255,
    parameter integer INTLV_D          = 64,
    parameter integer INTLV_N          = 255,
    parameter integer FRAMES_PER_BLOCK = 255,
    parameter integer LOCK_THRESH      = 1024,

    // SIM 默认模式：1=PRBS，0=Counter（综合时由 VIO 动态控制）
    parameter integer TEST_PRBS        = 1
)(
    input  wire         sys_clk_p,
    input  wire         sys_clk_n,
    input  wire         sys_rst_n,        // 低有效

    input  wire         mgtrefclk0_x1y1_p,
    input  wire         mgtrefclk0_x1y1_n,

    input  wire         gthrxp_in,
    input  wire         gthrxn_in,
    output wire         gthtxp_out,
    output wire         gthtxn_out,

    output wire [1:0]   tx_disable
);
    assign tx_disable = 2'b00;

    //======================================================================
    // 1. 时钟 & 逻辑复位
    //======================================================================
    wire freerun_clk;
    wire core_clk;
    wire axi_clk;
    wire clk_locked;

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


    //======================================================================
    // 0. VIO 控制信号
    //======================================================================
    wire        ber_clr;
    wire        scrambler_en;
    wire [2:0]  loop_backmode;

    // VIO 控制 PRBS/Counter（1=PRBS，0=Counter）
    wire        tx_pattern_prbs_vio;

    wire gth_reset_all = ~sys_rst_n | ~clk_locked;

    // loop_backmode CDC (core_clk/VIO -> freerun_clk)
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

    // VIO 输出给 probe_in
    wire [31:0] ber_result_to_vio;

`ifdef SIM
    assign loop_backmode        = 3'b001;
    assign scrambler_en         = 1'b0;
    assign ber_clr              = 1'b0;
    assign tx_pattern_prbs_vio  = (TEST_PRBS != 0); // SIM 用参数作为默认选择
`else
    // VIO: probe_in0 = 32bit, probe_out0/1/2/3
    vio_2 u_vio_ctrl (
        .clk        (core_clk),
        .probe_out0 (ber_clr),
        .probe_out1 (scrambler_en),
        .probe_out2 (loop_backmode),
        .probe_out3 (tx_pattern_prbs_vio), // 1=PRBS,0=Counter
        .probe_in0  (ber_result_to_vio)
    );
`endif


    reg tx_pat_ff1, tx_pat_ff2, tx_pat_ff2_d;
    always @(posedge core_clk) begin
        if (logic_rst) begin
            // 关键：上电默认值跟随 VIO（或 SIM 参数）当前值，避免伪切换
            tx_pat_ff1   <= tx_pattern_prbs_vio;
            tx_pat_ff2   <= tx_pattern_prbs_vio;
            tx_pat_ff2_d <= tx_pattern_prbs_vio;
        end else begin
            tx_pat_ff1   <= tx_pattern_prbs_vio;
            tx_pat_ff2   <= tx_pat_ff1;
            tx_pat_ff2_d <= tx_pat_ff2;
        end
    end

    (* MARK_DEBUG="true" *) wire test_prbs_sel   = tx_pat_ff2;                 // 1=PRBS,0=Counter
    (* MARK_DEBUG="true" *) wire tx_pat_sw_pulse = (tx_pat_ff2 ^ tx_pat_ff2_d);

    wire use_prbs = test_prbs_sel;
    wire use_cnt  = ~test_prbs_sel;

    // 切换 holdoff：切换后暂停若干拍并复位发生器/检查器/统计（避免过渡态污染 ILA/BER）
    reg [2:0] tx_pat_hold_cnt;
    always @(posedge core_clk) begin
        if (logic_rst) begin
            tx_pat_hold_cnt <= 3'd0;
        end else if (tx_pat_sw_pulse) begin
            tx_pat_hold_cnt <= 3'd4; // 可按需要调 4~8
        end else if (tx_pat_hold_cnt != 0) begin
            tx_pat_hold_cnt <= tx_pat_hold_cnt - 1'b1;
        end
    end
    (* MARK_DEBUG="true" *) wire tx_pat_hold = (tx_pat_hold_cnt != 0);

    //======================================================================
    // 2. GTH 顶层
    //======================================================================
    wire        tx_usr_clk;
    wire        tx_rst_n;
    (* MARK_DEBUG="true" *) wire         tx_done;
    (* MARK_DEBUG="true" *) wire         tx_active;

    wire        rx_usr_clk;
    wire        rx_rst_n;
    (* MARK_DEBUG="true" *) wire         rx_done;
    (* MARK_DEBUG="true" *) wire         rx_active;
    (* MARK_DEBUG="true" *) wire         cdr_stable;
    (* MARK_DEBUG="true" *) wire [W-1:0] rx_data_from_gth;

    (* MARK_DEBUG="true" *) wire [W-1:0] tx_data_to_gth;
    (* MARK_DEBUG="true" *) wire         rx_slide_req;

    gth_raw_top #(
        .W (W)
    ) u_gth_raw (
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

    // CDC: tx_done/tx_rst_n/rx_done/rx_rst_n -> core_clk 域
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
            tx_done_cdc1 <= tx_done;
            tx_done_cdc2 <= tx_done_cdc1;
            tx_rstn_cdc1 <= tx_rst_n;
            tx_rstn_cdc2 <= tx_rstn_cdc1;
            rx_done_cdc1 <= rx_done;
            rx_done_cdc2 <= rx_done_cdc1;
            rx_rstn_cdc1 <= rx_rst_n;
            rx_rstn_cdc2 <= rx_rstn_cdc1;
        end
    end

    wire tx_done_core  = tx_done_cdc2;
    wire tx_rst_n_core = tx_rstn_cdc2;
    wire rx_done_core  = rx_done_cdc2;
    wire rx_rst_n_core = rx_rstn_cdc2;

    wire tx_path_rst_n = logic_rst_n & tx_rst_n_core & tx_done_core & ~tx_pat_hold;
    wire tx_path_rst   = ~tx_path_rst_n;
    //======================================================================
    // 3. TX：PRBS/Counter → FEC_TX → GTH
    //======================================================================


    (* MARK_DEBUG="true" *) wire [7:0]  prbs_tx_data;
    (* MARK_DEBUG="true" *) wire        prbs_tx_ready;



    (* MARK_DEBUG="true" *) wire [W-1:0] fec_tx_data_line;
    (* MARK_DEBUG="true" *) wire         fec_tx_valid_line;
    (* MARK_DEBUG="true" *) wire [15:0]  tx_frame_index;

    // CDC: tx_active -> core_clk
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

    // 速率门控
    localparam integer RATE_TOT = 64;
    localparam integer RATE_ON  = 29;
    reg [$clog2(RATE_TOT)-1:0] rate_cnt;
    wire rate_gate = (rate_cnt < RATE_ON);
    // wire src_fire  = src_valid && prbs_tx_ready; 

    always @(posedge core_clk) begin
        if (tx_path_rst) begin
            rate_cnt <= RATE_TOT-1;
        end else if (tx_active_core && prbs_tx_ready) begin
            if (rate_cnt == RATE_TOT-1)
                rate_cnt <= 'd0;
            else
                rate_cnt <= rate_cnt + 1'b1;
        end
    end
    // 模式切换 holdoff 期间不发数（避免过渡态）
    wire prbs_en = use_prbs & prbs_tx_ready & tx_active_core & rate_gate & ~tx_pat_hold;
    wire cnt_en  = use_cnt  & prbs_tx_ready & tx_active_core & rate_gate & ~tx_pat_hold;

    // PRBS7 gen（切换时复位）
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

    // Counter gen
    reg [7:0] cnt_data;
    (* MARK_DEBUG="true" *) wire [7:0] src_data  = use_prbs ? prbs_tx_data : cnt_data;
    (* MARK_DEBUG="true" *) wire       src_valid = use_prbs ? prbs_en      : cnt_en;
    always @(posedge core_clk) begin
        if (tx_path_rst) begin
            cnt_data <= 8'd0;
        end else if (cnt_en) begin
            if (cnt_data == 8'd228)
                cnt_data <= 8'd0;
            else
                cnt_data <= cnt_data + 1'b1;
        end
    end

    fec_tx #(
        .W                (W),
        .PAYLOAD_WORDS    (PAYLOAD_WORDS),
        .RS_K             (RS_K),
        .RS_N             (RS_N),
        .INTLV_D          (INTLV_D),
        .INTLV_N          (INTLV_N),
        .FRAMES_PER_BLOCK (FRAMES_PER_BLOCK)
    ) u_fec_tx (
        .line_clk         (tx_usr_clk),
        .core_clk         (core_clk),
        .rst_n            (tx_path_rst_n),

        .scrambler_en     (scrambler_en),

        .i_data           (src_data),
        .i_valid          (src_valid),
        .i_ready          (prbs_tx_ready),

        .o_tx_data        (),
        .o_tx_valid       (),
        .o_tx_data_line   (fec_tx_data_line),
        .o_tx_valid_line  (fec_tx_valid_line),
        .o_tx_frame_index (tx_frame_index)
    );

    assign tx_data_to_gth = fec_tx_data_line;

    //======================================================================
    // 4. RX：GTH → FEC_RX → PRBS 检查
    //======================================================================
    (* MARK_DEBUG="true" *) wire [7:0]  fec_rx_data;
    (* MARK_DEBUG="true" *) wire        fec_rx_valid;
    (* MARK_DEBUG="true" *) wire        bit_locked;
    wire [15:0] rx_frame_index;
    wire [15:0] rx_block_id;
    wire [15:0] rx_frame_in_block;

    wire fec_rx_rst_n = logic_rst_n & rx_rst_n_core & rx_done_core;

    // CDC: rx_active/cdr_stable -> rx_usr_clk
    reg rx_act_l1, rx_act_l2;
    reg cdr_st_l1, cdr_st_l2;

    always @(posedge rx_usr_clk or negedge rx_rst_n) begin
        if (!rx_rst_n) begin
            rx_act_l1 <= 1'b0; rx_act_l2 <= 1'b0;
            cdr_st_l1 <= 1'b0; cdr_st_l2 <= 1'b0;
        end else begin
            rx_act_l1 <= rx_active;
            rx_act_l2 <= rx_act_l1;

            cdr_st_l1 <= cdr_stable;
            cdr_st_l2 <= cdr_st_l1;
        end
    end

    wire rx_active_line   = rx_act_l2;
    wire cdr_stable_line  = cdr_st_l2;

    fec_rx #(
        .W             (W),
        .PAYLOAD_WORDS (PAYLOAD_WORDS),
        .RS_N          (RS_N),
        .INTLV_D       (INTLV_D),
        .INTLV_N       (INTLV_N)
    ) u_fec_rx (
        .line_clk         (rx_usr_clk),
        .core_clk         (core_clk),
        .rst_n            (fec_rx_rst_n),

        .i_rx_data        (rx_data_from_gth),
        .i_rx_valid       (1'b1),

        .rx_reset_done    (rx_active_line),
        .rx_cdr_stable    (cdr_stable_line),

        .scrambler_en     (scrambler_en),

        .o_data           (fec_rx_data),
        .o_valid          (fec_rx_valid),
        .i_data_ready     (1'b1),

        .o_rxslide        (rx_slide_req),
        .o_bit_locked     (bit_locked),
        .o_frame_index    (rx_frame_index),
        .o_block_id       (rx_block_id),
        .o_frame_in_block (rx_frame_in_block)
    );

    //======================================================================
    // 5. PRBS 检查 + 误码统计
    //======================================================================
    // ber_clr：同步一次并做脉冲化（解决 VIO “清零后不工作”）
    reg ber_clr_ff1, ber_clr_ff2, ber_clr_ff2_d;
    always @(posedge core_clk) begin
        if (logic_rst) begin
            ber_clr_ff1   <= 1'b0;
            ber_clr_ff2   <= 1'b0;
            ber_clr_ff2_d <= 1'b0;
        end else begin
            ber_clr_ff1   <= ber_clr;
            ber_clr_ff2   <= ber_clr_ff1;
            ber_clr_ff2_d <= ber_clr_ff2;
        end
    end
    wire ber_clear_pulse = ber_clr_ff2 & ~ber_clr_ff2_d;

    // PRBS checker：仅在 PRBS 模式下使能；切换/清零时复位
    wire prbs_chk_en = fec_rx_valid & use_prbs & ~tx_pat_hold;

    wire [7:0] prbs_err_vec_int;
    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (1),
        .INV_PATTERN (0),
        .POLY_LENGHT (7),
        .POLY_TAP    (6),
        .NBITS       (8)
    ) u_prbs_chk_rx (
        .RST      (logic_rst | ber_clear_pulse | tx_pat_hold),
        .CLK      (core_clk),
        .DATA_IN  (fec_rx_data),
        .EN       (prbs_chk_en),
        .DATA_OUT (prbs_err_vec_int)
    );

    // Counter 模式下强制 0，避免 ILA/逻辑被假误码污染
    (* MARK_DEBUG="true" *) wire [7:0] prbs_err_vec = use_prbs ? prbs_err_vec_int : 8'h00;

    (* MARK_DEBUG="true" *) wire prbs_match      = ~|prbs_err_vec;
    (* MARK_DEBUG="true" *) wire prbs_match_fail = (fec_rx_valid & use_prbs) && (|prbs_err_vec);

    function integer popcount8;
        input [7:0] v;
        integer k;
        begin
            popcount8 = 0;
            for (k = 0; k < 8; k = k + 1)
                popcount8 = popcount8 + v[k];
        end
    endfunction
    // ============================================================
    // Counter checker（仅在 use_cnt 下工作）
    // 目标：像 PRBS 一样给出 locked / match_fail / err_vec / 统计计数
    // ============================================================
    localparam MASK_WAIT_CYCLES = 1024;
    localparam [7:0] CNT_MAX = 8'd228;

    function automatic [7:0] cnt_next;
        input [7:0] v;
        begin
            cnt_next = (v == CNT_MAX) ? 8'd0 : (v + 8'd1);
        end
    endfunction

    // Checker 使能：仅在 Counter 模式 + 有效数据 + 非切换 holdoff
    wire cnt_chk_fire = fec_rx_valid & use_cnt & ~tx_pat_hold;

    (* MARK_DEBUG="true" *) reg        cnt_seeded;
    (* MARK_DEBUG="true" *) reg        cnt_locked_internal;
    (* MARK_DEBUG="true" *) reg [31:0] cnt_good_cnt;
    (* MARK_DEBUG="true" *) reg [15:0] cnt_mask_cnt;
    (* MARK_DEBUG="true" *) reg        cnt_enable;

     reg  [7:0] cnt_expected;         // 期望值（当前拍）
     wire [7:0] cnt_err_vec = fec_rx_data ^ cnt_expected;
    (* MARK_DEBUG="true" *) wire       cnt_match   = ~|cnt_err_vec;

    // 两个 fail：一个是“任何阶段 mismatch”，另一个是“锁定后/统计期 mismatch”
    (* MARK_DEBUG="true" *) wire cnt_mismatch_any    = cnt_chk_fire & cnt_seeded & ~cnt_match;
    (* MARK_DEBUG="true" *) wire cnt_mismatch_locked = cnt_chk_fire & cnt_locked_internal & cnt_enable & ~cnt_match;

    (* MARK_DEBUG="true" *) reg [31:0] cnt_bad_word_cnt;     // mismatch 的字节个数
    (* MARK_DEBUG="true" *) reg [63:0] cnt_total_bits_cnt;   // 统计 bit 数
    (* MARK_DEBUG="true" *) reg [63:0] cnt_total_err_cnt;    // 统计 bit 错误数（popcount）

    (* MARK_DEBUG="true" *) reg [31:0] rx_cnt_word;
    (* MARK_DEBUG="true" *) reg        rx_cnt_word_valid;
    reg [1:0] rx_pack_cnt;

    always @(posedge core_clk) begin
        if (logic_rst || ber_clear_pulse || !bit_locked || !use_cnt || tx_pat_hold) begin
            // checker
            cnt_seeded          <= 1'b0;
            cnt_locked_internal <= 1'b0;
            cnt_good_cnt        <= 32'd0;
            cnt_mask_cnt        <= 16'd0;
            cnt_enable          <= 1'b0;

            cnt_expected        <= 8'd0;

            cnt_bad_word_cnt    <= 32'd0;
            cnt_total_bits_cnt  <= 64'd0;
            cnt_total_err_cnt   <= 64'd0;

            // packer
            rx_cnt_word         <= 32'd0;
            rx_cnt_word_valid   <= 1'b0;
            rx_pack_cnt         <= 2'd0;
        end else begin
            // ===== 32bit packer =====
            rx_cnt_word_valid <= 1'b0;
            if (cnt_chk_fire) begin
                case (rx_pack_cnt)
                    2'd0: rx_cnt_word[7:0]   <= fec_rx_data;
                    2'd1: rx_cnt_word[15:8]  <= fec_rx_data;
                    2'd2: rx_cnt_word[23:16] <= fec_rx_data;
                    2'd3: rx_cnt_word[31:24] <= fec_rx_data;
                endcase
                rx_cnt_word_valid <= (rx_pack_cnt == 2'd3);
                rx_pack_cnt <= rx_pack_cnt + 2'd1;
            end

            // ===== Counter lock + check =====
            if (cnt_chk_fire) begin
                if (!cnt_seeded) begin
                    // 第一个样本：只种子化 expected=next(sample)
                    cnt_seeded   <= 1'b1;
                    cnt_expected <= cnt_next(fec_rx_data);
                    cnt_good_cnt <= 32'd0;
                end else if (!cnt_locked_internal) begin
                    // 解锁期：连续命中 expected 才算“锁定”
                    if (fec_rx_data == cnt_expected) begin
                        if (cnt_good_cnt == LOCK_THRESH) begin
                            cnt_locked_internal <= 1'b1;
                            cnt_good_cnt        <= 32'd0;
                            cnt_mask_cnt        <= 16'd0;
                            cnt_enable          <= 1'b0;
                        end else begin
                            cnt_good_cnt <= cnt_good_cnt + 1'b1;
                        end
                    end else begin
                        cnt_good_cnt <= 32'd0;
                    end
                    // always 更新 candidate expected
                    cnt_expected <= cnt_next(fec_rx_data);
                end else begin
                    // 锁定期：先 mask 一段再统计
                    if (cnt_mask_cnt < MASK_WAIT_CYCLES) begin
                        cnt_mask_cnt <= cnt_mask_cnt + 1'b1;
                    end else begin
                        cnt_enable <= 1'b1;
                    end

                    // mismatch 统计（bit 级 + word 级）
                    if (cnt_enable) begin
                        cnt_total_bits_cnt <= cnt_total_bits_cnt + 64'd8;
                        if (fec_rx_data != cnt_expected) begin
                            cnt_bad_word_cnt   <= cnt_bad_word_cnt + 1'b1;
                            cnt_total_err_cnt  <= cnt_total_err_cnt + popcount8(cnt_err_vec);
                        end
                    end

                    // 期望更新：match 正常递增；mismatch 时“就地重同步”，避免后续连锁全红
                    if (fec_rx_data != cnt_expected)
                        cnt_expected <= cnt_next(fec_rx_data);
                    else
                        cnt_expected <= cnt_next(cnt_expected);
                end
            end
        end
    end
    wire [3:0] current_err_num = popcount8(prbs_err_vec);


    (* MARK_DEBUG="true" *) reg [31:0] good_cnt;
    (* MARK_DEBUG="true" *) reg        prbs_locked_internal;
    (* MARK_DEBUG="true" *) reg [15:0] mask_cnt;
    (* MARK_DEBUG="true" *) reg        ber_enable;

    (* MARK_DEBUG="true" *) reg [63:0] total_bits_cnt;
    (* MARK_DEBUG="true" *) reg [63:0] total_err_cnt;

    always @(posedge core_clk) begin
        if (logic_rst || ber_clear_pulse || !bit_locked || !use_prbs || tx_pat_hold) begin
            good_cnt             <= 32'd0;
            prbs_locked_internal <= 1'b0;
            mask_cnt             <= 16'd0;
            ber_enable           <= 1'b0;
            total_bits_cnt       <= 64'd0;
            total_err_cnt        <= 64'd0;
        end else if (fec_rx_valid) begin
            if (!prbs_locked_internal) begin
                ber_enable <= 1'b0;
                if (prbs_match_fail) begin
                    good_cnt <= 32'd0;
                end else begin
                    if (good_cnt == LOCK_THRESH) begin
                        prbs_locked_internal <= 1'b1;
                        good_cnt <= 32'd0;
                    end else begin
                        good_cnt <= good_cnt + 1'b1;
                    end
                end
            end else begin
                if (mask_cnt < MASK_WAIT_CYCLES) begin
                    mask_cnt <= mask_cnt + 1'b1;
                end else begin
                    ber_enable <= 1'b1;
                end

                if (ber_enable) begin
                    total_bits_cnt <= total_bits_cnt + 64'd8;
                    if (prbs_match_fail)
                        total_err_cnt <= total_err_cnt + current_err_num;
                end
            end
        end
    end

    //======================================================================
    // 6. BER 计算：div_gen_0
    //======================================================================
    reg [2:0] div_clr_cnt;
    always @(posedge core_clk) begin
        if (logic_rst || !bit_locked || !use_prbs || tx_pat_hold) begin
            div_clr_cnt <= 3'd0;
        end else if (ber_clear_pulse) begin
            div_clr_cnt <= 3'd4;     // 展宽 4 拍
        end else if (div_clr_cnt != 0) begin
            div_clr_cnt <= div_clr_cnt - 1'b1;
        end
    end

    wire div_clear_stretch = (div_clr_cnt != 0);
    wire div_aresetn = logic_rst_n & bit_locked & use_prbs & ~tx_pat_hold & ~div_clear_stretch;

    reg        div_valid;
    reg [63:0] div_dividend_reg; // err
    reg [63:0] div_divisor_reg;  // bits

    (* MARK_DEBUG="true" *) wire        m_axis_dout_tvalid;
    (* MARK_DEBUG="true" *) wire [95:0] m_axis_dout_tdata;
    (* MARK_DEBUG="true" *) wire        s_axis_divisor_tready;
    (* MARK_DEBUG="true" *) wire        s_axis_dividend_tready;

    wire div_fire = div_valid && s_axis_dividend_tready && s_axis_divisor_tready;

    always @(posedge core_clk) begin
        if (!div_aresetn) begin
            div_valid        <= 1'b0;
            div_dividend_reg <= 64'd0;
            div_divisor_reg  <= 64'd1;
        end else begin
            if (!div_valid) begin
                if (ber_enable) begin
                    div_valid        <= 1'b1;
                    div_dividend_reg <= total_err_cnt;
                    div_divisor_reg  <= (total_bits_cnt == 0) ? 64'd1 : total_bits_cnt;
                end
            end else if (div_fire) begin
                if (ber_enable) begin
                    div_valid        <= 1'b1;
                    div_dividend_reg <= total_err_cnt;
                    div_divisor_reg  <= (total_bits_cnt == 0) ? 64'd1 : total_bits_cnt;
                end else begin
                    div_valid <= 1'b0;
                end
            end
        end
    end

    div_gen_0 u_ber_calc (
        .aclk                   (core_clk),
        .aresetn                (div_aresetn),

        .s_axis_divisor_tvalid  (div_valid),
        .s_axis_divisor_tready  (s_axis_divisor_tready),
        .s_axis_divisor_tdata   (div_divisor_reg),

        .s_axis_dividend_tvalid (div_valid),
        .s_axis_dividend_tready (s_axis_dividend_tready),
        .s_axis_dividend_tdata  (div_dividend_reg),

        .m_axis_dout_tvalid     (m_axis_dout_tvalid),
        .m_axis_dout_tuser      (),
        .m_axis_dout_tdata      (m_axis_dout_tdata)
    );

    (* MARK_DEBUG="true" *) reg [31:0] ber_q32_reg;
    always @(posedge core_clk) begin
        if (logic_rst || ber_clear_pulse || !bit_locked || !use_prbs || tx_pat_hold) begin
            ber_q32_reg <= 32'd0;
        end else if (m_axis_dout_tvalid) begin
            ber_q32_reg <= m_axis_dout_tdata[31:0];
        end
    end

    assign ber_result_to_vio = ber_q32_reg;

endmodule

