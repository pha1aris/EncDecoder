-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
-- Date        : Sun Sep 28 21:34:07 2025
-- Host        : FSO-A running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               c:/Users/PC/Desktop/fps/EnDec/project_1/project_1.gen/sources_1/bd/design_1/ip/design_1_ber_test_gen_0_0/design_1_ber_test_gen_0_0_sim_netlist.vhdl
-- Design      : design_1_ber_test_gen_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xczu15eg-ffvb1156-2-i
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_ber_test_gen_0_0 is
  port (
    clk : in STD_LOGIC;
    rst_n : in STD_LOGIC;
    data_i0 : out STD_LOGIC_VECTOR ( 63 downto 0 );
    data_i1 : out STD_LOGIC_VECTOR ( 63 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of design_1_ber_test_gen_0_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of design_1_ber_test_gen_0_0 : entity is "design_1_ber_test_gen_0_0,ber_test_gen,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of design_1_ber_test_gen_0_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of design_1_ber_test_gen_0_0 : entity is "module_ref";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of design_1_ber_test_gen_0_0 : entity is "ber_test_gen,Vivado 2024.2";
end design_1_ber_test_gen_0_0;

architecture STRUCTURE of design_1_ber_test_gen_0_0 is
  signal \<const0>\ : STD_LOGIC;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of clk : signal is "xilinx.com:signal:clock:1.0 clk CLK";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of clk : signal is "slave";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of clk : signal is "XIL_INTERFACENAME clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_zynq_ultra_ps_e_0_0_pl_clk0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of rst_n : signal is "xilinx.com:signal:reset:1.0 rst_n RST";
  attribute X_INTERFACE_MODE of rst_n : signal is "slave";
  attribute X_INTERFACE_PARAMETER of rst_n : signal is "XIL_INTERFACENAME rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0";
begin
  data_i0(63) <= \<const0>\;
  data_i0(62) <= \<const0>\;
  data_i0(61) <= \<const0>\;
  data_i0(60) <= \<const0>\;
  data_i0(59) <= \<const0>\;
  data_i0(58) <= \<const0>\;
  data_i0(57) <= \<const0>\;
  data_i0(56) <= \<const0>\;
  data_i0(55) <= \<const0>\;
  data_i0(54) <= \<const0>\;
  data_i0(53) <= \<const0>\;
  data_i0(52) <= \<const0>\;
  data_i0(51) <= \<const0>\;
  data_i0(50) <= \<const0>\;
  data_i0(49) <= \<const0>\;
  data_i0(48) <= \<const0>\;
  data_i0(47) <= \<const0>\;
  data_i0(46) <= \<const0>\;
  data_i0(45) <= \<const0>\;
  data_i0(44) <= \<const0>\;
  data_i0(43) <= \<const0>\;
  data_i0(42) <= \<const0>\;
  data_i0(41) <= \<const0>\;
  data_i0(40) <= \<const0>\;
  data_i0(39) <= \<const0>\;
  data_i0(38) <= \<const0>\;
  data_i0(37) <= \<const0>\;
  data_i0(36) <= \<const0>\;
  data_i0(35) <= \<const0>\;
  data_i0(34) <= \<const0>\;
  data_i0(33) <= \<const0>\;
  data_i0(32) <= \<const0>\;
  data_i0(31) <= \<const0>\;
  data_i0(30) <= \<const0>\;
  data_i0(29) <= \<const0>\;
  data_i0(28) <= \<const0>\;
  data_i0(27) <= \<const0>\;
  data_i0(26) <= \<const0>\;
  data_i0(25) <= \<const0>\;
  data_i0(24) <= \<const0>\;
  data_i0(23) <= \<const0>\;
  data_i0(22) <= \<const0>\;
  data_i0(21) <= \<const0>\;
  data_i0(20) <= \<const0>\;
  data_i0(19) <= \<const0>\;
  data_i0(18) <= \<const0>\;
  data_i0(17) <= \<const0>\;
  data_i0(16) <= \<const0>\;
  data_i0(15) <= \<const0>\;
  data_i0(14) <= \<const0>\;
  data_i0(13) <= \<const0>\;
  data_i0(12) <= \<const0>\;
  data_i0(11) <= \<const0>\;
  data_i0(10) <= \<const0>\;
  data_i0(9) <= \<const0>\;
  data_i0(8) <= \<const0>\;
  data_i0(7) <= \<const0>\;
  data_i0(6) <= \<const0>\;
  data_i0(5) <= \<const0>\;
  data_i0(4) <= \<const0>\;
  data_i0(3) <= \<const0>\;
  data_i0(2) <= \<const0>\;
  data_i0(1) <= \<const0>\;
  data_i0(0) <= \<const0>\;
  data_i1(63) <= \<const0>\;
  data_i1(62) <= \<const0>\;
  data_i1(61) <= \<const0>\;
  data_i1(60) <= \<const0>\;
  data_i1(59) <= \<const0>\;
  data_i1(58) <= \<const0>\;
  data_i1(57) <= \<const0>\;
  data_i1(56) <= \<const0>\;
  data_i1(55) <= \<const0>\;
  data_i1(54) <= \<const0>\;
  data_i1(53) <= \<const0>\;
  data_i1(52) <= \<const0>\;
  data_i1(51) <= \<const0>\;
  data_i1(50) <= \<const0>\;
  data_i1(49) <= \<const0>\;
  data_i1(48) <= \<const0>\;
  data_i1(47) <= \<const0>\;
  data_i1(46) <= \<const0>\;
  data_i1(45) <= \<const0>\;
  data_i1(44) <= \<const0>\;
  data_i1(43) <= \<const0>\;
  data_i1(42) <= \<const0>\;
  data_i1(41) <= \<const0>\;
  data_i1(40) <= \<const0>\;
  data_i1(39) <= \<const0>\;
  data_i1(38) <= \<const0>\;
  data_i1(37) <= \<const0>\;
  data_i1(36) <= \<const0>\;
  data_i1(35) <= \<const0>\;
  data_i1(34) <= \<const0>\;
  data_i1(33) <= \<const0>\;
  data_i1(32) <= \<const0>\;
  data_i1(31) <= \<const0>\;
  data_i1(30) <= \<const0>\;
  data_i1(29) <= \<const0>\;
  data_i1(28) <= \<const0>\;
  data_i1(27) <= \<const0>\;
  data_i1(26) <= \<const0>\;
  data_i1(25) <= \<const0>\;
  data_i1(24) <= \<const0>\;
  data_i1(23) <= \<const0>\;
  data_i1(22) <= \<const0>\;
  data_i1(21) <= \<const0>\;
  data_i1(20) <= \<const0>\;
  data_i1(19) <= \<const0>\;
  data_i1(18) <= \<const0>\;
  data_i1(17) <= \<const0>\;
  data_i1(16) <= \<const0>\;
  data_i1(15) <= \<const0>\;
  data_i1(14) <= \<const0>\;
  data_i1(13) <= \<const0>\;
  data_i1(12) <= \<const0>\;
  data_i1(11) <= \<const0>\;
  data_i1(10) <= \<const0>\;
  data_i1(9) <= \<const0>\;
  data_i1(8) <= \<const0>\;
  data_i1(7) <= \<const0>\;
  data_i1(6) <= \<const0>\;
  data_i1(5) <= \<const0>\;
  data_i1(4) <= \<const0>\;
  data_i1(3) <= \<const0>\;
  data_i1(2) <= \<const0>\;
  data_i1(1) <= \<const0>\;
  data_i1(0) <= \<const0>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
end STRUCTURE;
