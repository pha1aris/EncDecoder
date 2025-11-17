`timescale 1ns / 1ps

// 32bit RAW 模式 GTH 封装
module gth_raw_32b_phy
(
    // 自由运行时钟 & 复位
    input  wire        clk_freerun,   
    input  wire        rst_n,         

    // 参考时钟（已经是单端，外部用 IBUFDS_GTE4 转过来的）
    // input  wire        gtrefclk01,
    input  wire        mgtrefclk0_x1y1_p,
    input  wire        mgtrefclk0_x1y1_n,
    // 串行差分接口
    input  wire        gthrxp_in,
    input  wire        gthrxn_in,
    output wire        gthtxp_out,
    output wire        gthtxn_out,

    // 用户时钟（并行数据时钟域）
    input  wire        txusrclk,
    input  wire        txusrclk2,
    input  wire        rxusrclk,
    input  wire        rxusrclk2,

    // 用户并行 数据接口（RAW 32bit）
    input  wire [31:0] tx_data,
    input  wire        tx_data_valid, // 暂时只是用来选择 idle 还是有效数据

    output wire [31:0] rx_data,
    output wire        rx_data_valid,

    // 比特滑移控制（接你的 bit_aligner.o_rxslide）
    input  wire        rxslide,

    // 状态输出（给上层做 reset / 状态机）
    output wire        rx_cdr_stable,
    output wire        tx_reset_done,
    output wire        rx_reset_done,
    output wire        gtpowergood,

    // 方便外部 BUFG 使用的原始 outclk（可选）
    output wire        txoutclk,
    output wire        rxoutclk
);
    // 0) freerun BUFG
    wire freerun_clk_buf;
    BUFG u_bufg_freerun (.I(clk_freerun), .O(freerun_clk_buf));


    wire gtrefclk01;
    IBUFDS_GTE4 #(
      .REFCLK_EN_TX_PATH (1'b0),
      .REFCLK_HROW_CK_SEL(2'b00),
      .REFCLK_ICNTL_RX   (2'b00)
    ) u_ibufds_refclk (
      .I  (mgtrefclk0_x1y1_p),
      .IB (mgtrefclk0_x1y1_n),
      .CEB(1'b0),
      .O  (gtrefclk01),
      .ODIV2()
    );

    // gtwiz_* reset/clock/userclk 相关是 [0:0] 宽度
    wire [0:0] gtwiz_userclk_tx_active_in;
    wire [0:0] gtwiz_userclk_rx_active_in;

    wire [0:0] gtwiz_reset_clk_freerun_in;
    wire [0:0] gtwiz_reset_all_in;
    wire [0:0] gtwiz_reset_tx_pll_and_datapath_in;
    wire [0:0] gtwiz_reset_tx_datapath_in;
    wire [0:0] gtwiz_reset_rx_pll_and_datapath_in;
    wire [0:0] gtwiz_reset_rx_datapath_in;

    wire [0:0] gtwiz_reset_rx_cdr_stable_out;
    wire [0:0] gtwiz_reset_tx_done_out;
    wire [0:0] gtwiz_reset_rx_done_out;

    wire [31:0] gtwiz_userdata_tx_in;
    wire [31:0] gtwiz_userdata_rx_out;

    wire [0:0] gtrefclk01_in;
    wire [0:0] qpll1outclk_out;
    wire [0:0] qpll1outrefclk_out;

    wire [0:0] gthrxp_in_bus;
    wire [0:0] gthrxn_in_bus;
    wire [0:0] gthtxp_out_bus;
    wire [0:0] gthtxn_out_bus;

    wire [2:0] loopback_in;
    wire [0:0] rxcdrhold_in;
    wire [0:0] rxlpmen_in;
    wire [0:0] rxslide_in;
    wire [0:0] rxusrclk_in;
    wire [0:0] rxusrclk2_in;
    wire [4:0] txdiffctrl_in;
    wire [4:0] txpostcursor_in;
    wire [4:0] txprecursor_in;
    wire [0:0] txusrclk_in;
    wire [0:0] txusrclk2_in;

    wire [0:0] gtpowergood_out;
    wire [0:0] rxoutclk_out;
    wire [0:0] rxpmaresetdone_out;
    wire [0:0] txoutclk_out;
    wire [0:0] txpmaresetdone_out;

    // --------------------------------------------------------------------
    // 信号连接 / tie-off
    // --------------------------------------------------------------------

    // userclk active：假设外部已经保证 txusrclk/rxusrclk 稳定，这里直接用 ~rst_n 置 1
    assign gtwiz_userclk_tx_active_in = rst_n;  // 1'b1 也可以
    assign gtwiz_userclk_rx_active_in = rst_n;

    // reset freerun clock & 全局 reset
    assign gtwiz_reset_clk_freerun_in = clk_freerun;   // 注意：这是时钟，不是 reset
    assign gtwiz_reset_all_in         = ~rst_n;        // gtwiz 接口一般是高有效 reset

    // 细分复位不用时可拉低，统一用 reset_all
    assign gtwiz_reset_tx_pll_and_datapath_in = 1'b0;
    assign gtwiz_reset_tx_datapath_in         = 1'b0;
    assign gtwiz_reset_rx_pll_and_datapath_in = 1'b0;
    assign gtwiz_reset_rx_datapath_in         = 1'b0;

    // refclk
    assign gtrefclk01_in = gtrefclk01;

    // 串行 IO 封装成 [0:0] bus
    assign gthrxp_in_bus = gthrxp_in;
    assign gthrxn_in_bus = gthrxn_in;
    assign gthtxp_out    = gthtxp_out_bus;
    assign gthtxn_out    = gthtxn_out_bus;

    // loopback / CDR hold / LPM 等：先给合理默认值
    assign loopback_in  = 3'b000;  // normal mode
    assign rxcdrhold_in = 1'b0;    // 不 hold CDR
    assign rxlpmen_in   = 1'b1;    // 低功耗均衡打开（看你向导怎么配置的）

    // RXSLIDE：外部输入 -> [0:0]
    assign rxslide_in   = rxslide;

    // 用户时钟域
    assign rxusrclk_in  = rxusrclk;
    assign rxusrclk2_in = rxusrclk2;
    assign txusrclk_in  = txusrclk;
    assign txusrclk2_in = txusrclk2;

    // TX 摆幅 & 前/后加重：可以根据板卡设计细调，这里先用一个常见默认值
    assign txdiffctrl_in   = 5'b01000; // 中等摆幅
    assign txpostcursor_in = 5'b00000; // 先关掉预/后加重
    assign txprecursor_in  = 5'b00000;

    // TX 用户数据：RAW 模式下每拍都要给数据
    // 如果 tx_data_valid=0，就发 0 或 IDLE pattern
    assign gtwiz_userdata_tx_in = tx_data_valid ? tx_data : 32'h0000_0000;

    // RX 用户数据直接引出
    assign rx_data       = gtwiz_userdata_rx_out;

    // 简单给一个 rx_data_valid：只要 RX reset done 且 powergood 就认为有效
    assign rx_data_valid = gtpowergood_out[0] & gtwiz_reset_rx_done_out[0];

    // 状态信号引出
    assign rx_cdr_stable = gtwiz_reset_rx_cdr_stable_out[0];
    assign tx_reset_done = gtwiz_reset_tx_done_out[0];
    assign rx_reset_done = gtwiz_reset_rx_done_out[0];
    assign gtpowergood   = gtpowergood_out[0];

    // outclk 引出
    assign txoutclk = txoutclk_out[0];
    assign rxoutclk = rxoutclk_out[0];

    // --------------------------------------------------------------------
    // 实例化 GTH Wizard IP
    // 名字用你生成 IP 时的名字替换：gtwizard_ultrascale_0
    // --------------------------------------------------------------------
    gtwizard_ultrascale_0 u_gtwizard_ultrascale_0 (
        .gtwiz_userclk_tx_active_in          (gtwiz_userclk_tx_active_in),          // input  [0:0]
        .gtwiz_userclk_rx_active_in          (gtwiz_userclk_rx_active_in),          // input  [0:0]
        .gtwiz_reset_clk_freerun_in          (gtwiz_reset_clk_freerun_in),          // input  [0:0]
        .gtwiz_reset_all_in                  (gtwiz_reset_all_in),                  // input  [0:0]
        .gtwiz_reset_tx_pll_and_datapath_in  (gtwiz_reset_tx_pll_and_datapath_in),  // input  [0:0]
        .gtwiz_reset_tx_datapath_in          (gtwiz_reset_tx_datapath_in),          // input  [0:0]
        .gtwiz_reset_rx_pll_and_datapath_in  (gtwiz_reset_rx_pll_and_datapath_in),  // input  [0:0]
        .gtwiz_reset_rx_datapath_in          (gtwiz_reset_rx_datapath_in),          // input  [0:0]
        .gtwiz_reset_rx_cdr_stable_out       (gtwiz_reset_rx_cdr_stable_out),       // output [0:0]
        .gtwiz_reset_tx_done_out             (gtwiz_reset_tx_done_out),             // output [0:0]
        .gtwiz_reset_rx_done_out             (gtwiz_reset_rx_done_out),             // output [0:0]

        .gtwiz_userdata_tx_in                (gtwiz_userdata_tx_in),                // input  [31:0]
        .gtwiz_userdata_rx_out               (gtwiz_userdata_rx_out),               // output [31:0]

        .gtrefclk01_in                       (gtrefclk01_in),                       // input  [0:0]
        .qpll1outclk_out                     (qpll1outclk_out),                     // output [0:0]
        .qpll1outrefclk_out                  (qpll1outrefclk_out),                  // output [0:0]

        .gthrxn_in                           (gthrxn_in_bus),                       // input  [0:0]
        .gthrxp_in                           (gthrxp_in_bus),                       // input  [0:0]
        .loopback_in                         (loopback_in),                         // input  [2:0]
        .rxcdrhold_in                        (rxcdrhold_in),                        // input  [0:0]
        .rxlpmen_in                          (rxlpmen_in),                          // input  [0:0]
        .rxslide_in                          (rxslide_in),                          // input  [0:0]
        .rxusrclk_in                         (rxusrclk_in),                         // input  [0:0]
        .rxusrclk2_in                        (rxusrclk2_in),                        // input  [0:0]

        .txdiffctrl_in                       (txdiffctrl_in),                       // input  [4:0]
        .txpostcursor_in                     (txpostcursor_in),                     // input  [4:0]
        .txprecursor_in                      (txprecursor_in),                      // input  [4:0]
        .txusrclk_in                         (txusrclk_in),                         // input  [0:0]
        .txusrclk2_in                        (txusrclk2_in),                        // input  [0:0]

        .gthtxn_out                          (gthtxn_out_bus),                      // output [0:0]
        .gthtxp_out                          (gthtxp_out_bus),                      // output [0:0]
        .gtpowergood_out                     (gtpowergood_out),                     // output [0:0]

        .rxoutclk_out                        (rxoutclk_out),                        // output [0:0]
        .rxpmaresetdone_out                  (rxpmaresetdone_out),                  // output [0:0]
        .txoutclk_out                        (txoutclk_out),                        // output [0:0]
        .txpmaresetdone_out                  (txpmaresetdone_out)                   // output [0:0]
    );

endmodule
