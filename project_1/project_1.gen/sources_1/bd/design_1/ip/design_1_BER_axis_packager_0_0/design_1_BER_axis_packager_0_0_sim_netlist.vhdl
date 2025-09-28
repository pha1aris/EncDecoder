-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
-- Date        : Sat Sep 27 20:14:17 2025
-- Host        : FSO-A running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               c:/Users/PC/Desktop/fps/EnDec/project_1/project_1.gen/sources_1/bd/design_1/ip/design_1_BER_axis_packager_0_0/design_1_BER_axis_packager_0_0_sim_netlist.vhdl
-- Design      : design_1_BER_axis_packager_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xczu15eg-ffvb1156-2-i
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_BER_axis_packager_0_0_BER_axis_packager is
  port (
    M_AXIS_TLAST_reg_0 : out STD_LOGIC;
    M_AXIS_TDATA : out STD_LOGIC_VECTOR ( 127 downto 0 );
    M_AXIS_TREADY : in STD_LOGIC;
    clk : in STD_LOGIC;
    D : in STD_LOGIC_VECTOR ( 127 downto 0 );
    rst_n : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of design_1_BER_axis_packager_0_0_BER_axis_packager : entity is "BER_axis_packager";
end design_1_BER_axis_packager_0_0_BER_axis_packager;

architecture STRUCTURE of design_1_BER_axis_packager_0_0_BER_axis_packager is
  signal \M_AXIS_TDATA[127]_i_1_n_0\ : STD_LOGIC;
  signal \M_AXIS_TDATA[127]_i_2_n_0\ : STD_LOGIC;
  signal M_AXIS_TLAST_i_1_n_0 : STD_LOGIC;
  signal \^m_axis_tlast_reg_0\ : STD_LOGIC;
  signal cycle_cnt : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal \cycle_cnt0_carry__0_n_0\ : STD_LOGIC;
  signal \cycle_cnt0_carry__0_n_1\ : STD_LOGIC;
  signal \cycle_cnt0_carry__0_n_2\ : STD_LOGIC;
  signal \cycle_cnt0_carry__0_n_3\ : STD_LOGIC;
  signal \cycle_cnt0_carry__0_n_4\ : STD_LOGIC;
  signal \cycle_cnt0_carry__0_n_5\ : STD_LOGIC;
  signal \cycle_cnt0_carry__0_n_6\ : STD_LOGIC;
  signal \cycle_cnt0_carry__0_n_7\ : STD_LOGIC;
  signal \cycle_cnt0_carry__1_n_2\ : STD_LOGIC;
  signal \cycle_cnt0_carry__1_n_3\ : STD_LOGIC;
  signal \cycle_cnt0_carry__1_n_4\ : STD_LOGIC;
  signal \cycle_cnt0_carry__1_n_5\ : STD_LOGIC;
  signal \cycle_cnt0_carry__1_n_6\ : STD_LOGIC;
  signal \cycle_cnt0_carry__1_n_7\ : STD_LOGIC;
  signal cycle_cnt0_carry_n_0 : STD_LOGIC;
  signal cycle_cnt0_carry_n_1 : STD_LOGIC;
  signal cycle_cnt0_carry_n_2 : STD_LOGIC;
  signal cycle_cnt0_carry_n_3 : STD_LOGIC;
  signal cycle_cnt0_carry_n_4 : STD_LOGIC;
  signal cycle_cnt0_carry_n_5 : STD_LOGIC;
  signal cycle_cnt0_carry_n_6 : STD_LOGIC;
  signal cycle_cnt0_carry_n_7 : STD_LOGIC;
  signal \cycle_cnt[23]_i_2_n_0\ : STD_LOGIC;
  signal \cycle_cnt[23]_i_3_n_0\ : STD_LOGIC;
  signal \cycle_cnt[23]_i_4_n_0\ : STD_LOGIC;
  signal \cycle_cnt[23]_i_5_n_0\ : STD_LOGIC;
  signal \cycle_cnt[23]_i_6_n_0\ : STD_LOGIC;
  signal \cycle_cnt[23]_i_7_n_0\ : STD_LOGIC;
  signal \cycle_cnt[23]_i_8_n_0\ : STD_LOGIC;
  signal cycle_cnt_0 : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal data0 : STD_LOGIC_VECTOR ( 23 downto 1 );
  signal send_req_i_1_n_0 : STD_LOGIC;
  signal send_req_reg_n_0 : STD_LOGIC;
  signal \NLW_cycle_cnt0_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 6 );
  signal \NLW_cycle_cnt0_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 to 7 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of M_AXIS_TLAST_i_1 : label is "soft_lutpair1";
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of cycle_cnt0_carry : label is 35;
  attribute ADDER_THRESHOLD of \cycle_cnt0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \cycle_cnt0_carry__1\ : label is 35;
  attribute SOFT_HLUTNM of \cycle_cnt[0]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \cycle_cnt[10]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \cycle_cnt[11]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \cycle_cnt[12]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \cycle_cnt[13]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \cycle_cnt[14]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \cycle_cnt[15]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \cycle_cnt[16]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \cycle_cnt[17]_i_1\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \cycle_cnt[18]_i_1\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \cycle_cnt[19]_i_1\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \cycle_cnt[1]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \cycle_cnt[20]_i_1\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \cycle_cnt[21]_i_1\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \cycle_cnt[22]_i_1\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \cycle_cnt[23]_i_8\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \cycle_cnt[2]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \cycle_cnt[3]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \cycle_cnt[4]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \cycle_cnt[5]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \cycle_cnt[6]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \cycle_cnt[7]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \cycle_cnt[8]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \cycle_cnt[9]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of send_req_i_1 : label is "soft_lutpair1";
