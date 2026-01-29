`timescale 1ns / 1ps
`include "global_defines.vh"

//==============================================================
// Stage1 Top: Sync Only (No FEC) + Robust BER Logic + UART
// - TX: PRBS -> Framer (S1) -> GTH
// - RX: GTH -> Deframer (S1) -> PRBS Checker -> UART/VIO
//==============================================================
module fec_gth_loopback_top_s1 #(
    parameter integer W                = 32,
    parameter integer PAYLOAD_WORDS    = 16,
    parameter integer FRAMES_PER_BLOCK = 255,
    parameter integer LOCK_THRESH      = 1024,
    // SIM 默认模式：1=PRBS，0=Counter
    parameter integer TEST_PRBS        = 1,

    // UART 参数配置
    parameter integer CORE_CLK_HZ      = 100_000_000,
    parameter integer UART_BAUD        = 115200, // 建议稍微快点，或者保持 9600
    parameter integer PRINT_DIV        = 100_000_000
)(
    input  wire         sys_clk_p,
    input  wire         sys_clk_n,
    input  wire         sys_rst_n,

    input  wire         mgtrefclk0_x1y1_p,
    input  wire         mgtrefclk0_x1y1_n,

    output wire         uart_txd,
    input  wire         uart_rxd,

    input  wire         gthrxp_in,
    input  wire         gthrxn_in,
    output wire         gthtxp_out,
    output wire         gthtxn_out,

    input  wire [1:0]   sfp_loss,
    output wire [1:0]   tx_disable
);
    assign tx_disable = 2'b00;

    //======================================================================
    // 1. 时钟 & 逻辑复位 (保持一致)
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
    // 0. VIO 控制信号 (保持一致)
    //======================================================================
    wire        ber_clr;
    wire        scrambler_en;
    wire [2:0]  loop_backmode;
    wire        tx_pattern_prbs_vio;
    wire [31:0] ber_result_to_vio;

    wire gth_reset_all = ~sys_rst_n | ~clk_locked;

    // loop_backmode CDC
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
    assign scrambler_en         = 1'b0;
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

    wire test_prbs_sel   = tx_pat_ff2;                 
    wire tx_pat_sw_pulse = (tx_pat_ff2 ^ tx_pat_ff2_d);
    wire use_prbs = test_prbs_sel;
    wire use_cnt  = ~test_prbs_sel;

    reg [2:0] tx_pat_hold_cnt;
    always @(posedge core_clk) begin
        if (logic_rst) begin
            tx_pat_hold_cnt <= 3'd0;
        end else if (tx_pat_sw_pulse) begin
            tx_pat_hold_cnt <= 3'd4; 
        end else if (tx_pat_hold_cnt != 0) begin
            tx_pat_hold_cnt <= tx_pat_hold_cnt - 1'b1;
        end
    end
    wire tx_pat_hold = (tx_pat_hold_cnt != 0);

    //======================================================================
    // 2. GTH 顶层 (保持一致)
    //======================================================================
    wire        tx_usr_clk;
    wire        tx_rst_n;
    wire        tx_done;
    wire        tx_active;

    wire        rx_usr_clk;
    wire        rx_rst_n;
    (* MARK_DEBUG="true" *) wire        rx_done;
    (* MARK_DEBUG="true" *) wire        rx_active;
    (* MARK_DEBUG="true" *) wire        cdr_stable;
    (* MARK_DEBUG="true" *) wire [W-1:0] rx_data_from_gth;

    (* MARK_DEBUG="true" *) wire [W-1:0] tx_data_to_gth;
    (* MARK_DEBUG="true" *) wire        rx_slide_req;

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

    // CDC Logic
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

    // CDC: sfp loss & CDR stable
    reg [1:0] loss_core_ff1, loss_core_ff2;
    reg [1:0] loss_rx_ff1,   loss_rx_ff2;
    reg cdr_core_ff1, cdr_core_ff2; 

    always @(posedge core_clk) begin
        if(logic_rst) begin
            loss_core_ff1 <= 2'b11;
            loss_core_ff2 <= 2'b11;
            cdr_core_ff1  <= 1'b0;
            cdr_core_ff2  <= 1'b0;
        end else begin
            loss_core_ff1 <= sfp_loss;
            loss_core_ff2 <= loss_core_ff1;
            
            cdr_core_ff1  <= cdr_stable;
            cdr_core_ff2  <= cdr_core_ff1;
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
    wire cdr_stable_core = cdr_core_ff2;      

    //======================================================================
    // 3. TX Logic (S1: Framer Only, No FEC)
    //======================================================================
    wire [7:0]   prbs_tx_data;
    wire         prbs_tx_ready;
    wire [W-1:0] s1_tx_data_line;
    // wire        s1_tx_valid_line; // 暂不需
    // wire [15:0] tx_frame_index;   // 暂不需

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

    wire tx_src_run = tx_path_rst_n & tx_active_core;
    wire src_fire = tx_src_run & prbs_tx_ready;
    wire prbs_en = use_prbs & src_fire;
    wire cnt_en  = use_cnt  & src_fire;

    // TX PRBS Gen (保持一致：i_force_lock=0)
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
        .DATA_OUT (prbs_tx_data),
        .i_force_lock (1'b0) 
    );

    // Counter gen
    reg [7:0] cnt_data;
    always @(posedge core_clk) begin
        if (tx_path_rst) cnt_data <= 8'd0;
        else if (cnt_en) cnt_data <= cnt_data + 1'b1;
    end

    wire [7:0] src_data  = use_prbs ? prbs_tx_data : cnt_data;
    wire       src_valid = use_prbs ? prbs_en      : cnt_en;

    // ★★★ 替换为 S1 TX Framer (无FEC) ★★★
    tx_framer_only_s1 #(
        .W                (W),
        .PAYLOAD_WORDS    (PAYLOAD_WORDS),
        .FRAMES_PER_BLOCK (FRAMES_PER_BLOCK)
    ) u_tx_stage1 (
        .line_clk      (tx_usr_clk),
        .core_clk      (core_clk),
        .rst_n         (tx_path_rst_n),
        .scrambler_en  (scrambler_en),
        
        .i_data        (src_data),
        .i_valid       (src_valid),
        .o_ready       (prbs_tx_ready), // 驱动上游 PRBS

        .o_tx_data_line(s1_tx_data_line),
        .o_tx_valid_line(),
        .o_tx_frame_index()
    );
    assign tx_data_to_gth = s1_tx_data_line;

    //======================================================================
    // 4. RX Logic (S1: Deframer Only, No FEC)
    //======================================================================
    wire [7:0]   s1_rx_data;
    wire         s1_rx_valid;
    wire         bit_locked;
    (* MARK_DEBUG="true" *) wire [15:0]  rx_frame_index;
    (* MARK_DEBUG="true" *) wire [15:0]  rx_block_id;
    (* MARK_DEBUG="true" *) wire [15:0]  rx_frame_in_block;
    (* MARK_DEBUG="true" *) wire         rx_frame_locked;
    
    // ★★★★★ 修复点开始：补全缺失的同步逻辑 ★★★★★
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
    // 注意：S1 deframer 模块内部已包含 FIFO 和 CDC
    // 且已配置了鲁棒参数 (realign_or=0, pre_bad_th=255)
    
    (* MARK_DEBUG="true" *) wire rx_active_line     = rx_act_l2; // from previous CDC block
    (* MARK_DEBUG="true" *) wire cdr_stable_line    = cdr_st_l2;
    (* MARK_DEBUG="true" *) wire rx_word_valid_line = rx_active_line & cdr_stable_line & have_light_line;
    (* MARK_DEBUG="true" *) wire s1_rx_rst_n        = logic_rst_n & rx_rst_n_core & rx_done_core;

    // ★★★ 替换为 S1 RX Deframer (无FEC) ★★★
    // 该模块输出的数据直接接入 PRBS Checker
    rx_deframer_only_s1 #(
        .W            (W),
        .PAYLOAD_WORDS(PAYLOAD_WORDS)
    ) u_rx_stage1 (
        .line_clk      (rx_usr_clk),
        .core_clk      (core_clk),
        .rst_n         (s1_rx_rst_n),

        .i_rx_data     (rx_data_from_gth),
        .i_rx_valid    (rx_word_valid_line),
        .rx_reset_done (rx_active_line),
        .rx_cdr_stable (cdr_stable_line),
        .scrambler_en  (scrambler_en),

        .o_data        (s1_rx_data),
        .o_valid       (s1_rx_valid),
        .i_data_ready  (1'b1),

        .o_rxslide        (rx_slide_req),
        .bit_locked_core  (bit_locked),
        .frame_locked_core(rx_frame_locked),
        .o_frame_index    (rx_frame_index),
        .o_block_id       (rx_block_id),
        .o_frame_in_block (rx_frame_in_block)
    );

    //======================================================================
    // 5. UART RX (保持一致)
    //======================================================================
    localparam integer CORE_CLK_MHZ = CORE_CLK_HZ / 1_000_000;
    wire [7:0] uart_rx_byte;
    wire       uart_rx_valid;

    uart_rx #(
        .CLK_FRE(100000000),
        .BAUD_RATE(UART_BAUD)
    ) u_uart_rx (
        .clk(core_clk),
        .rst_n(logic_rst_n),
        .rx_data(uart_rx_byte),
        .rx_data_valid(uart_rx_valid),
        .rx_data_ready(1'b1),
        .rx_pin(uart_rxd)
    );

    wire uart_clr_cmd = uart_rx_valid && (uart_rx_byte == 8'h63 || uart_rx_byte == 8'h43 || uart_rx_byte == 8'hAA);

    reg ber_clr_ff1, ber_clr_ff2, ber_clr_ff2_d;
    always @(posedge core_clk) begin
        if (logic_rst) begin
            ber_clr_ff1 <= 1'b0;
            ber_clr_ff2 <= 1'b0;
            ber_clr_ff2_d <= 1'b0;
        end else begin
            ber_clr_ff1 <= ber_clr;
            ber_clr_ff2 <= ber_clr_ff1;
            ber_clr_ff2_d <= ber_clr_ff2;
        end
    end
    wire vio_clear_pulse = ber_clr_ff2 & ~ber_clr_ff2_d;
    wire master_clear_pulse = vio_clear_pulse | uart_clr_cmd;
    wire ber_clear_pulse = master_clear_pulse;

    //======================================================================
    // 6. PRBS Check & Statistics (照搬 Sticky Lock & Force Lock 逻辑)
    //======================================================================
    // 注意：S1 模式下，rx_frame_locked 对于数据有效性也很重要，建议加入判断
    wire prbs_meas_ok = use_prbs & ~tx_pat_hold & tx_done_core & rx_done_core & bit_locked;
    wire prbs_chk_fire = s1_rx_valid & prbs_meas_ok;

    reg prbs_meas_ok_d;
    always @(posedge core_clk) begin
        if (logic_rst) prbs_meas_ok_d <= 1'b0;
        else prbs_meas_ok_d <= prbs_meas_ok;
    end
    (* MARK_DEBUG="true" *) wire prbs_meas_start = prbs_meas_ok & ~prbs_meas_ok_d;
    (* MARK_DEBUG="true" *) wire prbs_chk_rst = logic_rst | master_clear_pulse | prbs_meas_start;

    (* MARK_DEBUG="true" *) wire [7:0] prbs_err_vec_int;
    reg prbs_locked_internal; // Forward Declaration

    // RX PRBS Check (i_force_lock 接内部信号)
    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (1),
        .INV_PATTERN (0),
        .POLY_LENGHT (7),
        .POLY_TAP    (6),
        .NBITS       (8)
    ) u_prbs_chk_rx (
        .RST      (prbs_chk_rst),
        .CLK      (core_clk),
        .DATA_IN  (s1_rx_data),
        .EN       (prbs_chk_fire),
        .DATA_OUT (prbs_err_vec_int),
        .i_force_lock (prbs_locked_internal) 
    );

    (* MARK_DEBUG="true" *) wire prbs_match_fail = prbs_chk_fire && (|prbs_err_vec_int);
    wire [7:0] prbs_err_vec = prbs_chk_fire ? prbs_err_vec_int : 8'h00;

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

    reg [31:0] good_cnt;
    reg [15:0] mask_cnt;
    reg        ber_enable;
    reg [63:0] total_bits_cnt;
    reg [63:0] total_err_cnt;

    // ★★★ Sticky Lock Logic (原封不动) ★★★
    always @(posedge core_clk) begin
        if (logic_rst || master_clear_pulse || ~prbs_meas_ok) begin
            good_cnt             <= 32'd0;
            prbs_locked_internal <= 1'b0;
            mask_cnt             <= 16'd0;
            ber_enable           <= 1'b0;
            total_bits_cnt       <= 64'd0;
            total_err_cnt        <= 64'd0;
        end else if (prbs_chk_fire) begin
            if (!prbs_locked_internal) begin
                // Searching Phase
                ber_enable <= 1'b0;
                if (prbs_match_fail) begin
                    good_cnt <= 32'd0;
                end else begin
                    if (good_cnt >= (LOCK_THRESH-1)) begin
                        prbs_locked_internal <= 1'b1; // Lock!
                        good_cnt <= 32'd0;
                        mask_cnt <= 16'd0;
                    end else begin
                        good_cnt <= good_cnt + 1'b1;
                    end
                end
            end else begin
                // Locked Phase (Never unlocks automatically)
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
    // 7. VIO BER Hardware Calculation (保留硬件除法器)
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
    wire       s_axis_dividend_tready;
    wire       s_axis_divisor_tready;
    wire       m_axis_dout_tvalid;
    wire [95:0] m_axis_dout_tdata;

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

    reg [31:0] ber_q32_reg;
    always @(posedge core_clk) begin
        if (logic_rst) begin
            ber_q32_reg <= 32'hFFFF_FFFF; // LINK_DOWN
        end else if (!use_prbs) begin
            ber_q32_reg <= 32'd0;
        end else if (!have_light_core) begin
            ber_q32_reg <= 32'hFFFF_FFFF;
        end else if (!prbs_meas_ok || !prbs_locked_internal) begin
            ber_q32_reg <= 32'hFFFF_FFFD; // SEARCHING
        end else if (!ber_enable) begin
            ber_q32_reg <= 32'hFFFF_FFFD; // MASKING
        end else if (ber_clear_pulse) begin
            ber_q32_reg <= 32'hFFFF_FFFD;
        end else if (m_axis_dout_tvalid) begin
            ber_q32_reg <= m_axis_dout_tdata[31:0];
        end
    end

    assign ber_result_to_vio = ber_q32_reg;

//======================================================================
    // 8. UART TX (修复版：防死锁状态机 + 快速打印)
    //======================================================================
    
    // 构造状态掩码
    wire [7:0] uart_status_byte = {
        1'b1,                  // [7] Alive
        1'b0,                  // [6] Reserved
        ~rx_frame_locked,      // [5] Realigning
        prbs_locked_internal,  // [4] PRBS Locked
        1'b0,                  // [3] Block ID Aligned
        rx_frame_locked,       // [2] Frame Locked
        cdr_stable_core,       // [1] CDR Stable
        have_light_core        // [0] Light
    };

    wire uart_tx_ready;
    reg uart_tx_valid;
    reg [7:0] uart_tx_data;
    
    uart_tx #(
        .CLK_FRE(100000000),
        .BAUD_RATE(UART_BAUD)
    ) u_uart_tx (
        .clk(core_clk),
        .rst_n(logic_rst_n),
        .tx_data(uart_tx_data),
        .tx_data_valid(uart_tx_valid),
        .tx_data_ready(uart_tx_ready),
        .tx_pin(uart_txd)
    );

    function [7:0] hexchar(input [3:0] nib);
        hexchar = (nib < 10) ? (8'h30 + nib) : (8'h41 + (nib - 10));
    endfunction

    // ★ 修改 1: 减小打印间隔 (仿真用小值，综合用大值)
