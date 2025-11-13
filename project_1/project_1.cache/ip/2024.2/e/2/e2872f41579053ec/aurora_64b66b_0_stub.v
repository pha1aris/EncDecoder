// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Sat Nov  8 09:49:25 2025
// Host        : FSO-A running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ aurora_64b66b_0_stub.v
// Design      : aurora_64b66b_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu15eg-ffvb1156-2-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* DowngradeIPIdentifiedWarnings = "yes" *) (* EGW_IS_PARENT_IP = "1" *) (* X_CORE_INFO = "aurora_64b66b_v13_0_0, Coregen v14.3_ip3, Number of lanes = 1, Line rate is double1.25Gbps, Reference Clock is double125.0MHz, Interface is Framing, Flow Control is None and is operating in DUPLEX configuration" *) 
(* core_generation_info = "aurora_64b66b_0,aurora_64b66b_v13_0_0,{c_aurora_lanes=1,c_column_used=left,c_gt_clock_1=GTHQ0,c_gt_clock_2=None,c_gt_loc_1=1,c_gt_loc_10=X,c_gt_loc_11=X,c_gt_loc_12=X,c_gt_loc_13=X,c_gt_loc_14=X,c_gt_loc_15=X,c_gt_loc_16=X,c_gt_loc_17=X,c_gt_loc_18=X,c_gt_loc_19=X,c_gt_loc_2=X,c_gt_loc_20=X,c_gt_loc_21=X,c_gt_loc_22=X,c_gt_loc_23=X,c_gt_loc_24=X,c_gt_loc_25=X,c_gt_loc_26=X,c_gt_loc_27=X,c_gt_loc_28=X,c_gt_loc_29=X,c_gt_loc_3=X,c_gt_loc_30=X,c_gt_loc_31=X,c_gt_loc_32=X,c_gt_loc_33=X,c_gt_loc_34=X,c_gt_loc_35=X,c_gt_loc_36=X,c_gt_loc_37=X,c_gt_loc_38=X,c_gt_loc_39=X,c_gt_loc_4=X,c_gt_loc_40=X,c_gt_loc_41=X,c_gt_loc_42=X,c_gt_loc_43=X,c_gt_loc_44=X,c_gt_loc_45=X,c_gt_loc_46=X,c_gt_loc_47=X,c_gt_loc_48=X,c_gt_loc_5=X,c_gt_loc_6=X,c_gt_loc_7=X,c_gt_loc_8=X,c_gt_loc_9=X,c_lane_width=4,c_line_rate=1.25,c_gt_type=GTHE4,c_qpll=false,c_nfc=false,c_nfc_mode=IMM,c_refclk_frequency=125.0,c_simplex=false,c_simplex_mode=TX,c_stream=false,c_ufc=false,c_user_k=false,flow_mode=None,interface_mode=Framing,dataflow_config=Duplex}" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(s_axi_tx_tdata, s_axi_tx_tlast, 
  s_axi_tx_tkeep, s_axi_tx_tvalid, s_axi_tx_tready, m_axi_rx_tdata, m_axi_rx_tlast, 
  m_axi_rx_tkeep, m_axi_rx_tvalid, rxp, rxn, txp, txn, refclk1_in, hard_err, soft_err, channel_up, 
  lane_up, crc_pass_fail_n, crc_valid, mmcm_not_locked, user_clk, sync_clk, reset_pb, 
  gt_rxcdrovrden_in, power_down, loopback, pma_init, gt_pll_lock, s_axi_awaddr, s_axi_awvalid, 
  s_axi_awready, s_axi_wdata, s_axi_wstrb, s_axi_wvalid, s_axi_wready, s_axi_bvalid, 
  s_axi_bresp, s_axi_bready, s_axi_araddr, s_axi_arvalid, s_axi_arready, s_axi_rdata, 
  s_axi_rvalid, s_axi_rresp, s_axi_rready, init_clk, link_reset_out, gt_powergood, 
  sys_reset_out, bufg_gt_clr_out, tx_out_clk)
/* synthesis syn_black_box black_box_pad_pin="s_axi_tx_tdata[0:63],s_axi_tx_tlast,s_axi_tx_tkeep[0:7],s_axi_tx_tvalid,s_axi_tx_tready,m_axi_rx_tdata[0:63],m_axi_rx_tlast,m_axi_rx_tkeep[0:7],m_axi_rx_tvalid,rxp[0:0],rxn[0:0],txp[0:0],txn[0:0],refclk1_in,hard_err,soft_err,channel_up,lane_up[0:0],crc_pass_fail_n,crc_valid,mmcm_not_locked,reset_pb,gt_rxcdrovrden_in,power_down,loopback[2:0],pma_init,gt_pll_lock,s_axi_awaddr[31:0],s_axi_awvalid,s_axi_awready,s_axi_wdata[31:0],s_axi_wstrb[3:0],s_axi_wvalid,s_axi_wready,s_axi_bvalid,s_axi_bresp[1:0],s_axi_bready,s_axi_araddr[31:0],s_axi_arvalid,s_axi_arready,s_axi_rdata[31:0],s_axi_rvalid,s_axi_rresp[1:0],s_axi_rready,link_reset_out,gt_powergood[0:0],sys_reset_out,bufg_gt_clr_out" */
/* synthesis syn_force_seq_prim="user_clk" */
/* synthesis syn_force_seq_prim="sync_clk" */
/* synthesis syn_force_seq_prim="init_clk" */
/* synthesis syn_force_seq_prim="tx_out_clk" */;
  input [0:63]s_axi_tx_tdata;
  input s_axi_tx_tlast;
  input [0:7]s_axi_tx_tkeep;
  input s_axi_tx_tvalid;
  output s_axi_tx_tready;
  output [0:63]m_axi_rx_tdata;
  output m_axi_rx_tlast;
  output [0:7]m_axi_rx_tkeep;
  output m_axi_rx_tvalid;
  input [0:0]rxp;
  input [0:0]rxn;
  output [0:0]txp;
  output [0:0]txn;
  input refclk1_in;
  output hard_err;
  output soft_err;
  output channel_up;
  output [0:0]lane_up;
  output crc_pass_fail_n;
  output crc_valid;
  input mmcm_not_locked;
  input user_clk /* synthesis syn_isclock = 1 */;
  input sync_clk /* synthesis syn_isclock = 1 */;
  input reset_pb;
  input gt_rxcdrovrden_in;
  input power_down;
  input [2:0]loopback;
  input pma_init;
  output gt_pll_lock;
  input [31:0]s_axi_awaddr;
  input s_axi_awvalid;
  output s_axi_awready;
  input [31:0]s_axi_wdata;
  input [3:0]s_axi_wstrb;
  input s_axi_wvalid;
  output s_axi_wready;
  output s_axi_bvalid;
  output [1:0]s_axi_bresp;
  input s_axi_bready;
  input [31:0]s_axi_araddr;
  input s_axi_arvalid;
  output s_axi_arready;
  output [31:0]s_axi_rdata;
  output s_axi_rvalid;
  output [1:0]s_axi_rresp;
  input s_axi_rready;
  input init_clk /* synthesis syn_isclock = 1 */;
  output link_reset_out;
  output [0:0]gt_powergood;
  output sys_reset_out;
  output bufg_gt_clr_out;
  output tx_out_clk /* synthesis syn_isclock = 1 */;
endmodule