begin
  M_AXIS_TLAST_reg_0 <= \^m_axis_tlast_reg_0\;
\M_AXIS_TDATA[127]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => send_req_reg_n_0,
      I1 => \^m_axis_tlast_reg_0\,
      O => \M_AXIS_TDATA[127]_i_1_n_0\
    );
\M_AXIS_TDATA[127]_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => rst_n,
      O => \M_AXIS_TDATA[127]_i_2_n_0\
    );
\M_AXIS_TDATA_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(0),
      Q => M_AXIS_TDATA(0)
    );
\M_AXIS_TDATA_reg[100]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(100),
      Q => M_AXIS_TDATA(100)
    );
\M_AXIS_TDATA_reg[101]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(101),
      Q => M_AXIS_TDATA(101)
    );
\M_AXIS_TDATA_reg[102]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(102),
      Q => M_AXIS_TDATA(102)
    );
\M_AXIS_TDATA_reg[103]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(103),
      Q => M_AXIS_TDATA(103)
    );
\M_AXIS_TDATA_reg[104]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(104),
      Q => M_AXIS_TDATA(104)
    );
\M_AXIS_TDATA_reg[105]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(105),
      Q => M_AXIS_TDATA(105)
    );
\M_AXIS_TDATA_reg[106]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(106),
      Q => M_AXIS_TDATA(106)
    );
\M_AXIS_TDATA_reg[107]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(107),
      Q => M_AXIS_TDATA(107)
    );
\M_AXIS_TDATA_reg[108]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(108),
      Q => M_AXIS_TDATA(108)
    );
\M_AXIS_TDATA_reg[109]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(109),
      Q => M_AXIS_TDATA(109)
    );
\M_AXIS_TDATA_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(10),
      Q => M_AXIS_TDATA(10)
    );
\M_AXIS_TDATA_reg[110]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(110),
      Q => M_AXIS_TDATA(110)
    );
\M_AXIS_TDATA_reg[111]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(111),
      Q => M_AXIS_TDATA(111)
    );
\M_AXIS_TDATA_reg[112]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(112),
      Q => M_AXIS_TDATA(112)
    );
\M_AXIS_TDATA_reg[113]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(113),
      Q => M_AXIS_TDATA(113)
    );
\M_AXIS_TDATA_reg[114]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(114),
      Q => M_AXIS_TDATA(114)
    );
\M_AXIS_TDATA_reg[115]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(115),
      Q => M_AXIS_TDATA(115)
    );
\M_AXIS_TDATA_reg[116]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(116),
      Q => M_AXIS_TDATA(116)
    );
\M_AXIS_TDATA_reg[117]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(117),
      Q => M_AXIS_TDATA(117)
    );
\M_AXIS_TDATA_reg[118]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(118),
      Q => M_AXIS_TDATA(118)
    );
\M_AXIS_TDATA_reg[119]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(119),
      Q => M_AXIS_TDATA(119)
    );
\M_AXIS_TDATA_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(11),
      Q => M_AXIS_TDATA(11)
    );
\M_AXIS_TDATA_reg[120]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(120),
      Q => M_AXIS_TDATA(120)
    );
