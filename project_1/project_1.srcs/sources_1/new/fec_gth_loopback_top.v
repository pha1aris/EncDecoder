`timescale 1ns / 1ps

module fec_gth_loopback_top #(
    parameter integer W                = 32,
    parameter integer PAYLOAD_WORDS    = 16,
    parameter integer RS_K             = 229,
    parameter integer RS_N             = 255,
    parameter integer INTLV_D          = 64,
    parameter integer INTLV_N          = 255,
    parameter integer FRAMES_PER_BLOCK = 255
)(
    input  wire        sys_clk_p,
    input  wire        sys_clk_n,
    input  wire        sys_rst_n,        // 低有效，板上按键/复位

    input  wire        mgtrefclk0_x1y1_p,
    input  wire        mgtrefclk0_x1y1_n,

    input  wire        gthrxp_in,
    input  wire        gthrxn_in,
    output wire        gthtxp_out,
    output wire        gthtxn_out,

    output wire [1:0]  tx_disable

);

    //======================================================================
    // 1. 时钟 & 逻辑复位（来自 clk_wiz_sys）
    //======================================================================
    wire freerun_clk;   // clk_out1：15.625 MHz（给 GTH freerun）
    wire core_clk;      // clk_out2：100 MHz（FEC / RS / PRBS）
    wire axi_clk;       // clk_out3：100 MHz（未来 AXI 用）
    wire clk_locked;

    clk_wiz_sys u_clk_wiz (
        .clk_out1 (freerun_clk),  // 15.625 MHz
        .clk_out2 (core_clk),     // 100 MHz
        .clk_out3 (axi_clk),      // 100 MHz
        .reset    (~sys_rst_n),   // active-high
        .locked   (clk_locked),
        .clk_in1_p(sys_clk_p),
        .clk_in1_n(sys_clk_n)
    );

    // 逻辑复位
    wire logic_rst_n = sys_rst_n & clk_locked;
    wire logic_rst   = ~logic_rst_n;

    //======================================================================
    // 0. VIO 控制信号（清零 / 扰码开关 / GTH loopback）
    //======================================================================
    wire        ber_clr;        // 清零误码计数 & BER
    wire        scrambler_en;   // 扰码使能，TX/RX 共用
    wire [2:0]  loop_backmode;  // GTH loopback 模式

    vio_2 u_vio_ctrl (
        .clk        (core_clk),
        .probe_out0 (ber_clr),
        .probe_out1 (scrambler_en),
        .probe_out2 (loop_backmode)
    );

    //======================================================================
    // 2. GTH 顶层：gth_raw_top
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

    // GTH 全局复位：系统复位 或 clk_wiz 未锁定
    wire gth_reset_all = ~sys_rst_n | ~clk_locked;

    gth_raw_top #(
        .W (W)
    ) u_gth_raw (
        .freerun_clk        (freerun_clk),
        .gth_reset_all      (gth_reset_all),

        .tx_disable         (tx_disable),
        .mgtrefclk0_x1y1_p  (mgtrefclk0_x1y1_p),
        .mgtrefclk0_x1y1_n  (mgtrefclk0_x1y1_n),
        .gthrxp_in          (gthrxp_in),
        .gthrxn_in          (gthrxn_in),
        .gthtxp_out         (gthtxp_out),
        .gthtxn_out         (gthtxn_out),

        .i_loopback         (loop_backmode),   // ★ 用 VIO 控制 loopback
        .o_pll_locked       (),                // 已固定为 1，可不用

        .o_tx_clk           (tx_usr_clk),      // TX line_clk
        .o_tx_rst_n         (tx_rst_n),
        .o_tx_done          (tx_done),
        .o_tx_active        (tx_active),
        .i_tx_data          (tx_data_to_gth),

        .o_rx_clk           (rx_usr_clk),      // RX line_clk
        .o_rx_rst_n         (rx_rst_n),
        .o_rx_done          (rx_done),
        .o_rx_active        (rx_active),
        .o_cdr_stable       (cdr_stable),
        .o_rx_data          (rx_data_from_gth),
        .i_rx_slide         (rx_slide_req)
    );

    // 如果外面有 LED：
    // assign led_rx_active = rx_active;

    //======================================================================
    // 3. TX 端：PRBS7 → FEC_TX → GTH
    //======================================================================
    (* MARK_DEBUG="true" *) wire [7:0]  prbs_tx_data;
    (* MARK_DEBUG="true" *) wire        prbs_tx_ready;

    (* MARK_DEBUG="true" *) wire [W-1:0] fec_tx_data_line;
    (* MARK_DEBUG="true" *) wire         fec_tx_valid_line;
    (* MARK_DEBUG="true" *) wire [15:0]  tx_frame_index;

    // PRBS7 发生器在 tx_usr_clk 域
    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (0),  // 0 = 生成模式
        .INV_PATTERN (0),
        .POLY_LENGHT (7),
        .POLY_TAP    (6),
        .NBITS       (8)
    ) u_prbs_gen_tx (
        .RST      (~tx_rst_n),      // 对 TX 用户时钟域复位
        .CLK      (tx_usr_clk),
        .DATA_IN  (8'd0),
        .EN       (prbs_tx_ready),  // 由 FEC 流控
        .DATA_OUT (prbs_tx_data)
    );

    // FEC 发送链路
    fec_tx #(
        .W                (W),
        .PAYLOAD_WORDS    (PAYLOAD_WORDS),
        .RS_K             (RS_K),
        .RS_N             (RS_N),
        .INTLV_D          (INTLV_D),
        .INTLV_N          (INTLV_N),
        .FRAMES_PER_BLOCK (FRAMES_PER_BLOCK)
    ) u_fec_tx (
        .line_clk         (tx_usr_clk),     // line_clk = GTH TX usr_clk
        .core_clk         (core_clk),       // core_clk = clk_wiz_sys.clk_out2
        .rst_n            (logic_rst_n),

        .scrambler_en     (scrambler_en),   // ★ VIO 控制

        .i_data           (prbs_tx_data),
        .i_valid          (1'b1),           // 始终有数据，由 ready 控制速率
        .i_ready          (prbs_tx_ready),

        .o_tx_data        (),               // core_clk 域帧数据，可接 ILA 调试
        .o_tx_valid       (),
        .o_tx_data_line   (fec_tx_data_line),  // tx_usr_clk 域，含空闲填充
        .o_tx_valid_line  (fec_tx_valid_line),
        .o_tx_frame_index (tx_frame_index)
    );

    assign tx_data_to_gth = fec_tx_data_line;

    //======================================================================
    // 4. RX 端：GTH → FEC_RX → PRBS 检查
    //======================================================================
    (* MARK_DEBUG="true" *) wire [7:0]  fec_rx_data;
    (* MARK_DEBUG="true" *) wire        fec_rx_valid;
    (* MARK_DEBUG="true" *) wire        bit_locked;
    wire [15:0] rx_frame_index;
    wire [15:0] rx_block_id;
    wire [15:0] rx_frame_in_block;

    fec_rx #(
        .W             (W),
        .PAYLOAD_WORDS (PAYLOAD_WORDS),
        .RS_N          (RS_N),
        .INTLV_D       (INTLV_D),
        .INTLV_N       (INTLV_N)
    ) u_fec_rx (
        .line_clk         (rx_usr_clk),      // line_clk = GTH RX usr_clk
        .core_clk         (core_clk),        // core_clk = clk_wiz_sys.clk_out2
        .rst_n            (logic_rst_n),

        .i_rx_data        (rx_data_from_gth),
        .i_rx_valid       (1'b1),            // GTH 每拍都有 32bit

        .rx_reset_done    (rx_active),       // GTH init done → 给 bit_aligner
        .rx_cdr_stable    (cdr_stable),

        .scrambler_en     (scrambler_en),    // ★ 与 TX 一致

        .o_data           (fec_rx_data),
        .o_valid          (fec_rx_valid),
        .i_data_ready     (1'b1),

        .o_rxslide        (rx_slide_req),
        .o_bit_locked     (bit_locked),
        .o_frame_index    (rx_frame_index),
        .o_block_id       (rx_block_id),
        .o_frame_in_block (rx_frame_in_block)
    );

    // 如果外面有 LED：
    // assign led_bit_locked = bit_locked;

    //======================================================================
    // 5. PRBS 检查 + 误码统计（core_clk 域）
    //======================================================================
    wire [7:0] prbs_err_vec;

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (1),   // 1 = 检查模式
        .INV_PATTERN (0),
        .POLY_LENGHT (7),
        .POLY_TAP    (6),
        .NBITS       (8)
    ) u_prbs_chk_rx (
        .RST      (logic_rst),
        .CLK      (core_clk),
        .DATA_IN  (fec_rx_data),
        .EN       (fec_rx_valid),
        .DATA_OUT (prbs_err_vec)
    );

    reg  [3:0] mask_cnt;
    (* MARK_DEBUG="true" *) reg        prbs_lock_reg;
    (* MARK_DEBUG="true" *) reg        err_detect_reg;

    (* MARK_DEBUG="true" *) reg [63:0] prbs_err_bits;
    (* MARK_DEBUG="true" *) reg [63:0] prbs_rx_bits;

    wire [3:0] current_err_bits_cnt;
    assign current_err_bits_cnt =
          prbs_err_vec[0] + prbs_err_vec[1] +
          prbs_err_vec[2] + prbs_err_vec[3] +
          prbs_err_vec[4] + prbs_err_vec[5] +
          prbs_err_vec[6] + prbs_err_vec[7];

    // 清零条件：全局复位 + VIO 清零
    wire do_clear = logic_rst | ber_clr;

    always @(posedge core_clk or posedge do_clear) begin
        if (do_clear) begin
            mask_cnt       <= 4'd0;
            prbs_lock_reg  <= 1'b0;
            err_detect_reg <= 1'b0;
            prbs_err_bits  <= 64'd0;
            prbs_rx_bits   <= 64'd0;
        end else begin
            err_detect_reg <= 1'b0;

            if (fec_rx_valid) begin
                if (mask_cnt < 4) begin
                    mask_cnt <= mask_cnt + 1'b1;
                end else begin
                    prbs_rx_bits <= prbs_rx_bits + 64'd8;

                    if (|prbs_err_vec) begin
                        err_detect_reg <= 1'b1;
                        prbs_err_bits  <= prbs_err_bits + current_err_bits_cnt;
                    end else begin
                        prbs_lock_reg <= 1'b1;
                    end
                end
            end
        end
    end

    // 如果外面有 LED：
    // assign led_prbs_locked = prbs_lock_reg;
    // assign led_error       = err_detect_reg;

    //======================================================================
    // 6. BER 计算：div_gen_0（64b÷64b → Q0.32 fractional）
    //======================================================================
    wire [63:0] ber_dividend = prbs_err_bits;
    wire [63:0] ber_divisor  = (prbs_rx_bits == 64'd0) ? 64'd1 : prbs_rx_bits;

    wire ber_div_aresetn = ~do_clear;

    wire        s_axis_divisor_tready;
    wire        s_axis_dividend_tready;
    wire        m_axis_dout_tvalid;
    wire  [0:0] m_axis_dout_tuser;
    wire [95:0] m_axis_dout_tdata;

    div_gen_0 u_ber_calc (
        .aclk                    (core_clk),
        .aresetn                 (ber_div_aresetn),

        .s_axis_divisor_tvalid   (1'b1),
        .s_axis_divisor_tready   (s_axis_divisor_tready),
        .s_axis_divisor_tdata    (ber_divisor),

        .s_axis_dividend_tvalid  (1'b1),
        .s_axis_dividend_tready  (s_axis_dividend_tready),
        .s_axis_dividend_tdata   (ber_dividend),

        .m_axis_dout_tvalid      (m_axis_dout_tvalid),
        .m_axis_dout_tuser       (m_axis_dout_tuser),
        .m_axis_dout_tdata       (m_axis_dout_tdata)
    );

    (* MARK_DEBUG="true" *) reg [31:0] ber_q32;

    always @(posedge core_clk or posedge do_clear) begin
        if (do_clear)
            ber_q32 <= 32'd0;
        else if (m_axis_dout_tvalid)
            ber_q32 <= m_axis_dout_tdata[31:0];  // 低 32bit 为小数部分
    end

endmodule
