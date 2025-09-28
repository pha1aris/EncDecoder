// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Sat Sep 27 20:14:17 2025
// Host        : FSO-A running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/PC/Desktop/fps/EnDec/project_1/project_1.gen/sources_1/bd/design_1/ip/design_1_BER_axis_packager_0_0/design_1_BER_axis_packager_0_0_sim_netlist.v
// Design      : design_1_BER_axis_packager_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu15eg-ffvb1156-2-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "design_1_BER_axis_packager_0_0,BER_axis_packager,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "module_ref" *) 
(* X_CORE_INFO = "BER_axis_packager,Vivado 2024.2" *) 
(* NotValidForBitStream *)
module design_1_BER_axis_packager_0_0
   (clk,
    rst_n,
    data_i0,
    data_i1,
    M_AXIS_TDATA,
    M_AXIS_TVALID,
    M_AXIS_TREADY,
    M_AXIS_TLAST);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, ASSOCIATED_BUSIF M_AXIS, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_zynq_ultra_ps_e_0_0_pl_clk0, INSERT_VIP 0" *) input clk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rst_n RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input rst_n;
  input [63:0]data_i0;
  input [63:0]data_i1;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TDATA" *) (* X_INTERFACE_MODE = "master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXIS, TDATA_NUM_BYTES 16, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN design_1_zynq_ultra_ps_e_0_0_pl_clk0, LAYERED_METADATA undef, INSERT_VIP 0" *) output [127:0]M_AXIS_TDATA;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TVALID" *) output M_AXIS_TVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TREADY" *) input M_AXIS_TREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TLAST" *) output M_AXIS_TLAST;

  wire [127:0]M_AXIS_TDATA;
  wire M_AXIS_TREADY;
  wire M_AXIS_TVALID;
  wire clk;
  wire [63:0]data_i0;
  wire [63:0]data_i1;
  wire rst_n;

  assign M_AXIS_TLAST = M_AXIS_TVALID;
  design_1_BER_axis_packager_0_0_BER_axis_packager inst
       (.D({data_i0,data_i1}),
        .M_AXIS_TDATA(M_AXIS_TDATA),
        .M_AXIS_TLAST_reg_0(M_AXIS_TVALID),
        .M_AXIS_TREADY(M_AXIS_TREADY),
        .clk(clk),
        .rst_n(rst_n));
endmodule

