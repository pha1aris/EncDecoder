// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// -------------------------------------------------------------------------------

`timescale 1 ps / 1 ps

(* BLOCK_STUB = "true" *)
module design_1 (
  gthrxp_in,
  sys_rst_n,
  sys_clk_p,
  sys_clk_n,
  gthrxn_in,
  gthtxp_out,
  gthtxn_out,
  tx_disable,
  mgtrefclk0_x1y1_p,
  mgtrefclk0_x1y1_n
);

  (* X_INTERFACE_IGNORE = "true" *)
  input gthrxp_in;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.SYS_RST_N RST" *)
  (* X_INTERFACE_MODE = "slave RST.SYS_RST_N" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.SYS_RST_N, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
  input sys_rst_n;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.SYS_CLK_P CLK" *)
  (* X_INTERFACE_MODE = "slave CLK.SYS_CLK_P" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.SYS_CLK_P, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_sys_clk_p, INSERT_VIP 0" *)
  input sys_clk_p;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.SYS_CLK_N CLK" *)
  (* X_INTERFACE_MODE = "slave CLK.SYS_CLK_N" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.SYS_CLK_N, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_sys_clk_n, ASSOCIATED_RESET sys_rst_n, INSERT_VIP 0" *)
  input sys_clk_n;
  (* X_INTERFACE_IGNORE = "true" *)
  input gthrxn_in;
  (* X_INTERFACE_IGNORE = "true" *)
  output gthtxp_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output gthtxn_out;
  (* X_INTERFACE_IGNORE = "true" *)
  output [1:0]tx_disable;
  (* X_INTERFACE_IGNORE = "true" *)
  input mgtrefclk0_x1y1_p;
  (* X_INTERFACE_IGNORE = "true" *)
  input mgtrefclk0_x1y1_n;

  // stub module has no contents

endmodule
