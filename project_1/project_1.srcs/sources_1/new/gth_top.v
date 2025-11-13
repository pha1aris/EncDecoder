`timescale 1ns/1ps

module gth_top (
    input  wire        freerun_clk,
    input wire         gtwiz_rst_in,

    output wire        gth_rxbyteisaligned_mon,

    // TX/RX 用户数据
    input  wire [31:0] gtwiz_userdata_tx_in,
    output wire [31:0] gtwiz_userdata_rx_out,
    output wire        gtwiz_userclk_tx_active_out,
    output wire        gtwiz_userclk_rx_active_out,
    output wire        gtwiz_userclk_tx_usrclk2_out,
    output wire        gtwiz_userclk_rx_usrclk2_out,
   // 8b10b控制端口

    input   wire [15 : 0] txctrl0_in,
    input   wire [15 : 0] txctrl1_in,
    input   wire [7 : 0] txctrl2_in,

    output wire [15:0] rxctrl0_out, 
    output wire [15:0] rxctrl1_out, 
    output wire [7:0]  rxctrl2_out, 
    output wire [7:0]  rxctrl3_out,

    input wire [0:0]   tx8b10ben_in,
    input wire [0:0]   rx8b10ben_in,
    input wire [0:0]   rxcommadeten_in ,
    input wire [0:0]   rxmcommaalignen_in,
    input wire [0:0]   rxpcommaalignen_in,
    input wire [0:0]   rxbufreset_in,

    // 参考时钟
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


  //  打包成 [0:0] 向量以匹配 IP
    wire [0:0] gtwiz_reset_clk_freerun_in = freerun_clk_buf;
    wire [0:0] gtwiz_reset_all_in         = gtwiz_rst_in;
    wire [0:0] drpclk_in                  = freerun_clk_buf;
    wire [0:0] gtrefclk0_in               = gtrefclk0;

    wire [0:0] gthrxp_vec = gthrxp_in;
    wire [0:0] gthrxn_vec = gthrxn_in;
    wire [0:0] gthtxp_vec;
    wire [0:0] gthtxn_vec;
    assign gthtxp_out = gthtxp_vec[0];
    assign gthtxn_out = gthtxn_vec[0];

    // 8b/10b/对齐控制
    // RX 弹性缓冲(Buffer)复位

    //  helper 的 userclk reset 依赖 PMA 就绪
    wire [0:0] txpmaresetdone_out, rxpmaresetdone_out;
    wire [0:0] gtwiz_userclk_tx_reset_in;
    wire [0:0] gtwiz_userclk_rx_reset_in;
    assign   gtwiz_userclk_tx_reset_in[0] = ~txpmaresetdone_out[0];
    assign   gtwiz_userclk_rx_reset_in[0] = ~rxpmaresetdone_out[0];

    //  导出 usrclk2/active
    wire [0:0] tx_usrclk2_v, rx_usrclk2_v, tx_active_v, rx_active_v;
    assign gtwiz_userclk_tx_usrclk2_out = tx_usrclk2_v[0];
    assign gtwiz_userclk_rx_usrclk2_out = rx_usrclk2_v[0];
    assign gtwiz_userclk_tx_active_out  = tx_active_v[0];
    assign gtwiz_userclk_rx_active_out  = rx_active_v[0];

  // 其余状态
    (* MARK_DEBUG="true" *)wire [0:0]  gtpowergood_out;
    (* MARK_DEBUG="true" *)wire [2:0]  rxbufstatus_out;
    (* MARK_DEBUG="true" *)wire [0:0]  rxbyteisaligned_out;
    (* MARK_DEBUG="true" *)wire        rxbyterealign_out;
    (* MARK_DEBUG="true" *)wire        rxcommadet_out;
    (* MARK_DEBUG="true" *)wire [1:0]  rxclkcorcnt_out;
    (* MARK_DEBUG="true" *)wire [0:0]  gtwiz_reset_tx_done_out;
    (* MARK_DEBUG="true" *)wire        gtwiz_reset_rx_done_out;
    (* MARK_DEBUG="true" *)wire        rx_cdr_stable;

    wire        rxlpmen_in;
    wire [2:0]  loopback;

   vio_0   vio_0 (
    .clk            (freerun_clk),                  // input wire clk
    .probe_in0      (gtpowergood_out),              // input wire [0 : 0] probe_in0
    .probe_in1      (rxbufstatus_out),              // input wire [2 : 0] probe_in1
    .probe_in2      (rxbyteisaligned_out),          // input wire [0 : 0] probe_in2
    .probe_in3      (rxbyterealign_out),            // input wire [0 : 0] probe_in3
    .probe_in4      (rxcommadet_out),               // input wire [0 : 0] probe_in4
    .probe_in5      (gtwiz_reset_tx_done_out),      // input wire [0 : 0] probe_in5
    .probe_in6      (gtwiz_reset_rx_done_out),      // input wire [0 : 0] probe_in6
    .probe_in7      (gtwiz_userclk_tx_active_out),    // input wire [0 : 0] probe_in7
    .probe_in8      (gtwiz_userclk_rx_active_out),    // input wire [0 : 0] probe_in8
    .probe_in9      (rxpmaresetdone_out),            // input wire [0 : 0] probe_in9
    .probe_out0     (rxlpmen_in),  // output wire [0 : 0] probe_out0
    .probe_out1     (loopback)  // output wire [2 : 0] probe_out1
  );   

assign gth_rxbyteisaligned_mon = rxbyteisaligned_out[0];
    // wire rxprbslocked_out;
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

      .gtwiz_reset_rx_cdr_stable_out        (rx_cdr_stable),
      .gtwiz_reset_tx_done_out              (gtwiz_reset_tx_done_out),
      .gtwiz_reset_rx_done_out              (gtwiz_reset_rx_done_out),

      .gtwiz_userdata_tx_in                 (gtwiz_userdata_tx_in),
      .gtwiz_userdata_rx_out                (gtwiz_userdata_rx_out),

      .drpclk_in                            (drpclk_in),
      //链路均衡部分 alinx 例中设置
      .txdiffctrl_in                        (5'b11000   ),         
      .txprecursor_in                       (5'b01110   ),         
      .txpostcursor_in                      (5'b00111   ),         
      .rxlpmen_in                           (rxlpmen_in ),         

      .gthrxn_in                            (gthrxn_vec),
      .gthrxp_in                            (gthrxp_vec),
      .gthtxn_out                           (gthtxn_vec),
      .gthtxp_out                           (gthtxp_vec),

      .gtrefclk0_in                         (gtrefclk0_in),
      //8b10b 部分
      .rx8b10ben_in                         (rx8b10ben_in),
      .rxbufreset_in                        (rxbufreset_in),
      .rxcommadeten_in                      (rxcommadeten_in),
      .rxmcommaalignen_in                   (rxmcommaalignen_in),
      .rxpcommaalignen_in                   (rxpcommaalignen_in),

      .tx8b10ben_in                         (tx8b10ben_in),
      .txctrl0_in                           (txctrl0_in),          //8b10b(RD) 强制视差  
      .txctrl1_in                           (txctrl1_in),          //8b10b(RD) 视差错误 / 视差设置 
      .txctrl2_in                           (txctrl2_in),           

      .rxctrl0_out                          (rxctrl0_out),    // 接收到的视差
      .rxctrl1_out                          (rxctrl1_out),    // 接收到的视差
      .rxctrl2_out                          (rxctrl2_out),    // charisk 每位对应一个字节 当前仅低4位使用
      .rxctrl3_out                          (rxctrl3_out),    // 接收到的8b/10b错误

      .loopback_in                          (loopback ), 

      .gtpowergood_out                      (gtpowergood_out),
      .rxbufstatus_out                      (rxbufstatus_out),
      .rxbyteisaligned_out                  (rxbyteisaligned_out),
      .rxbyterealign_out                    (rxbyterealign_out),
      .rxclkcorcnt_out                      (rxclkcorcnt_out),
      .rxcommadet_out                       (rxcommadet_out),
      .rxpmaresetdone_out                   (rxpmaresetdone_out),
      .txpmaresetdone_out                   (txpmaresetdone_out)
  );

endmodule