\M_AXIS_TDATA_reg[121]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(121),
      Q => M_AXIS_TDATA(121)
    );
\M_AXIS_TDATA_reg[122]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(122),
      Q => M_AXIS_TDATA(122)
    );
\M_AXIS_TDATA_reg[123]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(123),
      Q => M_AXIS_TDATA(123)
    );
\M_AXIS_TDATA_reg[124]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(124),
      Q => M_AXIS_TDATA(124)
    );
\M_AXIS_TDATA_reg[125]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(125),
      Q => M_AXIS_TDATA(125)
    );
\M_AXIS_TDATA_reg[126]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(126),
      Q => M_AXIS_TDATA(126)
    );
\M_AXIS_TDATA_reg[127]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(127),
      Q => M_AXIS_TDATA(127)
    );
\M_AXIS_TDATA_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(12),
      Q => M_AXIS_TDATA(12)
    );
\M_AXIS_TDATA_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(13),
      Q => M_AXIS_TDATA(13)
    );
\M_AXIS_TDATA_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(14),
      Q => M_AXIS_TDATA(14)
    );
\M_AXIS_TDATA_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(15),
      Q => M_AXIS_TDATA(15)
    );
\M_AXIS_TDATA_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(16),
      Q => M_AXIS_TDATA(16)
    );
\M_AXIS_TDATA_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(17),
      Q => M_AXIS_TDATA(17)
    );
\M_AXIS_TDATA_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(18),
      Q => M_AXIS_TDATA(18)
    );
\M_AXIS_TDATA_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(19),
      Q => M_AXIS_TDATA(19)
    );
\M_AXIS_TDATA_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(1),
      Q => M_AXIS_TDATA(1)
    );
\M_AXIS_TDATA_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(20),
      Q => M_AXIS_TDATA(20)
    );
\M_AXIS_TDATA_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(21),
      Q => M_AXIS_TDATA(21)
    );
\M_AXIS_TDATA_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(22),
      Q => M_AXIS_TDATA(22)
    );
\M_AXIS_TDATA_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(23),
      Q => M_AXIS_TDATA(23)
    );
\M_AXIS_TDATA_reg[24]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(24),
      Q => M_AXIS_TDATA(24)
    );
\M_AXIS_TDATA_reg[25]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(25),
      Q => M_AXIS_TDATA(25)
    );
\M_AXIS_TDATA_reg[26]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(26),
      Q => M_AXIS_TDATA(26)
    );
\M_AXIS_TDATA_reg[27]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(27),
      Q => M_AXIS_TDATA(27)
    );
\M_AXIS_TDATA_reg[28]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(28),
      Q => M_AXIS_TDATA(28)
    );
\M_AXIS_TDATA_reg[29]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(29),
      Q => M_AXIS_TDATA(29)
    );
\M_AXIS_TDATA_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(2),
      Q => M_AXIS_TDATA(2)
    );
\M_AXIS_TDATA_reg[30]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(30),
      Q => M_AXIS_TDATA(30)
    );
\M_AXIS_TDATA_reg[31]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(31),
      Q => M_AXIS_TDATA(31)
    );
\M_AXIS_TDATA_reg[32]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(32),
      Q => M_AXIS_TDATA(32)
    );
\M_AXIS_TDATA_reg[33]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(33),
      Q => M_AXIS_TDATA(33)
    );
\M_AXIS_TDATA_reg[34]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(34),
      Q => M_AXIS_TDATA(34)
    );
\M_AXIS_TDATA_reg[35]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(35),
      Q => M_AXIS_TDATA(35)
    );
\M_AXIS_TDATA_reg[36]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(36),
      Q => M_AXIS_TDATA(36)
    );
\M_AXIS_TDATA_reg[37]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(37),
      Q => M_AXIS_TDATA(37)
    );
\M_AXIS_TDATA_reg[38]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(38),
      Q => M_AXIS_TDATA(38)
    );
\M_AXIS_TDATA_reg[39]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(39),
      Q => M_AXIS_TDATA(39)
    );
\M_AXIS_TDATA_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(3),
      Q => M_AXIS_TDATA(3)
    );
\M_AXIS_TDATA_reg[40]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(40),
      Q => M_AXIS_TDATA(40)
    );
\M_AXIS_TDATA_reg[41]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(41),
      Q => M_AXIS_TDATA(41)
    );
\M_AXIS_TDATA_reg[42]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(42),
      Q => M_AXIS_TDATA(42)
    );
\M_AXIS_TDATA_reg[43]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(43),
      Q => M_AXIS_TDATA(43)
    );
