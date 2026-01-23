`timescale 1ns / 1ps
`include "global_defines.vh"

module gth_loopback_top_nofec #(
    parameter integer W                = 32,
    parameter integer PAYLOAD_WORDS    = 16,
    parameter integer RS_K             = 229,
    parameter integer RS_N             = 255,
    parameter integer INTLV_D          = 64,
    parameter integer INTLV_N          = 255,
    parameter integer FRAMES_PER_BLOCK = 255,
    parameter integer LOCK_THRESH      = 1024,
    parameter integer UNLOCK_THRESH    = 16,
    parameter integer TEST_PRBS        = 1,

    parameter integer CORE_CLK_HZ      = 100_000_000,
    parameter integer UART_BAUD        = 9600,
    parameter integer PRINT_DIV        = 100_000_000
)(
    input  wire         sys_clk_p,
    input  wire         sys_clk_n,
    input  wire         sys_rst_n,

    input  wire         mgtrefclk0_x1y1_p,
    input  wire         mgtrefclk0_x1y1_n,

    // UART 接口
    output wire         uart_txd,
    input  wire         uart_rxd, // 【输入】连接到 ALINX uart_rx 的 rx_pin

    input  wire         gthrxp_in,
    input  wire         gthrxn_in,
    output wire         gthtxp_out,
    output wire         gthtxn_out,

    input  wire [1:0]   sfp_loss,
    output wire [1:0]   tx_disable
);
    assign tx_disable = 2'b00;

    //======================================================================
    // 1. Clocks & Logic Reset
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
    // 0. VIO Control
    //======================================================================
    wire        ber_clr;
    wire        scrambler_en;
    wire [2:0]  loop_backmode;
    wire        tx_pattern_prbs_vio;
    wire [31:0] ber_result_to_vio;

    // 请根据你的实际 IP 核名称进行例化
    vio_2 u_vio_ctrl (
        .clk        (core_clk),
        .probe_out0 (ber_clr),
        .probe_out1 (scrambler_en),
        .probe_out2 (loop_backmode),
        .probe_out3 (tx_pattern_prbs_vio),
        .probe_in0  (ber_result_to_vio)
    );

    // TX Pattern Select Logic
    reg tx_pat_ff1, tx_pat_ff2, tx_pat_ff2_d;
    always @(posedge core_clk) begin
        if (logic_rst) begin
            tx_pat_ff1 <= tx_pattern_prbs_vio; tx_pat_ff2 <= tx_pattern_prbs_vio; tx_pat_ff2_d <= tx_pattern_prbs_vio;
        end else begin
            tx_pat_ff1 <= tx_pattern_prbs_vio; tx_pat_ff2 <= tx_pat_ff1;          tx_pat_ff2_d <= tx_pat_ff2;
        end
    end
    wire use_prbs = tx_pat_ff2;
    wire use_cnt  = ~tx_pat_ff2;
    wire tx_pat_sw_pulse = (tx_pat_ff2 ^ tx_pat_ff2_d);
    
    reg [2:0] tx_pat_hold_cnt;
    always @(posedge core_clk) begin
        if (logic_rst) tx_pat_hold_cnt <= 0;
        else if (tx_pat_sw_pulse) tx_pat_hold_cnt <= 4;
        else if (tx_pat_hold_cnt!=0) tx_pat_hold_cnt <= tx_pat_hold_cnt - 1;
    end
    wire tx_pat_hold = (tx_pat_hold_cnt != 0);

    //======================================================================
    // 2. GTH Raw Top
    //======================================================================
    wire tx_usr_clk, tx_rst_n, tx_done, tx_active;
    wire rx_usr_clk, rx_rst_n, rx_done, rx_active, cdr_stable;
    wire [W-1:0] rx_data_from_gth;
    wire [W-1:0] tx_data_to_gth;

    // VIO Loopback control sync
    reg [2:0] loopback_fr1, loopback_fr2;
    always @(posedge freerun_clk) begin
         loopback_fr1 <= loop_backmode; loopback_fr2 <= loopback_fr1;
    end
    wire [2:0] loop_backmode_fr = loopback_fr2;

    gth_raw_top #(.W(W)) u_gth_raw (
        .freerun_clk(freerun_clk),
        .gth_reset_all(~sys_rst_n | ~clk_locked),
        .mgtrefclk0_x1y1_p(mgtrefclk0_x1y1_p), .mgtrefclk0_x1y1_n(mgtrefclk0_x1y1_n),
        .gthrxp_in(gthrxp_in), .gthrxn_in(gthrxn_in),
        .gthtxp_out(gthtxp_out), .gthtxn_out(gthtxn_out),
        .i_loopback(loop_backmode_fr),
        .o_tx_clk(tx_usr_clk), .o_tx_rst_n(tx_rst_n), .o_tx_done(tx_done), .o_tx_active(tx_active), .i_tx_data(tx_data_to_gth),
        .o_rx_clk(rx_usr_clk), .o_rx_rst_n(rx_rst_n), .o_rx_done(rx_done), .o_rx_active(rx_active), .o_cdr_stable(cdr_stable), .o_rx_data(rx_data_from_gth), .i_rx_slide(1'b0)
    );

    // CDC Logic for status
    reg tx_done_cdc1, tx_done_cdc2;
    reg rx_done_cdc1, rx_done_cdc2;
    always @(posedge core_clk) begin
        if(logic_rst) begin tx_done_cdc1<=0; tx_done_cdc2<=0; rx_done_cdc1<=0; rx_done_cdc2<=0; end
        else begin tx_done_cdc1<=tx_done; tx_done_cdc2<=tx_done_cdc1; rx_done_cdc1<=rx_done; rx_done_cdc2<=rx_done_cdc1; end
    end
    wire tx_done_core = tx_done_cdc2;
    wire rx_done_core = rx_done_cdc2;

    // SFP Loss Logic (Core域用于状态显示，RX域用于...其实这里RX域不再阻断统计了)
    reg [1:0] loss_core_ff1, loss_core_ff2;
    reg [1:0] loss_rx_ff1, loss_rx_ff2;
    always @(posedge core_clk) begin loss_core_ff1 <= sfp_loss; loss_core_ff2 <= loss_core_ff1; end
    always @(posedge rx_usr_clk) begin loss_rx_ff1 <= sfp_loss; loss_rx_ff2 <= loss_rx_ff1; end
    wire have_light_core = ~loss_core_ff2[0];
    wire have_light_line = ~loss_rx_ff2[0];

    //======================================================================
    // 3. TX Logic
    //======================================================================
    wire [W-1:0] prbs_tx_word;
    wire tx_fire = tx_active & tx_rst_n; 
    
    // TX 使用修改后的模块，i_force_lock=0 代表纯前馈生成
    prbs_chk #(
        .CHK_MODE    (0),
        .INV_PATTERN (0),
        .POLY_LENGHT (7),
        .POLY_TAP    (6),
        .NBITS       (W)
    ) u_prbs_gen_tx (
        .RST          (~tx_rst_n),
        .CLK          (tx_usr_clk),
        .DATA_IN      ({W{1'b0}}),
        .EN           (use_prbs & tx_fire),
        .DATA_OUT     (prbs_tx_word),
        .i_force_lock (1'b0)
    );
    
    reg [W-1:0] cnt_word;
    always @(posedge tx_usr_clk) begin
       if (~tx_rst_n) cnt_word <= 0;
       else if (use_cnt & tx_fire) cnt_word <= cnt_word + 1;
    end
    assign tx_data_to_gth = use_prbs ? prbs_tx_word : cnt_word;

    //======================================================================
    // 4. RX Logic
    //======================================================================
    reg rx_act_l1, rx_act_l2;
    reg cdr_st_l1, cdr_st_l2;
    reg tx_done_rx1, tx_done_rx2;
    always @(posedge rx_usr_clk) begin
       rx_act_l1 <= rx_active; rx_act_l2 <= rx_act_l1;
       cdr_st_l1 <= cdr_stable; cdr_st_l2 <= cdr_st_l1;
       tx_done_rx1 <= tx_done; tx_done_rx2 <= tx_done_rx1;
    end
    wire rx_active_line  = rx_act_l2;
    wire cdr_stable_line = cdr_st_l2;
    wire tx_done_line    = tx_done_rx2;
    
    // ★★★ 修改点 1：强行统计模式 ★★★
    // 去掉 have_light_line 和 cdr_stable 的限制，只看 GTH RX 是否 Active。
    // 这样即使全是噪声，也会送入 PRBS Checker 产生误码计数。
    wire rx_word_valid_line = rx_active_line; 

    //======================================================================
    // 5. UART RX & 命令解析 
    //======================================================================
    // 状态码定义
    localparam [31:0] BER_CODE_LINK_DOWN  = 32'hFFFF_FFFF;
    localparam [31:0] BER_CODE_NOT_READY  = 32'hFFFF_FFFE;
    localparam [31:0] BER_CODE_SEARCHING  = 32'hFFFF_FFFD;
    localparam [31:0] BER_CODE_LOCKING    = 32'hFFFF_FFFC;

    wire [7:0] rx_byte;
    wire       rx_valid;
    localparam integer CORE_CLK_MHZ = CORE_CLK_HZ / 1_000_000;

    // ALINX UART RX 模块
    uart_rx #(
        .CLK_FRE   (CORE_CLK_MHZ),
        .BAUD_RATE (UART_BAUD)
    ) u_uart_rx (
        .clk           (core_clk),
        .rst_n         (~logic_rst),
        .rx_data       (rx_byte),
        .rx_data_valid (rx_valid),
        .rx_data_ready (1'b1), // 持续接收
        .rx_pin        (uart_rxd)
    );

    // 解析清零指令 (c / C / 0xAA)
    wire uart_clr_cmd = rx_valid && (rx_byte == 8'h63 || rx_byte == 8'h43 || rx_byte == 8'hAA);

    // Core域脉冲 -> Toggle
    reg uart_clr_tgl;
    always @(posedge core_clk) begin
        if (logic_rst) uart_clr_tgl <= 1'b0;
        else if (uart_clr_cmd) uart_clr_tgl <= ~uart_clr_tgl;
    end

    //======================================================================
    // 6. 清零信号跨域处理 (Core -> RX)
    //======================================================================
    reg uart_clr_rx1, uart_clr_rx2, uart_clr_rx3;
    always @(posedge rx_usr_clk or negedge rx_rst_n) begin
        if (!rx_rst_n) begin
            uart_clr_rx1 <= 0; uart_clr_rx2 <= 0; uart_clr_rx3 <= 0;
        end else begin
            uart_clr_rx1 <= uart_clr_tgl;
            uart_clr_rx2 <= uart_clr_rx1;
            uart_clr_rx3 <= uart_clr_rx2;
        end
    end
    wire uart_clear_pulse_rx = (uart_clr_rx2 ^ uart_clr_rx3);

    reg ber_clr_ff1, ber_clr_ff2, ber_clr_ff2_d;
    always @(posedge rx_usr_clk or negedge rx_rst_n) begin
        if (!rx_rst_n) begin
            ber_clr_ff1 <= 0; ber_clr_ff2 <= 0; ber_clr_ff2_d <= 0;
        end else begin
            ber_clr_ff1 <= ber_clr;
            ber_clr_ff2 <= ber_clr_ff1;
            ber_clr_ff2_d <= ber_clr_ff2;
        end
    end
    wire vio_clear_pulse_rx = ber_clr_ff2 & ~ber_clr_ff2_d;
    
    // 最终清零信号 (VIO or UART)
    wire master_clear_pulse = vio_clear_pulse_rx | uart_clear_pulse_rx;

    //======================================================================
    // 7. PRBS Checker & 统计逻辑 (专业误码仪模式)
    //======================================================================
    
    // ★★★ 修改点 2：测量许可 ★★★
    // 只要 TX/RX 初始化完成，就允许测量。不关心光功率/CDR锁定。
    wire prbs_meas_ok = rx_word_valid_line & tx_done_line; 
    
    reg prbs_meas_ok_d;
    always @(posedge rx_usr_clk) prbs_meas_ok_d <= prbs_meas_ok;
    wire prbs_meas_start = prbs_meas_ok & ~prbs_meas_ok_d;

    reg prbs_chk_rst_r;
    always @(posedge rx_usr_clk or negedge rx_rst_n) begin
        if (!rx_rst_n) prbs_chk_rst_r <= 1'b1;
        else prbs_chk_rst_r <= (master_clear_pulse | ~prbs_meas_ok | prbs_meas_start);
    end

    (* MARK_DEBUG="true" *) reg force_lock_req;
    wire [W-1:0] prbs_err_vec_int;
    wire prbs_chk_fire = prbs_meas_ok; 

    // RX Checker 实例化 (带 force_lock)
    prbs_chk #(
        .CHK_MODE    (1),
        .INV_PATTERN (0),
        .POLY_LENGHT (7),
        .POLY_TAP    (6),
        .NBITS       (W)
    ) u_prbs_chk_rx (
        .RST          (prbs_chk_rst_r),
        .CLK          (rx_usr_clk),
        .DATA_IN      (rx_data_from_gth),
        .EN           (prbs_chk_fire),
        .DATA_OUT     (prbs_err_vec_int),
        .i_force_lock (force_lock_req) // 强制闭环
    );

    function integer popcountW;
      input [W-1:0] v;
      integer k;
      begin
        popcountW = 0;
        for (k = 0; k < W; k = k + 1) popcountW = popcountW + v[k];
      end
    endfunction
    wire [15:0] current_err_num = popcountW(prbs_err_vec_int);
    localparam [63:0] W64 = (64'd0 + W);

    // 统计状态机 (Sticky Lock)
    (* MARK_DEBUG="true" *) reg [31:0] good_cnt;
    (* MARK_DEBUG="true" *) reg        prbs_locked;
    (* MARK_DEBUG="true" *) reg [63:0] total_bits_cnt;
    (* MARK_DEBUG="true" *) reg [63:0] total_err_cnt;

    always @(posedge rx_usr_clk or negedge rx_rst_n) begin
      if (!rx_rst_n) begin
        good_cnt       <= 32'd0;
        prbs_locked    <= 1'b0;
        force_lock_req <= 1'b0;
        total_bits_cnt <= 64'd0;
        total_err_cnt  <= 64'd0;
      end else if (master_clear_pulse) begin
        good_cnt       <= 32'd0;
        prbs_locked    <= 1'b0;
        force_lock_req <= 1'b0;
        total_bits_cnt <= 64'd0;
        total_err_cnt  <= 64'd0;
      end else if (!prbs_meas_ok) begin
        // 仅当 GTH 彻底未准备好时复位
        good_cnt       <= 32'd0;
        prbs_locked    <= 1'b0;
        force_lock_req <= 1'b0;
      end else if (prbs_chk_fire) begin
        if (!prbs_locked) begin
          // --- 搜索阶段 ---
          if (|prbs_err_vec_int) begin
            good_cnt <= 32'd0;
          end else begin
            if (good_cnt >= (LOCK_THRESH-1)) begin
               prbs_locked    <= 1'b1;
               force_lock_req <= 1'b1; // 锁定！切断外部干扰
               good_cnt       <= 32'd0;
            end else begin
               good_cnt <= good_cnt + 1'b1;
            end
          end
        end else begin
          // --- 锁定统计阶段 ---
          // 哪怕此时光纤被拔，数据全0，Checker 也会疯狂报错，但不会掉锁
          // 从而如实记录下“断开瞬间”和“断开期间”的所有错误
          total_bits_cnt <= total_bits_cnt + W64;
          total_err_cnt  <= total_err_cnt  + current_err_num;
        end
      end
    end

    // VIO Display
    reg [31:0] ber_status_rx;
    always @(posedge rx_usr_clk) begin
      if (!have_light_line)        ber_status_rx <= BER_CODE_LINK_DOWN;
      else if (!cdr_stable)        ber_status_rx <= BER_CODE_NOT_READY;
      else if (!prbs_locked)       ber_status_rx <= BER_CODE_SEARCHING;
      else                         ber_status_rx <= total_err_cnt[31:0];
    end
    
    reg [31:0] ber_sync1, ber_sync2;
    always @(posedge core_clk) begin
        if (logic_rst) begin 
            ber_sync1 <= BER_CODE_LINK_DOWN; 
            ber_sync2 <= BER_CODE_LINK_DOWN; 
        end else begin
            ber_sync1 <= ber_status_rx; 
            ber_sync2 <= ber_sync1; 
        end
    end
    assign ber_result_to_vio = ber_sync2;

    //======================================================================
    // 8. UART TX Logic (包含 Watchdog 和 物理层诊断)
    //======================================================================
    
    wire ber_clear_pulse_core = (ber_clr_ff2 & ~ber_clr_ff2_d); 
    wire uart_clear_pulse_core = uart_clr_cmd; 
    
    // [RX域] 逻辑状态码
    reg [7:0] rx_stat_code_internal;
    always @(*) begin
        if (!prbs_locked) rx_stat_code_internal = 8'h01; // Searching
        else              rx_stat_code_internal = 8'h00; // Locked
    end

    // [Core域] 物理状态直通 (用于 RX CLK 挂掉时验尸)
    reg cdr_stable_c1, cdr_stable_c2;
    always @(posedge core_clk) begin
        cdr_stable_c1 <= cdr_stable; cdr_stable_c2 <= cdr_stable_c1;
    end
    wire cdr_stable_core = cdr_stable_c2;
    // have_light_core 之前已定义

    // 快照握手
    reg snap_req_tgl;
    reg snap_busy;
    
    // Core -> RX
    reg snap_req_rx1, snap_req_rx2, snap_req_rx2_d;
    always @(posedge rx_usr_clk) begin
        snap_req_rx1 <= snap_req_tgl; 
        snap_req_rx2 <= snap_req_rx1; 
        snap_req_rx2_d <= snap_req_rx2;
    end
    wire snap_req_pulse_rx = snap_req_rx2 ^ snap_req_rx2_d;
    
    // RX -> Core (锁存)
    reg [63:0] bits_latch_rx, err_latch_rx;
    reg [7:0] stat_latch_rx;
    reg snap_ack_tgl_rx;
    
    always @(posedge rx_usr_clk) begin
        if(snap_req_pulse_rx) begin
            bits_latch_rx   <= total_bits_cnt;
            err_latch_rx    <= total_err_cnt;
            stat_latch_rx   <= rx_stat_code_internal;
            snap_ack_tgl_rx <= ~snap_ack_tgl_rx;
        end
    end
    
    // RX -> Core (应答)
    reg snap_ack_c1, snap_ack_c2, snap_ack_c2_d;
    always @(posedge core_clk) begin
        snap_ack_c1 <= snap_ack_tgl_rx; 
        snap_ack_c2 <= snap_ack_c1; 
        snap_ack_c2_d <= snap_ack_c2;
    end
    wire snap_ready_normal = snap_ack_c2 ^ snap_ack_c2_d; 

    // ★★★ 看门狗：防止 RX 时钟停振导致死机 ★★★
    reg [9:0] watchdog_cnt;
    reg snap_timeout_pulse;
    
    always @(posedge core_clk) begin
        if (logic_rst) begin
            watchdog_cnt <= 0; snap_timeout_pulse <= 0;
        end else if (snap_busy) begin
            if (snap_ready_normal) begin
                watchdog_cnt <= 0; snap_timeout_pulse <= 0;
            end else if (watchdog_cnt == 10'd1023) begin
                watchdog_cnt <= 0; snap_timeout_pulse <= 1; // 超时!
            end else begin
                watchdog_cnt <= watchdog_cnt + 1; snap_timeout_pulse <= 0;
            end
        end else begin
            watchdog_cnt <= 0; snap_timeout_pulse <= 0;
        end
    end

    wire snap_finish = snap_ready_normal | snap_timeout_pulse;

    // 最终数据更新 (Core Domain)
    reg [63:0] bits_snap_core, err_snap_core;
    reg [7:0] stat_snap_core;
    
    reg [63:0] bits_l1, bits_l2, err_l1, err_l2;
    reg [7:0]  stat_l1, stat_l2;
    
    always @(posedge core_clk) begin
        bits_l1 <= bits_latch_rx; bits_l2 <= bits_l1;
        err_l1  <= err_latch_rx;  err_l2  <= err_l1;
        stat_l1 <= stat_latch_rx; stat_l2 <= stat_l1;
        
        if (snap_ready_normal) begin
            // RX 正常，综合逻辑 + 物理状态判断
            bits_snap_core <= bits_l2; 
            err_snap_core  <= err_l2; 
            if (!have_light_core)      stat_snap_core <= 8'h03; // No Light
            else if (!cdr_stable_core) stat_snap_core <= 8'h02; // CDR Unlock
            else                       stat_snap_core <= stat_l2; // Locked/Search
        end else if (snap_timeout_pulse) begin
            // RX 挂了，直接验尸
            // 保留最后的计数值
            if (!have_light_core)      stat_snap_core <= 8'h03; // No Light
            else if (!cdr_stable_core) stat_snap_core <= 8'h02; // CDR Unlock
            else                       stat_snap_core <= 8'h04; // S=04: RX CLK DEAD
        end
    end

    // 定时器
    localparam integer PRINT_CNT_W = (PRINT_DIV <= 1) ? 1 : $clog2(PRINT_DIV);
    reg [PRINT_CNT_W-1:0] print_cnt;
    reg print_pulse;
    always @(posedge core_clk) begin
        if (logic_rst || uart_clear_pulse_core) begin print_cnt <= 0; print_pulse <= 0; end
        else if (print_cnt == PRINT_DIV-1) begin print_cnt <= 0; print_pulse <= 1; end
        else begin print_cnt <= print_cnt + 1; print_pulse <= 0; end
    end
    
    reg sending;
    wire snap_can_issue = print_pulse && !sending && (!snap_busy || snap_finish);
    
    always @(posedge core_clk) begin
        if (logic_rst) begin snap_req_tgl <= 0; snap_busy <= 0; end
        else if (snap_can_issue) begin snap_req_tgl <= ~snap_req_tgl; snap_busy <= 1; end
        else if (snap_finish) snap_busy <= 0;
    end

    // UART TX Instantiation
    wire uart_tx_ready;
    reg uart_tx_valid;
    reg [7:0] uart_tx_data;
    
    uart_tx #(
        .CLK_FRE(CORE_CLK_MHZ),
        .BAUD_RATE(UART_BAUD)
    ) u_uart_tx (
        .clk(core_clk),
        .rst_n(~logic_rst),
        .tx_data(uart_tx_data),
        .tx_data_valid(uart_tx_valid),
        .tx_data_ready(uart_tx_ready),
        .tx_pin(uart_txd)
    );

    function [7:0] hexchar(input [3:0] nib);
        hexchar = (nib < 10) ? (8'h30 + nib) : (8'h41 + (nib - 10));
    endfunction

    // UART TX FSM (S=xx B=... E=...)
    reg [2:0] fsm_state;
    reg [5:0] msg_idx;
    reg [63:0] bits_frame, err_frame;
    reg [7:0] stat_frame;
    
    localparam S_IDLE_WAIT=0, S_PREPARE=1, S_SEND=2, S_WAIT_BUSY=3, S_WAIT_DONE=4;
    
    always @(posedge core_clk) begin
        if (logic_rst || uart_clear_pulse_core) begin
            fsm_state <= S_IDLE_WAIT; sending <= 0; uart_tx_valid <= 0;
        end else begin
            uart_tx_valid <= 0;
            case (fsm_state)
                S_IDLE_WAIT: begin
                    sending <= 0;
                    if (snap_finish) begin // 只要完成（无论成功失败）都发送
                        bits_frame <= bits_snap_core; err_frame <= err_snap_core; stat_frame <= stat_snap_core;
                        sending <= 1; msg_idx <= 0; fsm_state <= S_PREPARE;
                    end
                end
                S_PREPARE: begin
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
                S_SEND: begin uart_tx_valid <= 1; fsm_state <= S_WAIT_BUSY; end
                S_WAIT_BUSY: if (!uart_tx_ready) fsm_state <= S_WAIT_DONE;
                S_WAIT_DONE: if (uart_tx_ready) begin
                    if (msg_idx == 43) begin fsm_state <= S_IDLE_WAIT; sending <= 0; end
                    else begin msg_idx <= msg_idx + 1; fsm_state <= S_PREPARE; end
                end
            endcase
        end
    end

endmodule