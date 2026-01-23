`timescale 1ns / 1ps
`include "global_defines.vh"

module fec_gth_loopback_top_nogate #(
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
    assign loop_backmode        = 3'b000;
    assign scrambler_en         = 1'b0;
    assign ber_clr              = 1'b0;
    assign tx_pattern_prbs_vio  = (TEST_PRBS != 0); // SIM 用参数作为默认选择
`else
    // VIO: probe_in0 = 32bit, probe_out0/1/2/3/4
    vio_2 u_vio_ctrl (
        .clk        (core_clk),
        .probe_out0 (ber_clr),
        .probe_out1 (scrambler_en),
        .probe_out2 (loop_backmode),
        .probe_out3 (tx_pattern_prbs_vio), // 1=PRBS,0=Counter default 0
        .probe_in0  (ber_result_to_vio)
    );
`endif

    reg tx_pat_ff1, tx_pat_ff2, tx_pat_ff2_d;
    always @(posedge core_clk) begin
        if (logic_rst) begin
            // 上电默认值跟随 VIO（或 SIM 参数）当前值，避免伪切换
            tx_pat_ff1   <= tx_pattern_prbs_vio;
            tx_pat_ff2   <= tx_pattern_prbs_vio;
            tx_pat_ff2_d <= tx_pattern_prbs_vio;
        end else begin
            tx_pat_ff1   <= tx_pattern_prbs_vio;
            tx_pat_ff2   <= tx_pat_ff1;
            tx_pat_ff2_d <= tx_pat_ff2;
        end
    end

    wire test_prbs_sel   = tx_pat_ff2;                 // 1=PRBS,0=Counter
    wire tx_pat_sw_pulse = (tx_pat_ff2 ^ tx_pat_ff2_d);
    wire use_prbs = test_prbs_sel;
    wire use_cnt  = ~test_prbs_sel;

    // 切换后暂停若干拍并复位发生器/检查器/统计
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
    wire tx_pat_hold = (tx_pat_hold_cnt != 0);

    //======================================================================
    // 2. GTH 顶层
    //======================================================================
    wire        tx_usr_clk;
    wire        tx_rst_n;
    wire        tx_done;
    wire        tx_active;

    wire        rx_usr_clk;
    wire        rx_rst_n;
    wire        rx_done;
    wire        rx_active;
    wire        cdr_stable;
    wire [W-1:0] rx_data_from_gth;

    wire [W-1:0] tx_data_to_gth;
    wire         rx_slide_req;

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

    // CDC sfp loss信号 core_clk/rx_usr_clk域
    reg [1:0] loss_core_ff1,loss_core_ff2;
    reg [1:0] loss_rx_ff1, loss_rx_ff2;

    always @(posedge core_clk) begin
        if(logic_rst) begin
            loss_core_ff1 <= 2'b11;
            loss_core_ff2 <= 2'b11;
        end else begin
            loss_core_ff1 <= sfp_loss;
            loss_core_ff2 <= loss_core_ff1;
        end
    end

    always @(posedge rx_usr_clk) begin
        if(!rx_rst_n) begin
            loss_rx_ff1 <= 2'b11;
            loss_rx_ff2 <= 2'b11;
        end else begin
            loss_rx_ff1 <= sfp_loss;
            loss_rx_ff2 <= loss_rx_ff1;
        end
    end
    wire have_light_core = ~loss_core_ff2[0];
    wire have_light_line = ~loss_rx_ff2[0];

    //======================================================================
    // 3. TX：PRBS/Counter → FEC_TX → GTH   （无门控版本）
    //======================================================================
    wire [7:0]   prbs_tx_data;
    wire         prbs_tx_ready;
    wire [W-1:0] fec_tx_data_line;
    wire         fec_tx_valid_line;
    wire [15:0]  tx_frame_index;

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

    // ★无门控：只依赖 fec_tx 的 ready 做自然反压
    // 注意：tx_path_rst_n 已经包含 ~tx_pat_hold，因此这里不需要再额外 gate
    wire tx_src_run = tx_path_rst_n & tx_active_core;

    // 源侧“真正推进一次”的时刻（fire）
    wire src_fire = tx_src_run & prbs_tx_ready;

    // PRBS/Counter 推进（只在 fire 时推进，避免错位）
    wire prbs_en = use_prbs & src_fire;
    wire cnt_en  = use_cnt  & src_fire;

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

    localparam integer BLK_IN_BYTES = INTLV_D * RS_K;   // 64*229=14656
    localparam integer BLK_W        = $clog2(BLK_IN_BYTES);
    reg [BLK_W-1:0] blk_byte_idx;   // 0..BLK_IN_BYTES-1
    reg [15:0] seq16;
    reg        seq_hi_phase;        // 0:发低字节 1:发高字节（两拍组成一个序号）

    always @(posedge core_clk) begin
        if (tx_path_rst) begin
            blk_byte_idx  <= 'd0;
            seq16         <= 16'd0;
            seq_hi_phase  <= 1'b0;
            cnt_data      <= 8'd0;
        end else if (cnt_en) begin
            if (!seq_hi_phase) begin
                cnt_data     <= seq16[7:0];
                seq_hi_phase <= 1'b1;
            end else begin
                cnt_data     <= seq16[15:8];
                seq_hi_phase <= 1'b0;
                seq16        <= seq16 + 1'b1;
            end

            if (blk_byte_idx == BLK_IN_BYTES-1)
                blk_byte_idx <= 'd0;
            else
                blk_byte_idx <= blk_byte_idx + 1'b1;
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

        .o_tx_data_line   (fec_tx_data_line),
        .o_tx_valid_line  (fec_tx_valid_line),
        .o_tx_frame_index (tx_frame_index)
    );

    assign tx_data_to_gth = fec_tx_data_line;

    // ★SIM：把最终送入 GTH 的数据写 txt（每个 tx_usr_clk 一行）