(* ORIG_REF_NAME = "BER_axis_packager" *) 
module design_1_BER_axis_packager_0_0_BER_axis_packager
   (M_AXIS_TLAST_reg_0,
    M_AXIS_TDATA,
    M_AXIS_TREADY,
    clk,
    D,
    rst_n);
  output M_AXIS_TLAST_reg_0;
  output [127:0]M_AXIS_TDATA;
  input M_AXIS_TREADY;
  input clk;
  input [127:0]D;
  input rst_n;

  wire [127:0]D;
  wire [127:0]M_AXIS_TDATA;
  wire \M_AXIS_TDATA[127]_i_1_n_0 ;
  wire \M_AXIS_TDATA[127]_i_2_n_0 ;
  wire M_AXIS_TLAST_i_1_n_0;
  wire M_AXIS_TLAST_reg_0;
  wire M_AXIS_TREADY;
  wire clk;
  wire [23:0]cycle_cnt;
  wire cycle_cnt0_carry__0_n_0;
  wire cycle_cnt0_carry__0_n_1;
  wire cycle_cnt0_carry__0_n_2;
  wire cycle_cnt0_carry__0_n_3;
  wire cycle_cnt0_carry__0_n_4;
  wire cycle_cnt0_carry__0_n_5;
  wire cycle_cnt0_carry__0_n_6;
  wire cycle_cnt0_carry__0_n_7;
  wire cycle_cnt0_carry__1_n_2;
  wire cycle_cnt0_carry__1_n_3;
  wire cycle_cnt0_carry__1_n_4;
  wire cycle_cnt0_carry__1_n_5;
  wire cycle_cnt0_carry__1_n_6;
  wire cycle_cnt0_carry__1_n_7;
  wire cycle_cnt0_carry_n_0;
  wire cycle_cnt0_carry_n_1;
  wire cycle_cnt0_carry_n_2;
  wire cycle_cnt0_carry_n_3;
  wire cycle_cnt0_carry_n_4;
  wire cycle_cnt0_carry_n_5;
  wire cycle_cnt0_carry_n_6;
  wire cycle_cnt0_carry_n_7;
  wire \cycle_cnt[23]_i_2_n_0 ;
  wire \cycle_cnt[23]_i_3_n_0 ;
  wire \cycle_cnt[23]_i_4_n_0 ;
  wire \cycle_cnt[23]_i_5_n_0 ;
  wire \cycle_cnt[23]_i_6_n_0 ;
  wire \cycle_cnt[23]_i_7_n_0 ;
  wire \cycle_cnt[23]_i_8_n_0 ;
  wire [23:0]cycle_cnt_0;
  wire [23:1]data0;
  wire rst_n;
  wire send_req_i_1_n_0;
  wire send_req_reg_n_0;
  wire [7:6]NLW_cycle_cnt0_carry__1_CO_UNCONNECTED;
  wire [7:7]NLW_cycle_cnt0_carry__1_O_UNCONNECTED;

  LUT2 #(
    .INIT(4'h2)) 
    \M_AXIS_TDATA[127]_i_1 
       (.I0(send_req_reg_n_0),
        .I1(M_AXIS_TLAST_reg_0),
        .O(\M_AXIS_TDATA[127]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \M_AXIS_TDATA[127]_i_2 
       (.I0(rst_n),
        .O(\M_AXIS_TDATA[127]_i_2_n_0 ));
  FDCE \M_AXIS_TDATA_reg[0] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[0]),
        .Q(M_AXIS_TDATA[0]));
  FDCE \M_AXIS_TDATA_reg[100] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[100]),
        .Q(M_AXIS_TDATA[100]));
  FDCE \M_AXIS_TDATA_reg[101] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[101]),
        .Q(M_AXIS_TDATA[101]));
  FDCE \M_AXIS_TDATA_reg[102] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[102]),
        .Q(M_AXIS_TDATA[102]));
  FDCE \M_AXIS_TDATA_reg[103] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[103]),
        .Q(M_AXIS_TDATA[103]));
  FDCE \M_AXIS_TDATA_reg[104] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[104]),
        .Q(M_AXIS_TDATA[104]));
  FDCE \M_AXIS_TDATA_reg[105] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[105]),
        .Q(M_AXIS_TDATA[105]));
  FDCE \M_AXIS_TDATA_reg[106] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[106]),
        .Q(M_AXIS_TDATA[106]));
  FDCE \M_AXIS_TDATA_reg[107] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[107]),
        .Q(M_AXIS_TDATA[107]));
  FDCE \M_AXIS_TDATA_reg[108] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[108]),
        .Q(M_AXIS_TDATA[108]));
  FDCE \M_AXIS_TDATA_reg[109] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[109]),
        .Q(M_AXIS_TDATA[109]));
  FDCE \M_AXIS_TDATA_reg[10] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[10]),
        .Q(M_AXIS_TDATA[10]));
  FDCE \M_AXIS_TDATA_reg[110] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[110]),
        .Q(M_AXIS_TDATA[110]));
  FDCE \M_AXIS_TDATA_reg[111] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[111]),
        .Q(M_AXIS_TDATA[111]));
  FDCE \M_AXIS_TDATA_reg[112] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[112]),
        .Q(M_AXIS_TDATA[112]));
  FDCE \M_AXIS_TDATA_reg[113] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[113]),
        .Q(M_AXIS_TDATA[113]));
  FDCE \M_AXIS_TDATA_reg[114] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[114]),
        .Q(M_AXIS_TDATA[114]));
  FDCE \M_AXIS_TDATA_reg[115] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[115]),
        .Q(M_AXIS_TDATA[115]));
  FDCE \M_AXIS_TDATA_reg[116] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[116]),
        .Q(M_AXIS_TDATA[116]));
  FDCE \M_AXIS_TDATA_reg[117] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[117]),
        .Q(M_AXIS_TDATA[117]));
  FDCE \M_AXIS_TDATA_reg[118] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[118]),
        .Q(M_AXIS_TDATA[118]));
  FDCE \M_AXIS_TDATA_reg[119] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[119]),
        .Q(M_AXIS_TDATA[119]));
  FDCE \M_AXIS_TDATA_reg[11] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[11]),
        .Q(M_AXIS_TDATA[11]));
  FDCE \M_AXIS_TDATA_reg[120] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[120]),
        .Q(M_AXIS_TDATA[120]));
  FDCE \M_AXIS_TDATA_reg[121] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[121]),
        .Q(M_AXIS_TDATA[121]));
  FDCE \M_AXIS_TDATA_reg[122] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[122]),
        .Q(M_AXIS_TDATA[122]));
  FDCE \M_AXIS_TDATA_reg[123] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[123]),
        .Q(M_AXIS_TDATA[123]));
  FDCE \M_AXIS_TDATA_reg[124] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[124]),
        .Q(M_AXIS_TDATA[124]));
  FDCE \M_AXIS_TDATA_reg[125] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[125]),
        .Q(M_AXIS_TDATA[125]));
  FDCE \M_AXIS_TDATA_reg[126] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[126]),
        .Q(M_AXIS_TDATA[126]));
  FDCE \M_AXIS_TDATA_reg[127] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[127]),
        .Q(M_AXIS_TDATA[127]));
  FDCE \M_AXIS_TDATA_reg[12] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[12]),
        .Q(M_AXIS_TDATA[12]));
  FDCE \M_AXIS_TDATA_reg[13] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[13]),
        .Q(M_AXIS_TDATA[13]));
  FDCE \M_AXIS_TDATA_reg[14] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[14]),
        .Q(M_AXIS_TDATA[14]));
  FDCE \M_AXIS_TDATA_reg[15] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[15]),
        .Q(M_AXIS_TDATA[15]));
  FDCE \M_AXIS_TDATA_reg[16] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[16]),
        .Q(M_AXIS_TDATA[16]));
  FDCE \M_AXIS_TDATA_reg[17] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[17]),
        .Q(M_AXIS_TDATA[17]));
  FDCE \M_AXIS_TDATA_reg[18] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[18]),
        .Q(M_AXIS_TDATA[18]));
  FDCE \M_AXIS_TDATA_reg[19] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[19]),
        .Q(M_AXIS_TDATA[19]));
  FDCE \M_AXIS_TDATA_reg[1] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[1]),
        .Q(M_AXIS_TDATA[1]));
  FDCE \M_AXIS_TDATA_reg[20] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[20]),
        .Q(M_AXIS_TDATA[20]));
  FDCE \M_AXIS_TDATA_reg[21] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[21]),
        .Q(M_AXIS_TDATA[21]));
  FDCE \M_AXIS_TDATA_reg[22] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[22]),
        .Q(M_AXIS_TDATA[22]));
  FDCE \M_AXIS_TDATA_reg[23] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[23]),
        .Q(M_AXIS_TDATA[23]));
  FDCE \M_AXIS_TDATA_reg[24] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[24]),
        .Q(M_AXIS_TDATA[24]));
  FDCE \M_AXIS_TDATA_reg[25] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[25]),
        .Q(M_AXIS_TDATA[25]));
  FDCE \M_AXIS_TDATA_reg[26] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[26]),
        .Q(M_AXIS_TDATA[26]));
  FDCE \M_AXIS_TDATA_reg[27] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[27]),
        .Q(M_AXIS_TDATA[27]));
  FDCE \M_AXIS_TDATA_reg[28] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[28]),
        .Q(M_AXIS_TDATA[28]));
  FDCE \M_AXIS_TDATA_reg[29] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[29]),
        .Q(M_AXIS_TDATA[29]));
  FDCE \M_AXIS_TDATA_reg[2] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[2]),
        .Q(M_AXIS_TDATA[2]));
  FDCE \M_AXIS_TDATA_reg[30] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[30]),
        .Q(M_AXIS_TDATA[30]));
  FDCE \M_AXIS_TDATA_reg[31] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[31]),
        .Q(M_AXIS_TDATA[31]));
  FDCE \M_AXIS_TDATA_reg[32] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[32]),
        .Q(M_AXIS_TDATA[32]));
  FDCE \M_AXIS_TDATA_reg[33] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[33]),
        .Q(M_AXIS_TDATA[33]));
  FDCE \M_AXIS_TDATA_reg[34] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[34]),
        .Q(M_AXIS_TDATA[34]));
  FDCE \M_AXIS_TDATA_reg[35] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[35]),
        .Q(M_AXIS_TDATA[35]));
  FDCE \M_AXIS_TDATA_reg[36] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[36]),
        .Q(M_AXIS_TDATA[36]));
  FDCE \M_AXIS_TDATA_reg[37] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[37]),
        .Q(M_AXIS_TDATA[37]));
  FDCE \M_AXIS_TDATA_reg[38] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[38]),
        .Q(M_AXIS_TDATA[38]));
  FDCE \M_AXIS_TDATA_reg[39] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[39]),
        .Q(M_AXIS_TDATA[39]));
  FDCE \M_AXIS_TDATA_reg[3] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[3]),
        .Q(M_AXIS_TDATA[3]));
  FDCE \M_AXIS_TDATA_reg[40] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[40]),
        .Q(M_AXIS_TDATA[40]));
  FDCE \M_AXIS_TDATA_reg[41] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[41]),
        .Q(M_AXIS_TDATA[41]));
  FDCE \M_AXIS_TDATA_reg[42] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[42]),
        .Q(M_AXIS_TDATA[42]));
  FDCE \M_AXIS_TDATA_reg[43] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[43]),
        .Q(M_AXIS_TDATA[43]));
  FDCE \M_AXIS_TDATA_reg[44] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[44]),
        .Q(M_AXIS_TDATA[44]));
  FDCE \M_AXIS_TDATA_reg[45] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[45]),
        .Q(M_AXIS_TDATA[45]));
  FDCE \M_AXIS_TDATA_reg[46] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[46]),
        .Q(M_AXIS_TDATA[46]));
  FDCE \M_AXIS_TDATA_reg[47] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[47]),
        .Q(M_AXIS_TDATA[47]));
  FDCE \M_AXIS_TDATA_reg[48] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[48]),
        .Q(M_AXIS_TDATA[48]));
  FDCE \M_AXIS_TDATA_reg[49] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[49]),
        .Q(M_AXIS_TDATA[49]));
  FDCE \M_AXIS_TDATA_reg[4] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[4]),
        .Q(M_AXIS_TDATA[4]));
  FDCE \M_AXIS_TDATA_reg[50] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[50]),
        .Q(M_AXIS_TDATA[50]));
  FDCE \M_AXIS_TDATA_reg[51] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[51]),
        .Q(M_AXIS_TDATA[51]));
  FDCE \M_AXIS_TDATA_reg[52] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[52]),
        .Q(M_AXIS_TDATA[52]));
  FDCE \M_AXIS_TDATA_reg[53] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[53]),
        .Q(M_AXIS_TDATA[53]));
  FDCE \M_AXIS_TDATA_reg[54] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[54]),
        .Q(M_AXIS_TDATA[54]));
  FDCE \M_AXIS_TDATA_reg[55] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[55]),
        .Q(M_AXIS_TDATA[55]));
  FDCE \M_AXIS_TDATA_reg[56] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[56]),
        .Q(M_AXIS_TDATA[56]));
  FDCE \M_AXIS_TDATA_reg[57] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[57]),
        .Q(M_AXIS_TDATA[57]));
  FDCE \M_AXIS_TDATA_reg[58] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[58]),
        .Q(M_AXIS_TDATA[58]));
  FDCE \M_AXIS_TDATA_reg[59] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[59]),
        .Q(M_AXIS_TDATA[59]));
  FDCE \M_AXIS_TDATA_reg[5] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[5]),
        .Q(M_AXIS_TDATA[5]));
  FDCE \M_AXIS_TDATA_reg[60] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[60]),
        .Q(M_AXIS_TDATA[60]));
  FDCE \M_AXIS_TDATA_reg[61] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[61]),
        .Q(M_AXIS_TDATA[61]));
  FDCE \M_AXIS_TDATA_reg[62] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[62]),
        .Q(M_AXIS_TDATA[62]));
  FDCE \M_AXIS_TDATA_reg[63] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[63]),
        .Q(M_AXIS_TDATA[63]));
  FDCE \M_AXIS_TDATA_reg[64] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[64]),
        .Q(M_AXIS_TDATA[64]));
  FDCE \M_AXIS_TDATA_reg[65] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[65]),
        .Q(M_AXIS_TDATA[65]));
  FDCE \M_AXIS_TDATA_reg[66] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[66]),
        .Q(M_AXIS_TDATA[66]));
  FDCE \M_AXIS_TDATA_reg[67] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[67]),
        .Q(M_AXIS_TDATA[67]));
  FDCE \M_AXIS_TDATA_reg[68] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[68]),
        .Q(M_AXIS_TDATA[68]));
  FDCE \M_AXIS_TDATA_reg[69] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[69]),
        .Q(M_AXIS_TDATA[69]));
  FDCE \M_AXIS_TDATA_reg[6] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[6]),
        .Q(M_AXIS_TDATA[6]));
  FDCE \M_AXIS_TDATA_reg[70] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[70]),
        .Q(M_AXIS_TDATA[70]));
  FDCE \M_AXIS_TDATA_reg[71] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[71]),
        .Q(M_AXIS_TDATA[71]));
  FDCE \M_AXIS_TDATA_reg[72] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[72]),
        .Q(M_AXIS_TDATA[72]));
  FDCE \M_AXIS_TDATA_reg[73] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[73]),
        .Q(M_AXIS_TDATA[73]));
  FDCE \M_AXIS_TDATA_reg[74] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[74]),
        .Q(M_AXIS_TDATA[74]));
  FDCE \M_AXIS_TDATA_reg[75] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[75]),
        .Q(M_AXIS_TDATA[75]));
  FDCE \M_AXIS_TDATA_reg[76] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[76]),
        .Q(M_AXIS_TDATA[76]));
  FDCE \M_AXIS_TDATA_reg[77] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[77]),
        .Q(M_AXIS_TDATA[77]));
  FDCE \M_AXIS_TDATA_reg[78] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[78]),
        .Q(M_AXIS_TDATA[78]));
  FDCE \M_AXIS_TDATA_reg[79] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[79]),
        .Q(M_AXIS_TDATA[79]));
  FDCE \M_AXIS_TDATA_reg[7] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[7]),
        .Q(M_AXIS_TDATA[7]));
  FDCE \M_AXIS_TDATA_reg[80] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[80]),
        .Q(M_AXIS_TDATA[80]));
  FDCE \M_AXIS_TDATA_reg[81] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[81]),
        .Q(M_AXIS_TDATA[81]));
  FDCE \M_AXIS_TDATA_reg[82] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[82]),
        .Q(M_AXIS_TDATA[82]));
  FDCE \M_AXIS_TDATA_reg[83] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[83]),
        .Q(M_AXIS_TDATA[83]));
  FDCE \M_AXIS_TDATA_reg[84] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[84]),
        .Q(M_AXIS_TDATA[84]));
  FDCE \M_AXIS_TDATA_reg[85] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[85]),
        .Q(M_AXIS_TDATA[85]));
  FDCE \M_AXIS_TDATA_reg[86] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[86]),
        .Q(M_AXIS_TDATA[86]));
  FDCE \M_AXIS_TDATA_reg[87] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[87]),
        .Q(M_AXIS_TDATA[87]));
  FDCE \M_AXIS_TDATA_reg[88] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[88]),
        .Q(M_AXIS_TDATA[88]));
  FDCE \M_AXIS_TDATA_reg[89] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[89]),
        .Q(M_AXIS_TDATA[89]));
  FDCE \M_AXIS_TDATA_reg[8] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[8]),
        .Q(M_AXIS_TDATA[8]));
  FDCE \M_AXIS_TDATA_reg[90] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[90]),
        .Q(M_AXIS_TDATA[90]));
  FDCE \M_AXIS_TDATA_reg[91] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[91]),
        .Q(M_AXIS_TDATA[91]));
  FDCE \M_AXIS_TDATA_reg[92] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[92]),
        .Q(M_AXIS_TDATA[92]));
  FDCE \M_AXIS_TDATA_reg[93] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[93]),
        .Q(M_AXIS_TDATA[93]));
  FDCE \M_AXIS_TDATA_reg[94] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[94]),
        .Q(M_AXIS_TDATA[94]));
  FDCE \M_AXIS_TDATA_reg[95] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[95]),
        .Q(M_AXIS_TDATA[95]));
  FDCE \M_AXIS_TDATA_reg[96] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[96]),
        .Q(M_AXIS_TDATA[96]));
  FDCE \M_AXIS_TDATA_reg[97] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[97]),
        .Q(M_AXIS_TDATA[97]));
  FDCE \M_AXIS_TDATA_reg[98] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[98]),
        .Q(M_AXIS_TDATA[98]));
  FDCE \M_AXIS_TDATA_reg[99] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[99]),
        .Q(M_AXIS_TDATA[99]));
  FDCE \M_AXIS_TDATA_reg[9] 
       (.C(clk),
        .CE(\M_AXIS_TDATA[127]_i_1_n_0 ),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(D[9]),
        .Q(M_AXIS_TDATA[9]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h6E)) 
    M_AXIS_TLAST_i_1
       (.I0(send_req_reg_n_0),
        .I1(M_AXIS_TLAST_reg_0),
        .I2(M_AXIS_TREADY),
        .O(M_AXIS_TLAST_i_1_n_0));
  FDCE M_AXIS_TLAST_reg
       (.C(clk),
        .CE(1'b1),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(M_AXIS_TLAST_i_1_n_0),
        .Q(M_AXIS_TLAST_reg_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY8 cycle_cnt0_carry
       (.CI(cycle_cnt[0]),
        .CI_TOP(1'b0),
        .CO({cycle_cnt0_carry_n_0,cycle_cnt0_carry_n_1,cycle_cnt0_carry_n_2,cycle_cnt0_carry_n_3,cycle_cnt0_carry_n_4,cycle_cnt0_carry_n_5,cycle_cnt0_carry_n_6,cycle_cnt0_carry_n_7}),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O(data0[8:1]),
        .S(cycle_cnt[8:1]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY8 cycle_cnt0_carry__0
       (.CI(cycle_cnt0_carry_n_0),
        .CI_TOP(1'b0),
        .CO({cycle_cnt0_carry__0_n_0,cycle_cnt0_carry__0_n_1,cycle_cnt0_carry__0_n_2,cycle_cnt0_carry__0_n_3,cycle_cnt0_carry__0_n_4,cycle_cnt0_carry__0_n_5,cycle_cnt0_carry__0_n_6,cycle_cnt0_carry__0_n_7}),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O(data0[16:9]),
        .S(cycle_cnt[16:9]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY8 cycle_cnt0_carry__1
       (.CI(cycle_cnt0_carry__0_n_0),
        .CI_TOP(1'b0),
        .CO({NLW_cycle_cnt0_carry__1_CO_UNCONNECTED[7:6],cycle_cnt0_carry__1_n_2,cycle_cnt0_carry__1_n_3,cycle_cnt0_carry__1_n_4,cycle_cnt0_carry__1_n_5,cycle_cnt0_carry__1_n_6,cycle_cnt0_carry__1_n_7}),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O({NLW_cycle_cnt0_carry__1_O_UNCONNECTED[7],data0[23:17]}),
        .S({1'b0,cycle_cnt[23:17]}));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \cycle_cnt[0]_i_1 
       (.I0(cycle_cnt[0]),
        .O(cycle_cnt_0[0]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cycle_cnt[10]_i_1 
       (.I0(\cycle_cnt[23]_i_2_n_0 ),
        .I1(data0[10]),
        .O(cycle_cnt_0[10]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cycle_cnt[11]_i_1 
       (.I0(\cycle_cnt[23]_i_2_n_0 ),
        .I1(data0[11]),
        .O(cycle_cnt_0[11]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cycle_cnt[12]_i_1 
       (.I0(\cycle_cnt[23]_i_2_n_0 ),
        .I1(data0[12]),
        .O(cycle_cnt_0[12]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cycle_cnt[13]_i_1 
       (.I0(\cycle_cnt[23]_i_2_n_0 ),
        .I1(data0[13]),
        .O(cycle_cnt_0[13]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cycle_cnt[14]_i_1 
       (.I0(\cycle_cnt[23]_i_2_n_0 ),
        .I1(data0[14]),
        .O(cycle_cnt_0[14]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cycle_cnt[15]_i_1 
       (.I0(\cycle_cnt[23]_i_2_n_0 ),
        .I1(data0[15]),
        .O(cycle_cnt_0[15]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cycle_cnt[16]_i_1 
       (.I0(\cycle_cnt[23]_i_2_n_0 ),
        .I1(data0[16]),
        .O(cycle_cnt_0[16]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cycle_cnt[17]_i_1 
       (.I0(\cycle_cnt[23]_i_2_n_0 ),
        .I1(data0[17]),
        .O(cycle_cnt_0[17]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cycle_cnt[18]_i_1 
       (.I0(\cycle_cnt[23]_i_2_n_0 ),
        .I1(data0[18]),
        .O(cycle_cnt_0[18]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cycle_cnt[19]_i_1 
       (.I0(\cycle_cnt[23]_i_2_n_0 ),
        .I1(data0[19]),
        .O(cycle_cnt_0[19]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cycle_cnt[1]_i_1 
       (.I0(\cycle_cnt[23]_i_2_n_0 ),
        .I1(data0[1]),
        .O(cycle_cnt_0[1]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cycle_cnt[20]_i_1 
       (.I0(\cycle_cnt[23]_i_2_n_0 ),
        .I1(data0[20]),
        .O(cycle_cnt_0[20]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cycle_cnt[21]_i_1 
       (.I0(\cycle_cnt[23]_i_2_n_0 ),
        .I1(data0[21]),
        .O(cycle_cnt_0[21]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cycle_cnt[22]_i_1 
       (.I0(\cycle_cnt[23]_i_2_n_0 ),
        .I1(data0[22]),
        .O(cycle_cnt_0[22]));
  LUT2 #(
    .INIT(4'h8)) 
    \cycle_cnt[23]_i_1 
       (.I0(\cycle_cnt[23]_i_2_n_0 ),
        .I1(data0[23]),
        .O(cycle_cnt_0[23]));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \cycle_cnt[23]_i_2 
       (.I0(\cycle_cnt[23]_i_3_n_0 ),
        .I1(\cycle_cnt[23]_i_4_n_0 ),
        .I2(\cycle_cnt[23]_i_5_n_0 ),
        .I3(\cycle_cnt[23]_i_6_n_0 ),
        .I4(\cycle_cnt[23]_i_7_n_0 ),
        .I5(\cycle_cnt[23]_i_8_n_0 ),
        .O(\cycle_cnt[23]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'hFFEF)) 
    \cycle_cnt[23]_i_3 
       (.I0(cycle_cnt[17]),
        .I1(cycle_cnt[16]),
        .I2(cycle_cnt[19]),
        .I3(cycle_cnt[18]),
        .O(\cycle_cnt[23]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hFFDF)) 
    \cycle_cnt[23]_i_4 
       (.I0(cycle_cnt[20]),
        .I1(cycle_cnt[21]),
        .I2(cycle_cnt[23]),
        .I3(cycle_cnt[22]),
        .O(\cycle_cnt[23]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'hFFDF)) 
    \cycle_cnt[23]_i_5 
       (.I0(cycle_cnt[9]),
        .I1(cycle_cnt[8]),
        .I2(cycle_cnt[10]),
        .I3(cycle_cnt[11]),
        .O(\cycle_cnt[23]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'hFFDF)) 
    \cycle_cnt[23]_i_6 
       (.I0(cycle_cnt[12]),
        .I1(cycle_cnt[13]),
        .I2(cycle_cnt[15]),
        .I3(cycle_cnt[14]),
        .O(\cycle_cnt[23]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'hFF7F)) 
    \cycle_cnt[23]_i_7 
       (.I0(cycle_cnt[5]),
        .I1(cycle_cnt[4]),
        .I2(cycle_cnt[6]),
        .I3(cycle_cnt[7]),
        .O(\cycle_cnt[23]_i_7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h7FFF)) 
    \cycle_cnt[23]_i_8 
       (.I0(cycle_cnt[1]),
        .I1(cycle_cnt[0]),
        .I2(cycle_cnt[3]),
        .I3(cycle_cnt[2]),
        .O(\cycle_cnt[23]_i_8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cycle_cnt[2]_i_1 
       (.I0(\cycle_cnt[23]_i_2_n_0 ),
        .I1(data0[2]),
        .O(cycle_cnt_0[2]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cycle_cnt[3]_i_1 
       (.I0(\cycle_cnt[23]_i_2_n_0 ),
        .I1(data0[3]),
        .O(cycle_cnt_0[3]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cycle_cnt[4]_i_1 
       (.I0(\cycle_cnt[23]_i_2_n_0 ),
        .I1(data0[4]),
        .O(cycle_cnt_0[4]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cycle_cnt[5]_i_1 
       (.I0(\cycle_cnt[23]_i_2_n_0 ),
        .I1(data0[5]),
        .O(cycle_cnt_0[5]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cycle_cnt[6]_i_1 
       (.I0(\cycle_cnt[23]_i_2_n_0 ),
        .I1(data0[6]),
        .O(cycle_cnt_0[6]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cycle_cnt[7]_i_1 
       (.I0(\cycle_cnt[23]_i_2_n_0 ),
        .I1(data0[7]),
        .O(cycle_cnt_0[7]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cycle_cnt[8]_i_1 
       (.I0(\cycle_cnt[23]_i_2_n_0 ),
        .I1(data0[8]),
        .O(cycle_cnt_0[8]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cycle_cnt[9]_i_1 
       (.I0(\cycle_cnt[23]_i_2_n_0 ),
        .I1(data0[9]),
        .O(cycle_cnt_0[9]));
  FDCE \cycle_cnt_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(cycle_cnt_0[0]),
        .Q(cycle_cnt[0]));
  FDCE \cycle_cnt_reg[10] 
       (.C(clk),
        .CE(1'b1),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(cycle_cnt_0[10]),
        .Q(cycle_cnt[10]));
  FDCE \cycle_cnt_reg[11] 
       (.C(clk),
        .CE(1'b1),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(cycle_cnt_0[11]),
        .Q(cycle_cnt[11]));
  FDCE \cycle_cnt_reg[12] 
       (.C(clk),
        .CE(1'b1),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(cycle_cnt_0[12]),
        .Q(cycle_cnt[12]));
  FDCE \cycle_cnt_reg[13] 
       (.C(clk),
        .CE(1'b1),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(cycle_cnt_0[13]),
        .Q(cycle_cnt[13]));
  FDCE \cycle_cnt_reg[14] 
       (.C(clk),
        .CE(1'b1),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(cycle_cnt_0[14]),
        .Q(cycle_cnt[14]));
  FDCE \cycle_cnt_reg[15] 
       (.C(clk),
        .CE(1'b1),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(cycle_cnt_0[15]),
        .Q(cycle_cnt[15]));
  FDCE \cycle_cnt_reg[16] 
       (.C(clk),
        .CE(1'b1),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(cycle_cnt_0[16]),
        .Q(cycle_cnt[16]));
  FDCE \cycle_cnt_reg[17] 
       (.C(clk),
        .CE(1'b1),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(cycle_cnt_0[17]),
        .Q(cycle_cnt[17]));
  FDCE \cycle_cnt_reg[18] 
       (.C(clk),
        .CE(1'b1),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(cycle_cnt_0[18]),
        .Q(cycle_cnt[18]));
  FDCE \cycle_cnt_reg[19] 
       (.C(clk),
        .CE(1'b1),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(cycle_cnt_0[19]),
        .Q(cycle_cnt[19]));
  FDCE \cycle_cnt_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(cycle_cnt_0[1]),
        .Q(cycle_cnt[1]));
  FDCE \cycle_cnt_reg[20] 
       (.C(clk),
        .CE(1'b1),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(cycle_cnt_0[20]),
        .Q(cycle_cnt[20]));
  FDCE \cycle_cnt_reg[21] 
       (.C(clk),
        .CE(1'b1),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(cycle_cnt_0[21]),
        .Q(cycle_cnt[21]));
  FDCE \cycle_cnt_reg[22] 
       (.C(clk),
        .CE(1'b1),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(cycle_cnt_0[22]),
        .Q(cycle_cnt[22]));
  FDCE \cycle_cnt_reg[23] 
       (.C(clk),
        .CE(1'b1),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(cycle_cnt_0[23]),
        .Q(cycle_cnt[23]));
  FDCE \cycle_cnt_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(cycle_cnt_0[2]),
        .Q(cycle_cnt[2]));
  FDCE \cycle_cnt_reg[3] 
       (.C(clk),
        .CE(1'b1),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(cycle_cnt_0[3]),
        .Q(cycle_cnt[3]));
  FDCE \cycle_cnt_reg[4] 
       (.C(clk),
        .CE(1'b1),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(cycle_cnt_0[4]),
        .Q(cycle_cnt[4]));
  FDCE \cycle_cnt_reg[5] 
       (.C(clk),
        .CE(1'b1),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(cycle_cnt_0[5]),
        .Q(cycle_cnt[5]));
  FDCE \cycle_cnt_reg[6] 
       (.C(clk),
        .CE(1'b1),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(cycle_cnt_0[6]),
        .Q(cycle_cnt[6]));
  FDCE \cycle_cnt_reg[7] 
       (.C(clk),
        .CE(1'b1),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(cycle_cnt_0[7]),
        .Q(cycle_cnt[7]));
  FDCE \cycle_cnt_reg[8] 
       (.C(clk),
        .CE(1'b1),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(cycle_cnt_0[8]),
        .Q(cycle_cnt[8]));
  FDCE \cycle_cnt_reg[9] 
       (.C(clk),
        .CE(1'b1),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(cycle_cnt_0[9]),
        .Q(cycle_cnt[9]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'h4C7F)) 
    send_req_i_1
       (.I0(M_AXIS_TREADY),
        .I1(send_req_reg_n_0),
        .I2(M_AXIS_TLAST_reg_0),
        .I3(\cycle_cnt[23]_i_2_n_0 ),
        .O(send_req_i_1_n_0));
  FDCE send_req_reg
       (.C(clk),
        .CE(1'b1),
        .CLR(\M_AXIS_TDATA[127]_i_2_n_0 ),
        .D(send_req_i_1_n_0),
        .Q(send_req_reg_n_0));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
