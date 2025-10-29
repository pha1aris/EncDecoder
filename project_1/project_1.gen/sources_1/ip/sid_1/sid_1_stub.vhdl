-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
-- Date        : Tue Oct 28 10:43:50 2025
-- Host        : FSO-A running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/Users/PC/Desktop/fps/EnDec/project_1/project_1.gen/sources_1/ip/sid_1/sid_1_stub.vhdl
-- Design      : sid_1
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu15eg-ffvb1156-2-i
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sid_1 is
  Port ( 
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    s_axis_data_tdata : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axis_data_tvalid : in STD_LOGIC;
    s_axis_data_tlast : in STD_LOGIC;
    s_axis_data_tready : out STD_LOGIC;
    m_axis_data_tdata : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axis_data_tuser : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axis_data_tvalid : out STD_LOGIC;
    m_axis_data_tlast : out STD_LOGIC;
    m_axis_data_tready : in STD_LOGIC;
    event_tlast_unexpected : out STD_LOGIC;
    event_tlast_missing : out STD_LOGIC;
    event_halted : out STD_LOGIC
  );

  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of sid_1 : entity is "sid_1,sid_v8_0_22,{}";
  attribute PARTIALLYOBFUSCATED : boolean;
  attribute PARTIALLYOBFUSCATED of sid_1 : entity is std.standard.true;
  attribute core_generation_info : string;
  attribute core_generation_info of sid_1 : entity is "sid_1,sid_v8_0_22,{x_ipProduct=Vivado 2024.2,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=sid,x_ipVersion=8.0,x_ipCoreRevision=22,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,c_xdevicefamily=zynquplus,c_family=zynquplus,c_architecture=0,c_mem_init_prefix=sid_1,c_elaboration_dir=./,c_type=0,c_mode=1,c_symbol_width=8,c_row_type=0,c_row_constant=255,c_has_row=0,c_has_row_valid=0,c_min_num_rows=15,c_row_width=4,c_num_selectable_rows=4,c_row_select_file=sid_1_RS.mif,c_has_row_sel=0,c_has_row_sel_valid=0,c_use_row_permute_file=0,c_row_permute_file=sid_1_RP.mif,c_col_type=0,c_col_constant=255,c_has_col=0,c_has_col_valid=0,c_min_num_cols=15,c_col_width=4,c_num_selectable_cols=4,c_col_select_file=sid_1_CS.mif,c_has_col_sel=0,c_has_col_sel_valid=0,c_use_col_permute_file=0,c_col_permute_file=sid_1_CP.mif,c_block_size_type=3,c_block_size_constant=225,c_has_block_size=0,c_block_size_width=8,c_has_block_size_valid=0,c_num_branches=16,c_branch_length_type=0,c_branch_length_constant=16,c_branch_length_file=sid_1.mif,c_num_configurations=1,c_external_ram=0,c_ext_mem_latency=0,c_ext_addr_width=16,c_memstyle=1,c_pipe_level=0,c_throughput_mode=0,c_has_aclken=0,c_has_aresetn=1,c_has_rdy=0,c_has_block_start=1,c_has_block_end=1,c_has_fdo=0,c_s_axis_ctrl_tdata_width=1,c_s_axis_data_tdata_width=8,c_m_axis_data_tdata_width=8,c_m_axis_data_tuser_width=2,c_has_dout_tready=1,x_ipLicense=sid@2013.03(bought)}";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of sid_1 : entity is "yes";
end sid_1;

