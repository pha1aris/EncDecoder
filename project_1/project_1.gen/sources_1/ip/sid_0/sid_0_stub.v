// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Tue Oct 28 09:48:35 2025
// Host        : FSO-A running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/PC/Desktop/fps/EnDec/project_1/project_1.gen/sources_1/ip/sid_0/sid_0_stub.v
// Design      : sid_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu15eg-ffvb1156-2-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* CHECK_LICENSE_TYPE = "sid_0,sid_v8_0_22,{}" *) (* PARTIALLYOBFUSCATED *) (* core_generation_info = "sid_0,sid_v8_0_22,{x_ipProduct=Vivado 2024.2,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=sid,x_ipVersion=8.0,x_ipCoreRevision=22,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,c_xdevicefamily=zynquplus,c_family=zynquplus,c_architecture=0,c_mem_init_prefix=sid_0,c_elaboration_dir=./,c_type=0,c_mode=0,c_symbol_width=8,c_row_type=0,c_row_constant=255,c_has_row=0,c_has_row_valid=0,c_min_num_rows=15,c_row_width=4,c_num_selectable_rows=4,c_row_select_file=sid_0_RS.mif,c_has_row_sel=0,c_has_row_sel_valid=0,c_use_row_permute_file=0,c_row_permute_file=sid_0_RP.mif,c_col_type=0,c_col_constant=255,c_has_col=0,c_has_col_valid=0,c_min_num_cols=15,c_col_width=4,c_num_selectable_cols=4,c_col_select_file=sid_0_CS.mif,c_has_col_sel=0,c_has_col_sel_valid=0,c_use_col_permute_file=0,c_col_permute_file=sid_0_CP.mif,c_block_size_type=3,c_block_size_constant=225,c_has_block_size=0,c_block_size_width=8,c_has_block_size_valid=0,c_num_branches=16,c_branch_length_type=0,c_branch_length_constant=16,c_branch_length_file=sid_0.mif,c_num_configurations=1,c_external_ram=0,c_ext_mem_latency=0,c_ext_addr_width=16,c_memstyle=1,c_pipe_level=0,c_throughput_mode=0,c_has_aclken=0,c_has_aresetn=1,c_has_rdy=0,c_has_block_start=1,c_has_block_end=1,c_has_fdo=0,c_s_axis_ctrl_tdata_width=1,c_s_axis_data_tdata_width=8,c_m_axis_data_tdata_width=8,c_m_axis_data_tuser_width=2,c_has_dout_tready=1,x_ipLicense=sid@2013.03(bought)}" *) 
(* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "sid_v8_0_22,Vivado 2024.2" *) 
module sid_0(aclk, aresetn, s_axis_data_tdata, 
  s_axis_data_tvalid, s_axis_data_tlast, s_axis_data_tready, m_axis_data_tdata, 
  m_axis_data_tuser, m_axis_data_tvalid, m_axis_data_tlast, m_axis_data_tready, 
  event_tlast_unexpected, event_tlast_missing, event_halted)
/* synthesis syn_black_box black_box_pad_pin="aresetn,s_axis_data_tdata[7:0],s_axis_data_tvalid,s_axis_data_tlast,s_axis_data_tready,m_axis_data_tdata[7:0],m_axis_data_tuser[1:0],m_axis_data_tvalid,m_axis_data_tlast,m_axis_data_tready,event_tlast_unexpected,event_tlast_missing,event_halted" */
/* synthesis syn_force_seq_prim="aclk" */;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 aclk_intf CLK" *) (* x_interface_mode = "slave aclk_intf" *) (* x_interface_parameter = "XIL_INTERFACENAME aclk_intf, ASSOCIATED_BUSIF S_AXIS_CTRL:M_AXIS_DATA:S_AXIS_DATA, ASSOCIATED_RESET aresetn, ASSOCIATED_CLKEN aclken, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *) input aclk /* synthesis syn_isclock = 1 */;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 aresetn_intf RST" *) (* x_interface_mode = "slave aresetn_intf" *) (* x_interface_parameter = "XIL_INTERFACENAME aresetn_intf, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input aresetn;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 S_AXIS_DATA TDATA" *) (* x_interface_mode = "slave S_AXIS_DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME S_AXIS_DATA, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, LAYERED_METADATA undef, INSERT_VIP 0" *) input [7:0]s_axis_data_tdata;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 S_AXIS_DATA TVALID" *) input s_axis_data_tvalid;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 S_AXIS_DATA TLAST" *) input s_axis_data_tlast;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 S_AXIS_DATA TREADY" *) output s_axis_data_tready;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M_AXIS_DATA TDATA" *) (* x_interface_mode = "master M_AXIS_DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME M_AXIS_DATA, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 2, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, LAYERED_METADATA undef, INSERT_VIP 0" *) output [7:0]m_axis_data_tdata;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M_AXIS_DATA TUSER" *) output [1:0]m_axis_data_tuser;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M_AXIS_DATA TVALID" *) output m_axis_data_tvalid;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M_AXIS_DATA TLAST" *) output m_axis_data_tlast;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M_AXIS_DATA TREADY" *) input m_axis_data_tready;
  (* x_interface_info = "xilinx.com:signal:interrupt:1.0 event_tlast_unexpected_intf INTERRUPT" *) (* x_interface_mode = "master event_tlast_unexpected_intf" *) (* x_interface_parameter = "XIL_INTERFACENAME event_tlast_unexpected_intf, SENSITIVITY EDGE_RISING, PortWidth 1" *) output event_tlast_unexpected;
  (* x_interface_info = "xilinx.com:signal:interrupt:1.0 event_tlast_missing_intf INTERRUPT" *) (* x_interface_mode = "master event_tlast_missing_intf" *) (* x_interface_parameter = "XIL_INTERFACENAME event_tlast_missing_intf, SENSITIVITY EDGE_RISING, PortWidth 1" *) output event_tlast_missing;
  (* x_interface_info = "xilinx.com:signal:interrupt:1.0 event_halted_intf INTERRUPT" *) (* x_interface_mode = "master event_halted_intf" *) (* x_interface_parameter = "XIL_INTERFACENAME event_halted_intf, SENSITIVITY EDGE_RISING, PortWidth 1" *) output event_halted;
endmodule
