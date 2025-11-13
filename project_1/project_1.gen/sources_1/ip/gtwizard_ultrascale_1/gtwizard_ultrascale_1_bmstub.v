// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// -------------------------------------------------------------------------------

`timescale 1 ps / 1 ps

(* BLOCK_STUB = "true" *)
module gtwizard_ultrascale_1 (
  gtwiz_userclk_tx_reset_in,
  gtwiz_userclk_tx_srcclk_out,
  gtwiz_userclk_tx_usrclk_out,
  gtwiz_userclk_tx_usrclk2_out,
  gtwiz_userclk_tx_active_out,
  gtwiz_userclk_rx_reset_in,
  gtwiz_userclk_rx_srcclk_out,
  gtwiz_userclk_rx_usrclk_out,
  gtwiz_userclk_rx_usrclk2_out,
  gtwiz_userclk_rx_active_out,
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
  drpclk_in,
  gthrxn_in,
  gthrxp_in,
  gtrefclk0_in,
  loopback_in,
  rx8b10ben_in,
  rxbufreset_in,
  rxcommadeten_in,
  rxlpmen_in,
  rxmcommaalignen_in,
  rxpcommaalignen_in,
  tx8b10ben_in,
  txctrl0_in,
  txctrl1_in,
  txctrl2_in,
  txdiffctrl_in,
  txpostcursor_in,
  txprecursor_in,
  gthtxn_out,
  gthtxp_out,
  gtpowergood_out,
  rxbufstatus_out,
  rxbyteisaligned_out,
  rxbyterealign_out,
  rxclkcorcnt_out,
  rxcommadet_out,
  rxctrl0_out,
  rxctrl1_out,
  rxctrl2_out,
  rxctrl3_out,
  rxpmaresetdone_out,
  txpmaresetdone_out
);

  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]gtwiz_userclk_tx_reset_in;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]gtwiz_userclk_tx_srcclk_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]gtwiz_userclk_tx_usrclk_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]gtwiz_userclk_tx_usrclk2_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]gtwiz_userclk_tx_active_out;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]gtwiz_userclk_rx_reset_in;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]gtwiz_userclk_rx_srcclk_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]gtwiz_userclk_rx_usrclk_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]gtwiz_userclk_rx_usrclk2_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]gtwiz_userclk_rx_active_out;
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
  input [0:0]drpclk_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]gthrxn_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]gthrxp_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]gtrefclk0_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [2:0]loopback_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]rx8b10ben_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]rxbufreset_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]rxcommadeten_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]rxlpmen_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]rxmcommaalignen_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]rxpcommaalignen_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]tx8b10ben_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [15:0]txctrl0_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [15:0]txctrl1_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [7:0]txctrl2_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [4:0]txdiffctrl_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [4:0]txpostcursor_in;
  (* X_INTERFACE_IGNORE = "true" *)
  input [4:0]txprecursor_in;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]gthtxn_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]gthtxp_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]gtpowergood_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [2:0]rxbufstatus_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]rxbyteisaligned_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]rxbyterealign_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [1:0]rxclkcorcnt_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]rxcommadet_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [15:0]rxctrl0_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [15:0]rxctrl1_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [7:0]rxctrl2_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [7:0]rxctrl3_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]rxpmaresetdone_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]txpmaresetdone_out;

  // stub module has no contents

endmodule
