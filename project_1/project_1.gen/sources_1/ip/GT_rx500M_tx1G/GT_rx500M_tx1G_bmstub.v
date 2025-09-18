// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// -------------------------------------------------------------------------------

`timescale 1 ps / 1 ps

(* BLOCK_STUB = "true" *)
module GT_rx500M_tx1G (
  gtwiz_userclk_tx_active_in,
  gtwiz_userclk_rx_active_in,
  gtwiz_reset_clk_freerun_in,
  gtwiz_reset_all_in,
  gtwiz_reset_tx_pll_and_datapath_in,
  gtwiz_reset_tx_datapath_in,
  gtwiz_reset_rx_pll_and_datapath_in,
  gtwiz_reset_rx_datapath_in,
  gtwiz_reset_rx_cdr_stable_out,
  gtwiz_reset_tx_done_out,
  gtwiz_reset_rx_done_out,
  gtwiz_userdata_tx_in,
  gtwiz_userdata_rx_out,
  gtrefclk00_in,
  gtrefclk01_in,
  qpll0outclk_out,
  qpll0outrefclk_out,
  qpll1outclk_out,
  qpll1outrefclk_out,
  gthrxn_in,
  gthrxp_in,
  rxusrclk_in,
  rxusrclk2_in,
  tx8b10ben_in,
  txctrl0_in,
  txctrl1_in,
  txctrl2_in,
  txusrclk_in,
  txusrclk2_in,
  gthtxn_out,
  gthtxp_out,
  gtpowergood_out,
  rxoutclk_out,
  rxpmaresetdone_out,
  txoutclk_out,
  txpmaresetdone_out
);

  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]gtwiz_userclk_tx_active_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]gtwiz_userclk_rx_active_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]gtwiz_reset_clk_freerun_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]gtwiz_reset_all_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]gtwiz_reset_tx_pll_and_datapath_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]gtwiz_reset_tx_datapath_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]gtwiz_reset_rx_pll_and_datapath_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]gtwiz_reset_rx_datapath_in;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]gtwiz_reset_rx_cdr_stable_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]gtwiz_reset_tx_done_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]gtwiz_reset_rx_done_out;
  (* X_INTERFACE_IGNORE = "true" *)
  input [31:0]gtwiz_userdata_tx_in;
  (* X_INTERFACE_IGNORE = "true" *)
  output [31:0]gtwiz_userdata_rx_out;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]gtrefclk00_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]gtrefclk01_in;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]qpll0outclk_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]qpll0outrefclk_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]qpll1outclk_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]qpll1outrefclk_out;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]gthrxn_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]gthrxp_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]rxusrclk_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]rxusrclk2_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]tx8b10ben_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [15:0]txctrl0_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [15:0]txctrl1_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [7:0]txctrl2_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]txusrclk_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]txusrclk2_in;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]gthtxn_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]gthtxp_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]gtpowergood_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]rxoutclk_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]rxpmaresetdone_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]txoutclk_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]txpmaresetdone_out;

  // stub module has no contents

endmodule
