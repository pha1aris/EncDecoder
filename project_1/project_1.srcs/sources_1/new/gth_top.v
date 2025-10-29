`timescale 1ns/1ps
module gth_top(

input  wire gthrxp_in,
input  wire gthrxn_in,
output  wire gthtxp_out,
output  wire gthtxn_out,
  // GT输出
output wire txoutclk_out,
output wire rxoutclk_out

    );
  // =========================
  // 0) 全局参数/局部常量
  // =========================
  localparam LANES = 1;

  // =========================
  // 1) Freerun / 复位与DRP域
  // =========================
  wire                 freerun_clk;       // 50~125 MHz, 常用100/125
  wire [LANES-1:0]     gtwiz_reset_clk_freerun_in = {LANES{freerun_clk}};
  reg                  gtwiz_reset_all_in = 1'b1; // 上电拉高，稍后释放
  wire [LANES-1:0]     drpclk_in          = {LANES{freerun_clk}};

  // （可选）精细复位输入，默认拉低
  wire [LANES-1:0]     gtwiz_reset_tx_pll_and_datapath_in = {LANES{1'b0}};
  wire [LANES-1:0]     gtwiz_reset_tx_datapath_in         = {LANES{1'b0}};
  wire [LANES-1:0]     gtwiz_reset_rx_pll_and_datapath_in = {LANES{1'b0}};
  wire [LANES-1:0]     gtwiz_reset_rx_datapath_in         = {LANES{1'b0}};

  // =========================
  // 2) 参考时钟 / GT Refclk
  // =========================
  wire [LANES-1:0]     gtrefclk0_in;      // 由 IBUFDS_GTE# 提供

  // =========================
  // 3) 用户时钟（由GT输出产生并回灌）
  // =========================

  // BUFG_GT 后的用户时钟
  wire [LANES-1:0]     txusrclk_in;
  wire [LANES-1:0]     txusrclk2_in;
  wire [LANES-1:0]     rxusrclk_in;
  wire [LANES-1:0]     rxusrclk2_in;

  // 用户时钟激活/复位（用户域）
  wire [LANES-1:0]     gtwiz_userclk_tx_reset_in = {LANES{1'b0}};
  reg  [LANES-1:0]     gtwiz_userclk_tx_active_in = {LANES{1'b0}};
  reg  [LANES-1:0]     gtwiz_userclk_rx_active_in = {LANES{1'b0}};

  // =========================
  // 5) 编码/对齐/缓冲控制
  // =========================
  wire [LANES-1:0]     tx8b10ben_in       = {LANES{1'b1}}; // 若用8b/10b
  wire [LANES-1:0]     rx8b10ben_in       = {LANES{1'b1}};
  wire [LANES-1:0]     rxcommadeten_in    = {LANES{1'b1}}; // 用K28.5做对齐时置1
  wire [LANES-1:0]     rxmcommaalignen_in = {LANES{1'b1}};
  wire [LANES-1:0]     rxpcommaalignen_in = {LANES{1'b1}};
  wire [LANES-1:0]     rxbufreset_in      = {LANES{1'b0}};

  // =========================
  // 6) 发送数据/控制（TX域）
  // =========================
  wire [32*LANES-1:0]  gtwiz_userdata_tx_in;   // 例化时是32位/通道
  wire [16*LANES-1:0]  txctrl0_in = {16*LANES{1'b0}};
  wire [16*LANES-1:0]  txctrl1_in = {16*LANES{1'b0}};
  wire [ 8*LANES-1:0]  txctrl2_in;             // 每字节CHARISK(K字)

  // =========================
  // 7) 接收数据/状态（RX域 输出→内部连用）
  // =========================
  wire [32*LANES-1:0]  gtwiz_userdata_rx_out;
  wire [ 3*LANES-1:0]  rxbufstatus_out;
  wire [LANES-1:0]     rxbyteisaligned_out, rxbyterealign_out, rxcommadet_out;
  wire [ 2*LANES-1:0]  rxclkcorcnt_out;
  wire [16*LANES-1:0]  rxctrl0_out, rxctrl1_out;
  wire [ 8*LANES-1:0]  rxctrl2_out, rxctrl3_out;

  // =========================
  // 8) 复位/电源/完成指示（输出→内部连用）
  // =========================
  wire [LANES-1:0]     gtwiz_reset_rx_cdr_stable_out;
  wire [LANES-1:0]     gtwiz_reset_tx_done_out;
  wire [LANES-1:0]     gtwiz_reset_rx_done_out;
  wire [LANES-1:0]     gtpowergood_out;
  wire [LANES-1:0]     txpmaresetdone_out, rxpmaresetdone_out;

  // =========================
  // 9) 示例：生成用户时钟并置active
  // =========================
  // 单通道演示：BUFG_GT建议按通道各放一个
  BUFG_GT u_bufg_txusrclk  (.I(txoutclk_out[0]), .CE(1'b1), .CEMASK(1'b0), .CLR(1'b0), .CLRMASK(1'b0), .DIV(3'd0), .O(txusrclk_in [0]));
  BUFG_GT u_bufg_txusrclk2 (.I(txoutclk_out[0]), .CE(1'b1), .CEMASK(1'b0), .CLR(1'b0), .CLRMASK(1'b0), .DIV(3'd0), .O(txusrclk2_in[0]));
  BUFG_GT u_bufg_rxusrclk  (.I(rxoutclk_out[0]), .CE(1'b1), .CEMASK(1'b0), .CLR(1'b0), .CLRMASK(1'b0), .DIV(3'd0), .O(rxusrclk_in [0]));
  BUFG_GT u_bufg_rxusrclk2 (.I(rxoutclk_out[0]), .CE(1'b1), .CEMASK(1'b0), .CLR(1'b0), .CLRMASK(1'b0), .DIV(3'd0), .O(rxusrclk2_in[0]));

  // 时钟出来后在各自域里把 active 拉1（极简示例）
  always @(posedge txusrclk_in[0]) gtwiz_userclk_tx_active_in[0] <= 1'b1;
  always @(posedge rxusrclk_in[0]) gtwiz_userclk_rx_active_in[0] <= 1'b1;

  // 上电若干freerun周期释放总复位（极简上电时序）
  reg [7:0] rst_cnt = 8'd0;
  always @(posedge freerun_clk) begin
    if (rst_cnt != 8'hFF) rst_cnt <= rst_cnt + 1'b1;
    if (rst_cnt == 8'd100) gtwiz_reset_all_in <= 1'b0;
  end

  // =========================
  // 10) 示例：常量/测试数据装载
  // =========================
  assign gtwiz_userdata_tx_in = 32'hBC_55_AA_55; // 仅通道0示例
  // 使能最低字节K字符(0xBC=K28.5)，其余为数据
  assign txctrl2_in[7:0] = 8'b0000_0001;

  // =========================
  // 11) GT Wizard 例化（分组排版）
  // =========================
  gtwizard_ultrascale_1 u_gtwiz (
    // ---- 用户时钟控制（用户域）----
    .gtwiz_userclk_tx_reset_in            (gtwiz_userclk_tx_reset_in),
    .gtwiz_userclk_tx_active_in           (gtwiz_userclk_tx_active_in),
    .gtwiz_userclk_rx_active_in           (gtwiz_userclk_rx_active_in),

    // ---- Freerun/复位/DRP ----
    .gtwiz_reset_clk_freerun_in           (gtwiz_reset_clk_freerun_in),
    .drpclk_in                            (drpclk_in),
    .gtwiz_reset_all_in                   (gtwiz_reset_all_in),
    .gtwiz_reset_tx_pll_and_datapath_in   (gtwiz_reset_tx_pll_and_datapath_in),
    .gtwiz_reset_tx_datapath_in           (gtwiz_reset_tx_datapath_in),
    .gtwiz_reset_rx_pll_and_datapath_in   (gtwiz_reset_rx_pll_and_datapath_in),
    .gtwiz_reset_rx_datapath_in           (gtwiz_reset_rx_datapath_in),

    // ---- 复位/完成指示（输出）----
    .gtwiz_reset_rx_cdr_stable_out        (gtwiz_reset_rx_cdr_stable_out),
    .gtwiz_reset_tx_done_out              (gtwiz_reset_tx_done_out),
    .gtwiz_reset_rx_done_out              (gtwiz_reset_rx_done_out),

    // ---- 用户数据 ----
    .gtwiz_userdata_tx_in                 (gtwiz_userdata_tx_in),
    .gtwiz_userdata_rx_out                (gtwiz_userdata_rx_out),

    // ---- 参考时钟/用户时钟 ----
    .gtrefclk0_in                         (gtrefclk0_in),
    .txusrclk_in                          (txusrclk_in),
    .txusrclk2_in                         (txusrclk2_in),
    .rxusrclk_in                          (rxusrclk_in),
    .rxusrclk2_in                         (rxusrclk2_in),

    // ---- 串行物理 ----
    .gthrxp_in                            (gthrxp_in),
    .gthrxn_in                            (gthrxn_in),
    .gthtxp_out                           (gthtxp_out),
    .gthtxn_out                           (gthtxn_out),

    // ---- 编码/对齐/缓冲 ----
    .tx8b10ben_in                         (tx8b10ben_in),
    .rx8b10ben_in                         (rx8b10ben_in),
    .rxcommadeten_in                      (rxcommadeten_in),
    .rxmcommaalignen_in                   (rxmcommaalignen_in),
    .rxpcommaalignen_in                   (rxpcommaalignen_in),
    .rxbufreset_in                        (rxbufreset_in),

    // ---- TX控制 ----
    .txctrl0_in                           (txctrl0_in),
    .txctrl1_in                           (txctrl1_in),
    .txctrl2_in                           (txctrl2_in),

    // ---- 状态/调试（输出）----
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
    .rxoutclk_out                         (rxoutclk_out),
    .rxpmaresetdone_out                   (rxpmaresetdone_out),
    .txoutclk_out                         (txoutclk_out),
    .txpmaresetdone_out                   (txpmaresetdone_out)
  );

endmodule