`ifdef SIM
    integer tx_log_fd;
    initial begin
        tx_log_fd = $fopen("tx_words.txt", "w");
        if (tx_log_fd == 0) begin
            $display("[%0t] ERROR: cannot open tx_words.txt", $time);
        end else begin
            $fwrite(tx_log_fd, "# time  tx_done  tx_rst_n  valid  data_hex\n");
        end
    end

    always @(posedge tx_usr_clk) begin
        if (tx_log_fd != 0) begin
            $fwrite(tx_log_fd, "%0t  %0d  %0d  %0d  %08x\n",
                    $time, tx_done, tx_rst_n, fec_tx_valid_line, tx_data_to_gth);
        end
    end
`endif

    //======================================================================
    // 4. RX：GTH → FEC_RX → PRBS 检查
    //======================================================================
    wire [7:0]  fec_rx_data;
    wire        fec_rx_valid;
    (* MARK_DEBUG="true" *) wire        bit_locked;
    (* MARK_DEBUG="true" *) wire [15:0] rx_frame_index;
    (* MARK_DEBUG="true" *) wire [15:0] rx_block_id;
    (* MARK_DEBUG="true" *) wire [15:0] rx_frame_in_block;

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

    (* MARK_DEBUG="true" *) wire rx_active_line        = rx_act_l2;
    (* MARK_DEBUG="true" *) wire cdr_stable_line       = cdr_st_l2;
    (* MARK_DEBUG="true" *) wire rx_word_valid_line    = rx_active_line & cdr_stable_line & have_light_line;

    fec_rx #(
        .W                (W),
        .PAYLOAD_WORDS    (PAYLOAD_WORDS),
        .RS_N             (RS_N),
        .INTLV_D          (INTLV_D),
        .INTLV_N          (INTLV_N)
    ) u_fec_rx (
        .line_clk         (rx_usr_clk),
        .core_clk         (core_clk),
        .rst_n            (fec_rx_rst_n),

        .i_rx_data        (rx_data_from_gth),
        .i_rx_valid       (rx_word_valid_line),

        .rx_reset_done    (rx_active_line),
        .rx_cdr_stable    (cdr_stable_line),

        .scrambler_en     (scrambler_en),

        .o_data           (fec_rx_data),
        .o_valid          (fec_rx_valid),
        .i_data_ready     (1'b1),

        .o_rxslide        (rx_slide_req),
        .bit_locked_core  (bit_locked),
        .o_frame_index    (rx_frame_index),
        .o_block_id       (rx_block_id),
        .o_frame_in_block (rx_frame_in_block)
    );

    ila_fec_rx ila_fec_rx (
        .clk    (core_clk),
        .probe0 (fec_rx_data),
        .probe1 (fec_rx_valid)
    );

    //======================================================================
    // 5. PRBS 检查 + 误码统计（保持原逻辑）
    //======================================================================
    localparam [31:0] BER_CODE_LINK_DOWN = 32'hFFFF_FFFF;
    localparam [31:0] BER_CODE_SEARCHING = 32'hFFFF_FFFE;
    localparam [31:0] BER_CODE_MASKING   = 32'hFFFF_FFFD;

    // ber_clr：同步
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

    (* MARK_DEBUG="true" *) wire prbs_meas_ok =
        have_light_core &
        use_prbs &
        ~tx_pat_hold &
        tx_done_core & rx_done_core &
        bit_locked;

    wire prbs_chk_fire = fec_rx_valid & prbs_meas_ok;

    wire [7:0] prbs_err_vec_int;

    reg prbs_meas_ok_d;
    always @(posedge core_clk) begin
        if (logic_rst) prbs_meas_ok_d <= 1'b0;
        else          prbs_meas_ok_d <= prbs_meas_ok;
    end
    wire prbs_meas_start = prbs_meas_ok & ~prbs_meas_ok_d;
    wire prbs_chk_rst = logic_rst | ber_clear_pulse | prbs_meas_start;

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
        .EN       (prbs_chk_fire),
        .DATA_OUT (prbs_err_vec_int)
    );

    reg [7:0] rx_k_cnt;
    always @(posedge core_clk) begin
        if (logic_rst || !prbs_meas_ok) begin
            rx_k_cnt <= 8'd0;
        end else if (prbs_chk_fire) begin
            if (rx_k_cnt == RS_K-1) rx_k_cnt <= 8'd0;
            else rx_k_cnt <= rx_k_cnt + 1'b1;
        end
    end

    (* MARK_DEBUG="true" *) wire prbs_match_fail = prbs_chk_fire && (|prbs_err_vec_int);
    (* MARK_DEBUG="true" *) wire prbs_match = ~|prbs_err_vec_int;
    (* MARK_DEBUG="true" *) wire [7:0] prbs_err_vec = prbs_chk_fire ? prbs_err_vec_int : 8'h00;

    function integer popcount8;
        input [7:0] v;
        integer k;
        begin
            popcount8 = 0;
            for (k = 0; k < 8; k = k + 1)
                popcount8 = popcount8 + v[k];
        end
    endfunction
    wire [3:0] current_err_num = popcount8(prbs_err_vec);

    localparam integer MASK_WAIT_CYCLES = 1024;

    (* MARK_DEBUG="true" *) reg [31:0] good_cnt;
    (* MARK_DEBUG="true" *) reg        prbs_locked_internal;
    (* MARK_DEBUG="true" *) reg [15:0] mask_cnt;
    (* MARK_DEBUG="true" *) reg        ber_enable;
    (* MARK_DEBUG="true" *) reg [63:0] total_bits_cnt;
    (* MARK_DEBUG="true" *) reg [63:0] total_err_cnt;

    always @(posedge core_clk) begin
        if (logic_rst || ber_clear_pulse || ~prbs_meas_ok) begin
            good_cnt             <= 32'd0;
            prbs_locked_internal <= 1'b0;
            mask_cnt             <= 16'd0;
            ber_enable           <= 1'b0;
            total_bits_cnt       <= 64'd0;
            total_err_cnt        <= 64'd0;
        end else if (prbs_chk_fire) begin
            if (!prbs_locked_internal) begin
                ber_enable <= 1'b0;

                if (prbs_match_fail) begin
                    good_cnt <= 32'd0;
                end else begin
                    if (good_cnt >= (LOCK_THRESH-1)) begin
                        prbs_locked_internal <= 1'b1;
                        good_cnt   <= 32'd0;
                        mask_cnt   <= 16'd0;
                        ber_enable <= 1'b0;
                    end else begin
                        good_cnt <= good_cnt + 1'b1;
                    end
                end
            end else begin
                if (!ber_enable) begin
                    if (mask_cnt >= (MASK_WAIT_CYCLES-1)) begin
                        ber_enable <= 1'b1;
                    end else begin
                        mask_cnt   <= mask_cnt + 1'b1;
                        ber_enable <= 1'b0;
                    end
                end

                if (ber_enable) begin
                    if (total_bits_cnt != 64'hFFFF_FFFF_FFFF_FFFF)
                        total_bits_cnt <= total_bits_cnt + 64'd8;

                    if (prbs_match_fail) begin
                        if (total_err_cnt <= (64'hFFFF_FFFF_FFFF_FFFF - current_err_num))
                            total_err_cnt <= total_err_cnt + current_err_num;
                        else
                            total_err_cnt <= 64'hFFFF_FFFF_FFFF_FFFF;
                    end
                end
            end
        end
    end

    //======================================================================
    // 6. BER 计算：div_gen_0（保持原逻辑）
    //======================================================================
    reg [2:0] div_clr_cnt;
    always @(posedge core_clk) begin
        if (logic_rst || ~prbs_meas_ok) begin
            div_clr_cnt <= 3'd0;
        end else if (ber_clear_pulse) begin
            div_clr_cnt <= 3'd4;
        end else if (div_clr_cnt != 0) begin
            div_clr_cnt <= div_clr_cnt - 1'b1;
        end
    end

    wire div_clear_stretch = (div_clr_cnt != 0);
    wire div_aresetn = logic_rst_n & prbs_meas_ok & ~div_clear_stretch;

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
        if (logic_rst) begin
            ber_q32_reg <= BER_CODE_LINK_DOWN;
        end else if (!use_prbs) begin
            ber_q32_reg <= 32'd0;
        end else if (!have_light_core) begin
            ber_q32_reg <= BER_CODE_LINK_DOWN;
        end else if (!prbs_meas_ok || !prbs_locked_internal) begin
            ber_q32_reg <= BER_CODE_SEARCHING;
        end else if (!ber_enable) begin
            ber_q32_reg <= BER_CODE_MASKING;
        end else if (ber_clear_pulse) begin
            ber_q32_reg <= BER_CODE_SEARCHING;
        end else if (m_axis_dout_tvalid) begin
            ber_q32_reg <= m_axis_dout_tdata[31:0];
        end
    end

    assign ber_result_to_vio = ber_q32_reg;

endmodule
