`timescale 1ns/1ps

module gth_prbs_raw_loopback_top #(
    parameter integer W = 32,
    parameter integer PRBS_INV    = 1,
    parameter integer PRBS_LEN    = 31,
    parameter integer PRBS_TAP    = 28,
    parameter integer LOCK_THRESH = 1024
)(
    input  wire         sys_clk_p,    // 200Mhz
    input  wire         sys_clk_n,
    input  wire         sys_rst_n,

    output wire [1:0]   tx_disable,

    input  wire         mgtrefclk0_x1y1_p,  // 125Mhz
    input  wire         mgtrefclk0_x1y1_n,

    input  wire         gthrxp_in,
    input  wire         gthrxn_in,
    output wire         gthtxp_out,
    output wire         gthtxn_out
);

    // SFP TX disable：0=enable
    assign tx_disable = 2'b00;

    // =========================================================================
    // 1. 时钟与复位
    // =========================================================================
    wire freerun_clk;
    wire pll_locked;
    clk_wiz_2 u_clk_wiz_2 (
        .clk_out1 (freerun_clk),
        .reset    (~sys_rst_n),
        .locked   (pll_locked),
        .clk_in1_p(sys_clk_p),
        .clk_in1_n(sys_clk_n)
    );

    // GTH 复位 (active-high)
    wire gth_reset_all = ~(sys_rst_n & pll_locked);

    // =========================================================================
    // 2. VIO 控制与监视
    // =========================================================================
    // 注意：请确保您的 vio_2 IP 核已配置为：
    // OUTPUT PROBES: 4个 (index 0~3)
    // INPUT PROBES:  1个 (index 0, 宽度32)
    wire [2:0]  loopback_mode;
    wire        rx_slide;
    wire [W-1:0] tx_err_inject;
    wire        vio_ber_clr;      // probe_out3: 误码清零
    wire [31:0] vio_ber_result;   // probe_in0:  BER结果显示

    vio_2 u_vio (
        .clk        (freerun_clk),
        .probe_out0 (loopback_mode),  // [2:0]
        .probe_out1 (rx_slide),       // [0:0]
        .probe_out2 (tx_err_inject),  // [31:0]
        .probe_out3 (vio_ber_clr),    // [0:0]  <-- 新增：清零
        .probe_in0  (vio_ber_result)  // [31:0] <-- 新增：BER结果
    );

    // =========================================================================
    // 3. GTH Transceiver Instantiation
    // =========================================================================

    wire o_tx_clk;
    wire o_rx_clk;
    (* MARK_DEBUG="true" *) wire [W-1:0] tx_data;
    (* MARK_DEBUG="true" *) wire [W-1:0] rx_data;
    (* MARK_DEBUG="true" *) wire  o_tx_rst_n, o_tx_done, o_tx_active;
    (* MARK_DEBUG="true" *) wire  o_rx_rst_n, o_rx_done, o_rx_active, o_cdr_stable;

    gth_raw_top #(.W(W)) u_gth_raw_top (
        .freerun_clk        (freerun_clk),
        .gth_reset_all      (gth_reset_all),
        .mgtrefclk0_x1y1_p  (mgtrefclk0_x1y1_p),
        .mgtrefclk0_x1y1_n  (mgtrefclk0_x1y1_n),
        .gthrxp_in          (gthrxp_in),
        .gthrxn_in          (gthrxn_in),
        .gthtxp_out         (gthtxp_out),
        .gthtxn_out         (gthtxn_out),
        .i_loopback         (loopback_mode),
        .o_pll_locked       (),
        .o_tx_clk           (o_tx_clk),
        .o_tx_rst_n         (o_tx_rst_n),
        .o_tx_done          (o_tx_done),
        .o_tx_active        (o_tx_active),
        .i_tx_data          (tx_data),
        .o_rx_clk           (o_rx_clk),
        .o_rx_rst_n         (o_rx_rst_n),
        .o_rx_done          (o_rx_done),
        .o_rx_active        (o_rx_active),
        .o_cdr_stable       (o_cdr_stable),
        .o_rx_data          (rx_data),
        .i_rx_slide         (rx_slide)
    );

    // =========================================================================
    // 4. PRBS Generator (TX)
    // =========================================================================
    wire [W-1:0] prbs_tx;
    assign tx_data = prbs_tx;

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (0),
        .INV_PATTERN (PRBS_INV),
        .POLY_LENGHT (PRBS_LEN),
        .POLY_TAP    (PRBS_TAP),
        .NBITS       (W)
    ) u_prbs_gen (
        .RST      (~o_tx_rst_n),
        .CLK      (o_tx_clk),
        .DATA_IN  (tx_err_inject),
        .EN       (o_tx_rst_n),
        .DATA_OUT (prbs_tx)
    );

    // =========================================================================
    // 5. PRBS Checker (RX)
    // =========================================================================
    wire [W-1:0] prbs_err_bits_vec;
    // 用于 ILA 观察是否有错（只要有一位错就是1）
    (* MARK_DEBUG="true" *) wire prbs_match_fail = |prbs_err_bits_vec;

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (1),
        .INV_PATTERN (PRBS_INV),
        .POLY_LENGHT (PRBS_LEN),
        .POLY_TAP    (PRBS_TAP),
        .NBITS       (W)
    ) u_prbs_chk (
        .RST      (~o_rx_rst_n),
        .CLK      (o_rx_clk),
        .DATA_IN  (rx_data),
        .EN       (o_rx_rst_n),
        .DATA_OUT (prbs_err_bits_vec)
    );

    // =========================================================================
    // 6. 工业级误码统计逻辑 (带 ILA Debug)
    // =========================================================================

    // Popcount 函数
    function integer popcount;
        input [W-1:0] v;
        integer k;
        begin
            popcount = 0;
            for (k = 0; k < W; k = k + 1)
                popcount = popcount + v[k];
        end
    endfunction

    // 跨时钟域处理 VIO 复位
    reg ber_clr_sync_r1, ber_clr_sync_r2;
    (* MARK_DEBUG="true" *) wire ber_clear_pulse = ber_clr_sync_r2;

    always @(posedge o_rx_clk) begin
        ber_clr_sync_r1 <= vio_ber_clr;
        ber_clr_sync_r2 <= ber_clr_sync_r1;
    end

    // --- 状态机参数与寄存器 ---
    localparam MASK_WAIT_CYCLES = 1024; 

    // 这些变量全部加上 MARK_DEBUG 以便调试状态机
    (* MARK_DEBUG="true" *) reg [31:0] good_cnt;
    (* MARK_DEBUG="true" *) reg        prbs_locked_internal;
    (* MARK_DEBUG="true" *) reg [15:0] mask_cnt;
    (* MARK_DEBUG="true" *) reg        ber_enable; // 统计使能：只有它为1时才计数

    // 64位计数器 (拆分成高低位观察，或者直接观察64位)
    (* MARK_DEBUG="true" *) reg [63:0] total_bits_cnt;
    (* MARK_DEBUG="true" *) reg [63:0] total_err_cnt;
    
    // 当前时钟周期的错误比特数 (0~32)
    (* MARK_DEBUG="true" *) wire [5:0] current_err_num; 
    assign current_err_num = popcount(prbs_err_bits_vec);

    always @(posedge o_rx_clk) begin
        // 全局复位 或者 物理层未就绪 (Rx Down) 时彻底复位
        if (!o_rx_rst_n || ber_clear_pulse || !o_rx_done) begin
            good_cnt             <= 32'd0;
            prbs_locked_internal <= 1'b0;
            mask_cnt             <= 16'd0;
            ber_enable           <= 1'b0;
            total_bits_cnt       <= 64'd0;
            total_err_cnt        <= 64'd0;
        end else begin
            
            // --- 状态 1: 如果还没锁定，致力于寻找锁定 ---
            if (!prbs_locked_internal) begin
                ber_enable <= 1'b0; // 未锁定时不统计
                
                if (prbs_match_fail) begin
                    good_cnt <= 32'd0; // 有错就重置计数
                end else begin
                    // 连续收到正确数据，good_cnt 累加
                    if (good_cnt == LOCK_THRESH) begin
                        prbs_locked_internal <= 1'b1; // 终于锁定了！
                        good_cnt <= 32'd0;
                    end else begin
                        good_cnt <= good_cnt + 1;
                    end
                end
            end 
            
            else begin                
                // Mask 等待 (等待刚刚锁定后的不稳定期过去)
                if (mask_cnt < MASK_WAIT_CYCLES) begin
                    mask_cnt <= mask_cnt + 1'b1;
                end else begin
                    ber_enable <= 1'b1; // Mask 结束，开始统计
                end

                // 累加统计 (仅在 ber_enable 有效时)
                if (ber_enable) begin
                    total_bits_cnt <= total_bits_cnt + W;
                    // 无论有没有错，都继续跑，有错就加到 err_cnt 里
                    if (prbs_match_fail) begin
                        total_err_cnt <= total_err_cnt + current_err_num;
                    end
                end
            end
        end
    end

    // =========================================================================
    // 7. 硬件除法器 (Div Gen) - Blocking 模式
    // =========================================================================
    
    // 准备数据
    wire [63:0] axis_dividend_tdata = total_err_cnt;
    wire [63:0] axis_divisor_tdata  = (total_bits_cnt == 0) ? 64'd1 : total_bits_cnt;
    
    (* MARK_DEBUG="true" *) wire        m_axis_dout_tvalid;
    (* MARK_DEBUG="true" *) wire [95:0] m_axis_dout_tdata; // [95:32]整数, [31:0]小数
    wire [0:0]  m_axis_dout_tuser; // Dummy

    (* MARK_DEBUG="true" *) wire s_axis_divisor_tready;
    (* MARK_DEBUG="true" *) wire s_axis_dividend_tready;

    div_gen_0 u_ber_div (
        .aclk                   (o_rx_clk),
        .aresetn                (~ber_clear_pulse), // 复位

        // Divisor Channel (除数)
        .s_axis_divisor_tvalid  (ber_enable),       // 使能时持续请求
        .s_axis_divisor_tready  (s_axis_divisor_tready),
        .s_axis_divisor_tdata   (axis_divisor_tdata),

        // Dividend Channel (被除数)
        .s_axis_dividend_tvalid (ber_enable),
        .s_axis_dividend_tready (s_axis_dividend_tready),
        .s_axis_dividend_tdata  (axis_dividend_tdata),

        // Output Channel (结果)
        .m_axis_dout_tvalid     (m_axis_dout_tvalid),
        .m_axis_dout_tuser      (m_axis_dout_tuser),
        .m_axis_dout_tdata      (m_axis_dout_tdata)
    );

    // =========================================================================
    // 8. 结果锁存与输出
    // =========================================================================
    // 只需要小数部分 [31:0] 给 VIO 显示
    (* MARK_DEBUG="true" *) reg [31:0] ber_fractional_reg;

    always @(posedge o_rx_clk) begin
        if (m_axis_dout_tvalid) begin
            ber_fractional_reg <= m_axis_dout_tdata[31:0];
        end
    end

    assign vio_ber_result = ber_fractional_reg;

endmodule