\M_AXIS_TDATA_reg[44]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(44),
      Q => M_AXIS_TDATA(44)
    );
\M_AXIS_TDATA_reg[45]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(45),
      Q => M_AXIS_TDATA(45)
    );
\M_AXIS_TDATA_reg[46]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(46),
      Q => M_AXIS_TDATA(46)
    );
\M_AXIS_TDATA_reg[47]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(47),
      Q => M_AXIS_TDATA(47)
    );
\M_AXIS_TDATA_reg[48]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(48),
      Q => M_AXIS_TDATA(48)
    );
\M_AXIS_TDATA_reg[49]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(49),
      Q => M_AXIS_TDATA(49)
    );
\M_AXIS_TDATA_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(4),
      Q => M_AXIS_TDATA(4)
    );
\M_AXIS_TDATA_reg[50]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(50),
      Q => M_AXIS_TDATA(50)
    );
\M_AXIS_TDATA_reg[51]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(51),
      Q => M_AXIS_TDATA(51)
    );
\M_AXIS_TDATA_reg[52]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(52),
      Q => M_AXIS_TDATA(52)
    );
\M_AXIS_TDATA_reg[53]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(53),
      Q => M_AXIS_TDATA(53)
    );
\M_AXIS_TDATA_reg[54]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(54),
      Q => M_AXIS_TDATA(54)
    );
\M_AXIS_TDATA_reg[55]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(55),
      Q => M_AXIS_TDATA(55)
    );
\M_AXIS_TDATA_reg[56]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(56),
      Q => M_AXIS_TDATA(56)
    );
\M_AXIS_TDATA_reg[57]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(57),
      Q => M_AXIS_TDATA(57)
    );
\M_AXIS_TDATA_reg[58]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(58),
      Q => M_AXIS_TDATA(58)
    );
\M_AXIS_TDATA_reg[59]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(59),
      Q => M_AXIS_TDATA(59)
    );
\M_AXIS_TDATA_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(5),
      Q => M_AXIS_TDATA(5)
    );
\M_AXIS_TDATA_reg[60]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(60),
      Q => M_AXIS_TDATA(60)
    );
\M_AXIS_TDATA_reg[61]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(61),
      Q => M_AXIS_TDATA(61)
    );
\M_AXIS_TDATA_reg[62]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(62),
      Q => M_AXIS_TDATA(62)
    );
\M_AXIS_TDATA_reg[63]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(63),
      Q => M_AXIS_TDATA(63)
    );
\M_AXIS_TDATA_reg[64]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(64),
      Q => M_AXIS_TDATA(64)
    );
\M_AXIS_TDATA_reg[65]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(65),
      Q => M_AXIS_TDATA(65)
    );
\M_AXIS_TDATA_reg[66]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(66),
      Q => M_AXIS_TDATA(66)
    );
\M_AXIS_TDATA_reg[67]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(67),
      Q => M_AXIS_TDATA(67)
    );
\M_AXIS_TDATA_reg[68]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(68),
      Q => M_AXIS_TDATA(68)
    );
\M_AXIS_TDATA_reg[69]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(69),
      Q => M_AXIS_TDATA(69)
    );
\M_AXIS_TDATA_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(6),
      Q => M_AXIS_TDATA(6)
    );
\M_AXIS_TDATA_reg[70]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(70),
      Q => M_AXIS_TDATA(70)
    );
\M_AXIS_TDATA_reg[71]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(71),
      Q => M_AXIS_TDATA(71)
    );
\M_AXIS_TDATA_reg[72]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(72),
      Q => M_AXIS_TDATA(72)
    );
\M_AXIS_TDATA_reg[73]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(73),
      Q => M_AXIS_TDATA(73)
    );
\M_AXIS_TDATA_reg[74]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(74),
      Q => M_AXIS_TDATA(74)
    );
\M_AXIS_TDATA_reg[75]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(75),
      Q => M_AXIS_TDATA(75)
    );
\M_AXIS_TDATA_reg[76]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(76),
      Q => M_AXIS_TDATA(76)
    );
\M_AXIS_TDATA_reg[77]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(77),
      Q => M_AXIS_TDATA(77)
    );
\M_AXIS_TDATA_reg[78]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(78),
      Q => M_AXIS_TDATA(78)
    );
\M_AXIS_TDATA_reg[79]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(79),
      Q => M_AXIS_TDATA(79)
    );
