`timescale 1ns / 1ps
`include "global_defines.vh"

module fec_gth_loopback_top_nogate #(
    parameter integer W                = 32,
    parameter integer PAYLOAD_WORDS    = 16,
    parameter integer RS_K             = 229,
    parameter integer RS_N             = 255,
    parameter integer INTLV_D          = 64,  // 当前深度
    parameter integer INTLV_N          = 255,
    parameter integer FRAMES_PER_BLOCK = 255,
    parameter integer LOCK_THRESH      = 1024,
    // SIM 默认模式：1=PRBS，0=Counter (延迟测试建议用0，方便ILA核对，但此逻辑对PRBS也有效)
    parameter integer TEST_PRBS        = 1, 

    // UART 参数配置
    parameter integer CORE_CLK_HZ      = 100_000_000,
    parameter integer UART_BAUD        = 115200,
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
    wire        tx_pattern_prbs_vio;
    wire [31:0] ber_result_to_vio; // ★ 这个信号被复用显示延迟

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
            .probe_in0  (ber_result_to_vio) // ★ 连接复用结果
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
    wire        rx_slide_req;

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

    wire tx_path_rst_n = logic_rst_n & tx_rst_n_core & tx_done_core & ~tx_pat_hold;
    wire tx_path_rst   = ~tx_path_rst_n;

    // ======================================================================
    // SFP Loss 信号处理
    // ======================================================================
    reg [1:0] loss_core_ff1, loss_core_ff2;
    reg [1:0] loss_rx_ff1,   loss_rx_ff2;
    reg cdr_core_ff1, cdr_core_ff2; 

    always @(posedge core_clk) begin
        if(logic_rst) begin
            loss_core_ff1 <= 2'b11; loss_core_ff2 <= 2'b11;
            cdr_core_ff1  <= 1'b0;  cdr_core_ff2  <= 1'b0;
        end else begin
            loss_core_ff1 <= sfp_loss;
            loss_core_ff2 <= loss_core_ff1;
            cdr_core_ff1  <= cdr_stable;
            cdr_core_ff2  <= cdr_core_ff1;
        end
    end

    always @(posedge rx_usr_clk) begin
        if(!rx_rst_n) begin
            loss_rx_ff1 <= 2'b11; loss_rx_ff2 <= 2'b11;
        end else begin
            loss_rx_ff1 <= sfp_loss;
            loss_rx_ff2 <= loss_rx_ff1;
        end
    end
    
    wire sfp_real_status_core = ~loss_core_ff2[0];
    wire have_light_core = 1'b1; 
    wire have_light_line = 1'b1; 
    wire cdr_stable_core = cdr_core_ff2;

    //======================================================================
    // 3. TX Logic (Original FEC TX)
    //======================================================================
    wire [7:0]   prbs_tx_data;
    wire         prbs_tx_ready;
    wire [W-1:0] fec_tx_data_line;
    wire         fec_tx_valid_line;
    wire [15:0]  tx_frame_index;

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
    wire tx_src_run = tx_path_rst_n & tx_active_core;
    wire src_fire = tx_src_run & prbs_tx_ready;
    wire prbs_en = use_prbs & src_fire;
    wire cnt_en  = use_cnt  & src_fire;

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (0), .INV_PATTERN (0), .POLY_LENGHT (7), .POLY_TAP    (6), .NBITS       (8)
    ) u_prbs_gen_tx (
        .RST      (tx_path_rst),
        .CLK      (core_clk),
        .DATA_IN  (8'd0),
        .EN       (prbs_en),
        .DATA_OUT (prbs_tx_data),
        .i_force_lock (1'b0) 
    );

    // Counter gen
    (* mark_debug = "true" *) reg [7:0] cnt_data;
    wire [7:0] src_data  = use_prbs ? prbs_tx_data : cnt_data;
    wire       src_valid = use_prbs ? prbs_en      : cnt_en;

    localparam integer BLK_IN_BYTES = INTLV_D * RS_K;
    localparam integer BLK_W        = $clog2(BLK_IN_BYTES);
    reg [BLK_W-1:0] blk_byte_idx;
    reg [15:0] seq16;
    reg        seq_hi_phase;

    always @(posedge core_clk) begin
        if (tx_path_rst) begin
            blk_byte_idx <= 'd0;
            seq16        <= 16'd0;
            seq_hi_phase <= 1'b0;
            cnt_data     <= 8'd0;
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
        .W(W), .PAYLOAD_WORDS(PAYLOAD_WORDS), .RS_K(RS_K), .RS_N(RS_N),
        .INTLV_D(INTLV_D), .INTLV_N(INTLV_N), .FRAMES_PER_BLOCK(FRAMES_PER_BLOCK)
    ) u_fec_tx (
        .line_clk(tx_usr_clk),
        .core_clk(core_clk),
        .rst_n(tx_path_rst_n),
        .scrambler_en(scrambler_en),
        .i_data(src_data),
        .i_valid(src_valid),
        .i_ready(prbs_tx_ready),
        .o_tx_data_line(fec_tx_data_line),
        .o_tx_valid_line(fec_tx_valid_line),
        .o_tx_frame_index(tx_frame_index)
    );
    assign tx_data_to_gth = fec_tx_data_line;

    //======================================================================
    // 4. RX Logic
    //======================================================================
    (* mark_debug = "true" *) wire [7:0]  fec_rx_data;
    (* mark_debug = "true" *) wire        fec_rx_valid;
    wire        bit_locked;
    wire [15:0] rx_frame_index;
    wire [15:0] rx_block_id;
    wire [15:0] rx_frame_in_block;

    wire fec_rx_rst_n = logic_rst_n & rx_rst_n_core & rx_done_core;

    reg rx_act_l1, rx_act_l2;
    reg cdr_st_l1, cdr_st_l2;

    always @(posedge rx_usr_clk or negedge rx_rst_n) begin
        if (!rx_rst_n) begin
            rx_act_l1 <= 1'b0; rx_act_l2 <= 1'b0;
            cdr_st_l1 <= 1'b0; cdr_st_l2 <= 1'b0;
        end else begin
            rx_act_l1 <= rx_active; rx_act_l2 <= rx_act_l1;
            cdr_st_l1 <= cdr_stable; cdr_st_l2 <= cdr_st_l1;
        end
    end
    wire rx_frame_locked;
    wire rx_block_aligned;
    wire rx_realign_req;
    wire rx_active_line     = rx_act_l2;
    wire cdr_stable_line    = cdr_st_l2;
    wire rx_word_valid_line = rx_active_line & cdr_stable_line & have_light_line;

    fec_rx #(
        .W(W), 
        .PAYLOAD_WORDS(PAYLOAD_WORDS), 
        .RS_N(RS_N),
        .INTLV_D(INTLV_D), 
        .FRAMES_PER_BLOCK(FRAMES_PER_BLOCK), 
        .INTLV_N(INTLV_N)
    ) u_fec_rx (
        .line_clk(rx_usr_clk),
        .core_clk(core_clk),
        .rst_n(fec_rx_rst_n),
        .i_rx_data(rx_data_from_gth),
        .i_rx_valid(rx_word_valid_line),
        .rx_reset_done(rx_active_line),
        .rx_cdr_stable(cdr_stable_line),
        .scrambler_en(scrambler_en),
        .o_data(fec_rx_data),
        .o_valid(fec_rx_valid),
        .i_data_ready(1'b1),
        .o_rxslide(rx_slide_req),
        .bit_locked_core(bit_locked),
        .o_frame_index(rx_frame_index),
        .o_block_id(rx_block_id),
        .o_frame_in_block(rx_frame_in_block),
        .o_frame_locked   (rx_frame_locked),
        .o_block_aligned  (rx_block_aligned),
        .o_realign_req    (rx_realign_req)
    );

    //======================================================================
    // 5. UART RX (用于 'c' 指令复位)
    //======================================================================
    localparam integer CORE_CLK_MHZ = CORE_CLK_HZ / 1_000_000;
    wire [7:0] uart_rx_byte;
    wire       uart_rx_valid;

    uart_rx #(
        .CLK_FRE(CORE_CLK_MHZ),
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
    // 6. PRBS Check & Statistics
    //======================================================================
    wire prbs_meas_ok = have_light_core & use_prbs & ~tx_pat_hold & tx_done_core & rx_done_core & bit_locked;
    wire prbs_chk_fire = fec_rx_valid & prbs_meas_ok;

    reg prbs_meas_ok_d;
    always @(posedge core_clk) begin
        if (logic_rst) prbs_meas_ok_d <= 1'b0;
        else prbs_meas_ok_d <= prbs_meas_ok;
    end
    wire prbs_meas_start = prbs_meas_ok & ~prbs_meas_ok_d;
    wire prbs_chk_rst = logic_rst | master_clear_pulse | prbs_meas_start;

    wire [7:0] prbs_err_vec_int;
    reg prbs_locked_internal; 

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (1), .INV_PATTERN (0), .POLY_LENGHT (7), .POLY_TAP    (6), .NBITS       (8)
    ) u_prbs_chk_rx (
        .RST      (prbs_chk_rst),
        .CLK      (core_clk),
        .DATA_IN  (fec_rx_data),
        .EN       (prbs_chk_fire),
        .DATA_OUT (prbs_err_vec_int),
        .i_force_lock (prbs_locked_internal)
    );
    wire prbs_match_fail = prbs_chk_fire && (|prbs_err_vec_int);
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

    // PRBS Fire Delay
    reg prbs_chk_fire_d;
    always @(posedge core_clk) begin
        if (logic_rst) prbs_chk_fire_d <= 1'b0;
        else prbs_chk_fire_d <= prbs_chk_fire;
    end

    // Lock State Machine
    always @(posedge core_clk) begin
        if (logic_rst || master_clear_pulse || ~prbs_meas_ok) begin
            good_cnt             <= 32'd0;
            prbs_locked_internal <= 1'b0;
            mask_cnt             <= 16'd0;
            ber_enable           <= 1'b0;
        end else if (prbs_chk_fire) begin
            if (!prbs_locked_internal) begin
                ber_enable <= 1'b0;
                if (prbs_match_fail) begin
                    good_cnt <= 32'd0;
                end else begin
                    if (good_cnt >= (LOCK_THRESH-1)) begin
                        prbs_locked_internal <= 1'b1;
                        good_cnt <= 32'd0;
                        mask_cnt <= 16'd0;
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
            end
        end
    end

    // Error Counters
    always @(posedge core_clk) begin
        if (logic_rst || master_clear_pulse) begin
            total_bits_cnt <= 64'd0;
            total_err_cnt  <= 64'd0;
        end else if (prbs_meas_ok && ber_enable && prbs_chk_fire_d) begin 
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

    //======================================================================
    // 7. VIO BER Hardware Calculation
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
    reg [63:0] div_dividend_reg;
    reg [63:0] div_divisor_reg;  
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

    // ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
    // [新版] 稳态延迟测量逻辑 (Steady-State Latency Measurement)
    // 原理：计算"在途数据量" (In-Flight Words)
    // ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
    
    reg [31:0] tx_word_cnt;    // 发送端累计发送出的有效 User Word 总数
    reg [31:0] rx_word_cnt;    // 接收端累计接收到的有效 User Word 总数
    reg [31:0] latency_diff;   // 差值，即延迟周期数

    // 复位：跟随系统复位 (链路断开时清零，重新对齐)
    // 注意：这里使用 logic_rst 而不是 ber_clr，保证链路建立后一直累计
    always @(posedge core_clk) begin
        if (logic_rst) begin
            tx_word_cnt <= 32'd0;
            rx_word_cnt <= 32'd0;
            latency_diff <= 32'd0;
        end else begin
            // 1. 统计 TX 进入 FEC 的有效数据个数
            // source 62: src_valid 是用户数据进入 FEC 的有效指示
            // source 58: tx_src_run 确保物理层 ready
            if (tx_src_run && src_valid) begin
                tx_word_cnt <= tx_word_cnt + 1'b1;
            end

            // 2. 统计 RX 从 FEC 出来的有效数据个数
            // source 75: fec_rx_valid 是用户数据输出的有效指示
            if (fec_rx_valid) begin
                rx_word_cnt <= rx_word_cnt + 1'b1;
            end

            // 3. 实时计算差值 (利用补码特性，自动处理32位溢出回绕)
            // 这个差值就是“正在 FIFO 和交织器里排队的数据量”
            latency_diff <= tx_word_cnt - rx_word_cnt;
        end
    end

    // [VIO 显示]
    // 当 loop_backmode == 001 时，显示稳态延迟
    assign ber_result_to_vio = (loop_backmode == 3'b001) ? latency_diff : ber_q32_reg;


    //======================================================================
    // 8. UART TX (发送 S=xx B=... E=...)
    //======================================================================
    wire [7:0] uart_status_byte = {
        1'b1,                  // [7] Alive
        1'b0,                  // [6] Reserved
        rx_realign_req,        // [5] Realigning
        prbs_locked_internal,  // [4] PRBS Locked
        rx_block_aligned,      // [3] Block ID Aligned 
        rx_frame_locked,       // [2] Frame Locked 
        cdr_stable_core,       // [1] CDR Stable
        sfp_real_status_core   // [0] Light (真实状态)
    };
    wire uart_tx_ready;
    reg uart_tx_valid;
    reg [7:0] uart_tx_data;
    
    uart_tx #(
        .CLK_FRE(CORE_CLK_MHZ),
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

    localparam integer PRINT_CNT_W = (PRINT_DIV <= 1) ? 1 : $clog2(PRINT_DIV);
    reg [PRINT_CNT_W-1:0] print_cnt;
    reg print_pulse;
    always @(posedge core_clk) begin
        if (logic_rst) begin print_cnt <= 0; print_pulse <= 0; end
        else if (print_cnt == PRINT_DIV-1) begin print_cnt <= 0; print_pulse <= 1; end
        else begin print_cnt <= print_cnt + 1; print_pulse <= 0; end
    end

    reg [2:0] fsm_state;
    reg [5:0] msg_idx;
    reg [63:0] bits_frame, err_frame;
    reg [7:0] stat_frame;
    localparam S_IDLE_WAIT=0, S_PREPARE=1, S_SEND=2, S_WAIT_BUSY=3, S_WAIT_DONE=4;
    
    always @(posedge core_clk) begin
        if (logic_rst) begin
            fsm_state <= S_IDLE_WAIT;
            uart_tx_valid <= 0;
        end else begin
            uart_tx_valid <= 0;
            case (fsm_state)
                S_IDLE_WAIT: begin
                    if (print_pulse) begin 
                        bits_frame <= total_bits_cnt;
                        err_frame  <= total_err_cnt; 
                        stat_frame <= uart_status_byte;
                        msg_idx <= 0; fsm_state <= S_PREPARE;
                    end
                end
                S_PREPARE: begin
                    if (uart_tx_ready) begin
                        case (msg_idx)
                            0: uart_tx_data <= "S"; 1: uart_tx_data <= "=";
                            2: uart_tx_data <= hexchar(stat_frame[7:4]);
                            3: uart_tx_data <= hexchar(stat_frame[3:0]); 4: uart_tx_data <= " ";
                            5: uart_tx_data <= "B"; 6: uart_tx_data <= "=";
                            7: uart_tx_data <= hexchar(bits_frame[63:60]); 8: uart_tx_data <= hexchar(bits_frame[59:56]);
                            9: uart_tx_data <= hexchar(bits_frame[55:52]); 10: uart_tx_data <= hexchar(bits_frame[51:48]);
                            11: uart_tx_data <= hexchar(bits_frame[47:44]);
                            12: uart_tx_data <= hexchar(bits_frame[43:40]);
                            13: uart_tx_data <= hexchar(bits_frame[39:36]); 14: uart_tx_data <= hexchar(bits_frame[35:32]);
                            15: uart_tx_data <= hexchar(bits_frame[31:28]); 16: uart_tx_data <= hexchar(bits_frame[27:24]);
                            17: uart_tx_data <= hexchar(bits_frame[23:20]); 18: uart_tx_data <= hexchar(bits_frame[19:16]);
                            19: uart_tx_data <= hexchar(bits_frame[15:12]); 20: uart_tx_data <= hexchar(bits_frame[11:8]);
                            21: uart_tx_data <= hexchar(bits_frame[7:4]);
                            22: uart_tx_data <= hexchar(bits_frame[3:0]);
                            23: uart_tx_data <= " "; 24: uart_tx_data <= "E"; 25: uart_tx_data <= "=";
                            26: uart_tx_data <= hexchar(err_frame[63:60]); 27: uart_tx_data <= hexchar(err_frame[59:56]);
                            28: uart_tx_data <= hexchar(err_frame[55:52]); 29: uart_tx_data <= hexchar(err_frame[51:48]);
                            30: uart_tx_data <= hexchar(err_frame[47:44]);
                            31: uart_tx_data <= hexchar(err_frame[43:40]);
                            32: uart_tx_data <= hexchar(err_frame[39:36]); 33: uart_tx_data <= hexchar(err_frame[35:32]);
                            34: uart_tx_data <= hexchar(err_frame[31:28]); 35: uart_tx_data <= hexchar(err_frame[27:24]);
                            36: uart_tx_data <= hexchar(err_frame[23:20]); 37: uart_tx_data <= hexchar(err_frame[19:16]);
                            38: uart_tx_data <= hexchar(err_frame[15:12]); 39: uart_tx_data <= hexchar(err_frame[11:8]);
                            40: uart_tx_data <= hexchar(err_frame[7:4]);
                            41: uart_tx_data <= hexchar(err_frame[3:0]);
                            42: uart_tx_data <= 8'h0D; 43: uart_tx_data <= 8'h0A;
                            default: uart_tx_data <= "?";
                        endcase
                        fsm_state <= S_SEND;
                    end
                end
                S_SEND: begin uart_tx_valid <= 1; fsm_state <= S_WAIT_BUSY; end
                S_WAIT_BUSY: if (!uart_tx_ready) fsm_state <= S_WAIT_DONE;
                S_WAIT_DONE: if (uart_tx_ready) begin
                    if (msg_idx == 43) begin fsm_state <= S_IDLE_WAIT; end
                    else begin msg_idx <= msg_idx + 1; fsm_state <= S_PREPARE; end
                end
            endcase
        end
    end

endmodule