architecture stub of sid_1 is
  attribute syn_black_box : boolean;
  attribute black_box_pad_pin : string;
  attribute syn_black_box of stub : architecture is true;
  attribute black_box_pad_pin of stub : architecture is "aclk,aresetn,s_axis_data_tdata[7:0],s_axis_data_tvalid,s_axis_data_tlast,s_axis_data_tready,m_axis_data_tdata[7:0],m_axis_data_tuser[1:0],m_axis_data_tvalid,m_axis_data_tlast,m_axis_data_tready,event_tlast_unexpected,event_tlast_missing,event_halted";
  attribute x_interface_info : string;
  attribute x_interface_info of aclk : signal is "xilinx.com:signal:clock:1.0 aclk_intf CLK";
  attribute x_interface_mode : string;
  attribute x_interface_mode of aclk : signal is "slave aclk_intf";
  attribute x_interface_parameter : string;
  attribute x_interface_parameter of aclk : signal is "XIL_INTERFACENAME aclk_intf, ASSOCIATED_BUSIF S_AXIS_CTRL:M_AXIS_DATA:S_AXIS_DATA, ASSOCIATED_RESET aresetn, ASSOCIATED_CLKEN aclken, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0";
  attribute x_interface_info of aresetn : signal is "xilinx.com:signal:reset:1.0 aresetn_intf RST";
  attribute x_interface_mode of aresetn : signal is "slave aresetn_intf";
  attribute x_interface_parameter of aresetn : signal is "XIL_INTERFACENAME aresetn_intf, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute x_interface_info of s_axis_data_tdata : signal is "xilinx.com:interface:axis:1.0 S_AXIS_DATA TDATA";
  attribute x_interface_mode of s_axis_data_tdata : signal is "slave S_AXIS_DATA";
  attribute x_interface_parameter of s_axis_data_tdata : signal is "XIL_INTERFACENAME S_AXIS_DATA, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, LAYERED_METADATA undef, INSERT_VIP 0";
  attribute x_interface_info of s_axis_data_tvalid : signal is "xilinx.com:interface:axis:1.0 S_AXIS_DATA TVALID";
  attribute x_interface_info of s_axis_data_tlast : signal is "xilinx.com:interface:axis:1.0 S_AXIS_DATA TLAST";
  attribute x_interface_info of s_axis_data_tready : signal is "xilinx.com:interface:axis:1.0 S_AXIS_DATA TREADY";
  attribute x_interface_info of m_axis_data_tdata : signal is "xilinx.com:interface:axis:1.0 M_AXIS_DATA TDATA";
  attribute x_interface_mode of m_axis_data_tdata : signal is "master M_AXIS_DATA";
  attribute x_interface_parameter of m_axis_data_tdata : signal is "XIL_INTERFACENAME M_AXIS_DATA, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 2, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, LAYERED_METADATA undef, INSERT_VIP 0";
  attribute x_interface_info of m_axis_data_tuser : signal is "xilinx.com:interface:axis:1.0 M_AXIS_DATA TUSER";
  attribute x_interface_info of m_axis_data_tvalid : signal is "xilinx.com:interface:axis:1.0 M_AXIS_DATA TVALID";
  attribute x_interface_info of m_axis_data_tlast : signal is "xilinx.com:interface:axis:1.0 M_AXIS_DATA TLAST";
  attribute x_interface_info of m_axis_data_tready : signal is "xilinx.com:interface:axis:1.0 M_AXIS_DATA TREADY";
  attribute x_interface_info of event_tlast_unexpected : signal is "xilinx.com:signal:interrupt:1.0 event_tlast_unexpected_intf INTERRUPT";
  attribute x_interface_mode of event_tlast_unexpected : signal is "master event_tlast_unexpected_intf";
  attribute x_interface_parameter of event_tlast_unexpected : signal is "XIL_INTERFACENAME event_tlast_unexpected_intf, SENSITIVITY EDGE_RISING, PortWidth 1";
  attribute x_interface_info of event_tlast_missing : signal is "xilinx.com:signal:interrupt:1.0 event_tlast_missing_intf INTERRUPT";
  attribute x_interface_mode of event_tlast_missing : signal is "master event_tlast_missing_intf";
  attribute x_interface_parameter of event_tlast_missing : signal is "XIL_INTERFACENAME event_tlast_missing_intf, SENSITIVITY EDGE_RISING, PortWidth 1";
  attribute x_interface_info of event_halted : signal is "xilinx.com:signal:interrupt:1.0 event_halted_intf INTERRUPT";
  attribute x_interface_mode of event_halted : signal is "master event_halted_intf";
  attribute x_interface_parameter of event_halted : signal is "XIL_INTERFACENAME event_halted_intf, SENSITIVITY EDGE_RISING, PortWidth 1";
  attribute x_core_info : string;
  attribute x_core_info of stub : architecture is "sid_v8_0_22,Vivado 2024.2";
begin
end;
