// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Fri Sep 19 17:51:04 2025
// Host        : FSO-A running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ blk_mem_gen_0_sim_netlist.v
// Design      : blk_mem_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu15eg-ffvb1156-2-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_0,blk_mem_gen_v8_4_9,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_9,Vivado 2024.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (clka,
    wea,
    addra,
    dina,
    douta,
    clkb,
    web,
    addrb,
    dinb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [9:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_mode = "slave BRAM_PORTB" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB WE" *) input [0:0]web;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [9:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DIN" *) input [31:0]dinb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [31:0]doutb;

  wire [9:0]addra;
  wire [9:0]addrb;
  wire clka;
  wire clkb;
  wire [31:0]dina;
  wire [31:0]dinb;
  wire [31:0]douta;
  wire [31:0]doutb;
  wire [0:0]wea;
  wire [0:0]web;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [9:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [9:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "10" *) 
  (* C_ADDRB_WIDTH = "10" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "1" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     4.238151 mW" *) 
  (* C_FAMILY = "zynquplus" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "0" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "1" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "1" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "blk_mem_gen_0.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "2" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "520" *) 
  (* C_READ_DEPTH_B = "520" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "32" *) 
  (* C_READ_WIDTH_B = "32" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "520" *) 
  (* C_WRITE_DEPTH_B = "520" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "32" *) 
  (* C_XDEVICEFAMILY = "zynquplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_9 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb(dinb),
        .douta(douta),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(1'b0),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[9:0]),
        .regcea(1'b1),
        .regceb(1'b1),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[9:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[31:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(web));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2024.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
FPXllyX2NFs/RMngGqZy2bLYbZr92CdofeZrJOHklWXExpaPgHNYp2Lzm4MnflbnrfSkCmLwwKT5
zfRgEip7FKQ5Zhb73p0MAIADixBZ/ZRt4hQkJL0T9brm0waLHfanjnov2aCX6jN3LbQc3ujmDga6
Dd73k78u4xjRTDv1/P4=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
kr7VKKvChFoiyRCReag+OvU3jnmG9pN0cv+BxhNmMKLthg/ksgNZyU3L+fQ7cmIQELtlUjwjkBAP
Jjq5RsCnHbJxj+Ys1GNhriiBsxLqxWCP8onhAVvgZN2xZFOih0UWpqlU8NVP8Eww1ohvkDgxTstC
3kDmYehxIUJjqCC/mgRZmuezqugrFdubYmBoz16tUvD17iA5qqCIMS9xSIXYp2LBNekmWEwrVqzu
R4koEo4UlXl/CEw0XY3QvMoHnlXgu6N/6sc+nxZtKSwjiMVvGnZE9UVvJPAC3Hn3zKFGlK53mmGO
Tj0dWzhwX0ahSYzkyJC/HLdbGZmriL2UNvDyFw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
CaLc9FGt3AdRHfNtGAsGFY/QEvHY1Vv4TvvgCDsdDMqiuDeLizFJDJeskBWjeKDoE2cufK8TxiBq
mySRQNJoeOKnxTiDdf+Rx6m0iR6h/YeswegYwgghpM5KVrl6mSwF3+4yEovPM7a+9ArDQ5vl+WT8
SilNGzyW0KnTwe7+szs=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
cEnudSW1X71p0Xuq6jrXOxHnBku87IA0RA3zKqmeZHZM0r+9rEm5MSzX8RecnQ994yiqeyxbIH2l
fGEzUzr0ZzryS3fkf2LnJuB39f2YARW9eVCSiaeWaraZuY1l89T+h3vgdlurS/1LIraYLS1MyOXa
6F1LAcQp3W4OO4ctc3q1FRMZGldRS1biMsKwJ8Lxj8NEOm67UfgFrJNQAxbVXEfbWRWhKtwNxcTB
JbgC8j4EHkIA46mzoHloeBAL6KieplQUBjKXSSTb66rxglbFhWLy+mirROHcocu9J4ZbvTRYZEww
4lso1lqAllVLAoKYqa3WImZuSRoTbGDngBt9Lg==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
rOyI+x4PlmKcVSFoN3oKgSYpVlmYxc194Ej04il/YmBg10xopy4zmtu5sdCP/uGSNYcNGWeAiw01
mNf98KyNgTUFXruHCA38qjhhEIvl4vfWWn3W3mFRxrIuwmnreT6qTvgMaxIkCdVBDP7Iy7O6WmCf
3Va5X5hnCHhtXgX5UYniBHiLjmupv63B8XMAYDH2n6mQ3H0DF7mtb7psBafd0Z6+IWUbmzwMtKrf
ZrRJBGAhNT0i1KrEjEh/rWjN7Z7N32zQ+Pl1kc5gYCQIX5McfdTdqSaRVXZ/HF90ymS7/8d5LDyj
Er+ORdcjnOn6oAyY4PuUUl4OYUHv5k+RglTe5Q==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2023_11", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
bJa7kPSpDipzoJoQu1APEjc8vFLqBfQZK/grZvWijD7/FgMTerFCWLUY6n8DWeGdvjXvTeyrqCHE
2rP/H57wUqPC8tIJlGm6ZYQGjZ3TgYqLrJshDE5zYMTO//q0vuSraWvZP7A7SLuW6y7tFE/nplpx
L8gbYORx6j70okGUwnamCMS9yhFr7Z2QTJne1k4GNFGvy66URk3k5cBPl5j4/1yc4xGV+aWYl6L8
q8RorRU/CltObHKrji/jdiY1WtdGrkpRyCEFc+XNPazL9xSLLu5bz6XlvKwoks+8a5KYT/VFUovM
JbM0bpAXM8Z7rGaPuXjqXtZBg5praTZLu/WNcA==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
PYKBDinOGc/kIVdFzXrz2wA4/QNFxLDrQfTWfR5TjYE6bm49vrZi0bawcr9HXp4OP1+XxPLB3oCP
oV5e/rYeDln531ebt8yEg27XCoSHEX4FU8oG8aBJ8fqgWayOnAMJt025WodOxuZXbhT1zPo7J3uh
6iO9Mv7RtYE2fZ1W+G8oN//FTOEJYPWlKYnt0cDeZrN3I4rHHptZHuu7l8T+df0PYea3x6U3Mvkl
ojZ+TwQtdu0NuYY5j3QNgx3+W2XYq1M773FAnEz/deW54EjE+jf1jjrBk2pl8SYxeKuutS15oPVF
eHdqXYVcJxoUY5JH8z04lITKEnZ4oq6sYS6dog==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
tl+2vFCWZ583gQGsVC7oopz2NCKBiJ9uOHYBGzJZheOHJMqI/ehNvo25l710eBx00tztXzM30AH6
ZhAJg+kJwE2jO0MV5fmG5dnwXmLqoGEJMBs7xwWxvYK7w/0z9M0AJKD7HnuC+IiLhNU/fIxyuE+I
+vWqp//RcfY0tMMp2I2J1yEW6GUahS1ve/4JchssZ7Xu7VthoSDWXMQWATbvsUsDzeSo2+Ruz8Kq
Dc05HqEU8NgBxDPPEKLCcdKLp4byglwj7iCAtCjsPy8P18qjgb2sycFjNgmaiNMMB51WqeD+hneG
hLOue9bqVdEojkrb3q4WbsGZKz0bAGsryxslOlYHP1b8vey3yI2ixA80wyERe8d3GRIeZiSxGykH
qWxsE6x/iyi8QRb5mXZPMApA+Fln8tYmn7+1rFCm8gF4gJWhr1PsSJqTi658symGrzT0Ghjvf2QL
SvvoaeNdy0pOsWs7jLBFndd4GiFA+9K6Y33sziLToU9EvvFokENIslod

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
oYiCujFRj1F3wKsGZlHR9niEtR9MLXEVAVfy+f/3xrmpW6Ye5a+fBCvm4TH+iRQefGHNdMPnzTNW
K/pEPAS9uMJjOdFiu+APT+LYrSRnEg4W0dX5buSDGM6LBWAuMseoTMjbJJoYDGLRckJgW43E30mX
ej4823nkbfwc+Ecbrup825qLyv8RTQLNHafvJA5lSapdqXwnlOIYRmcHn+sfAh5pGv9kW9aokcdh
ObR2XYxX99rYloyvz3x0pmjxD5ILW4SQMB1IUEuuyqX6eb5IQ+kZ41hjvsHIuQH29vzpCfV9Jqha
WC5yxxK1R+cleZSKD1H1gVzbTei8uFs/91Bgeg==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
urNc+S8AFPj+GVFdqJE5V7P8O6QI6MA3nkwYb8NKbYbVufnXKg6voJIRYYeYr7EOa8mrqirozWbY
Lln9SLWnkaAy2LvL/N6WahoQdCt++4RH+xe768XvSrVUFPrIwZRixqMLurc/tPov4i5P/ukZKl18
ZPZvXRzUNlvCZnMPcF+5QCQihqPbjcZ0YyGgWgX/ipTGG3sNqmylGN7qLa4Rgqu/mB5a2xVyu5Wc
911+/X3VVFx697WVaP5V0SbOzYN8R8+8B8kdznwixMA+f4lSbBXyRysVOSzYjo8bKEMqyKMVBQn9
xDmEuV0DvVWXdO7VPvWA1LuJFwS07OxeI2GCcQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QcP7fsLZxaDrG29e9HQeXfu2TsKsdyW7Yc1vWct6lbmDEfXkWMU1fFWSPIjPzRc9UOnfEu0bRn+B
D+8MWokqes3WF7txljBmgUPiNGZ8arUU6ENa/IY/Wv7iaB/ZKM5PtdnFAkjDIrYyKFCTz/U6Yzwi
hBGGarK/wYQOLzeeKRewiPTiNUL7tztWuMZ1t1msxD951EeKrwjrjcXIIuf/TzrOGUOlWgjHlnrl
4Q/lfMAnRLBNTSWG+5wWewCE8jK2X/gJ5AV4p3x1WP3+JglbxpP39l3pzedXqciZPbuz2XlFnRPV
KByaUaAShzJ56p8+0HjWebibqQdieGNPiPWW0Q==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 30304)
`pragma protect data_block
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
`pragma protect end_protected
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
