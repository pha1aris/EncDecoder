`timescale 1ps/1ps

module fso_prbs_hardware_top (
  // 1. 系统物理时钟与复位
  input  wire        sys_clk_p,
  input  wire        sys_clk_n,
  input  wire        sys_rst_n, 

  // 2. 光模块控制
  output wire [1:0]  tx_disable,

  // 3. GTH 参考时钟
  input  wire        mgtrefclk0_x1y1_p,
  input  wire        mgtrefclk0_x1y1_n,

  output wire        pl_led1,
  output wire        pl_led2,
  // 4. GTH 串行差分接口
  input  wire        gthrxp_in,
  input  wire        gthrxn_in,
  output wire        gthtxp_out,
  output wire        gthtxn_out
);

  // ===========================================================================
  // 0. 基础配置与时钟
  // ===========================================================================
  assign tx_disable = 2'b00; 
  wire [2:0] loopback_cfg = 3'b000; 

  // 生成自由运行时钟
  wire freerun_clk, pll_locked;
  clk_wiz_2 u_clk_wiz (
    .clk_out1 (freerun_clk),
    .reset    (~sys_rst_n), // 注意：这里如果是高电平复位IP，则取反正确
    .locked   (pll_locked),
    .clk_in1_p(sys_clk_p),
    .clk_in1_n(sys_clk_n)
  );

  // 全局复位生成（同步到 freerun_clk）
  // 目的：消除按键抖动，保证 GTH 复位信号干净
  wire gth_reset_in_raw = ~(sys_rst_n & pll_locked);
  wire gth_reset_in_sync;
  
  xpm_cdc_async_rst #(
    .DEST_SYNC_FF(4),    // 4级同步
    .RST_ACTIVE_HIGH(1)  // 输入高电平有效
  ) u_rst_sync_gth (
    .src_arst(gth_reset_in_raw),
    .dest_clk(freerun_clk),
    .dest_arst(gth_reset_in_sync) //产生gth总复位
  );

  // GTH 参考时钟缓冲
  wire gtrefclk0;
  IBUFDS_GTE4 #(
    .REFCLK_EN_TX_PATH (1'b0),
    .REFCLK_HROW_CK_SEL(2'b00),
    .REFCLK_ICNTL_RX   (2'b00)
  ) u_ibufds_refclk (
    .I(mgtrefclk0_x1y1_p), .IB(mgtrefclk0_x1y1_n), .CEB(1'b0), .O(gtrefclk0), .ODIV2()
  );

  // ===========================================================================
  // 1. GTH IP 核实例化
  // ===========================================================================
  wire [31:0] gth_tx_data;
  wire [31:0] gth_rx_data;
  wire        txusrclk2, rxusrclk2;
  wire [0:0]  txpmaresetdone, rxpmaresetdone;
  wire [0:0]  txoutclk_out, rxoutclk_out;
  wire [0:0]  gtwiz_reset_rx_cdr_stable_out;
  wire [0:0]  rxslide_in;

  BUFG_GT u_bufg_tx (.I(txoutclk_out), .CE(1'b1), .CEMASK(0), .CLR(0), .CLRMASK(0), .DIV(0), .O(txusrclk2));
  BUFG_GT u_bufg_rx (.I(rxoutclk_out), .CE(1'b1), .CEMASK(0), .CLR(0), .CLRMASK(0), .DIV(0), .O(rxusrclk2));

  gtwizard_ultrascale_0 u_gth (
    .gtwiz_reset_clk_freerun_in      (freerun_clk),
    .gtwiz_reset_all_in              (gth_reset_in_sync), // 使用同步后的复位
    .gtwiz_userclk_tx_active_in      (txpmaresetdone),    // UltraScale 常用做法：直接回环
    .gtwiz_userclk_rx_active_in      (rxpmaresetdone),
    .gtwiz_reset_rx_cdr_stable_out   (gtwiz_reset_rx_cdr_stable_out),
    .txpmaresetdone_out              (txpmaresetdone),
    .rxpmaresetdone_out              (rxpmaresetdone),
    .gtwiz_userdata_tx_in            (gth_tx_data),
    .gtwiz_userdata_rx_out           (gth_rx_data),
    .gtrefclk01_in                   (gtrefclk0),
    .txoutclk_out(txoutclk_out), .rxoutclk_out(rxoutclk_out),
    .txusrclk_in(txusrclk2),     .txusrclk2_in(txusrclk2),
    .rxusrclk_in(rxusrclk2),     .rxusrclk2_in(rxusrclk2),
    .gthrxp_in(gthrxp_in),       .gthrxn_in(gthrxn_in),
    .gthtxp_out(gthtxp_out),     .gthtxn_out(gthtxn_out),
    .loopback_in                     (loopback_cfg),
    .rxslide_in                      (rxslide_in),
    // 默认值
    .rxcdrhold_in(0), .rxlpmen_in(0), 
    .txdiffctrl_in(5'b11000), .txpostcursor_in(0), .txprecursor_in(0), 
    .gtwiz_reset_tx_pll_and_datapath_in(0), .gtwiz_reset_tx_datapath_in(0),
    .gtwiz_reset_rx_pll_and_datapath_in(0), .gtwiz_reset_rx_datapath_in(0)
  );

  // ===========================================================================
  // [重要修改] 复位同步处理 (Reset Synchronization)
  // ===========================================================================
  
  // --- TX 域复位同步 ---
  wire tx_rst_n_sync; // 供 TX 用户逻辑使用 (Active Low)
  wire tx_rst_p_sync; // 供 TX 用户逻辑使用 (Active High)
  
  // 将异步的 txpmaresetdone 同步到 txusrclk2 域
  // 注意：txpmaresetdone 高电平表示复位完成(Active)，低电平表示复位中
  xpm_cdc_async_rst #(
    .DEST_SYNC_FF(2),
    .RST_ACTIVE_HIGH(0) // src_arst 低电平表示复位
  ) u_rst_sync_tx (
    .src_arst(txpmaresetdone), 
    .dest_clk(txusrclk2),
    .dest_arst(tx_rst_n_sync) // 输出低电平有效的复位 (复位释放时为1)
  );
  assign tx_rst_p_sync = ~tx_rst_n_sync; // 高电平复位信号

  // --- RX 域复位同步 ---
  wire rx_rst_n_sync; // 供 RX 用户逻辑使用 (Active Low)
  wire rx_rst_p_sync; // 供 RX 用户逻辑使用 (Active High)

  xpm_cdc_async_rst #(
    .DEST_SYNC_FF(2),
    .RST_ACTIVE_HIGH(0)
  ) u_rst_sync_rx (
    .src_arst(rxpmaresetdone),
    .dest_clk(rxusrclk2),
    .dest_arst(rx_rst_n_sync)
  );
  assign rx_rst_p_sync = ~rx_rst_n_sync;


  // ===========================================================================
  // 2. 发送路径 (TX Path)
  // ===========================================================================
  
  reg [15:0] tx_word_cnt;
  wire       tx_block_start_pulse;
  wire       framer_payload_ready;

  // 修改：使用同步后的复位信号 tx_rst_n_sync
  always @(posedge txusrclk2 or negedge tx_rst_n_sync) begin
    if(!tx_rst_n_sync) begin
        tx_word_cnt <= 'd0;
    end else begin
        if (framer_payload_ready) begin
          if (tx_word_cnt == 1023) 
            tx_word_cnt <= 0;
          else
            tx_word_cnt <= tx_word_cnt + 1'b1;
        end
    end
  end
  assign tx_block_start_pulse = (tx_word_cnt == 0);

  (* MARK_DEBUG="true" *)wire [31:0] prbs_tx_data;
  
  gtwizard_ultrascale_0_prbs_any #(
    .CHK_MODE(0),
    .INV_PATTERN(1),
    .NBITS(32)
  ) u_prbs_gen (
    .RST      (tx_rst_p_sync), // 修改：使用同步的高电平复位
    .CLK      (txusrclk2),
    .DATA_IN  (32'd0),
    .EN       (framer_payload_ready),
    .DATA_OUT (prbs_tx_data)
  );

  reg [31:0] send_cnt;
  always@(posedge txusrclk2 or posedge tx_rst_p_sync)begin
    if(tx_rst_p_sync)begin
      send_cnt <= 'd0;
    end else begin
      if(framer_payload_ready)
        send_cnt <= send_cnt + 1'b1;
    end
  end

  fso_framer #(
    .W(32), .PAYLOAD_WORDS(16)
  ) u_framer (
    .clk             (txusrclk2),
    .rst_n           (tx_rst_n_sync), // 修改：使用同步的低电平复位
    .i_payload_data  (prbs_tx_data),
    .i_payload_valid (1'b1), 
    .i_block_start_word (tx_block_start_pulse),
    .o_payload_ready (framer_payload_ready),
    .i_tx_ready      (1'b1), 
    .o_tx_data       (gth_tx_data),
    .o_tx_valid      (), 
    .o_frame_index   ()
  );

  // ===========================================================================
  // 3. 接收路径 (RX Path)
  // ===========================================================================

  (* MARK_DEBUG="true" *)wire aligner_locked;
  (* MARK_DEBUG="true" *)wire [31:0] aligned_data;
  wire aligned_valid;
  wire deframer_realign_req;
  assign pl_led1 = aligner_locked;

  bit_aligner #(
    .W(32), .SLIDE_COOLDOWN(32)
  ) u_aligner (
    .clk             (rxusrclk2),
    .rst_n           (rx_rst_n_sync), // 修改：使用同步的低电平复位
    .rx_reset_done   (rx_rst_n_sync), // 逻辑上代表 Reset Done
    .rx_cdr_stable   (gtwiz_reset_rx_cdr_stable_out),
    .i_rx_data       (gth_rx_data),
    .i_rx_valid      (1'b1),
    .i_realign_req   (deframer_realign_req),
    .o_rxslide       (rxslide_in), 
    .o_aligned_valid (aligned_valid),
    .o_bit_locked    (aligner_locked),
    .o_data_aligned  (aligned_data)
  );

  wire [31:0] deframer_payload_data;
  wire        deframer_payload_valid;
  wire        block_soft_rst;

  fso_deframer #(
    .W(32)
  ) u_deframer (
    .clk             (rxusrclk2),
    .rst_n           (rx_rst_n_sync), // 修改：使用同步的低电平复位
    .i_link_up       (aligner_locked),
    .i_rx_data       (aligned_data),
    .i_rx_valid      (aligned_valid),
    .o_realign_req   (deframer_realign_req),
    .o_blk_soft_rst  (block_soft_rst),
    .o_payload_data  (deframer_payload_data),
    .o_payload_valid (deframer_payload_valid),
    .o_frame_start(), .o_frame_index(), .o_block_id(), .o_frame_in_block()
  );

  (* MARK_DEBUG="true" *)wire [31:0] prbs_err_bits;
  (* MARK_DEBUG="true" *) wire prbs_error_detected = |prbs_err_bits;
  assign pl_led2 = prbs_error_detected;
  (* MARK_DEBUG="true" *)reg [31:0] total_err_cnt;
  always @(posedge rxusrclk2) begin
    if (!rx_rst_n_sync || !aligner_locked) // 修改：使用同步复位
      total_err_cnt <= 0;
    else if (deframer_payload_valid && prbs_error_detected)
      total_err_cnt <= total_err_cnt + 1'b1;
  end

  gtwizard_ultrascale_0_prbs_any #(
    .CHK_MODE(1), .INV_PATTERN(1), .NBITS(32)
  ) u_prbs_chk (
    .RST      (rx_rst_p_sync), // 修改：使用同步的高电平复位
    .CLK      (rxusrclk2),
    .DATA_IN  (deframer_payload_data),
    .EN       (deframer_payload_valid), 
    .DATA_OUT (prbs_err_bits) 
  );


endmodule