\M_AXIS_TDATA_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(7),
      Q => M_AXIS_TDATA(7)
    );
\M_AXIS_TDATA_reg[80]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(80),
      Q => M_AXIS_TDATA(80)
    );
\M_AXIS_TDATA_reg[81]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(81),
      Q => M_AXIS_TDATA(81)
    );
\M_AXIS_TDATA_reg[82]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(82),
      Q => M_AXIS_TDATA(82)
    );
\M_AXIS_TDATA_reg[83]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(83),
      Q => M_AXIS_TDATA(83)
    );
\M_AXIS_TDATA_reg[84]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(84),
      Q => M_AXIS_TDATA(84)
    );
\M_AXIS_TDATA_reg[85]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(85),
      Q => M_AXIS_TDATA(85)
    );
\M_AXIS_TDATA_reg[86]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(86),
      Q => M_AXIS_TDATA(86)
    );
\M_AXIS_TDATA_reg[87]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(87),
      Q => M_AXIS_TDATA(87)
    );
\M_AXIS_TDATA_reg[88]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(88),
      Q => M_AXIS_TDATA(88)
    );
\M_AXIS_TDATA_reg[89]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(89),
      Q => M_AXIS_TDATA(89)
    );
\M_AXIS_TDATA_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(8),
      Q => M_AXIS_TDATA(8)
    );
\M_AXIS_TDATA_reg[90]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(90),
      Q => M_AXIS_TDATA(90)
    );
\M_AXIS_TDATA_reg[91]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(91),
      Q => M_AXIS_TDATA(91)
    );
\M_AXIS_TDATA_reg[92]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(92),
      Q => M_AXIS_TDATA(92)
    );
\M_AXIS_TDATA_reg[93]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(93),
      Q => M_AXIS_TDATA(93)
    );
\M_AXIS_TDATA_reg[94]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(94),
      Q => M_AXIS_TDATA(94)
    );
\M_AXIS_TDATA_reg[95]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(95),
      Q => M_AXIS_TDATA(95)
    );
\M_AXIS_TDATA_reg[96]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(96),
      Q => M_AXIS_TDATA(96)
    );
\M_AXIS_TDATA_reg[97]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(97),
      Q => M_AXIS_TDATA(97)
    );
\M_AXIS_TDATA_reg[98]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(98),
      Q => M_AXIS_TDATA(98)
    );
\M_AXIS_TDATA_reg[99]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(99),
      Q => M_AXIS_TDATA(99)
    );
\M_AXIS_TDATA_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \M_AXIS_TDATA[127]_i_1_n_0\,
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => D(9),
      Q => M_AXIS_TDATA(9)
    );
M_AXIS_TLAST_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"6E"
    )
        port map (
      I0 => send_req_reg_n_0,
      I1 => \^m_axis_tlast_reg_0\,
      I2 => M_AXIS_TREADY,
      O => M_AXIS_TLAST_i_1_n_0
    );
M_AXIS_TLAST_reg: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => M_AXIS_TLAST_i_1_n_0,
      Q => \^m_axis_tlast_reg_0\
    );
cycle_cnt0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => cycle_cnt(0),
      CI_TOP => '0',
      CO(7) => cycle_cnt0_carry_n_0,
      CO(6) => cycle_cnt0_carry_n_1,
      CO(5) => cycle_cnt0_carry_n_2,
      CO(4) => cycle_cnt0_carry_n_3,
      CO(3) => cycle_cnt0_carry_n_4,
      CO(2) => cycle_cnt0_carry_n_5,
      CO(1) => cycle_cnt0_carry_n_6,
      CO(0) => cycle_cnt0_carry_n_7,
      DI(7 downto 0) => B"00000000",
      O(7 downto 0) => data0(8 downto 1),
      S(7 downto 0) => cycle_cnt(8 downto 1)
    );
\cycle_cnt0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => cycle_cnt0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \cycle_cnt0_carry__0_n_0\,
      CO(6) => \cycle_cnt0_carry__0_n_1\,
      CO(5) => \cycle_cnt0_carry__0_n_2\,
      CO(4) => \cycle_cnt0_carry__0_n_3\,
      CO(3) => \cycle_cnt0_carry__0_n_4\,
      CO(2) => \cycle_cnt0_carry__0_n_5\,
      CO(1) => \cycle_cnt0_carry__0_n_6\,
      CO(0) => \cycle_cnt0_carry__0_n_7\,
      DI(7 downto 0) => B"00000000",
      O(7 downto 0) => data0(16 downto 9),
      S(7 downto 0) => cycle_cnt(16 downto 9)
    );
