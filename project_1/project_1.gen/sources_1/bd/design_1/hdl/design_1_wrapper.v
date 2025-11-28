//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
//Date        : Thu Nov 27 18:07:32 2025
//Host        : FSO-A running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (gthrxn_in,
    gthrxp_in,
    gthtxn_out,
    gthtxp_out,
    mgtrefclk0_x1y1_n,
    mgtrefclk0_x1y1_p,
    sys_clk_n,
    sys_clk_p,
    sys_rst_n,
    tx_disable);
  input gthrxn_in;
  input gthrxp_in;
  output gthtxn_out;
  output gthtxp_out;
  input mgtrefclk0_x1y1_n;
  input mgtrefclk0_x1y1_p;
  input sys_clk_n;
  input sys_clk_p;
  input sys_rst_n;
  output [1:0]tx_disable;

  wire gthrxn_in;
  wire gthrxp_in;
  wire gthtxn_out;
  wire gthtxp_out;
  wire mgtrefclk0_x1y1_n;
  wire mgtrefclk0_x1y1_p;
  wire sys_clk_n;
  wire sys_clk_p;
  wire sys_rst_n;
  wire [1:0]tx_disable;

  design_1 design_1_i
       (.gthrxn_in(gthrxn_in),
        .gthrxp_in(gthrxp_in),
        .gthtxn_out(gthtxn_out),
        .gthtxp_out(gthtxp_out),
        .mgtrefclk0_x1y1_n(mgtrefclk0_x1y1_n),
        .mgtrefclk0_x1y1_p(mgtrefclk0_x1y1_p),
        .sys_clk_n(sys_clk_n),
        .sys_clk_p(sys_clk_p),
        .sys_rst_n(sys_rst_n),
        .tx_disable(tx_disable));
endmodule
