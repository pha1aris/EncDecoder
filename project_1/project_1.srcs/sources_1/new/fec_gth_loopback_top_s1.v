`timescale 1ns/1ps
`include "global_defines.vh"

//==============================================================
// Stage1 Top: bit sync + frame sync + PRBS verify
//   - TX: PRBS/Counter -> (8->32) -> framer -> async fifo -> burst(IDLE) -> GTH
//   - RX: GTH -> bit_aligner -> async fifo -> deframer -> (32->8) -> PRBS checker
//==============================================================
module fec_gth_loopback_top_s1 #(
    parameter integer W                = 32,
    parameter integer PAYLOAD_WORDS    = 16,
    parameter integer FRAMES_PER_BLOCK = 255,
    parameter integer LOCK_THRESH      = 1024,

    // SIM 默认：1=PRBS，0=Counter
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
    // 1) Clocks & logic reset
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
    // 2) VIO controls (贴近原顶层)
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
    assign loop_backmode        = 3'b000;           // 仿真用 stub，不靠 GT 内环回
    assign scrambler_en         = 1'b0;             // Stage1 PRBS 测试建议关
    assign ber_clr              = 1'b0;
    assign tx_pattern_prbs_vio  = (TEST_PRBS != 0); // 默认 PRBS
`else
    // VIO: probe_out0/1/2/3, probe_in0=BER
    vio_2 u_vio_ctrl (
        .clk        (core_clk),
        .probe_out0 (ber_clr),
        .probe_out1 (scrambler_en),
        .probe_out2 (loop_backmode),
        .probe_out3 (tx_pattern_prbs_vio), // 1=PRBS 0=Counter
        .probe_in0  (ber_result_to_vio)
    );
`endif

    // PRBS/Counter 模式选择同步（贴近原顶层）
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
    // 3) GTH raw top (仿真 stub / 板上真实 GT)
    //==========================================================
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
        .W(W)
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

    // CDC: tx_done/tx_rst_n/rx_done/rx_rst_n -> core_clk
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
            tx_done_cdc1 <= tx_done;     tx_done_cdc2 <= tx_done_cdc1;
            tx_rstn_cdc1 <= tx_rst_n;    tx_rstn_cdc2 <= tx_rstn_cdc1;
            rx_done_cdc1 <= rx_done;     rx_done_cdc2 <= rx_done_cdc1;
            rx_rstn_cdc1 <= rx_rst_n;    rx_rstn_cdc2 <= rx_rstn_cdc1;
        end
    end
    wire tx_done_core  = tx_done_cdc2;
    wire tx_rst_n_core = tx_rstn_cdc2;
    wire rx_done_core  = rx_done_cdc2;
    wire rx_rst_n_core = rx_rstn_cdc2;

    //==========================================================
    // 4) SFP loss gating（贴近原顶层但可忽略）
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
    // 5) Stage1 TX: PRBS/Counter byte source -> tx_framer_only_s1
    //==========================================================
    // Stage1：建议不要 rate_gate（避免帧间 idle 太长导致 bit_aligner 误 slip）
    wire rate_gate = 1'b1;

    // tx_active CDC to core_clk (贴近原顶层)
    reg tx_act_cdc1, tx_act_cdc2;
    always @(posedge core_clk or posedge logic_rst) begin
        if (logic_rst) begin
            tx_act_cdc1 <= 1'b0; tx_act_cdc2 <= 1'b0;
        end else begin
            tx_act_cdc1 <= tx_active;
            tx_act_cdc2 <= tx_act_cdc1;
        end
    end
    wire tx_active_core = tx_act_cdc2;

    wire tx_path_rst_n = logic_rst_n & tx_rst_n_core & tx_done_core;
    wire tx_path_rst   = ~tx_path_rst_n;

    wire [7:0]  prbs_tx_data;
    wire        tx_byte_ready;

    wire prbs_en = use_prbs & tx_byte_ready & tx_active_core & rate_gate;
    wire cnt_en  = use_cnt  & tx_byte_ready & tx_active_core & rate_gate;

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

    reg [7:0] cnt_data;
    always @(posedge core_clk) begin
        if (tx_path_rst) begin
            cnt_data <= 8'd0;
        end else if (cnt_en) begin
            cnt_data <= cnt_data + 1'b1;
        end
    end

    wire [7:0] src_data  = use_prbs ? prbs_tx_data : cnt_data;
    wire       src_valid = use_prbs ? prbs_en      : cnt_en;

    tx_framer_only_s1 #(
        .W                (W),
        .PAYLOAD_WORDS    (PAYLOAD_WORDS),
        .FRAMES_PER_BLOCK (FRAMES_PER_BLOCK)
    ) u_tx_stage1 (
        .line_clk        (tx_usr_clk),
        .core_clk        (core_clk),
        .rst_n           (tx_path_rst_n),

        .scrambler_en    (scrambler_en),

        .i_data          (src_data),
        .i_valid         (src_valid),
        .o_ready         (tx_byte_ready),

        .o_tx_data_line  (tx_data_to_gth),
        .o_tx_valid_line (), // 可不接
        .o_tx_frame_index()
    );

    //==========================================================
    // 6) Stage1 RX: bit_aligner + deframer + 32->8 -> PRBS checker
    //==========================================================
    wire fec_rx_rst_n = logic_rst_n & rx_rst_n_core & rx_done_core;

    // rx_active/cdr_stable sync to rx_usr_clk (贴近原顶层)
    reg rx_act_l1, rx_act_l2;
    reg cdr_st_l1, cdr_st_l2;
    always @(posedge rx_usr_clk or negedge rx_rst_n) begin
        if (!rx_rst_n) begin
            rx_act_l1 <= 1'b0; rx_act_l2 <= 1'b0;
            cdr_st_l1 <= 1'b0; cdr_st_l2 <= 1'b0;
        end else begin
            rx_act_l1 <= rx_active;   rx_act_l2 <= rx_act_l1;
            cdr_st_l1 <= cdr_stable;  cdr_st_l2 <= cdr_st_l1;
        end
    end
    (* MARK_DEBUG="true" *)wire rx_active_line  = rx_act_l2;
    (* MARK_DEBUG="true" *)wire cdr_stable_line = cdr_st_l2;

    // 注意：这里仍然“每个 word 都认为 valid”（与原顶层一致）
    wire rx_word_valid_line = rx_active_line & cdr_stable_line & have_light_line;

    (* MARK_DEBUG="true" *)wire [7:0]  rx_payload_byte;
    (* MARK_DEBUG="true" *)wire        rx_payload_vld;
    (* MARK_DEBUG="true" *)wire        bit_locked_core;
    (* MARK_DEBUG="true" *)wire        frame_locked_core;
    (* MARK_DEBUG="true" *)wire [15:0] rx_frame_index, rx_block_id, rx_frame_in_block;

    rx_deframer_only_s1 #(
        .W            (W),
        .PAYLOAD_WORDS(PAYLOAD_WORDS)
    ) u_rx_stage1 (
        .line_clk        (rx_usr_clk),
        .core_clk        (core_clk),
        .rst_n           (fec_rx_rst_n),

        .i_rx_data       (rx_data_from_gth),
        .i_rx_valid      (rx_word_valid_line),
        .rx_reset_done   (rx_active_line),
        .rx_cdr_stable   (cdr_stable_line),
        .scrambler_en    (scrambler_en),

        .o_data          (rx_payload_byte),
        .o_valid         (rx_payload_vld),
        .i_data_ready    (1'b1),

        .o_rxslide       (rx_slide_req),
        .bit_locked_core (bit_locked_core),
        .frame_locked_core(frame_locked_core),
        .o_frame_index   (rx_frame_index),
        .o_block_id      (rx_block_id),
        .o_frame_in_block(rx_frame_in_block)
    );

`ifdef SIM
    integer fd_rx;

    // 1) 仿真开始打开文件（覆盖写）
    initial begin
        fd_rx = $fopen("C:/Users/PC/Desktop/rx_payload_data.txt", "w");
        if (fd_rx == 0) begin
            $display("ERROR: cannot open rx_payload_data.txt");
            $finish;
        end
        $display("INFO: rx_payload_data.txt opened.");
    end

    // 2) 每个收到的 payload byte 写一行
    //    建议只在 frame_locked_core 有效时写，避免把搜索阶段垃圾数据写进去
    always @(posedge core_clk) begin
    if (!logic_rst && rx_payload_vld) begin
        $fdisplay(fd_rx, "%0t blk=%0d finb=%0d findx=%0d data=0x%02x",
                $time, rx_block_id, rx_frame_in_block, rx_frame_index, rx_payload_byte);
    end
    end

    // 3) 仿真结束关闭文件
    // final begin
    //     if (fd_rx != 0) begin
    //         $fclose(fd_rx);
    //         $display("INFO: rx_payload_data.txt closed.");
    //     end
    
    // end
    always @(posedge core_clk) begin
    if (!logic_rst && rx_payload_vld && !frame_locked_core) begin
        $display("TAIL BYTE after frame_locked drop: t=%0t data=%02x", $time, rx_payload_byte);
    end
end
`endif

    //==========================================================
    // 7) PRBS checker + 简化 BER(沿用你原顶层的“状态码输出”思想)
    //==========================================================
    localparam [31:0] BER_CODE_LINK_DOWN = 32'hFFFF_FFFF;
    localparam [31:0] BER_CODE_SEARCHING = 32'hFFFF_FFFE;

    // ber_clr sync
    reg ber_clr_ff1, ber_clr_ff2, ber_clr_ff2_d;
    always @(posedge core_clk) begin
        if (logic_rst) begin
            ber_clr_ff1 <= 1'b0; ber_clr_ff2 <= 1'b0; ber_clr_ff2_d <= 1'b0;
        end else begin
            ber_clr_ff1 <= ber_clr;
            ber_clr_ff2 <= ber_clr_ff1;
            ber_clr_ff2_d <= ber_clr_ff2;
        end
    end
    wire ber_clear_pulse = ber_clr_ff2 & ~ber_clr_ff2_d;

    // 可测条件：必须 bit_locked + frame_locked（Stage1 建议加 frame_locked 更稳）
    wire prbs_meas_ok =
        have_light_core &
        use_prbs &
        tx_done_core & rx_done_core &
        bit_locked_core &
        frame_locked_core;

    (* MARK_DEBUG="true" *)wire [7:0] prbs_err_vec;
    (* MARK_DEBUG="true" *)wire prbs_match_raw;
    assign prbs_match_raw = ~| prbs_err_vec ;

    reg prbs_meas_ok_d;
    always @(posedge core_clk) begin
        if (logic_rst) prbs_meas_ok_d <= 1'b0;
        else          prbs_meas_ok_d <= prbs_meas_ok;
    end
    (* MARK_DEBUG="true" *)wire prbs_meas_start = prbs_meas_ok & ~prbs_meas_ok_d;
    (* MARK_DEBUG="true" *)wire prbs_chk_rst = logic_rst;
    (* MARK_DEBUG="true" *)wire prbs_chk_en  = rx_payload_vld & use_prbs;        // ✅ 只负责推进 LFSR，不要 gate frame_locked
    (* MARK_DEBUG="true" *)wire prbs_cnt_en  = rx_payload_vld & prbs_meas_ok;    // ✅ 统计/计数仍可用 prbs_meas_ok gate


    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (1),
        .INV_PATTERN (0),
        .POLY_LENGHT (7),
        .POLY_TAP    (6),
        .NBITS       (8)
    ) u_prbs_chk_rx (
        .RST      (prbs_chk_rst),
        .CLK      (core_clk),
        .DATA_IN  (rx_payload_byte),
        .EN       (prbs_chk_en),
        .DATA_OUT (prbs_err_vec)
    );

    // 简单统计：累计 bit error
    function integer popcount8;
        input [7:0] v;
        integer k;
        begin
            popcount8 = 0;
            for (k = 0; k < 8; k = k + 1)
                popcount8 = popcount8 + v[k];
        end
    endfunction

    (* MARK_DEBUG="true" *)reg [63:0] total_bits_cnt, total_err_cnt;
    always @(posedge core_clk) begin
        if (logic_rst || ber_clear_pulse || !prbs_meas_ok) begin
            total_bits_cnt <= 64'd0;
            total_err_cnt  <= 64'd0;
        end else if (prbs_cnt_en) begin
            total_bits_cnt <= total_bits_cnt + 64'd8;
            total_err_cnt  <= total_err_cnt + popcount8(prbs_err_vec);
        end
    end

    // 输出：Stage1 先不做除法，直接把 err_cnt 低 32bit 给 VIO（更直观）
    (* MARK_DEBUG="true" *)reg [31:0] ber_out;
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