\cycle_cnt0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \cycle_cnt0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7 downto 6) => \NLW_cycle_cnt0_carry__1_CO_UNCONNECTED\(7 downto 6),
      CO(5) => \cycle_cnt0_carry__1_n_2\,
      CO(4) => \cycle_cnt0_carry__1_n_3\,
      CO(3) => \cycle_cnt0_carry__1_n_4\,
      CO(2) => \cycle_cnt0_carry__1_n_5\,
      CO(1) => \cycle_cnt0_carry__1_n_6\,
      CO(0) => \cycle_cnt0_carry__1_n_7\,
      DI(7 downto 0) => B"00000000",
      O(7) => \NLW_cycle_cnt0_carry__1_O_UNCONNECTED\(7),
      O(6 downto 0) => data0(23 downto 17),
      S(7) => '0',
      S(6 downto 0) => cycle_cnt(23 downto 17)
    );
\cycle_cnt[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => cycle_cnt(0),
      O => cycle_cnt_0(0)
    );
\cycle_cnt[10]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \cycle_cnt[23]_i_2_n_0\,
      I1 => data0(10),
      O => cycle_cnt_0(10)
    );
\cycle_cnt[11]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \cycle_cnt[23]_i_2_n_0\,
      I1 => data0(11),
      O => cycle_cnt_0(11)
    );
\cycle_cnt[12]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \cycle_cnt[23]_i_2_n_0\,
      I1 => data0(12),
      O => cycle_cnt_0(12)
    );
\cycle_cnt[13]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \cycle_cnt[23]_i_2_n_0\,
      I1 => data0(13),
      O => cycle_cnt_0(13)
    );
\cycle_cnt[14]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \cycle_cnt[23]_i_2_n_0\,
      I1 => data0(14),
      O => cycle_cnt_0(14)
    );
\cycle_cnt[15]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \cycle_cnt[23]_i_2_n_0\,
      I1 => data0(15),
      O => cycle_cnt_0(15)
    );
\cycle_cnt[16]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \cycle_cnt[23]_i_2_n_0\,
      I1 => data0(16),
      O => cycle_cnt_0(16)
    );
\cycle_cnt[17]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \cycle_cnt[23]_i_2_n_0\,
      I1 => data0(17),
      O => cycle_cnt_0(17)
    );
\cycle_cnt[18]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \cycle_cnt[23]_i_2_n_0\,
      I1 => data0(18),
      O => cycle_cnt_0(18)
    );
\cycle_cnt[19]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \cycle_cnt[23]_i_2_n_0\,
      I1 => data0(19),
      O => cycle_cnt_0(19)
    );
\cycle_cnt[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \cycle_cnt[23]_i_2_n_0\,
      I1 => data0(1),
      O => cycle_cnt_0(1)
    );
\cycle_cnt[20]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \cycle_cnt[23]_i_2_n_0\,
      I1 => data0(20),
      O => cycle_cnt_0(20)
    );
\cycle_cnt[21]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \cycle_cnt[23]_i_2_n_0\,
      I1 => data0(21),
      O => cycle_cnt_0(21)
    );
\cycle_cnt[22]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \cycle_cnt[23]_i_2_n_0\,
      I1 => data0(22),
      O => cycle_cnt_0(22)
    );
\cycle_cnt[23]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \cycle_cnt[23]_i_2_n_0\,
      I1 => data0(23),
      O => cycle_cnt_0(23)
    );
\cycle_cnt[23]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => \cycle_cnt[23]_i_3_n_0\,
      I1 => \cycle_cnt[23]_i_4_n_0\,
      I2 => \cycle_cnt[23]_i_5_n_0\,
      I3 => \cycle_cnt[23]_i_6_n_0\,
      I4 => \cycle_cnt[23]_i_7_n_0\,
      I5 => \cycle_cnt[23]_i_8_n_0\,
      O => \cycle_cnt[23]_i_2_n_0\
    );
\cycle_cnt[23]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFEF"
    )
        port map (
      I0 => cycle_cnt(17),
      I1 => cycle_cnt(16),
      I2 => cycle_cnt(19),
      I3 => cycle_cnt(18),
      O => \cycle_cnt[23]_i_3_n_0\
    );
