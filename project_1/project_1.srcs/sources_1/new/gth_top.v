`timescale 1ns/1ps
module gth_top (
  input  wire        freerun_clk,

  // TX/RX 用户数据
  input  wire [31:0] gtwiz_userdata_tx_in,
  output wire [31:0] gtwiz_userdata_rx_out,

  // 导出 helper 生成的用户时钟与激活信号
  output wire        gtwiz_userclk_tx_active_out,
  output wire        gtwiz_userclk_rx_active_out,
  output wire        gtwiz_userclk_tx_usrclk2_out,
  output wire        gtwiz_userclk_rx_usrclk2_out,

  // 参考时钟（差分）
  input  wire        mgtrefclk0_x1y1_p,
  input  wire        mgtrefclk0_x1y1_n,

  // 串行物理
  input  wire        gthrxp_in,
  input  wire        gthrxn_in,
  output wire        gthtxp_out,
  output wire        gthtxn_out
);

  // 0) freerun BUFG
    wire freerun_clk_buf;
    BUFG u_bufg_freerun (.I(freerun_clk), .O(freerun_clk_buf));

    // 1) 参考时钟缓冲（按器件用 GTE4/GTE3）
    wire gtrefclk0;
    IBUFDS_GTE4 #(
      .REFCLK_EN_TX_PATH (1'b0),
      .REFCLK_HROW_CK_SEL(2'b00),
      .REFCLK_ICNTL_RX   (2'b00)
    ) u_ibufds_refclk (
      .I  (mgtrefclk0_x1y1_p),
      .IB (mgtrefclk0_x1y1_n),
      .CEB(1'b0),
      .O  (gtrefclk0),
      .ODIV2()
    );

  // 2) 上电复位（极简：计数释放）
    reg  rst_all = 1'b1;
    reg [7:0] rcnt = 8'd0;
    always @(posedge freerun_clk_buf) begin
      if (rcnt != 8'hFF) rcnt <= rcnt + 1'b1;
      if (rcnt == 8'd100) rst_all <= 1'b0;
    end

  // 3) 打包成 [0:0] 向量以匹配 IP
    wire [0:0] gtwiz_reset_clk_freerun_in = freerun_clk_buf;
    wire [0:0] gtwiz_reset_all_in         = rst_all;
    wire [0:0] drpclk_in                  = freerun_clk_buf;
    wire [0:0] gtrefclk0_in               = gtrefclk0;

    wire [0:0] gthrxp_vec = gthrxp_in;
    wire [0:0] gthrxn_vec = gthrxn_in;
    wire [0:0] gthtxp_vec;
    wire [0:0] gthtxn_vec;
    assign gthtxp_out = gthtxp_vec[0];
    assign gthtxn_out = gthtxn_vec[0];

    // 4) 8b/10b/对齐控制（示例：全开）
    wire [0:0] tx8b10ben_in       = 1'b1;
    wire [0:0] rx8b10ben_in       = 1'b1;
    wire [0:0] rxcommadeten_in    = 1'b1;
    wire [0:0] rxmcommaalignen_in = 1'b1;
    wire [0:0] rxpcommaalignen_in = 1'b1;
    wire [0:0] rxbufreset_in      = 1'b0;

  // 5) TX 控制（如果你要固定发送 K28.5，可把 txdata/ctrl 改成局部常量）
    wire [15:0] txctrl0_in = 16'h0000;
    wire [15:0] txctrl1_in = 16'h0000;
    wire [ 7:0] txctrl2_in = 8'b0000_0000; // 若最低字节要发 K28.5，则置 8'b0000_0001

    // 6) helper 的 userclk reset 依赖 PMA 就绪
    wire [0:0] txpmaresetdone_out, rxpmaresetdone_out;
    wire [0:0] gtwiz_userclk_tx_reset_in;
    wire [0:0] gtwiz_userclk_rx_reset_in;
    assign gtwiz_userclk_tx_reset_in[0] = ~txpmaresetdone_out[0];
    assign gtwiz_userclk_rx_reset_in[0] = ~rxpmaresetdone_out[0];

    // 7) 导出 usrclk2/active（IP 端口是向量，顶层是标量）
    wire [0:0] tx_usrclk2_v, rx_usrclk2_v, tx_active_v, rx_active_v;
    assign gtwiz_userclk_tx_usrclk2_out = tx_usrclk2_v[0];
    assign gtwiz_userclk_rx_usrclk2_out = rx_usrclk2_v[0];
    assign gtwiz_userclk_tx_active_out  = tx_active_v[0];
    assign gtwiz_userclk_rx_active_out  = rx_active_v[0];

  // 8) 其余状态（可选）
    wire [0:0] gtpowergood_out;
    wire [2:0] rxbufstatus_out;
    wire [0:0] rxbyteisaligned_out, rxbyterealign_out, rxcommadet_out;
    wire [1:0] rxclkcorcnt_out;
    wire [15:0] rxctrl0_out, rxctrl1_out;
    wire [7:0]  rxctrl2_out, rxctrl3_out;
    wire [0:0]  gtwiz_reset_tx_done_out, gtwiz_reset_rx_done_out;

  // 9) GT Wizard（In Core）例化
  gtwizard_ultrascale_1 u_gt (
      .gtwiz_userclk_tx_reset_in            (gtwiz_userclk_tx_reset_in),
      .gtwiz_userclk_tx_srcclk_out          (/* unconn */),
      .gtwiz_userclk_tx_usrclk_out          (/* unconn */),
      .gtwiz_userclk_tx_usrclk2_out         (tx_usrclk2_v),
      .gtwiz_userclk_tx_active_out          (tx_active_v),

      .gtwiz_userclk_rx_reset_in            (gtwiz_userclk_rx_reset_in),
      .gtwiz_userclk_rx_srcclk_out          (/* unconn */),
      .gtwiz_userclk_rx_usrclk_out          (/* unconn */),
      .gtwiz_userclk_rx_usrclk2_out         (rx_usrclk2_v),
      .gtwiz_userclk_rx_active_out          (rx_active_v),

      .gtwiz_reset_clk_freerun_in           (gtwiz_reset_clk_freerun_in),
      .gtwiz_reset_all_in                   (gtwiz_reset_all_in),
      .gtwiz_reset_tx_pll_and_datapath_in   (1'b0),
      .gtwiz_reset_tx_datapath_in           (1'b0),
      .gtwiz_reset_rx_pll_and_datapath_in   (1'b0),
      .gtwiz_reset_rx_datapath_in           (1'b0),

      .gtwiz_reset_rx_cdr_stable_out        (/* unconn */),
      .gtwiz_reset_tx_done_out              (gtwiz_reset_tx_done_out),
      .gtwiz_reset_rx_done_out              (gtwiz_reset_rx_done_out),

      .gtwiz_userdata_tx_in                 (gtwiz_userdata_tx_in),
      .gtwiz_userdata_rx_out                (gtwiz_userdata_rx_out),

      .drpclk_in                            (drpclk_in),

      .txdiffctrl_in                        (5'b10000 ),         // <-- 对应 847 mV
      .txprecursor_in                       (5'b00000 ),         // <-- 对应 0.00 dB
      .txpostcursor_in                      (5'b01010 ),         // <-- 对应 2.50 dB (请确保你的 u_gt 例化中有这个端口)
      .rxlpmen_in                           (1'b0     ),             // <-- 保持为 0 (DFE模式)

      .gthrxn_in                            (gthrxn_vec),
      .gthrxp_in                            (gthrxp_vec),
      .gthtxn_out                           (gthtxn_vec),
      .gthtxp_out                           (gthtxp_vec),

      .gtrefclk0_in                         (gtrefclk0_in),

      .rx8b10ben_in                         (rx8b10ben_in),
      .rxbufreset_in                        (rxbufreset_in),
      .rxcommadeten_in                      (rxcommadeten_in),
      .rxmcommaalignen_in                   (rxmcommaalignen_in),
      .rxpcommaalignen_in                   (rxpcommaalignen_in),

      .tx8b10ben_in                         (tx8b10ben_in),
      .txctrl0_in                           (txctrl0_in),
      .txctrl1_in                           (txctrl1_in),
      .txctrl2_in                           (txctrl2_in),

      .gtpowergood_out                      (gtpowergood_out),
      .rxbufstatus_out                      (rxbufstatus_out),
      .rxbyteisaligned_out                  (rxbyteisaligned_out),
      .rxbyterealign_out                    (rxbyterealign_out),
      .rxclkcorcnt_out                      (rxclkcorcnt_out),
      .rxcommadet_out                       (rxcommadet_out),
      .rxctrl0_out                          (rxctrl0_out),
      .rxctrl1_out                          (rxctrl1_out),
      .rxctrl2_out                          (rxctrl2_out),
      .rxctrl3_out                          (rxctrl3_out),
      .rxpmaresetdone_out                   (rxpmaresetdone_out),
      .txpmaresetdone_out                   (txpmaresetdone_out)
  );

endmodule
