`timescale 1ps/1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Module Name: gth_prbs8b10b_test
// Description:
//   使用 GTH Wizard 示例激励/校验模块测试 gth_top。
//   - 激励器 (Stimulus) -> gth_top (TX)
//   - gth_top (RX) -> 校验器 (Checker)
//   - gth_top 被配置为 8b/10b 模式，开启 COMMA 对齐，并使用内部 PMA 环回。
//
//////////////////////////////////////////////////////////////////////////////////

module gth_prbs8b10b_test(
    input  wire        sys_clk_p,
    input  wire        sys_clk_n,
    input  wire        sys_rst_n,

    output wire [1:0]  tx_disable,

    input  wire        mgtrefclk0_x1y1_p,
    input  wire        mgtrefclk0_x1y1_n,

    // 串行物理 (在 PMA 环回模式下不使用)
    input  wire        gthrxp_in,
    input  wire        gthrxn_in,
    output wire        gthtxp_out,
    output wire        gthtxn_out
);

    // ========= 时钟 / 复位 =========
    wire freerun_clk;
    wire pll_locked;

    // 统一的总复位（低有效输入转为高有效内部）
    wire gtwiz_reset_all;
    assign gtwiz_reset_all = !sys_rst_n || !pll_locked;

    // SFP/光模块禁用脚：常开
    assign tx_disable = 2'b00;

    // ========= GTH 时钟/状态 =========
    (* MARK_DEBUG="true" *) wire gtwiz_userclk_tx_active_out;
    (* MARK_DEBUG="true" *) wire gtwiz_userclk_rx_active_out;
                             wire gtwiz_userclk_tx_usrclk2_out;
                             wire gtwiz_userclk_rx_usrclk2_out;

    // ========= 激励器 -> GTH =========
    (* MARK_DEBUG="true" *)  wire [31:0]  stim_txdata_out;
                             wire [15:0]  stim_txctrl0_out;
                             wire [15:0]  stim_txctrl1_out;
    (* MARK_DEBUG="true" *)  wire [ 7:0]  stim_txctrl2_out;

    // ========= GTH -> 校验器 =========
    (* MARK_DEBUG="true" *)  wire [31:0]  gth_rxdata_out;
    (* MARK_DEBUG="true" *)  wire [15:0]  gth_rxctrl0_out; // 包含 rxdisperr
    (* MARK_DEBUG="true" *)  wire [15:0]  gth_rxctrl1_out; // 包含 rxnotintable
                             wire [ 7:0]  gth_rxctrl2_out;
                             wire [ 7:0]  gth_rxctrl3_out;

    wire         gth_rxbyteisaligned_mon;
    (* MARK_DEBUG="true" *)  wire         prbs_match;

    clk_wiz_0 u_clk_wiz (
        .clk_out1   (freerun_clk),     // 驱动 GTH 复位逻辑和 DRP
        .reset      (!sys_rst_n),
        .locked     (pll_locked),
        .clk_in1_p  (sys_clk_p),
        .clk_in1_n  (sys_clk_n)
    );

    gth_top gth_top (
        .freerun_clk                    (freerun_clk),
        .gtwiz_rst_in                   (gtwiz_reset_all),             // 统一使用 gtwiz_reset_all

        // TX/RX 用户数据
        .gtwiz_userdata_tx_in           (stim_txdata_out),
        .gtwiz_userdata_rx_out          (gth_rxdata_out),

        .gtwiz_userclk_tx_active_out    (gtwiz_userclk_tx_active_out),
        .gtwiz_userclk_rx_active_out    (gtwiz_userclk_rx_active_out),
        .gtwiz_userclk_tx_usrclk2_out   (gtwiz_userclk_tx_usrclk2_out),
        .gtwiz_userclk_rx_usrclk2_out   (gtwiz_userclk_rx_usrclk2_out),

        .txctrl0_in                     (stim_txctrl0_out),
        .txctrl1_in                     (stim_txctrl1_out),
        .txctrl2_in                     (stim_txctrl2_out),

        .rxctrl0_out                    (gth_rxctrl0_out),
        .rxctrl1_out                    (gth_rxctrl1_out),
        .rxctrl2_out                    (gth_rxctrl2_out),
        .rxctrl3_out                    (gth_rxctrl3_out),

        .gth_rxbyteisaligned_mon        (gth_rxbyteisaligned_mon),

        .tx8b10ben_in                   (1'b1),
        .rx8b10ben_in                   (1'b1),
        .rxcommadeten_in                (1'b1),
        .rxmcommaalignen_in             (1'b1),
        .rxpcommaalignen_in             (1'b1),

        // 最小改动：保持常 0；如需长期稳态运行，可在后续加入 FSM 脉冲该信号
        .rxbufreset_in                  (1'b0),

        // 参考时钟
        .mgtrefclk0_x1y1_p              (mgtrefclk0_x1y1_p),
        .mgtrefclk0_x1y1_n              (mgtrefclk0_x1y1_n),

        // 物理端口 (环回模式下未使用)
        .gthrxp_in                      (gthrxp_in),
        .gthrxn_in                      (gthrxn_in),
        .gthtxp_out                     (gthtxp_out),
        .gthtxn_out                     (gthtxn_out)
    );

    gtwizard_ultrascale_1_example_stimulus_8b10b u_stimulus (
        .gtwiz_reset_all_in            (gtwiz_reset_all),               // 使用主复位
        .gtwiz_userclk_tx_usrclk2_in   (gtwiz_userclk_tx_usrclk2_out),  // GTH TX 时钟
        .gtwiz_userclk_tx_active_in    (gtwiz_userclk_tx_active_out),   // GTH TX 激活
        .txctrl0_out                   (stim_txctrl0_out),              // (应为 0)
        .txctrl1_out                   (stim_txctrl1_out),              // (应为 0)
        .txctrl2_out                   (stim_txctrl2_out),              // K 码 / D 码
        .txdata_out                    (stim_txdata_out)                // K 码 / PRBS 数据
    );

    gtwizard_ultrascale_1_example_checking_8b10b u_checker (
        .gtwiz_reset_all_in            (gtwiz_reset_all),               // 使用主复位
        .gtwiz_userclk_rx_usrclk2_in   (gtwiz_userclk_rx_usrclk2_out),  // GTH RX 时钟
        .gtwiz_userclk_rx_active_in    (gtwiz_userclk_rx_active_out),   // GTH RX 激活
        .rxctrl0_in                    (gth_rxctrl0_out),
        .rxctrl1_in                    (gth_rxctrl1_out),
        .rxctrl2_in                    (gth_rxctrl2_out),
        .rxctrl3_in                    (gth_rxctrl3_out),
        .rxdata_in                     (gth_rxdata_out),
        .rxbyteisaligned_in            (gth_rxbyteisaligned_mon),
        .prbs_match_out                (prbs_match)                     // 连接到 ILA
    );

endmodule