\cycle_cnt[23]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFDF"
    )
        port map (
      I0 => cycle_cnt(20),
      I1 => cycle_cnt(21),
      I2 => cycle_cnt(23),
      I3 => cycle_cnt(22),
      O => \cycle_cnt[23]_i_4_n_0\
    );
\cycle_cnt[23]_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFDF"
    )
        port map (
      I0 => cycle_cnt(9),
      I1 => cycle_cnt(8),
      I2 => cycle_cnt(10),
      I3 => cycle_cnt(11),
      O => \cycle_cnt[23]_i_5_n_0\
    );
\cycle_cnt[23]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFDF"
    )
        port map (
      I0 => cycle_cnt(12),
      I1 => cycle_cnt(13),
      I2 => cycle_cnt(15),
      I3 => cycle_cnt(14),
      O => \cycle_cnt[23]_i_6_n_0\
    );
\cycle_cnt[23]_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FF7F"
    )
        port map (
      I0 => cycle_cnt(5),
      I1 => cycle_cnt(4),
      I2 => cycle_cnt(6),
      I3 => cycle_cnt(7),
      O => \cycle_cnt[23]_i_7_n_0\
    );
\cycle_cnt[23]_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => cycle_cnt(1),
      I1 => cycle_cnt(0),
      I2 => cycle_cnt(3),
      I3 => cycle_cnt(2),
      O => \cycle_cnt[23]_i_8_n_0\
    );
\cycle_cnt[2]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \cycle_cnt[23]_i_2_n_0\,
      I1 => data0(2),
      O => cycle_cnt_0(2)
    );
\cycle_cnt[3]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \cycle_cnt[23]_i_2_n_0\,
      I1 => data0(3),
      O => cycle_cnt_0(3)
    );
\cycle_cnt[4]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \cycle_cnt[23]_i_2_n_0\,
      I1 => data0(4),
      O => cycle_cnt_0(4)
    );
\cycle_cnt[5]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \cycle_cnt[23]_i_2_n_0\,
      I1 => data0(5),
      O => cycle_cnt_0(5)
    );
\cycle_cnt[6]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \cycle_cnt[23]_i_2_n_0\,
      I1 => data0(6),
      O => cycle_cnt_0(6)
    );
\cycle_cnt[7]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \cycle_cnt[23]_i_2_n_0\,
      I1 => data0(7),
      O => cycle_cnt_0(7)
    );
\cycle_cnt[8]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \cycle_cnt[23]_i_2_n_0\,
      I1 => data0(8),
      O => cycle_cnt_0(8)
    );
\cycle_cnt[9]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \cycle_cnt[23]_i_2_n_0\,
      I1 => data0(9),
      O => cycle_cnt_0(9)
    );
\cycle_cnt_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => cycle_cnt_0(0),
      Q => cycle_cnt(0)
    );
\cycle_cnt_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => cycle_cnt_0(10),
      Q => cycle_cnt(10)
    );
\cycle_cnt_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => cycle_cnt_0(11),
      Q => cycle_cnt(11)
    );
\cycle_cnt_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => cycle_cnt_0(12),
      Q => cycle_cnt(12)
    );
\cycle_cnt_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => cycle_cnt_0(13),
      Q => cycle_cnt(13)
    );
\cycle_cnt_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => cycle_cnt_0(14),
      Q => cycle_cnt(14)
    );
\cycle_cnt_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => cycle_cnt_0(15),
      Q => cycle_cnt(15)
    );
\cycle_cnt_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => cycle_cnt_0(16),
      Q => cycle_cnt(16)
    );
\cycle_cnt_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => cycle_cnt_0(17),
      Q => cycle_cnt(17)
    );
\cycle_cnt_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => cycle_cnt_0(18),
      Q => cycle_cnt(18)
    );
\cycle_cnt_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => cycle_cnt_0(19),
      Q => cycle_cnt(19)
    );
\cycle_cnt_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => cycle_cnt_0(1),
      Q => cycle_cnt(1)
    );
\cycle_cnt_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => cycle_cnt_0(20),
      Q => cycle_cnt(20)
    );
\cycle_cnt_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => cycle_cnt_0(21),
      Q => cycle_cnt(21)
    );
\cycle_cnt_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => cycle_cnt_0(22),
      Q => cycle_cnt(22)
    );
\cycle_cnt_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => cycle_cnt_0(23),
      Q => cycle_cnt(23)
    );
\cycle_cnt_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => cycle_cnt_0(2),
      Q => cycle_cnt(2)
    );