`ifdef SIM
    localparam integer DIV_VAL = 1000; // 仿真极快打印
`else
    localparam integer DIV_VAL = 10_000_000; // 上板 0.1s 打印一次
`endif

    localparam integer PRINT_CNT_W = $clog2(DIV_VAL + 1);
    reg [PRINT_CNT_W-1:0] print_cnt;
    reg print_pulse;
    always @(posedge core_clk) begin
        if (logic_rst) begin print_cnt <= 0; print_pulse <= 0; end
        else if (print_cnt == DIV_VAL-1) begin print_cnt <= 0; print_pulse <= 1; end
        else begin print_cnt <= print_cnt + 1; print_pulse <= 0; end
    end

    reg [2:0] fsm_state;
    reg [5:0] msg_idx;
    reg [63:0] bits_frame, err_frame;
    reg [7:0] stat_frame;
    
    // 移除 S_WAIT_BUSY，改用更稳健的 Valid/Ready 握手
    localparam S_IDLE_WAIT=0, S_PREPARE=1, S_SEND=2, S_CHECK_NEXT=3;
    
    always @(posedge core_clk) begin
        if (logic_rst) begin
            fsm_state <= S_IDLE_WAIT; 
            uart_tx_valid <= 0;
            msg_idx <= 0;
        end else begin
            // 默认拉低，除非在 SEND 状态显式拉高
            uart_tx_valid <= 0; 

            case (fsm_state)
                S_IDLE_WAIT: begin
                    if (print_pulse) begin 
                        bits_frame <= total_bits_cnt; 
                        err_frame  <= total_err_cnt; 
                        stat_frame <= uart_status_byte;
                        msg_idx <= 0; 
                        fsm_state <= S_PREPARE;
                    end
                end

                S_PREPARE: begin
                    // 只有当 UART 准备好接收数据时，才加载数据
                    if (uart_tx_ready) begin
                        case (msg_idx)
                            0: uart_tx_data <= "S"; 1: uart_tx_data <= "=";
                            2: uart_tx_data <= hexchar(stat_frame[7:4]); 3: uart_tx_data <= hexchar(stat_frame[3:0]); 4: uart_tx_data <= " ";
                            5: uart_tx_data <= "B"; 6: uart_tx_data <= "=";
                            7: uart_tx_data <= hexchar(bits_frame[63:60]); 8: uart_tx_data <= hexchar(bits_frame[59:56]);
                            9: uart_tx_data <= hexchar(bits_frame[55:52]); 10: uart_tx_data <= hexchar(bits_frame[51:48]);
                            11: uart_tx_data <= hexchar(bits_frame[47:44]); 12: uart_tx_data <= hexchar(bits_frame[43:40]);
                            13: uart_tx_data <= hexchar(bits_frame[39:36]); 14: uart_tx_data <= hexchar(bits_frame[35:32]);
                            15: uart_tx_data <= hexchar(bits_frame[31:28]); 16: uart_tx_data <= hexchar(bits_frame[27:24]);
                            17: uart_tx_data <= hexchar(bits_frame[23:20]); 18: uart_tx_data <= hexchar(bits_frame[19:16]);
                            19: uart_tx_data <= hexchar(bits_frame[15:12]); 20: uart_tx_data <= hexchar(bits_frame[11:8]);
                            21: uart_tx_data <= hexchar(bits_frame[7:4]); 22: uart_tx_data <= hexchar(bits_frame[3:0]);
                            23: uart_tx_data <= " "; 24: uart_tx_data <= "E"; 25: uart_tx_data <= "=";
                            26: uart_tx_data <= hexchar(err_frame[63:60]); 27: uart_tx_data <= hexchar(err_frame[59:56]);
                            28: uart_tx_data <= hexchar(err_frame[55:52]); 29: uart_tx_data <= hexchar(err_frame[51:48]);
                            30: uart_tx_data <= hexchar(err_frame[47:44]); 31: uart_tx_data <= hexchar(err_frame[43:40]);
                            32: uart_tx_data <= hexchar(err_frame[39:36]); 33: uart_tx_data <= hexchar(err_frame[35:32]);
                            34: uart_tx_data <= hexchar(err_frame[31:28]); 35: uart_tx_data <= hexchar(err_frame[27:24]);
                            36: uart_tx_data <= hexchar(err_frame[23:20]); 37: uart_tx_data <= hexchar(err_frame[19:16]);
                            38: uart_tx_data <= hexchar(err_frame[15:12]); 39: uart_tx_data <= hexchar(err_frame[11:8]);
                            40: uart_tx_data <= hexchar(err_frame[7:4]); 41: uart_tx_data <= hexchar(err_frame[3:0]);
                            42: uart_tx_data <= 8'h0D; 43: uart_tx_data <= 8'h0A;
                            default: uart_tx_data <= "?";
                        endcase
                        fsm_state <= S_SEND;
                    end
                end

                S_SEND: begin 
                    uart_tx_valid <= 1; // 拉高 valid
                    // ★ 修改 2: 不去等待 !ready，而是直接去检查下一个
                    // 只要 ready 为高，valid 为高，数据就被传输了(假设 UART 是 standard handshake)
                    // 为了稳妥，我们在这里待一拍，确保 valid 被采样
                    fsm_state <= S_CHECK_NEXT; 
                end

                S_CHECK_NEXT: begin
                    // 这里我们假设上一拍数据已被吃掉。
                    // 检查是否发完
                    if (msg_idx == 43) begin 
                        fsm_state <= S_IDLE_WAIT; 
                    end else begin 
                        msg_idx <= msg_idx + 1; 
                        // 如果 UART 很快（FIFO），ready 可能还是高，直接发下一个
                        // 如果 UART 慢，S_PREPARE 会卡住等待 ready
                        fsm_state <= S_PREPARE; 
                    end
                end
                
                default: fsm_state <= S_IDLE_WAIT;
            endcase
        end
    end

endmodule