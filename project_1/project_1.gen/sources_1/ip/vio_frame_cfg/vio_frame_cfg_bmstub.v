// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// -------------------------------------------------------------------------------

`timescale 1 ps / 1 ps

(* BLOCK_STUB = "true" *)
module vio_frame_cfg (
  clk,
  probe_out0,
  probe_out1,
  probe_out2,
  probe_out3,
  probe_out4,
  probe_out5,
  probe_out6,
  probe_out7,
  probe_out8
);

  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 signal_clock CLK" *)
  (* X_INTERFACE_MODE = "slave signal_clock" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME signal_clock, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN , ASSOCIATED_BUSIF , ASSOCIATED_PORT , ASSOCIATED_RESET , INSERT_VIP 0" *)
  input clk;
  (* X_INTERFACE_IGNORE = "true" *)
  output [5:0]probe_out0;
  (* X_INTERFACE_IGNORE = "true" *)
  output [7:0]probe_out1;
  (* X_INTERFACE_IGNORE = "true" *)
  output [15:0]probe_out2;
  (* X_INTERFACE_IGNORE = "true" *)
  output [15:0]probe_out3;
  (* X_INTERFACE_IGNORE = "true" *)
  output [7:0]probe_out4;
  (* X_INTERFACE_IGNORE = "true" *)
  output [7:0]probe_out5;
  (* X_INTERFACE_IGNORE = "true" *)
  output [7:0]probe_out6;
  (* X_INTERFACE_IGNORE = "true" *)
  output [7:0]probe_out7;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]probe_out8;

  // stub module has no contents

endmodule