\cycle_cnt_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => cycle_cnt_0(3),
      Q => cycle_cnt(3)
    );
\cycle_cnt_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => cycle_cnt_0(4),
      Q => cycle_cnt(4)
    );
\cycle_cnt_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => cycle_cnt_0(5),
      Q => cycle_cnt(5)
    );
\cycle_cnt_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => cycle_cnt_0(6),
      Q => cycle_cnt(6)
    );
\cycle_cnt_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => cycle_cnt_0(7),
      Q => cycle_cnt(7)
    );
\cycle_cnt_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => cycle_cnt_0(8),
      Q => cycle_cnt(8)
    );
\cycle_cnt_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => cycle_cnt_0(9),
      Q => cycle_cnt(9)
    );
send_req_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4C7F"
    )
        port map (
      I0 => M_AXIS_TREADY,
      I1 => send_req_reg_n_0,
      I2 => \^m_axis_tlast_reg_0\,
      I3 => \cycle_cnt[23]_i_2_n_0\,
      O => send_req_i_1_n_0
    );
send_req_reg: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => \M_AXIS_TDATA[127]_i_2_n_0\,
      D => send_req_i_1_n_0,
      Q => send_req_reg_n_0
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_BER_axis_packager_0_0 is
  port (
    clk : in STD_LOGIC;
    rst_n : in STD_LOGIC;
    data_i0 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    data_i1 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    M_AXIS_TDATA : out STD_LOGIC_VECTOR ( 127 downto 0 );
    M_AXIS_TVALID : out STD_LOGIC;
    M_AXIS_TREADY : in STD_LOGIC;
    M_AXIS_TLAST : out STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of design_1_BER_axis_packager_0_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of design_1_BER_axis_packager_0_0 : entity is "design_1_BER_axis_packager_0_0,BER_axis_packager,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of design_1_BER_axis_packager_0_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of design_1_BER_axis_packager_0_0 : entity is "module_ref";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of design_1_BER_axis_packager_0_0 : entity is "BER_axis_packager,Vivado 2024.2";
end design_1_BER_axis_packager_0_0;

architecture STRUCTURE of design_1_BER_axis_packager_0_0 is
  signal \^m_axis_tvalid\ : STD_LOGIC;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of M_AXIS_TLAST : signal is "xilinx.com:interface:axis:1.0 M_AXIS TLAST";
  attribute X_INTERFACE_INFO of M_AXIS_TREADY : signal is "xilinx.com:interface:axis:1.0 M_AXIS TREADY";
  attribute X_INTERFACE_INFO of M_AXIS_TVALID : signal is "xilinx.com:interface:axis:1.0 M_AXIS TVALID";
  attribute X_INTERFACE_INFO of clk : signal is "xilinx.com:signal:clock:1.0 clk CLK";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of clk : signal is "slave";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of clk : signal is "XIL_INTERFACENAME clk, ASSOCIATED_BUSIF M_AXIS, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_zynq_ultra_ps_e_0_0_pl_clk0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of rst_n : signal is "xilinx.com:signal:reset:1.0 rst_n RST";
  attribute X_INTERFACE_MODE of rst_n : signal is "slave";
  attribute X_INTERFACE_PARAMETER of rst_n : signal is "XIL_INTERFACENAME rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of M_AXIS_TDATA : signal is "xilinx.com:interface:axis:1.0 M_AXIS TDATA";
  attribute X_INTERFACE_MODE of M_AXIS_TDATA : signal is "master";
  attribute X_INTERFACE_PARAMETER of M_AXIS_TDATA : signal is "XIL_INTERFACENAME M_AXIS, TDATA_NUM_BYTES 16, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN design_1_zynq_ultra_ps_e_0_0_pl_clk0, LAYERED_METADATA undef, INSERT_VIP 0";
begin
  M_AXIS_TLAST <= \^m_axis_tvalid\;
  M_AXIS_TVALID <= \^m_axis_tvalid\;
inst: entity work.design_1_BER_axis_packager_0_0_BER_axis_packager
     port map (
      D(127 downto 64) => data_i0(63 downto 0),
      D(63 downto 0) => data_i1(63 downto 0),
      M_AXIS_TDATA(127 downto 0) => M_AXIS_TDATA(127 downto 0),
      M_AXIS_TLAST_reg_0 => \^m_axis_tvalid\,
      M_AXIS_TREADY => M_AXIS_TREADY,
      clk => clk,
      rst_n => rst_n
    );
end STRUCTURE;
