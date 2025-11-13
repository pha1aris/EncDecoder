`timescale 1ps/1ps

// ============================================================================
// Minimal RAW-GT PRBS loopback test top (no 8b/10b, PRBS31 on 32-bit bus)
//   - Works with: gtwizard_ultrascale_0 (RAW interface ports as you pasted)
//   - Clocks: rx/txusrclk2 derived from rx/txoutclk via BUFG_GT
//   - Reset: gtwiz_reset_all_in from sys_rst_n & freerun lock
//   - Active: gtwiz_userclk_{tx,rx}_active_in from *_pmaresetdone_out
//   - Data: PRBS gen -> gtwiz_userdata_tx_in, gtwiz_userdata_rx_out -> PRBS chk
//   - Serial: ports exposed; if you need PMA internal loopback, re-gen IP with
//             loopback port or configure via DRP (not included in RAW template).
// ============================================================================

module gth_prbs_raw_loopback_top (
  // system clock (for resets/DRP/timing only)
  input  wire        sys_clk_p,
  input  wire        sys_clk_n,
  input  wire        sys_rst_n,

  // SFP disable (active-high). Drive 0 to enable TX laser.
(* MARK_DEBUG="true" *)  output  wire [1:0]  tx_disable,

  // GT reference clock 0/0 (e.g., 125/156.25 MHz for your line rate plan)
  input  wire        mgtrefclk0_x1y1_p,
  input  wire        mgtrefclk0_x1y1_n,
  // Serial I/O (use external SFP loopback; PMA internal loopback not exposed in RAW ports)
  input  wire        gthrxp_in,
  input  wire        gthrxn_in,
  output wire        gthtxp_out,
  output wire        gthtxn_out
);

  // --------------------------------------------------------------------------
  // 0) Free-run fabric clock (for resets/DRP/helpers). Use your board clock.
  // --------------------------------------------------------------------------
  wire freerun_clk, pll_locked;
  clk_wiz_1 u_clk_wiz (
    .clk_out1 (freerun_clk), //39.0625Mhz
    .reset    (~sys_rst_n),
    .locked   (pll_locked),
    .clk_in1_p(sys_clk_p),
    .clk_in1_n(sys_clk_n)
  );

   assign tx_disable = 2'b00; // enable SFP TX

  // RAW wizard global resets
  wire [0:0] gtwiz_reset_clk_freerun_in = freerun_clk;
  wire [0:0] gtwiz_reset_all_in         = ~(sys_rst_n & pll_locked);
  wire [0:0] gtwiz_reset_tx_pll_and_datapath_in = 1'b0;
  wire [0:0] gtwiz_reset_tx_datapath_in         = 1'b0;
  wire [0:0] gtwiz_reset_rx_pll_and_datapath_in = 1'b0;
  wire [0:0] gtwiz_reset_rx_datapath_in         = 1'b0;

  // --------------------------------------------------------------------------
  // 1) GT REFCLK buffer to gtrefclk00_in
  // --------------------------------------------------------------------------
  wire gtrefclk0;
  IBUFDS_GTE4 #(
    .REFCLK_EN_TX_PATH (1'b0),
    .REFCLK_HROW_CK_SEL(2'b00),
    .REFCLK_ICNTL_RX   (2'b00)
  ) u_ibufds_refclk (
    .I   (mgtrefclk0_x1y1_p),
    .IB  (mgtrefclk0_x1y1_n),
    .CEB (1'b0),
    .O   (gtrefclk0),
    .ODIV2()
  );
  wire [0:0] gtrefclk00_in = gtrefclk0;

  // --------------------------------------------------------------------------
  // 2) Instantiate RAW GT wizard
  // --------------------------------------------------------------------------
  // user clocks from GT
  wire [0:0] txoutclk_out, rxoutclk_out;
  // pma done & powergood
  (* MARK_DEBUG="true" *)wire [0:0] txpmaresetdone_out, rxpmaresetdone_out;
  (* MARK_DEBUG="true" *)wire [0:0] gtpowergood_out;

  // QPLL outputs (unused for fabric, but must be wired)
  wire [0:0] qpll0outclk_out, qpll0outrefclk_out;

  // user clocks (usrclk / usrclk2) – both driven by same BUFG_GT output
  wire txusrclk, txusrclk2, rxusrclk, rxusrclk2;
  // Active flags for RAW core
  (* MARK_DEBUG="true" *)wire [0:0] gtwiz_userclk_tx_active_in = txpmaresetdone_out;
  (* MARK_DEBUG="true" *)wire [0:0] gtwiz_userclk_rx_active_in = rxpmaresetdone_out;

  // Generate usrclks from GT *_outclk
  BUFG_GT u_bufg_txusrclk  (.I(txoutclk_out[0]), .CE(1'b1), .CEMASK(1'b0), .CLR(1'b0), .CLRMASK(1'b0), .DIV(3'd0), .O(txusrclk));
  BUFG_GT u_bufg_txusrclk2 (.I(txoutclk_out[0]), .CE(1'b1), .CEMASK(1'b0), .CLR(1'b0), .CLRMASK(1'b0), .DIV(3'd0), .O(txusrclk2));
  BUFG_GT u_bufg_rxusrclk  (.I(rxoutclk_out[0]), .CE(1'b1), .CEMASK(1'b0), .CLR(1'b0), .CLRMASK(1'b0), .DIV(3'd0), .O(rxusrclk));
  BUFG_GT u_bufg_rxusrclk2 (.I(rxoutclk_out[0]), .CE(1'b1), .CEMASK(1'b0), .CLR(1'b0), .CLRMASK(1'b0), .DIV(3'd0), .O(rxusrclk2));

  // Pack to [0:0] buses for RAW ports
  wire [0:0] txusrclk_in  = txusrclk;
  wire [0:0] txusrclk2_in = txusrclk2;
  wire [0:0] rxusrclk_in  = rxusrclk;
  wire [0:0] rxusrclk2_in = rxusrclk2;

  // PRBS datapath wires
  (* MARK_DEBUG="true" *)wire [31:0] txdata32;
  (* MARK_DEBUG="true" *)wire [31:0] rxdata32;

  (* MARK_DEBUG="true" *)wire gtwiz_reset_rx_cdr_stable_out;
  (* MARK_DEBUG="true" *)wire gtwiz_reset_tx_done_out;
  (* MARK_DEBUG="true" *)wire gtwiz_reset_rx_done_out;

  (* MARK_DEBUG="true" *)wire        rxlpmen_in;

  wire          rxcdrhold_in;
  wire [2:0]    loopback_in;
  wire [0 : 0]  rxpolarity_in;
  wire [0 : 0]  rxslide_in;
  wire [4 : 0]  txdiffctrl_in;
  wire [0 : 0]  txpolarity_in;
  wire [4 : 0] txpostcursor_in;
  wire [4 : 0] txprecursor_in;

  vio_1   vio_1 (
    .clk            (freerun_clk),                // input wire clk
    .probe_out0     (rxcdrhold_in),     // output wire [0 : 0] probe_out0
    .probe_out1     (loopback_in),      // output wire [2 : 0] probe_out1
    .probe_out2     (rxlpmen_in),       // output wire [0 : 0] probe_out2
    .probe_out3     (rxpolarity_in),    // output wire [0 : 0] probe_out3
    .probe_out4     (rxslide_in),       // output wire [0 : 0] probe_out4
    .probe_out5     (txdiffctrl_in),    // output wire [4 : 0] probe_out5
    .probe_out6     (txpolarity_in),    // output wire [0 : 0] probe_out6
    .probe_out7     (txpostcursor_in),       // output wire [4 : 0] probe_out7
    .probe_out8     (txprecursor_in)        // output wire [4 : 0] probe_out8
  );


  gtwizard_ultrascale_0 u_gt_raw (
    .gtwiz_userclk_tx_active_in        (gtwiz_userclk_tx_active_in),
    .gtwiz_userclk_rx_active_in        (gtwiz_userclk_rx_active_in),

    .gtwiz_reset_clk_freerun_in        (gtwiz_reset_clk_freerun_in),
    .gtwiz_reset_all_in                (gtwiz_reset_all_in),
    .gtwiz_reset_tx_pll_and_datapath_in(gtwiz_reset_tx_pll_and_datapath_in),
    .gtwiz_reset_tx_datapath_in        (gtwiz_reset_tx_datapath_in),
    .gtwiz_reset_rx_pll_and_datapath_in(gtwiz_reset_rx_pll_and_datapath_in),
    .gtwiz_reset_rx_datapath_in        (gtwiz_reset_rx_datapath_in),

    .gtwiz_reset_rx_cdr_stable_out     (gtwiz_reset_rx_cdr_stable_out),
    .gtwiz_reset_tx_done_out           (gtwiz_reset_tx_done_out),
    .gtwiz_reset_rx_done_out           (gtwiz_reset_rx_done_out),

    .gtwiz_userdata_tx_in              (txdata32),
    .gtwiz_userdata_rx_out             (rxdata32),

    .gtrefclk00_in                     (gtrefclk00_in),
    .qpll0outclk_out                   (qpll0outclk_out),
    .qpll0outrefclk_out                (qpll0outrefclk_out),

    .gthrxn_in                         (gthrxn_in),
    .gthrxp_in                         (gthrxp_in),
    .rxusrclk_in                       (rxusrclk_in),
    .rxusrclk2_in                      (rxusrclk2_in),

    .rxcdrhold_in                       (rxcdrhold_in),                                              // input wire [0 : 0] rxcdrhold_in
    .loopback_in                        (loopback_in),                                                // input wire [2 : 0] loopback_in
    .rxlpmen_in                         (rxlpmen_in),                                                  // input wire [0 : 0] rxlpmen_in
    .rxpolarity_in                      (rxpolarity_in),                                            // input wire [0 : 0] rxpolarity_in
    .rxslide_in                         (rxslide_in),                                                  // input wire [0 : 0] rxslide_in
    .txdiffctrl_in                      (txdiffctrl_in),                                            // input wire [4 : 0] txdiffctrl_in
    .txpolarity_in                      (txpolarity_in),                                            // input wire [0 : 0] txpolarity_in

    .txpostcursor_in                    (txpostcursor_in),                                        // input wire [4 : 0] txpostcursor_in
    .txprecursor_in                     (txprecursor_in),                                          // input wire [4 : 0] txprecursor_in


    .txusrclk_in                       (txusrclk_in),
    .txusrclk2_in                      (txusrclk2_in),
    .gthtxn_out                        (gthtxn_out),
    .gthtxp_out                        (gthtxp_out),

    .gtpowergood_out                   (gtpowergood_out),
    .rxoutclk_out                      (rxoutclk_out),
    .rxpmaresetdone_out                (rxpmaresetdone_out),
    .txoutclk_out                      (txoutclk_out),
    .txpmaresetdone_out                (txpmaresetdone_out)
  );

  // --------------------------------------------------------------------------
  // 3) PRBS31 generator/checker (XAPP884 style)
  //     注意：与向导的数据位宽一致（此处 32bit）。INV_PATTERN 要 TX/RX 一致。
  // --------------------------------------------------------------------------
  // 发送侧
  gtwizard_ultrascale_0_prbs_any #(
    .CHK_MODE    (0),
    .INV_PATTERN (1),
    .POLY_LENGHT (31),
    .POLY_TAP    (28),
    .NBITS       (32)
  ) u_prbs_gen (
    .RST      (~gtwiz_userclk_tx_active_in[0]), // 等 TX userclk active
    .CLK      (txusrclk2),
    .DATA_IN  (32'd0),
    .EN       (1'b1),
    .DATA_OUT (txdata32)
  );

  // 接收侧
  wire [31:0] prbs_err_bits;
  gtwizard_ultrascale_0_prbs_any #(
    .CHK_MODE    (1),
    .INV_PATTERN (1),
    .POLY_LENGHT (31),
    .POLY_TAP    (28),
    .NBITS       (32)
  ) u_prbs_chk (
    .RST      (~gtwiz_userclk_rx_active_in[0]),
    .CLK      (rxusrclk2),
    .DATA_IN  (rxdata32),
    .EN       (1'b1),
    .DATA_OUT (prbs_err_bits)
  );

  (* MARK_DEBUG="true" *)wire prbs_match = ~(|prbs_err_bits);
  assign prbs_match_led = prbs_match;

endmodule
