// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Sat Sep 20 17:21:43 2025
// Host        : FSO-A running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/PC/Desktop/fps/EnDec/project_1/project_1.gen/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0_sim_netlist.v
// Design      : blk_mem_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu15eg-ffvb1156-2-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_0,blk_mem_gen_v8_4_9,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_9,Vivado 2024.2" *) 
(* NotValidForBitStream *)
module blk_mem_gen_0
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
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [8:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_mode = "slave BRAM_PORTB" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB WE" *) input [0:0]web;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [8:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DIN" *) input [31:0]dinb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [31:0]doutb;

  wire [8:0]addra;
  wire [8:0]addrb;
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
  wire [8:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [8:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "9" *) 
  (* C_ADDRB_WIDTH = "9" *) 
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
  (* C_READ_DEPTH_A = "260" *) 
  (* C_READ_DEPTH_B = "260" *) 
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
  (* C_WRITE_DEPTH_A = "260" *) 
  (* C_WRITE_DEPTH_B = "260" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "32" *) 
  (* C_XDEVICEFAMILY = "zynquplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  blk_mem_gen_0_blk_mem_gen_v8_4_9 U0
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
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[8:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[8:0]),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 30208)
`pragma protect data_block
6L7XR6g/+iAnHntlzq8Z+eVYfXhv1NFDTTOBrSZuEsUxfRgh9/yrOA6rwv1/5q/GX3ZQ3wEgVqe+
2+VyneAe2eWx8RUnIL/QhhI3pEsF1QU+hR+fwbZsIknlQVyoAywMrD9HRj9Sa1iVFU1VGcii/YBa
nSjO5Iq3LWrvVK/dhPj7nWpO44lzPFA6Yzbgs1HpSKUtMEPUafqCxT7agFUnLR5oCu5en4LQw1Jq
cB/Z0OcE1kPPFWLu+ssuHy0olnEUufuEXg1dowSCCoHOZs1TJsXHx4X1mwiEwXb7f5qN+SUPbW2s
ZHk2O1J/648YN/Wx9Zyik/yqkGNChr/toimlwlI2W41zzntSOd3djG5Kl9P0lsHByCSAZxigW+gx
g2oTP0Lzv8+baRBJyggNeSq8fqvUYNO3b7Sf0ltX6NhR3iBFCQKnG4h6kGJLHSvQSv04nlWGCQoy
RCjT1Toy6nFX/r+kwMcAHOZni0cWHrrBIkgruTkOmi72C0fkU1TtLWZ/CjeaCD7jIzk7PlsqnqRv
Zx5aXFEslTa2qjGTZj+C0QKbf+HXniAneaUoDiJ9lxVnoLVafaeFZpv/zzFKbymHtcAUcBRPO6ij
2TYosMqzcbJ9HCNCKLnCyx/G0SFLLF3KFtWA19wu9Dm+AC33cPUOELG157WQvdeEi6X1Bw9Xp4iJ
UNC7QMoBJdZtUrPoYACj04AYT9ZCNLZvjOmNNNxtqZ6jhhxHto5IbeNDY3PO+mYJxVc9VnvfCSM7
uYH0Pte3//bfYEYNHvRLQp3b9VoKKXLOmqOvClqoLMa7vcbzl5NtSGdmewOD0oHjNTyF8V+6xWac
xh6nmWaU1OS7PLsrXkLfcw81rgbcGQH+M2JCr30LQ8/kG8cr/T3hRF3GxshVGKsLWp2EwjGRxTvv
C4hBeoy5NlaepxbFAw+y5lZ6DTxY4Yjaw8bewSXlGkDjDDoWzgrP64kWHtNSahkFs3WkK1u7Y97/
PQ9JTpB7RdCtTLmZ1ZFzYp854DVR0GBxbaSj9PzPjNMxvgKNuLTN+IeFDrYD/eO9eGIV2upTuuvo
dRaD9bIZRewUryUMN0KlTFXq+TOrWC1L4aqo6TZyyffwh+Zda7CKKvxWz7mRpUQiNGzJoLAWffIY
czgOPJvUQh0LTRUXaOJSYaVwdCuejh3rYA58lWj+GVxY92R5iNACuPysqOgYYj9CcAMEBNXKD2GC
MNU99np/qnhIBgyadhQjJJdNm2LGp4bH5OMOMB5Mg5xw1Xh1XUsc9SBF1Oz8C2IpMdyGV3HeZS+0
vxyJW/miW+2C/L9ZP6/4jXZmSmx58FmydqFnpiVtHOj0RYknKpXqxwP4ZGqR5gzMT27Ct2LNsLH0
ojmjIhBk2dmNK7tqqlNLfhOk5NJqXixoSwUQQaWDSP42Pm+X4hJygekV+OKHGizxOENbtbI8ujmD
rpuNtWFyRwEZ483igyWQSGe2MEv3SmwNoepU7r0VvK8fAR5cpGeMD32r0tx1W6DsABSz0l3Oh5pN
bxt5Ki4hFnpuGL+MDopRG9MDlRUH9LNGfnTRh245EKfhfXViScCT8dt69XwJxBHuK+YWDR7YVWH2
Ufb7PCi+vRCmHY5Fs7SepjoH0KTy4/GMYI0K91RH2clBtTEm5qzmfTClssxFFyoXm0VS1BhVvtvF
PRWIZWbSCzGwiNfrCUIs+/TC/3rzNtr0TH6WUNg4Yo+mVSjlJ3tVjQ0/TQy32mD4/hauu2COH64R
umonE1m6WwPF46zUsKQ0kiwqoGtwW+l/6aGpz0xJQwPky62br3P4+fyEONHBQy30cCT8/hNWgq3d
gXhPS8aofVkhB0QAXKXHVxBKj6jtyZwgdBuKWgvqAEDdZkeKC6eGisneuONR7g7UxNQ1Iu2t7MS4
t5abssy3SvL/8l2F9GL3EyCrpf0UKjLjXbFBIM95eCjXrAM6Gh3YXH/CTg2i174CMhcVtla4+CWe
yrUa3MPf2J2f+bU/L+ZYhyiXdQs61ZKfxT//u+9AHVXheRK4S7gpcOuZUOwV9GWkyfB4A0zZAHdw
KyLJtJXZecI6/xx68CMTt1xgJgEWcFc4Xz7MDeLpLAJa7IiEf37cChKG77Q3abf68T/uQfP9yVRf
MdR5Va1vrSPa3duX/x4wyd/hYhT+W1/1D+cxdLH5sYyLOS7IOThVBrbsxsOiZwueimb+VKX9hxVA
Eb0JDH26AN0HfLs32Lj5oerWXwsBDRBWJMlmDPM+kzjGDLogzTVZI9qM8NRQl7wAHG4N/op30QIz
AcPk76HKUrWwtHxIRtrSZzw2Vmj+L8Z+RoWRk4kNNhtMq4O+mKH2djZeR/hHh1nmoYvJDM/Uh7Ot
aXRZ3NyNaJ3fm8+QX67g9Xdox7UDMYwDvmA/NKnHU8ek4I5CuNGTP98ouIYjQNfGqC4Aq1I6yN2A
ErNA6YucpJl1l/4C3lAlM8gs39seyVwKmRc7NSn5Tz69beBrIixigz1QG6gYl8mRDuYmK9tJW+Fv
u5iXbQmvuu9DgDSJQz7MOxLZD6ysLcDq+NGsAG7J8IursEEId7NSz8n8IA/1wqDjHRkrA4LiCuTh
MfnYZpB1infiKeVnRCZdypLV3wdenRsQ6kbpBpQHRyv3OCT6E7fbT0x/1OXkzA3RPOuYBAlQF3yt
lScLlWoxsGNFoOAY3re5hN02i0V13e50SnmvdEKg9V2gB01iX+JTdSaZVq5JLJmLzwcDHXfNJxlg
6JUEBP8d0MKxs2VEQA3zVUAEjZsNU6Sp+ik9+YVJ2CB/ytGj31lwITM3uZD6rKnojiZrEh7OhBDd
WsttQ57jzN1QqDJHcWdfyTw3GdZ2kAoQWuxff5w6Ih8XEv4PpeN/7x+SX065BKso0qgby8C/DFl5
P/o9SVx0d56dnG2BUiGIns5jT03MmO7HKZ4BwPt7Kxngcc7W8jDYsiIYCEB75BeVx6ZV9nUiDE1k
cFHsn54GBedwoN62VWP4w8+K9qtgjSlpDGyn2286k4lEkMh0wrXbZ+fQL4eipuhm9S72adIjvYqY
/LmjNCT5Kda6EaV5NRVhEHx27IdPIvjPgkZpAGqlHu+Uf1b576TLdxCWhJ4tZhQ/RbmXUAdEAACh
pWvffkTv+SQz36oOj9xFDuDF/esamD/G4FGJ7UbbOnfm/mIUW/nRn3e/vO+vkOfoVTjam37uc032
nGzoTbtI1UoO1FiURTnVJqRW1X0AJPiZr9gnHhp50yBIFbcx2v7yO3t3uevJLhWpUOA3dbwThRZS
U/wzquHDbyv6JNdS3ZnRXJ40xPSB7L8qN0KB9fLFdPjnELWaIVMdv5sZsu5IAazER3D2xw6G1Pf4
FsWHt0ryN2L+bsP5M1Nw+oJ4qf5uGSAIscNgKCBqt+5zSorQgCI8mY+hi60qiFr9qEoiPplju3jg
/xbn2+Q1MMovDnKsONau9Fcfzb94UNtEp3RnIPWThfaBLC3tvq3kULdaYYx2jfawx85w8cpCzlYV
Tr56u28GmpPKhixZZMW5LNwomLZd9aYPqv2kVTWdCpnPzq//z/biT2nxvMrTVWv4ITS3KwSIJ5Q1
CnIme7CSztCBADd+na0d2lCfqsij0SJ8FVhghuWV+mUd0nLQWs8X1bOBreYknw3zIrAHbZ8uK92T
P4+hu8HdVg4Ws9TLaS9fA3cEovV9LyqGTO2wbogPUPwzlCQVLS+iOmUWA080Ox/aDENqZumoqRlh
EWwaFxLQysiofBJzEj0BYGoqgkoIPlx5M1ghCsndGyxksgrrO4gIt+a6XRJsTf+DJCCCBJ37WWKw
LgoKObyJucTu8EXb4VewE36o4pBnalk1atWSZVjWpb/kvUVvnzn9mUjbzsdVI57ZM5VjVhTnNM29
A8m0pyTVw0sfhxRVitogO9XkdEk70ry3jxK0r31ZR+W/QmrL6eibjEvfGKokw5wx3pAObBXQEL+E
ED9HySHaDy0B1Fh3iWMYiB4WHML8utm/EjAq5yB1rXvtJA90YmfBpSeb3UajQ8FF6OxYjY2VErZJ
snEvu5fM/EL9P5erQhXQX9B0yZBuZOEKMHpAsUoePlJW3H85FjbysavWTFfd3Q5GB60V/oQ/hYmz
rs9w0h4YLsIUPbh01KKMTZWzW8J3zws+rkRewKcoOMPj5OHkBwrdIaMwyjdlSz/NQRFlzkApSiZe
4jSnFZMoqrZi+b7qX1oVV8qLAYh1pd/2GngusLGbh5mNjNxeghwrw00ZX5zB60ok32ZgTi/g8ZLx
bfYVgwL1cNly7ZBlGitTVNzQIbOVeYvcw41GUpk3aBewGSZkQRnYszTOpuctrtgQPtfoj21rlU6f
0an2Bl0ZZCHZaE/uwdaKyGn0j/LbeRSdopSP3c1e49nZ2oiLKQGSRJSe6KCzu2qZYrHvpN6Px9sA
yFHmjXbVqiw4kTh7nexhFGNnZC8r7Hm5sriDmna6SbzU1ff8jcnsOAR/TrUEuGSVWM2lZzCnIvpQ
+OqZnujF/BuLZKFHGRv7cv/fm4vbT/G+t4kvALK2SA3eKDAIa9T8GElzPeA40BtbbeIs9peqbKQ5
zjMoLh2kZ+ERHN+1dXCVnzPAAQkXjAwmRBe1fmI3r8HfUE5Ed07GbaMibLBi58p8KfNhOep9G4bh
45p44vWbkLp+zrWsl1SkfvPGkGCoKOPRTX0n+7pFDcQN/frKMyeelueBKsbpYEg8kKA1G3DkK3C6
nImKLVFomfxgGPOvpXy2calLns99RMm/dd4dQtZPVZon/pv1dX93GR/tVZWG18eI1zch6lEBiU+g
B+Kxi9aalMt94IJi8aWM2lJYuVw3ws5XO/RFSmYjl9AFSRGM5KCQaNmDSIz7jpKn2usN6+fAXoV9
axY1m2ggpTlv2htG21J5bg38PyWPRMnECdtO97ekHlB2hvPwh+vEgmofVYfZzcU7Z/oBG9eIto5P
56GjwKoDRCs4DYjmfeLTLm1f+YzHvEF+XxkoZb13B9Wbbcr6ZG4cLCaI6cOGryQkWKPBRtK3+HQk
lKQApk3+0vQO8R687wGXhZhfpFKl36krgVPQVkBalxzsSqSP+6/gLmChoNsTz+FOWKNqBoaIXeIL
rKz6GSC9ud/+WZrUvo4UJWSDRhSeaaIMsK8I47/aX8/2VuOQwcxZZ0s1A/rsnj3iedurkMd0hiD2
K8fdfRURDA+Egva5vWICg/pF+VdX/4AyZ+KfFxt9+rSA9vovPA1BrmPVsgS2kc4HReGApbs3flQy
PdNgfCtWfHuX0BQ9LfjKig/F7uyzfx8/f/xJfa1UtV8ow4XMK87eIV2cxnYQHZyIUwiK2H97TJ9Y
aVA+6lwlquSltLEHjKEgTNeiH2C4ynTju+dSID9GdAHZ1Pp98Y4DY8UgFWHXBzX6R18QLrKQ/AfV
uMdD+3zeNqDLox5UE7AC3GZzBM3EnVyZpmAP6NgoP7/wa/DN8ux7GfOAtARC9dAGh96B+V9KlsAY
ZQswYcnvwT2IyeNrqkf23V3oKcUBmqWFIVTssb/bKC0MkvLZPJTlBthNcgwOStMXUGR1/V9qhVMB
Kidzsz3iZlU5aSVY5DXz3gMyH2fDWdxjegklGo9jMCNT0HVHDEmfEqUnvQo/8//VmRAPJJwetLbp
rNFJUmlstIPhfPe/OYgd2i+dAiZInwkgTgQCNgjld9yVwmz+ICbJYd5Pxr8bb25bKTNgAa3AC/Ey
DL/h+C5/xrBt6JP/xS1g+9/xVRmJz4a+Pn8GBZnp3LT6qDqdCtR9pZQLdDYk3WjPHKi16aX2pbje
k4kOaE0X5Q6Ii4wAOJNZynNPUSy/Nm5ChuYAfKUaUnaRVmEUVRDpuLdREQrqgrnHPE/V+Ebz7mGv
QLBCnHujK3TGgYT9OKWv5XJjKo/end/HiRdlxT+zvIl2BUlsGF7vvHBNoE9HREKcZjjqNHrsko0I
6+6K2j0VObZYxLKFiyV6tT2T5KOGtGWTNNrxjoypY98uaUKuDNzD7nqLKUubVlpH/BWgvBcoSuOj
4mArgLu0zm0ofN+zQ6djM+wWVqqxVod/hxdYApKfd+2/kx7iZqnGJAWDcbNhsiZN1WqVBUwzWfxV
KTpOdqT83ZD53jkfDV2wpR9A1DR075ZGrkQydh3aunI9nr0g+3g3stS7yhqZm5dLfNr0HYDKQNA5
55O9wL0S834UuPGP4pk9+CXy3GZlpCToSXaEVpnME02hdCrMFS5aXY4vso461yRNsZhw5g7Iyke9
+aNCO/p123VtUYaXfO8ajkA8q0evAa5V/GiK72qIBnz2upU0zZ3LmrsePvXCKSnxvKpEETCJuCc+
t5t73DdNdhE4MS+xUg5pqlgWq4FX+E5UBQNesGbFNBv5KGQXXVHWiLqlFj1IA6vTWTpjOKfpFjNY
v2U/Jof77druFKZpfQnpxDiQWrWPETfno/Ko7lntjfAExG6oHMk+bXlcHWqfnwxH6WUh8uJtGqln
6JyGyjijDrN1UMcTxXW3NXi9ou4tpEUDQ8NLdAiFiVbQWTnA3AFlqqKY6TI1qnklwqcUgZlY4mu9
LcBm+kxXiX2cIziy9UdJNHtcbOPS89wqkcb5abl4sChzd6zztnq++v7MbhzDQFrQQsVSUfQMwvOY
CSF46bOUsSptE5eHzKCJMn/cqlQ0eA0WYxbuD4XytG5YM7B399xgB4j447SxLc22C14bMilqpiDF
QqJJiMYCEIYY0jM5JBmob/v2Q0gVAcb+HXEYS9SNUEgV6PNwuoEqUF+ZzyyLkpmXTzgicLQ2FJEn
g4OTyK7rADu2MbZqjsZ+wQSPSHrrSDjLVckVWVULlFR8Fa5GtGAuRpHE07xmNGc+S6KzusyfMBt0
38DshsuiW4isPM9a/Dd/T1AGt2sUv2sHyC6zZmr0AanvDDU06L++BW2STEWZu0QfogbePC9sMoPh
JLw7Dika57gtuEhG6RxAlvsAk11iEWxZW9xV9rCxDlMDi8FATh/wH2sG+n/43GuNwQvcGZgzCaij
qHjsb8HosDTW/zGiXhrJ3p+gbTuazxTMILmh+RGbsPQOvczwAhn4h20EFBGI7L1k4Q5ggNZ+BI3V
ZrFk7LI4oKvsqWdCXTPBEuCd0/WDMdssGPy/jh9W310xECwVWkF+WZrdq70qE0/wLTguS7Df4iKr
+CqqhhHOgTgFiP0tbCQkRN5McuvZ4DmG0akEzvZdcEU8Y5YlxkwmPV80DGw1iMpTwjrFpx4djMYF
f92YmFbbuMzI7DiqnLReQDgUkXLFcntb0eWQDUDTWc01sKYADOA+6lluIokBvZDPDaxvz1SCBe6N
mUcnTIY/3xFRRjmbvpXECqiG9oU6R1dOKEZUU/ACo0MNYjKrM8aANIwreS+j4DG4Rbd12U04CzYx
O1sOVSOvM2v6nuqC+EqdNDXlsUFERTue+GOJAzlnC8jZzlVcTByuxBdgLFFg9FMrGtXctA4mJmix
PSChejNqpqyfPhx+ufjnx8NYQOP/vL88VtWsku2YmQAWf9spivWgJN+bTs+WsozvK7aSDx9evEkv
R/uXCrV1hGvTkOPG6IVX1yfcTtEozgrghim6bwo7ZQ1H7+M8Hf/RIadeqjEAck58NTkTCmJofx+O
h4EmHFpqRxgmZoIQNTgel7i1X1hfQIL0Da/6dXQsw+OhbbLUt06M/GK3Km5I+vchkZ3TizP3XuP9
bHihnfX78luIQi9E+smBYDrqvqxFFmIN8X5KI8Hi3TG6DXJEmNnqEMRNNpeCrZA5JBsdK8Lbrilh
2kPPCBtUxjxK99zBwVPtWyi6C0hsGj5QqGlR5EzV2tEV+VxeBZLFEZQkzc6Sw9ng8oYtNvGUbapN
5iHp2D/Zv/yF5Cm/UT6ZMtAxEBQdy3E4A2yvymueEhsAKsMAZbha6FxT6nI3axhomjZrm3xHijdg
+XIAOn3hsUdGwifgB8+KYzUAuWQ5feCSKG8RSrc+rjQT1L3YO6v5Rba858cE4C3qnE9Q9jpywZ1u
6+bUO3OJiirVNvLYYpKA9fsC9IHkRjhZjgyP5xMlwg1jMfd62L7gOybK829WSn96WaV3fX6czlCO
iqL9/WSTYPQGAWSTfA6WETu2Jy+gG06bwAwAnenm3iucXR3DjDYNJpI+ZoDvdYSm6Fii8pycExdi
qrVRqvZdjJD7O769MBdIDGklcZDyij0QbJkVnTGbIGQBChkKQFE+gkb9GAaKThagE475vHeQD34d
e7ru5eJ7X8k3hTUBIbCN60xC6pLrDOh5px4bdXmRTP956pi2r0l9uXbgA1noszIVRPFw6OLxRHK7
uYkZmtA9yv6D6Wi+ViFQYJsBRPxg6hptAGWDaxthnf7m/f0u1vjbdqVM3+/mxDIPMXjLYEO7ZXK9
UoZoxhcdJerWGCe8te414ULZxGYCZ7Er1BbW/ylND1dbFpO7cS+YObQpVX5IEUMIazBc2m8BYWe3
ntfvqF18NmOO/yeoWHpH/5/VIME5ODkVsqXYpDOUY4goxz1CYWZWc1tttfu+wRTeub3OxfVHsuRY
SFj7/dyUqG4Dj/6zmvB8yjC3m1Jn5oHOneZoM7QtP9hyA4Iv2cWuFP3Hgfr3y3Cykc5cBvDO2sT0
zrQ7GYUHJ6vp2Ziuf9B8Reyy/7NES0kbx8zmf2oYlo4chm7UMpPItobm04Px7Br5eQ349mol9z3Q
xbj41mHo54raddsM/2KNcufTdAzpL/Um8GyLc+aYETp7MIXxjs65uvpcf+28SOqeAzOw566ZFcqE
dEoVXz4IJvDOmasVUUXEpyvOgOY50CNQYy5YQQAAYAxQ/x26hJtrlFmzpi/9RUm6WZ8vHuqjdDTj
7H54dvfs9v0l6clAk1Resx5Hh3KP9HtK6S6ZrlU2yTQjNW+tQO5wBc7e6/OdxvegAN+ztm2/oME9
ikKWDx1pOE/6IbvLmvBMAs1t7Mdga42TgSJMC9+LifIwnbtjiBnhrmCRJhpukKj+X8AuIYR1fBoH
KPOxIQ7EsDx3Ed2S5pm5wZF1cdwC0vjOuRxY0ttrId7Op3/KSyFBol4raOso9mXdUXHGcDcYD4WP
BNfReqaHEugaV2Mc05R3GB6Ib6ZpMAmy6xv3JQM0rRMRwNE35Wk4vGSOAz6gwwJAwwgeeMGfIBWr
XjIK5n515shmql+JBWo3bL/LJ/neVlC8pqD7XBlPJ48AmGraSNyY+R9IR9wi41xYwQxSv5osr1/x
3B9Od1cjIogFQNrNMFh73JpYcGU0x3i1mL53qaq+QHETJdFrOYvkHgbvQdPdHnn+wIHoeQpdH8I4
rha7edoXehDmwvZY3iDi1K1Mr9aVsvCiIIr+FPP+ec3F8HQs7ZiTNvQJK7u/E0IuQ5+Dme9sdZ1L
MkVNObfVFrp6+AxOPYG/aibheJm7Dk36pBv+71aHDa65SxzttB1DwqkdblQ9wN64rYkt+Wv5P2u1
9E+wGYMOkKweDI9dO5Izbd14MWtnCzm2637ExoAJXFD5ZTDBWgWjm9riuyzw0QVz2X3J3wnKkLRN
1W1zqPnmpzXFBCz7MVQnkREkDrYLABlE39HEtGkdAwa6dcptC7CGMhG7WyQSf5jVgc+XQiJzdxGJ
LghRrVkjo+SU6LVXC0TdzftxLiM1sNDGi3A+ilEU8XwCxwv9VKYEwHSluV55FXqDRHb0kMNGVwlY
wpsF7uejlBpWRQKYv0fgO3iLvMvJLvxJWlnmFihx8+zelCyzeIVv9Vg9w22+2y2qWBBmquesqEsz
DPG3x+6co6bHigxjVtx+4o/pOUI5HaMGriDzdep2nDZZ0GE+Ajo1rR7W+UZxNIrSqiqxc10YJOoj
Rt/QejDhQ6R+vYrD7C2Jjd4ff2xtHJscrVjID6gX7t3K7W4gEXL8O2UzERd2dncpmMOihS1PzmUS
L5EgDlbnZamE8QOsnQHsVbu15Xhruyv/ZwaZkcrR45ep9aYEb1iOtP0/LaUCFHRA8QpHs5/0Ud3a
kn4pI1IxoMSzsb5zYp9PhK8ax1cP3BmhK2cthTdhjYlLrF4xo1KvB7MoOgod77q/RGEi+6c5IiF+
76tzzTV2lJVNnUOaMic5oSxSSz+wKeyni+tzgfqqmurr3KgGMs+1/wG81UrWUojhjt/NtqUphybG
r0c4Y/Vy9B/n4LQ49D59Y9X02l5L1jOPw4UCGyb8sUlgf/pMek3MZHSVIDIg735IwGes///c/Fxg
nLvzad9PdD0jbkgOk53DYVNKpsSg6incOa+gWLwEtU2LPox/bgF0BIWr86vproJ67n57tmsySzOM
ZAAG4bFJOXQ2F9qwG/aNWL2HNtxLcuolIB9Bk9RpEGanuO7bAEno2K6cVADHTLxXwicYDbe0OOVX
8GnIii+4xVU2NV91hMl7DGw/gSR0w7MHsrzs2+SKOLpb3+NAcHe8PNsgc69voGUO8wfopzSCB+bY
xDZnwaUaHPGGXEKUse1lh2j2zDcp9RKWFbwQQ2GBdv3VhNtjEzeCD5IoIknaV7nXJXBDFoLwPlza
6J9iPGMTho5+kTEejnnADKkS19dZok8r5h+AwjYlIqWb9mJnb8c4/q1r0YoQIJW+ybdJD1zWKKWL
uSeZmBp5NW5zWIG8KJW9r1AB3TRn3rOWwB8v6+uSQXkoLWv+hA/dXnQ+dTzml7s3z+wxELgp46dP
7fAok/PYgXXhhBMZKv5YohvcOHcO5Q8SpAYQAYXGieaTwNXQT+frQPF9w5jEjC0TYeW4hMcDsfoM
Pl0Cyl4AzI0ITPg7lB1XTNwjZBNtSJOJO8nFCzLeSjBTdEq0ysn9FNxI+sch5lAyvR2memROFbHz
OklPDZkCw+3U/7VZx6nvx4oBgTUiTSu+89qJmCct1n1mPYMxMP8tFCDV5y16MPYbOQzmHwp7IBWG
90HCOMDYvPFUqUunlauJoz86jKa4YndjE7ONL+j+1teH4MUYtA53HYRO8honaBworwegLqbmDJ5N
G0wLC/vOHJDkAIp/DMS6p8kLFzFEUHz3qpIQaNrvNIohSGAPRSGOMlClKWYJrenURK9K/E3ZnDs6
sl8ljAnGawi6siLim7L+C1g6ucB+uqJdRzqTKwQMyVJoSJDa7Og5vQ09G+LeyBA5gCgp1oxeBRJo
2wBJl8w9oWfZrWWopkWqSXoNz2+ePxKMoDqoi8tN9rwst0yG5QdwRYIP9AIO04CC+g3BCvqDfVgk
QioTcDWTXNOTQHVTBVP/m4BbGg1cTUXB6Xu80MaPapzzEXvKRhqkupMrDIhKjj/MPl7MIGUuKy3R
VmzviZwLJlVojMjUmSz70NaPVfAup1ydXYiLrZCUcY/UxQOm+J6QWgkiQ4MMwjpnFUFboGZT03JG
f5iaEfSY9Cz9fjv94HsYuIVFFUclCMej9ZA2HmV1efthGSXAUW7XiH5ujTwD5N+Fkn+wpkBqI3K+
CnMpdA5ZptoTBbAf2wZOzmD20TSNsZweHEZ3bpM7JOC3JeH54pjgJbngzZ5Jo04TynKLckViGvVl
L8KdpQiuB5iXQn34ob5zXvJ+TmTnGR14qxb4PpxIQYXM/V25pIOu6/xl6xNkDqCV+WSWhRvfPv2j
aHfHloed3aN+IoD+0eI2UeRVGg1AconCGJmA/iZOEXcIRH7Idn1lYHB5Kvd3cNCDJMToZy/SMdnP
CpC7sB+/6h4Dk2CG9bDPZyZzzlLb5SYkUE/0UkZfiPd+NYj8RwPe942HtOVJVu0e9U9oO1tlt8md
6tPHudzOMiwOl1niMDUNav+kXd5bvFZ8ioX6WipmTWLWhyih36Y2J60iHzolp88Fc1uOtlbREzJk
s9tbGMIZwTm8euXy7auoQvQGEAO+qdQBCm7/j6a8DbL2Pnzk/WR5gBAucDcaWKV/aJLHqmaOFvvu
iXXGrnHX7zeK+IiJHCXfWpfq2ClQR6xN4uETY5GrxLW4l/Fd0Sl+i7V7BymD8j6LNb+7d2A9WENF
of1DV97JuykJrxjo4yxhziOByHsY59x/ZaJWFfgE3B4mO4o5WtRgplWZWe8M/UF8m/iVJHQbA5Ls
DYepQ1m4LY7AevADJdQ6hJf51xHDThSY7iDLIKHhBUT4x/jlzQU6HjNeVAQ3JAECAeq+aJzUStW7
7TcJgYggp0uKnK1carvsmKtVB4XeJTFN1x+rwuz9ABVngL0+xgUvAvZENwxOr3syliFM2Qf5HDwp
kVuKeHGk2KGf+nPjmUhHkOQukoXcsfRNW2xr0SXgnvCRPvnsy7EqLDiozIkOsXXOB45AbvrIN37d
9WxzmjSPwiun7GCma+6t9wqH+XpgUK1xw2l8WbEaLiRrhtbSLdqqqmrpQGEJmIlXzHpo5nbUOovK
dcJgLEhpmsKo+VddBnlm6I32eLEF/xlHgP0Cxv9UyJkwUKC0fNogw//kIfpimnsrqQcJBuYlrkxn
4Ek+sdpvmicq2Hbl3/doyUuJdcZoapv2S5LVKRTDqJ5/Y9CQ1oVFby4m7MrgKuTmjaEnj2ESvcta
wrRdvXLvpUSTCGU1Ks8XO70FLYNkN15rctiXkPQym4ljfsZ10K2JjyNyRmV4S7PzbODQKY6129ia
uoO4K2f23XxT0tF6mbvoypD84ueL4ZrB1sYLJN2OdAT3OvOknRL+dCyFA2+rSqukuy4dXGcyA8LS
FHS7GgCvQ/UPl4EIlAVj2FDKJ8JEFwTjPN4UGs/IEgkFCEXlhC7Dv1wxtZpbSQScVV3pebdInYLB
IJlgTMaTcm47JGeUnrjCz/jzg6vUFpTgKOy5KFwt92zEVuMgfhpdrxm/lY6tqc7Vv/NNW1IXdwMW
sEQDyftSbPEWKDkYIeGz0iQGVTP9uK2AwWEanS5idZxdJEXg+qc4ofqnvYttcdty/qzGjego0iQ2
BfB7Rzl9/B+2wBkf5PRBHGMWlIoOneo19GUsrwABC7k1TVUY8hgepMQXJPrlByAXnV9NY5LhpoqB
iJw+f7iiJGs4lgWagnLSvXwBT64z8v4nFl6tdR7qxrhy7jt7N/X6KTbm0/GlIRz6k0KL9RG9Mswg
A6dAIAh2YjLJaHWBKgEqB99oee7x/Kv5bOa1G3cXmmBvIoCfVUyMu0PXj5CespZFmYbrgDYfunCz
HWMy6FGYpmdEVX06p2GQEeLSbo0b5U1i5QWV1GxeAr4Wiu4kYfWP/Rg8BVeYtpKZtQy4TV9qK57b
/7wZaU6QMZRc+BIGPYfA8sDVxD1Q4bvBBqWrSZBmQISZ6ZU7P7iXEKOZM8AQl+3s6ofvyCH2aLWg
iRCbg2ngSKbfsFPR0FpUzKek8u3LwRIuN9HXMuVx9r5mt5ZYSA4ss1izjlIwDfsTTMuRj4tUDicx
9Z2oqF9zTNz87pB8WoXhAqtchTN9cVcvCRlpufIgrsXHGcqjs303sm8PyCnXG7DiwvMaWNpZrPMu
D97/ezRVXziIVFwXzpNCjXTIku/TwUCzwa0X/m7m35LfvEzUM68jEnhvQqALOE6OaPW4ojCVKBNn
hM4JulJ2/PBVfb8eFUoRDS0dT1zNtq59ZuLaJOOc1GKmq6e8yy/xKwNQAMYdqnwZOpxeCthJbCvm
KM7OKd/3uQa0WH86+mqM9pW5QI4+aFcnovPIOC2zxD3ckeq5kpkpsbrq4oxtx/tk0tate+PNNNZ2
F4k2LTa9wr675+paDEUj5rLwbnRoi3BKyQGP6mxmD36EJmecRMCbA6ULPRgr38SnrbWoowYtNFRh
/5UJ7od9+SO1U2GDqPjLSPX0nbk6ldImAz/bn+++vjymw01bUcVApC7nLydxeOrfO0lM48h36cUr
Lpu1w2b2gnyBOTOHsxM2JZ4rRZYDi1xivazzF1eaOjRP2JYEIaLU+vqZGROoszOQC2yn5Vfn12kh
v40U13FaP532PRJskoKAspIKA39RuZVZJVi4KV4dLUGH6TXNFnNJ/x/CgEBygZQ6GaX2H4qtOuav
z4iDOVeDLKY395f0j2PZQ2dfmfpAYIOuOnaTNkqFaZ+layki5dGbAi4PmuPBCLpA3Ouogf4hA8xS
S/+g4TLr07TazUJ1L3W0LscbRgZB0osh5QIAiJyGZsZ1rfoRNwf4ONjBCxw1DvLd7KW7AaF+rjYI
O19iDz/K6WVOowouF5ZexbekDf7VgA1jXt8m9knWIkr7oOMcw7zAohhw8rEgzC3eiC+fd1XU5JQb
Pj51TEI/h/WBlpqUAGUJKFdVWrLrtLOFh0JUHabbKfvvUa3/uH/YFpsMr6KD3a6ZKtzJVFRCi5RJ
o8ZD/RIyeo7Xhq9ihn+IAV1lIjpG3GeLjE6idk+uAL1sWJCTsSOwTB88DbOfwVaqYiBZrZ1a6uZo
9smSMG1go3w952PgkHuRvG0gOWm8vw7xxq2BZMTJDRf7UQ5YwcZkN5J2p8iEjcz38Vj/e3kUYd/x
A4cw+kIGk0yg3bNHz/fhxD84UJw4VklnbWXxx46N8H9hSon7VCsTdh6S/uNTe6WZSkrtSvspC1Yz
KVYG0EyJ05XSYDnrZ8msLMka1gM9tY76410mAQTo00cxbsNYU5OjM/oekASOTTCqbrkbGEvpG2/M
+4NIkAo2x701R6Zfpy1eij38z1PKxnog9d3pEdk80Bh7Fyo3HPjArNf34AT12ByUssAjzteUB9PR
ltvtkj7bJ/3zEav/o+kA7pU1/FuCdLPyfhHJFTnqlYy3Q7rq5C70YKR4RYTskAMvCIS7FSUcWzmt
mAqM2BqrvM+FkQT62z8ksFwSUa4sZ/fa2TD2T1KGUhFyLWr/NJV8N5OlhW1PYdfgcwgmTwQU6P8m
XQ0WH8LVDbaJBeGUm3LyyLbymRuhmIAf5pHzSg+kBb5YWryCKsmxSXFAL/9DzVeHEnz12Pfw61Dr
udN6/9GaVseohRjirg3W/jF7xLTmKgjpm4YenxqHK/RqHrJYP0IH74/ECVT2eYtRF72E6PtGil1j
OnuMH6QG7NgQol4QUzS0CYx8rOwJwG4+/hZpXokcGsZzsINr4zX714SgLrQzYZlHhcD9pkvOPjiI
zFaDgVx+iwaTM3HCroGRWFjY85Eni7ojB0dgnWz0Hvfb8aMZiK5qkth3NkY6TOJFOU/3n+R4dFcv
ZichbN4W3PDB3cUZccZjFc0dzve0P0Dxviva/2rRvW+OEukNAnJnz2270gRv749WaKQNB/vqbJ1w
VejZmjmiKqeYdU8skl9+YWXBQjqH8O4gZNXg8GTPldkRfD7hnmQbP8ESIgucd3IHKxulzGpPfeA5
YfQe6XSR/r1Vn1EltgC57+AuEvaFrMMrz5iwZRpvDxvnOtJkRDEGCgRlvbEygL/X5qeoHaRd6lhx
BKGDvHlV8zZyTKhTHWK75TfSv4xGOTnPganPvWZZr46f9sh183sd33/Bv+kSk8cdG1O00o390qSX
ZUIQmSSyFzeH8ZXpQgGAIL54q7pdFScVCgWmqSRiyX9VeMqqvw4C3U/M8+vl/pCzWJ2BtFzxw/d1
gqAMrdJ58JytZD2QUClfphuSJ8baeD8Sk1RAkB0ENbX8dIvd5YQ89KeV6TcVx6DROQKlOAiVI3A9
fcRlCDXToJ7OAWKx5I+S0PKIva6McqYn0WbAocaVlbvqXyGiEf0fSw+dVr13R2qErPDML8aX4Mlu
TpD66/G8X6p+Cl6pRE+TS0ItxUrbAatd+RXI4SXp5Zp/60Afmexd8Xw5Vzf5xfRzP9CMiGSCkFR5
qjo7EJBcEAA76j4/4AO+8ypi8d6KgHDLt9pgEa8HPioFIuAv6gzfubXBdsI2SpzA1To0yF+zu0Ly
UqaLkzGpMq21Tc8McH5XHclH33jewPrWCzV5nrOEjO2z+nWJaBjUdhP4exLgE52nkCAImdIzkCAs
M+eXe9MLe4ZxmHYo3DfNPcS5Kgk7rlGjEdvNyMNaXc7B69PNXHRtnMke4ZGEOfzs6mna0hCfjLZX
kUWNwn59zmFu/JGfqh49MdRtgQHyCYY0ipxw2VxPS+rXaDdhSz9pt2tgol6TnEE7CIAxh4wX/Ujz
czurVJUWHV56y1pUdWFh2+hilaGs7oJJI1HjmSXEV0wpohtmCTpALqP95h3PFLskKHFC0vPQS6X3
bHqnNHSKvm9UJLLaYrEfT0K0WjHIVxQvUkWAcNr83A3E10rkea8/kq/gKrrlEP4puoBTKRLeu9Ac
Z85bgvGnBFAKWq/lsicgGy8N04EaHji426Ogg1hz2Spfke2zhYfxQ+ZNwF5xtAZ4N68l3prSGKIC
g30ILCHVzO1qP5kaayca7tLJEB+Ffs/J2xPW3pOC6XoAQkXpLzUKxO+Xqy4Qfk/pbHNXlVSlRAnw
31px3nx5SbjEO13c8kOWtU7/HF/SiZJ3lWA6xgdSOR8KIYkohpueYUhN0J+79yYMKvh7UJjWciP8
JjkAuD4AOo0/LC6tw8tW7WIoqulRhvQGzvGKLCIYzQmb6sl/ZZbmg+Rk72dXz80uxFzZU+wiQuiJ
aiflxPEkremnu8JUzs44hx/00UyP0PN5elCxlS+UNQfCjqyfLc/VJhhLmjs9WYJ76Ra+5+c2nT7y
CHx2yo+4V4RAwiCparjzbg5HbSV16CY+HwL5mf3foncKsYTtAhApomcodm31iwE1YzSbAGUxGolc
qWpHfnBMHcRk4sbvH/3mdg1pwoCsNFnA6RUfgkJ/E2wvdfEByfNtN0aiONEFeUNeWie3BUYWQeGl
M5DHmuIc7m9tOg+3HxiaOKoxjAI38b0bORH68FDNEqoQN5pSptv/rkZny3+nbXsMA/reCKxKRGDs
45P+pmI1NxgKelidka6Q4eo9AIq3SFSaT/jlaqF2GIteiUrYEj11rk2HB/pvZxZaO4xeHtMZiB2E
i8w+TVFJPxDSo3L9wx/mmCtaY/BRsf2tY2jCyzHEgig+zWithDqD2rAuazw8J0CpNdBIvm300r6E
V2EaRCVCOhlv43P5saQ/d2VkpL3u1fg6Q4mU4nLvtDiTGWAb+wZ8HCiryTOX0Ivkr7jSw9rgo+Ny
lNN74vsb037bb7NnBHUWuoy1x15tk6cHFdEeWptSC+JB0DSVijiNyQL1XBJPEVN8yMKZt1O60z7a
mqbpb3hGmG/vjY2pxUlxORYseBvezU5ACPgtgGnL6kmMTKavpquchMYk0EAFJy6D7sWPgE+ioqV4
7ac0QpFDKYy78Xx0VpFzUzSjaIgGNXXvqH6zinXCx9JOW6wuZconsy90IA15U4QHH06VPGLbxjpp
BG7FB3j62L1RvH4JMZHIiw9MYZrYgaYzzwZM7eQcE5aHmB90QVPEhRSEULnIu/CLVlkWfc/ffkuv
rOKW0pnfHn5onRdKboXF4mH41vKtuTF4OvwSrXGuewtijWG43BHIPu5x0mccK/0Sra879kg5y2PL
sJxRip6FmMA6Ao9gzEZ62y9itJNdmziEkx8GZPUZVLBmjN7cPOJz/yLI1KNTUbO/u6gnxW+TJNJ9
RkMmzQh5EGqNq8onauAuJPZB4CP21ZNGzCvGkswKCBvVYyZyS/P1oe+LoqAFaCZ+ylBumsDlVCVS
8G6urFJ2mndtgsneN7xTIZVyx2PTehAPqu1yx4FLMu6pOxXBn6N5JNRP3gC7KqchL3+x8risSL3D
YQVkAptcsiadDxUbJa9Cf9lzzRuBlXSxhtVIo/nyT9xED2AsjAj2VRdoMNg7lCrfQNuUBUyXoCR9
TDoBD0I9dKQT19Eos6rNgNHEL60C6lqsvBMKXNrNVYJbVmlZKj9q1MsQwg3kqtp4Z7T9m8qaHN9R
wLlSTmPwQfTDvrjZUeaKRpE3ycaHCT2AN9UD4bvamVO00rMeQUiUnIB9NMupPDbT+cP5IM5z7Cy7
RsN6siOLYOhzEJGDhApdudtXJT/SZeo2CwHX4g1/4iJmF7MIOO0ydbalp2SLEWRxjO9RmNJ+wOPX
tYZS2HBlhqBVyOlD64hupMcmUbaPU5cKxb//FnkCf+psHsRlmsUXrw0KM5qozSxFstXI1cW1Sue7
1dmjm6jXtLXQ7Em7T5vZFNyrcbU79QEub7gsjhUPQo60CEYwS+SKxb5Y6VNxIAo+MKYUCEE5KEjE
8LzuSHKIueolzVsKCE+HMaklS46BxYSB6KVwQxhuO5vUQN0sql1n1vV21Yz7KDZYUFSfHO4d2wln
1EPEnmT705sgO/w7u03onQmwfYAHSa5CODOTIpX89qkv5PaiLtMCWI6ha4z+PLAFqfsjG/o0jraZ
dbzihN9+XOzL7FaEgJIrBy0iTmhWiDWrbUikgj7LXDYTWjK4srVdy6CKlJqEgXdtFRg4fdYLs6GH
BC0kt9SZwoPVPxxyxXe76NrinsmtlLcIHgv6Dx6epfkDMskY9nTFeecLlMR0fT/jaOrJC8GJ/da7
YwgDCAZ/6s6MRy4odYzhk9vAkwNtuU++mOGE9QvqBFP6AGEJyZNF2OjY9Nw7PRDr9X08fEWll58F
qbQ36uAb2oKxxuwtUCxRp5yQcKHAPVNMBNvxn+R0rXdqjiW1NsAbFGx292aTXpsrcJ5Wmkn4iA9p
meKFH9iG2T6wKhE2Zukaxj9O7BmrVKVA919t0wX9h5YnTizN+T3KMm8yFz4PMtEC7iswla2QpMxp
UMEzAC7afwPn1lLLk5xJZaZC4JWc1k2qNIn6V8soAS0+mgbvtHwRwsjiLNxIDkYpIXQ6e0RUt/HQ
qqi4XUnyAqJD6HSJHv7CtbSagGerF/9D2KeWcq+QMPUZFuoxrsNaKzlyjfnDbD2CY6HiXn6BmcTZ
MmyHKVIieOO8vwl34g5WCrW29BQ2yZGVKs6485u57+PPuDGkZmNRZGvm7uWUDo5wWI17gWz/72AF
gKNiC3VB5QfWY1Vt1TSsrHXsWNu6kvp7v2Z3yXISMVlELw5m8ugaP7zxed3bSqckvPUf42c18IYK
P0GwKXV836qXpO7J1VH15m2J31JYj6GgJXvGc4iHvCsLerVA3U7LzvanB6bxhdaxGgOx0fq2apxA
Wt6oRdzItlyabgUwm+noyZX+/sLn1tDXyfV+g1C8r/abrkYy/MbLnDaUkg8aZ7wiAuOkhfDM9Vff
nbkFCoPRUk+iissAEqnP3c/b338uuxn+qQ7wChBKAEaDqXGy+tMr8zTvE38a/ZhvPU9ujteYeYEo
IedcSX75C8vGI3sLsV9gTWnsZLi04Nc70KHcwsOmBsM9IZeUtiYzs/BCYdmjCWOtwxttg+tOr1tZ
lvHNeHsujV13ewlbUDuy9i9Oq5BXIWGi9B/QhE8GBpHkt5QKSjqRIs8R+PwvHXWQP+4QsZTWVeEv
29A6fYFQmrkHAz140kOtHZsOSJGpSTIeJs99z2pyLKp7QMJVMsoapSdjuSBBjGT1v+3Wtbq657ej
8krIqoSqHZuSW/5ZyZtG/O6qrGBDpkHAd5YSJfmw/h26ytBz4igkTCcWxmBkKBq0hzimrLdgcYBd
pzRSaIu3rWmx18L5Sbfb8dm7Vpi9WYdagFFzkGLw6eilDptlSD7mbU0yY6EYamvSmJQhAzHCfbin
Rc5Nk+hxUeYtcIiiKQneh2Wo1d+e7sQwn8T5YIAKh7H+tuda4bVJacjC6sKIEoQSr2E+pfCTfZXt
Qz7aRGHUturKoeU7yfXXhvDQXJpTAWkJVTFIjLOEudhEooNeoROoF3QQ5HHP2PbGTVQWNrQn3GW1
f9HhoD4Hg12qNZ2mTvoP90cHgsFIeAR63LZ5MJEDyGfEICIRdOpOV/B0JmqxairmTl+aJDV7Q/sf
3qKG98EM3bdWffKtERAMB8n0CSprI93mYnV2BZHXBQF2mBGkpQXJrJQAKf4cz5yv8QOODSO6L9r3
tZxXYLcvsJQuvhma6JGn/MLABqRqr99IKFOe8ELjnhAAmjxr9GI/iyvByNjBqBUxA+ltSKLnSU1T
pzroM4IAJYc/n3lQNbN8Twxjrc9Kq38R36UJtpYdm37wb6REvdXHZsl46ze4by1ccl1J7vMg6PiA
1xNOM4Qj2ZFJ+OWXt6PAD1e8VjSyXRJkujUz8404P326VGaNiqxoULg73V7v3n1t0cNBfem8/xNt
yaqfJi53FJoHPjs4ITtii1+d+ZOrIDGZ2M+YnHh2U221vEM08QjyKob7ETKgFIXfELQ40w/bLrn3
qy4BcunOlBdPJo5FaHd/TgqVuCiVvB1wOxAyORrMR948iHVoOa1u/kcyktEwQgd4/a0wNjEJEyNd
FhqqghGfqYh9NoMyw5kdD4/ZNKw1pRJIq3aUlIx4GK+fMFwRrEaUJ1vhddBt+gYONiOCTpQ2NKhH
uHJnNDX7+8sQidVpqVQHuSqzv33LXHTOPCHdVHyKnKweFA1f7xisOD19VIwLpE4wS2Eg+CD0Kp4G
+07PgmxogZ4qGluTB8z5YDyPXbJ8C1sqR9DqqobFXqMDMHAbyPUtncu6bBjFK4uXVCzvzp/Rb4l2
fHvXtKNo9JF0TvM+UxIZdxmcAEWIP916Q5/SB1pLEiv8eZnRvVgvVOyOCkLom4Wmbo6bhY0PDp3m
iC+ZbWH4LWY4jFzzVod+qmsnunudIi8482i5HxyptPEsaaK5dK9OMO9oKBPUIAVj+yK0CPaJ9JJq
e85LLS03EBeKGRF4psI1A27R9RasQw6qSp4yaJja4Ip8JiSRaXLJ4V/CymNcRX4qnKkS8+NTuNUN
xdgpkkqNDwt6BSPg0QK/ugA06RNyjyMzZcXnuC5SJUHibqdU9//HN5+KMpLAAEFKfYVcd4cN6a4C
XkqX42zrpL3L9E4TZKrwOlm70HJeGy6UF5Dxq3Q/Sz6Sintq+KkBirDvwm42SeZpUkGjfJn3tsDM
WKz9km3YjsR64S3dRzm69PfkSFlo0YMUEdXrQzlgvEr46pLpJ2hNRaKYqYHuyD5q4ck79na334Tm
IV8PYRCyLi+2BypWdOtErTePpPEyoT0eAHgM4Y/0xdZXM4L2oGKv2CaQjjTxMDG2RKoJKki17ZcP
2ZiWLo12NwBDwjuJ2R3RHHHwKRlM8ZFHVJpla9zOTtpE7aKv5CMk4L0Orh7nj7kQT2bbRcE5a5zQ
5C+ia45+JY0yq66q/MF3n+B+cDC8lBzgBb0i+57VlRcwOCYuoF7V7LafISlci5ycu6RnwE8LuGBP
PuL6gPeU4TabAqjt5u5n5Xyc4pOp0GPEhQgPko/nW+SMp0DBXHakxyuzhBknE6PqQkUh4h8V4YCL
OtWwTxVnejyQ8w2K5flGVnASDaZnzlvUfBm67aZaAG2JctGVzOwofVSPSYU0acllMfL8f/OIQVQf
KgQ2Gky2c77GD2EYGnHctTuXqOzneaGg+t5nfAFISVWpv/mcPR6HE7ju7xmpqfWE7+/ONVUMk9cx
/AR6sxvdqpVzC0tLthSzh/xV9YBtPyxLcVsflnxImBDwcsBPQYIvTkUytUtemrMqKwGYvnLK3s3s
J81DQlwCJT3+PrS9hBt3/EGxBxOdSRa1sPx+kCop/f9xG3rATDswtwFrwG/7em3jy3VzPCKmHndn
cOTTDNZwPPzNNi8SEJUUaqSlOcDP2tMTecmeiG/XB4Lm5MB0QQcU5gRXJJgnx99qCGLUI7HBw4co
mnhhr6whIh7f2qCajqy9JMkpN2P+MwVWQcigJwMB0gjHxSdyWy9jIiTKQY5zpWG4tiP9iiU8Ye84
WXf18FB9ieKpyJl34jy/WTUzSXrexb7wBdivNaq/HFy5JZpS2TBVKn9cj7hTKLKQaOypL9tUnbAU
DyEfRL0E+NYTYLIxyi9CVJzRpyo7W6vunbz/COHXAp+NLT5yCVQez/dD+eI5dWDFzbzVLqfQpxOZ
Y351cz1Oht0jdJcc9XhsdJfiAuSQFroMc0Z6e7N2i3qyzNqQMxhOKXbiH8eMiVFG6w/tqevFD8AL
CceNOtpQXWvrJTuFJlWycETAX+xTmwyPUcgYh2W/Fz+ICvLpRdl9ZejKdeWww2V+NEg2HXyHM1YH
kx86X/Mojt1bAl0OBxyR4ZvfmXpJiWjVWNzi+k1RfRa/RhZTaJ7jlQly68ADCLItuMfTW6XjJ3sn
uRnOc3Ts74Iqncsh8Cl4T4+1keE2gygUFOpYbXLO0EGrhwFLExKeFV7c+XkMTNvMaeCHltvNZpfR
Bn6FO9zmmKrqQYRFHiqdjbwjugwF9w2ZUaCeboJYz0QSU+MSr3+1/h0jw+d/4x0ETUrs6v6KRrjC
UN8T9fNxA3NrubJI7NzHw56GnOAnKG5gQEkKTrKIS8btRuYh/oFpsvwMxzUCEn8mjkYPd6qa+y3G
sZhJfv90go2wQ7KsbRB8Sxicyxx7haRebn25bwll755FRGbaT4SsaQVqjYpq8urQZCKcHqBI9H+w
CQhuXQBEjYsadmhakj3NQ5f1A6kEJH3d24oVNYKDLL0wk+xP+v3ke6IuO0nDZs402hRL88wvEeWe
+sdA6axrB4ly7sZKn2ELclFA5mqyWD+wxoHJk8kxfzN2ShbXrBZ2szVlSu6w+5qgf72FLxSA4+P0
717EmsUGS8TGLJll0zNywaWqeQqlHUXzNC0jFUNQHvWB7TOXJhfAoFcKBk84BfB2yo1vE/KJLvYM
KF/XWcvmkb41eR7tGlQ+eFVD/lSwK4oqdB6xVsnqgwIWR+UA+sIqUm5MiyOS4HJU5fhWim+98Pb/
M72ZoEjjx+FzvgFV21CZVmTTDsZsviY5BLST0jt1xQYJtM6uaX9XvbyO9byeW2rb6Io9FoQ2BcHj
/JdVAZje5AsGAE2qf45H63ccRwpT9zdiFwijqf89RF/HdSF2/NRWyUaN6FJa1R1WWuMQ7nZArrYe
H+LVN6Jznx7tf2M9woH5ooRbxqoHx+Mj95vZun+eDeE6yekCM1R2w2I2P30sGMktI16qw1HwUPsx
3mM0hHqKqSkWZZ8R05FJcTg3JCA1tglUw3aLjxOpfjYVM15+WDuCpvKDHdP71fRgayhDK/y3Y5/t
PkYlq1eiCxLuxQyh6AhSVvv1vq/M8N2zoz/v9l+p/K6j/NtCgrgTG4i0ZSI6xVO79dSBWbn8xCOF
PCQf03mkDson2QnIP3YxNrzxZrEEzm4L5AY0JaUxc2jMTgyhYlXgOF0cdzk5t4SFCEX00+vqbDE2
hP12WGfv9wFHk1/yJyMAk66W9yMTFGCRcUseGVsoTs75Ri9K3zMk/Lw8uWw2WrXmdUARTBtLQm4+
onleq01TdVh4M3Odt68f97UtlhXyaZXsM7nfHw8dkV7mzm03a0C9QTgYqPCXT8wKGQVLhV2B69V6
goMksoToCrDqdJy3Wtsy7v3adIZMRV316SfIfAD/5X7nAZQc7foB2lzWjDfdGUq4jb1+oOUshL44
E/GOSuDAI8aHi0tKMgbermOD86PgxWZ9Nk+YFnfu4PIK/DpfoHlfkFQkb3DjvhZe61d8Aq9fkMm2
d/ZNCGCytynKjlc4DNDKfGrQvyiDmW1OmTRk0swIfHefmcNtyVME7pN+t7bg+7YdiR18koiq6iZH
ov7ol87fWRDRqrvfpJ/JK/1/Ac3Yi0HkPfaS6ZC6iiT1oG+q4uHoKOt/5lc5Y88zzTpe+ETYNWTE
vrn5bYof05UTlrGS9MJVr7uF26vEURU8EkXmNOQp+uI883bXVfspUJiebhiJRWc5IC40GvbhuLXH
DNz+bxsB4MccTJbn9Dz8NRV73CVAozfjuGRA5S1ynkPIkTOrCA2RuFoxZy24MLz4zRU7jMUspHA/
Yxk+RRWAv86W4pJdxxEimgtHaiZCJObjmtg8ksYhb1D4j78coFFwDd8HWMQN8780Tmz7fxT/eZct
ToznnzN9Nde+2DwF4/ppnSF6X1c5kIN+pbtiai/T2Rk+GG8D7mnVuA2eo+YiIeksDH4BtNOHQYK4
MCCvWJie6C3iG741dhAZwDjEp/Lj5lDRVc+LIuh5bQp//MhrDOs+rzbqVM7D15KUOkIo8ab1zlFw
s8amFwcBSGTCT22s05ZjP6WZSnybn7VJvl43FesoWY5kvRvBVkCRNKovQp9bgG5T6/gWnoxx+tWF
OCzKvP/bnwicox0KTOouaPo1PA/gVJBSZ5BDfsmmajxa4rzxU57tSDQh9WPZ1uovPaix4JWem/8E
YvI4ZQL+2Y54674jWLSkcrvEsIzJtCFRuFKdAnr2Q/nCFpKA/GFleFVHEj2vwYoGiderWI0lmDve
7Mpk0V2u8/1PlD7DvXVXPGsJednldT++dKKHjpdSfYeL9jrGPH/SKubAtBT09RCMbbzDU+sxtp+I
6TB1o6znVnuXgKCofzqVxjTsdNjkzITza/RLrY3Kmzy/NiGWhBa1c7r4LjYXBrI09Uyuqhi2lUfI
02kbC7MAsFXcxvL7auh2Et9+BeJ1JdTAUYRfX16L2EPXleMb5UqAksQbFeEZFEPRcVApSZR9MuqI
pRX/gvii5xpIe4SBgwy06uCor0jN32WoYs36QY0h766tceVq58WpnXXNq9/o8ni928P8anqmgMRd
lNI191KUiFbVZlXW9oslglooF6eTp55FFMNXxhZYYkHaSsPGju5jK/tSJvlnHKFOQOp437u61JPQ
prVIKaHSyBoGGnTqkfSR+2VpADpQUN6JiLaNnqAwdxZiFguAgqWBS6apdbyJeNaJvjZoG23Rhenj
8AkNMr9PBLYEwxSB2yJjv4DZyCuNYCnbbmTeSS2WsQmxPz5aY5skUuQGoac7atHAGdppZa/sqrZa
O0A6x+Z4dt6j3rLMgYadrC+4ShPXNjDXHPYj09Ks2u5sD/czxVPACIdliDbaQ0Ou9+ToKbO8snk/
u1NuDOgSpeDwpPyO2QHVqQ3Fm8ewLhY0OEd60q0So67KY+Ct7nbnvpN8jUuINx4Q2VyqDXdZX8wq
wZIa5mWpB9p/tB9+aL8UjCRU+wOA7kW6TtwVCxDaYhST5aKqFyy2XmneEbVjs3/VSfSiqRon64W8
4+Mref5azk1iRCPJDaoGebjE2eCZjuINyMjWYUxu3hCi+TgZXU8Kq+ql8BX4eK/gHZoJvmj2xXfB
n6C9rsX/iIEYSQXvLFBGf7tN2qkujmm0HUPm5tfAuaDEfrnrgBHca8XK9KKKhFNhLXYo4KfCi6t8
hyBB+DYXXYw7tY/RaMJVdp+g+s7LvIH0/jXLEG9c/A8A2DYDxE+BhtK2sXHllQ6Dl9iX4VmF8ZVo
WIs12f7KUsIjwc585GozmuMbWlIArn4lk1n5Ir+Lpbfl4kN3hQym4kukqVVfExOcdPz9WpB0ACxq
S76BmEmhKu0TOcqPJiobPuWzYET7dJJegJKKm0IZyTwomeLuELK7iwkQQsKHb0547PvGmok9ME5i
S5RBkkYJPVapo163Qx5mbbUZQktDUe3+MxHoCQopWkzUkdkVzAK+k4WkPXIjtaT8kJxAXH0zxf7J
03y5MwLLG10emHV6fUUWBFnUZg3XLPAcLlhGBXDsWlpi87lSbidPFvB/VY1Et61xoO4yOIalhmKn
5/I8ADylOfpp9A3LcOXSiDFIxtmhrlP1jc9B/vYJOiWyTHm54p1o5beIwmA+w91LoLI9aorKcds9
tf36tNT50/nDOevem0eP9nBhPmbwGtXJPmhB7QA5KR4euoWLV7zSc+PLlz8FVHCe9AcOrYn9Mf2E
YJr//cRpnvESLfsVCYwuaKc4FUn+gcjmftLq1kucng0Q93v3eIWQ2YoIVra+DAi4OIEnYylbEH9W
AgzXisajiydteyQIRVMFWVM7NGs0hwxMBweRgIoWHxtuTufAUpU9lklcxtaYRzZ/RIeEDOpgVexP
zPmoqHUtwOHVzRB+wAoaa+XJBd+mE4Ns5BVZUGnMMJMXOBROFycfZlgOGG+uu92sp2/RP+YE59ET
UZaLKrFMNFPBiaIc7Wi+zU6PzAaPUQ9kx1ifwPc2uAo07QMiKyu0Ng9QTtmYXsNpBZv4bjNV+fr+
RuT/HduqRd3eUfrrDhVaBga5ppFL5Slp3txD+1J8eiZmzbuSMRFPaRz0+7DF/qZkVMmcLgBrHnl0
INBUzlpOMgPzEwazj2wM4c1Um3xRx35DQMYWK4/2A8a5vM47wOWi/MDlQ/d30nETLui7wrpgXGdB
kyynD4Y6hbdr8/VJL+NT6wtYDKtqI8VI+637WGjiXWJMkSQ9jXjzlWvmpBDtEUZCm4Wzq0uOnE8e
BuUQOhBEwCC/W1SOzwNRyezDDCwePureuzX8EfS19rFvgi9GvvA49NCOcM5bbEq6k8J/cwgjvrXU
JKdybMbX7ZDKVdZViotOny62r3gGq08qZgXxPdnwKsK1UJjg12UadZZ8+7736iY/D8gCjzFko+ai
9tpvGTqELqMawGKzs+P51zT+3PZtNaeqBKnC8KB0bnXtYMEBfEU2wF5WxVPcOwlt10C2oi0iP5Jl
XE/6m3mpGe/W0w2QaWQVCgOYHZlRm/J2vrD7waAsC15sTugqxmLQ+z5UltIscfsnvAieWIzGwIWV
1I7RDxLzeL7Z8wd0Nqma2fccFHLG/V/tANI6Enoc4duKRbb8WCNnGby/FoIhvWo07WksmA0sq8TE
BZnJF/CLfZBPvDsK+ECI7VquX2OsSZ+bqhMo7ipin4H4w1ZnJ0rSA9zlL/PiQAC2yUgaE/DDSyfR
c9FAfz/pSRuXLBZAUBErjdUxTlcU2gBhcSjB8bux8LyAjZ6YnwEKO2ZR5lgM+yI3O9DhbiyssD/1
tS6AFvRIj7xiHFPrAM7GhvBIgSnwZg0Fj1ganoBrMXnZkxkn0ks2HfK4pF5Z7Y16GFPtpEEwJu7X
sKWFj+cn+RgJ1kQOiUktzYHA63UvY1TpI6AV3WDe9v0C33JDzWcQenqxOAxPSEMNAwgPxktch4/r
2YlS6DcUxNwMD1lvUKbX46PdaNuqZozDx+qrh7oquJUt0EWylUcjsrS6tkaDv/HLmBsSnndpIZ93
6Ba/uf6TXlczct9jj9GrsrG/UxTDCZ4fr0loOzPghicRouYBfUcNIMRWfFrO+ZU1hQxNeqQM+Xoi
ImsZ9HgrL9oSuuD+RzEKQ+U/qFbkpF798wAiuLzSum5DJEu/YiVosAcLBiAKk14ZgSu7NbuynMXZ
MIeMMWv6sVLD5RXA7HBcEyNm/6gXZ+wJ6ljvpoN/eYbVkGmwkYOlQDTK5Slhqg8TkguXp9D8chHo
iVAlpV2GxI+uGmhlne3t6+roax7+WK696Bfl7rm+Frt9iyVF4e8zqGtax0fl21YU1+MH2n5K1fGK
HFjteQX5kTTHH6PUywawIKYTDQFz8dvKikBCHdwY0TeLPjPQwbqCyHQMFS5dPTLIIfeVOKU3u74u
i4atRCeyTmMvN32FE+AdsTjEgj/Ytw95F9zcvTtVlSsvdMnDg0pKa/jbkDLi6jpYUhYjuJpZViGd
CAiEkCTQeIkBqE8P2OByddyuNZRaHCimM3tePVrKnjdXhBujiZUVsH4IYJvCj+KP2mLL+JQpDYQD
RtNQTKn2zv0XGOaA8SDx2tpTjC4vASkjVK7rYEqOuv5eiGJmLFo9+QEHyZa5uYkgWQrpmmaatQ7F
+3ksUGdnM0l7PH238stXA/hlFEGEO/kpfzQ0K9BNQBT5Of3NvqQdo4kibRrXLaRcH5UpV3QKcpao
MFIvXz1Mp5dOK/DeazfFssJ9lBfFwufmEj9fMQ+NT95YNs7eh5bRRgkZ27yGUrjc0M6hPdGNUvTZ
y6/CoqcGU6G+rCpfKwPYkRIruAwivBmQK4RCaCUGI5hbCNE+xnE2R1ZemQHI5ka5X3sUPB+BCHqm
0X8ks1+Te4+Bi5dBIjU+M8iNtNwkmdX0VXx9DczNRuY3ojUw7KRqEcvd8ebok8WFA1mz7i3hhKLS
76KysOQxWAr4VcLif+QPKWASFn/Kyxq112jkkSuQjfPp54YVN81s9NCr6KEO4yBQPz6JbjI2VhAI
adxLeZFKGYslWVfV+LRYP255e6ZeelEl0Is/4IWSMcpckKvWFR6L5aHWZiHX5h5JGO+z2jR4ICsm
nH6a8kFrphntpGCkIfrEbaWKC+3t/T/SvIzF9dsYhFz8Rg/H1uzE/yYCfJRtagNsm4n14Uc6B9iH
Gh4iuFz5tFB+WnrKEKYnnK3rGqIPhT/YZLHc042FyeoIzHq8kIrdlrfgp46N4hQ6nM6KeHNoAqth
t/U25TfDJj/2iFwcg1HQPvx1IZs76h09V2ZKZ6hGE6t9H8rx2JY5fIMA1JD2NnbDA2Z3g2VWKjUP
A8uwfLdgvtpl0mslJLuoh1rTqgG90/aOyD4EeDQfFXJl6wOCP3Oof+3YmbuovDY0fHwu561YiUOO
Ro4/YsnDBg5ICKB3Jw5jtb34BDWxqpB628KOv0HGK+vTDfRAaCZ/ZUreuI9xwc/yWd4Lg7/qt1Py
MNMMzpLhAXwyjHndC0jUXaTr6UoJCBxSSJfMuZl6OGgxHDRZhq1HT6/tnJEyFm+GvnFHMgNund9E
AOJ7dbt8n3IVM3XyZK3UiRtaQNgggntaLOXg5umQKkyxopy+jlQXDva0nsnsF7N2YFV3pcDVIGp+
b0J1ejLCX9iI4pL1mJt4E/eSRL0yLvIWbnvhqnG9/n/7vXKVya049ZUpYbScLa8XDOS+fXumUXcg
iSm3jZNr2Jbz3ElILMCDobkAH7nUuN5aHCcw9qBTbaLdOo+OOTiPXaUF56AIX3fKFnZY1Q7zHKMO
JFVqyRyudINhsHPCg0X+g6WRJWPIs2rhoEc9msxQeC5iSFl7HBy0urx1ztzvcrMWm0kNuDAvwCpe
Q1hjs+xAKhzqq4TrTVCvgXSEbNquxRpDacNQPrDXW/3HUluAoZ02MWACrXhlmv2aJOTMquvvfrtu
Xd2R4o6wtDPN3NIQ7nLy8RsOOv+/zHN99jqUqxh6SbX+kqRHflbQT0kNp4/PK/km+lJf0xQCU518
hcWfA+9Bipnt41ZASZlGbDERjq0oq0JBPO8G7mGtb72VPTHJvAbTcPi4Df9iZBA5vdZ1El3z418E
L8duLtDIL1K9ja1e88lOMA7OuLbPm646X3Ts97NjSzkKctDPkqyPc5+vyAisU6CEXaVPJ3ORNofk
ZcaFQzeTUzKRqxIwOmREkMlV5GzZ7c1ev4otIl/Rx/iLwQ8gMMQFBZ3e0GCz9k6zsvEaaoP/LzDt
OSIhqKzsxyVp6fphpF4zei1pqIyKQQ74SEBQgcLF1cyWzcNILCfGoOlxaRxri44csV/hkVlys8ff
gOMZUDgsfyew6+IQM1rC1GQMwLrlSdhQgjA3DsU6Vc/99q/e1ncACXrWMR8IiVAViB2ZwqPpJuCx
VFlcZFZztplknJVTH8fw59J06UZUWdavDjHFak1aiJBqlp9nJR+sldBwIshVk2T5v1wr3gqIPCSv
DAKSTQvAg2kDtr7B/YyoOIEYZVJjztK6fXXvwdjdvzW+/fRzEl1rhab+GM0KuWAV0Mt9wFudbDRV
3aK2+RECUtLVlXjoTRbzCYLav6Y0oW0d1FBN/d9+vCBqzh1ogCM6Ow8YziCgdUZ7wfp2tZCSd4Xj
BHUGGtYlip8IERhzL73OC05s7Fd9Wtz7kxA3+AAO0BLjOyJv+Y7RXKwmW1akmAgUvhCc2P11WNue
7/gr8jSD7jqyCaxyuYsqHfXP889YVXcWifT9QlSxnvM+eaRKhSTo5MFrkd0XfLahPFRa9rAufpgQ
zha0gnOG3J6tGP80l7LWkHL5jxbc0LMyMQ5IHO4dM33U/sNqOSzVqvSEHB9UbHunn1/S6iYo6onO
98s/0BZdbspDuqDIFtAM/EPqR6uqk6nOp1qSO66lq6s5WxSQaemJS3j19poJWRM/GxXGyZa4BYQ3
eFH4TEl0m+dU3rRujDjsw4zVytyuC8QeNbiuSsV+RwZLaHaDewtDegSId0lpHHoW5urHHGSCkhyD
4UuWV7NdFXp8EqOmlm1wITXB4FMPON8px/HRWfTyiYgJBPKb8UAzO+XxgPaKYH08zZo/tS74Uyqd
qjyg8KKQGP/SJy1gJZUzXxS6ttmse3tci2p4WYikj8BwGDdZIO7454JOBCMqkj+EJQkuqY23Z03n
rl4EukY1eumsIbRLwjgdx/37ymWPWCBu4qtSvzOOAA6KSW5tv/yiDWxFTQ6fvwmEvHDZbElz250x
+EJ8UveJkCcK0GGJ4vN1Ego6PYYFMBdsisku9lTMzoNDMqBahO+Ma9jUV/9ScT/IOp45pePGAf6Z
xYBgyDSFgn704UqyPP4B9HrsG2Oa6ScOQmnRQ+fyn8Mt4DoX/0/HecXXZhU1B++UMvJP9Iqb11O1
7i9ijaIp9Isek8z9K9QJzGVak0+ZGFKxf2ozxXukPrWsZDB92QbLcCleVJ5spzvc7wzIlhHWa+Ws
wc7x/RL6+wIO/eX2ANMEBsjuzagAk1p4SqYM1t1PPCapbn4UU+2qoz4vfm8rynkp2ZKy2TKQzt3p
oDFZ7y/jim+lmGkUY9yiaoFLH1J24Dk7Gmfz2UxquupUHR/oLgNW7dFeRjX/y4PYZGJWm8ZCW9Hp
N23RjKu+eWD/gypKKg4lJ+L+0KvRjCnUdOA8cLPpqrJVylbrsfZKJPM0/aCUHRRbsqC4iijmqWRj
H6mdXcjSN8hSJZm4c4j0RYWgwj2qt54z4bFnTkjXuvGQbf/0dR7DxQTiN/OkvEonJp6V7jxUFYMf
jfsaLtrDLpT1zmGLI3wzT81ur2WSHorJtNaX1+71faaQqqbo4LZvFn/IdLtQDd4y8RhwabNfeUTD
SlIVrexWz7XUicx8gobx9PiQ/nIhaLa78u/tB2h4YbxUDAIYpHLpDyDygb3B4KnEQOvkCM75iWRK
YypSnQS84S0Fq3/v9YmXNn3Q/UCiLYI31+LbcMQFyD6Bdo0UdLpFJPv1g0RNJhaKvKSIl/wTigI3
H1cEi726GYgIgIJgQEQXKcCe+yiitasLZKgSvNJAnWhAzS73SJTJsEoYW9/9WUI5vXLw2wtpxI1n
MPq7Ex62AUHUYdO3cn3+bu0GS9ibnMS/STFEeF3T1bcyLX1p55ZIzQk1Ao4BLrmpqAEe06P8pW6f
EDNRijbtrVoCW/vPOUvMG1tCgEyn4hsPZ1n/lKY+cnOScb5WJ036NOrr+uvoU5Te6JOLRVcOhj2P
sKsUU5UVCyqsEQheLROuASAsbA6pelc+QphzSuGCKn2miwAOzZRFFIIxWjIyKYOfBkGWX/13332v
nJ12mnwTGjICtKvpC3B3G8G2x6jkI+MRoE8FQJd1+kYs9N8zjNhuMDojgysAemPfbP8dUL0/lZq/
2QlNqoutL7WSLeIOvjDOl2re7tUrS4+YjvcDIBtbBTua2lGThLu4wd+5WyZNvT5tCFVEddg8ucFm
Dv5WK/lIuYUqAG6ZYZV1yt0PG+4UYd6zA+befPu60yDkb0gmjcR5GofWfis2kS0ErEK4oVovWUv/
i8I7OE9p4/gIfNOwFkEZDkCrKpQeNod78gLh97/RosIQnpiIuEcDMlf+jAL/xri76T9jAkXWSjNL
5NbisFzQ1Ryr2i4J5WBoide8vv+ad0P61ESHnwuLJxua6shTt3RaTd//+GolkgrZ91HBOZVKRriQ
6fSIm+rUoVs3/3+/qHOpNh6QI0Tk7EcFzjva5aDVq8C/fjLmvIG0Bv5Fx53ZCvXPu0I0yRAeGkUw
GwHnfdP4AVxgqRNhCgZKVls6wCfUJdXpCGHhhxzQdbdPVlw8V/nTEuLem2dB5RQ7VIKp5TZAlHBz
wmymnPyFlWa1Ffz17jkDo91stQ53chLxSKfcTpJEBmaE5tsLiSYli2b4VxzsjoVgOdKDmoP29Zbd
4aXymGwr8GKcm8T3X+09T4X8wXcvbEnJbkmFbFyiKvg1upDw/HnxbP5GoIXYXLScjJjvtjzi+7XB
fp6ATJVpKuoMKDaa/cZesu7+d5ZOMfBqOUZHFC55xZjxb4WmKhL/IXSnCvZ5qcXQKSjp69qXekQv
QoKDqldEyUiig5/P8riCy8Qp86NjHecp8VC43gvsEQ11yVuBUejdqSnK26Tdfm/ejritnz1T3SJs
QnoJ0v4lkSbUIdlOt+CHclpTVZ6OTfE8RAzU4675nfP/NXAT/gSOA+kt7RsfVm2YbngPUZqo0PdG
mYItplhhicjg6vUcCEwPtgkeZ42qI8FUt4tWs746snG5eXkXiobz2dsAkLw9olabohknvMMErshh
M4mdLoj/nASqjQ4kX1W+couC0wnwVArR3ORuPpN76q1V5qUJkVQl9TWpRbIi6Ixl1OnZGQoMsZAq
bvdbjGx9XIZEvmHWJEAEL/nJ34fKZ1iw3tuWlIlGUDNgtNrQ4amuig1esecLwDKXFZKxIbBhpdjr
a6HdbHe7KyxHbVzZQltTRT/a+vToL8MlrpZBkMX5LkBIcKB7/oWd7IlwH9qooRZsrnZlmSaDKieC
8T4EE3wgjb4VbO6st4VQO1O1vvriodsxWjPYwVSWUf2EBh7sBJYV/g/1WB3ul3klL8erD2xreY0L
hPrwI2t2F8RDNc+Han6+zHMmp39xd1RVCUTPgO+k7e2bnrCex/ttTvBp20nI+qlPkrFY1BDh/4vB
RnjBIm9P2KknqFhAp+lOf7lydfMQVBnU9creCUDIaS56DAxm7WBDrSKgRdl8iWD1FHnNmn9Smg/w
G4GZe1aBgZcJ+r/gB+Bo3C+29wEvidyuEfNpfrLfc5dyM7yYWgQ/d7rzaQ2hheXRQPN7euC5c2aK
KfmxHqkBPW2npxsuqZu3TNNu8KH7KpJbjqGPTWBtI/3fvobWK2fuYmyTVhZBhQxOsp7wB4wggKat
0WEGM11f5zKNv4F1rMTtFORjSyiPo5vCkl6KN8/OI7HbMZQavGlstxFxd6/cScyTQF7ZCzciB5ph
UMbDQ7Ig9e7KdufG847lKftxsNgLye9FvhP0jHrfkIBdBudJ7rq/Adct2q44N7Crwyqi/oiig+qF
qUqrpfB9BIupWhRkaORDVi+VzH+9KfRpxtOSw9vRhmTTucKgTZRGR6XrhPxkQ0Am1YwCE8SfvX3G
bkUP8lCyyWMjPl+StrDFRJVl3L8+J8bKwDm0M/dx3sl2xcRiSK7xxmqml6rQll8bqdkqxOqQ8Ku0
jdqqcjkaVvbLIFJt25FgVmnbh14DRQgcFefUNT2c8dNzkG07c1ZQU1sEz1BeonAqbIvzuI9TUsZF
X2LjiFp8xJHaz5vHxX9NzFnF2ZcXE5SPtNIwmiJWBrqWEbGXQmkDHNj+6UP6yguY6pzhDyo0druE
bB5WtfdQuWQtXhbVBAaLZN7Ak83HOBe4wdttugbfgiP+lrjstZujNobimviiriDxSBCAyxATCKZL
8a0gYofVGbpWNozBB6pefWQ+6lhCpaTdADvpgYOiwFvXiZtRk/dquOLa3XF8SJhjJCLg+4MQxa0k
LbZ3yr9r6P/ADyjvJ0cx+ewn9TXppebdE7VxRyipmPPluRu422KzL129kLrK++gjX1y91JCBM0t7
WBHScCWt3utVqs4F16899AMrqJM0Br1yEY/qXsXUvahnqiEJ07syIjcgzkPkrupTAAoEqspM4+ss
xHGGdMez0XOy7TKMec0AG6J2pcm/0kl5/IFnmYqdj7uKFh9Z3D6wFJ0W5bAx33xhO+8UUfpRqhzk
4PY71iedDL0hhi7LscNg2GabRPk+4lLozGy3yTmJnm5cRJdhZ3C0LvfkY8YNww2Sjas8UR2TfXu2
MmOd10CnWbBLmxuFgPVhn/4vXRuhAvqKoM2F2uN+QWaACsbb0m+6Z4lxDg0Vl6JGRfxFpgY5sQDi
ykKpSIOkvgLXVnzGoUFaHpKubhjWqr2VtDO6MLH9019WvaswO3ORhFequaZwrXq6cPP9hWS+Ohrw
IUkz468boTCvpLBC7Fiolt5IyQy5G4YEeSJYn+JHLMx/YQQRKLh2LOfoaWAU0aVWhAubyHRZaN2k
pTvOBcCKYpPYWRFRfV3WPFouQWjZ0kEoYWjm9G7aRwbjFDjUoyy/gYaGv69pToBwoWKsHCzPW2OI
dplAKOEEVw0yrva5eXNuoRH5/tdOgU62SomTeNc1/P52mPsOoU2eeIytIahUh2IoFFd1j0b6HD2C
2pGmmiZVwy+wEXu1zO1X2BL1jAV7T3Nnb4F+OV6EDUPEkBV1t5yf/3oHBStXiTQI2KiyY/2iljZ1
VcDDXNixZ2VfxTZ9Ko1I/NXaEQtmmbDYaTvH5G4Eu//T3ys7i36c6xVqFez2M8IzNGMdf3Ie3BXg
tqs4IxqLubwlP397rI+Qq4yPwo+eOlEC69Mhy6R+PghRS8tlfpWNhEfA2pdU1tWLEkyKYEjff3R6
OKFTiA82YpSuFA3egDnuORrQ9Kq+iEgQjKYmeL/RAV9YIZucyDlX/6BH7t5v95g58mOKYm9TwD2j
CB9l4ddPeDrdRlcvCNmCzWS28sV7KL/7XvlHaI8VU29s4vzetpU1rWoVaOwNuyzY7QJhk+xisgdx
lMf/26hLGdcP9X75O3mC7rOckYxflRq7yATeQTwq95W7fAV0D6LZCYP13cmtdxdIrPjesLg33Jra
xzksvdnC6oGPEIZYqYQv9kvO6itNYWowXKfi6tk9y3b/V+t1ILqdQ0TfxHFJlkLkt7jtZF0zCeR+
3CMVg+DA6RrnQX9AxWDOFUQ87XHrwHnzCB9zj+l8C7A37xeKx1c28ZztHd23TLdjnvkLCzKRfJIE
y0p10QWxS6agfG/IOITt0Tzat8GchGXofW3oX2edceGYcpOdcRoMauw/Yl7FyUYU3IAH/+gZGTUO
LrRRAaDQ0WmzBFsSlQOcwN5xa5vukRuS+bzBE2qewxITG49BAs26P3k4gdrz0mNzFh0oYl0/gSfY
rNRtgE43as0t3AKppqNyxy/VHgp+vJMppaM6ADrbwZcv0qIPbJBamnG0bwLUx8YcNBCV2vuZn47O
q0vSjxWHtVvaw64tN9z7yYuqivFizukFLRJKpZ6ez3K4wHKaj6RM7J9Y/Gf+Exq+YGRM5fHwv8NG
KFus0V1UqzoQoKRjSBw6dqsSlhEYBAiRrWUbikbBJ08om0zEef/Cdz621q+YK4K87zZbIGFdrTcx
9vwU7EL40h5QzwBN/BGtl/3HeOqmTZMGhUZkf9EFTg4rB9VRBOhsg8w7dLqfj5S6YFjbLTPr67kJ
xGSNBBTN61jhbp2lxt/7gO3EoCKOXJS81RSsjh3eYSm8L19YZBrlwIHRy7hFJV8/po+6xM/9hRm7
VQSnJgZPUeSCy5d338KvCINCssYAdMfxP7jFulXjBDHDwboSr6qD54ecbgYQPcHCf4lHbRbWZamw
Feu0UI81xCHDVQ55YuFU9sCFA8PVWU9fYSoOfZnHJGw39sXckdjzj1ebd0SimCbQ8H2KPJk1zCqo
ziV/PcrgidLN7oMjwrlvJa8aHVNIEBoG3YrNEMWQ/aw4449m+AdPzJvjkHTQbyls1TrUaN+jXH0q
ClxEfu12OhuWUdZU8An5rXz6SynJ5pqY1yj89vDmFZxgxxfkkltH66ZFY5VX8lPyVzbxcMBgOEdm
IMimebvmFXcyKFirU/sK9KN+eugL31bV30RzUfbcNpB3sG3wCKd0huwFvaCf0qvg46nULWdzEIfI
DSNIyH4qxi+KID5BdqQOSxjfJ87N3f9fQp6LNji0KmrHyReoD4tHsDKTPgsKt8jZ6uPXh2YbJumu
1VPxUQ4jAB/g65/tM1Qf9sb0VMEjmwQtmeF+D8pgWR/ewBkqqrAZ9VkezhpVTTkS6WnxLE6YewJh
ZZ9n7x4zpEu5vynTJz6okkRzlu/F+QeLlZABn2mgFVrSWvgQNJ8ZQzBgq9OYPZm5ts/0hguAgJ8M
LEnZke7AgQrBcCHuE7wI+y+ggIP8x5KCo5hLnv2/kItdsuZ2CJojd1tj9I2Xv34RW3Izm9mdbIkC
iqTyY0/FAl3auqpxEccMfSK5zUCipsZNMiAAzW52mJF6Gt9QPrB+hESla4f+k3EGdZYzLb4fDB9l
Jx7y4EuhJk+J12nW9LdHe6ZMF0hgPAu6u36KOBRn2znzR06plnxmorxILCYbONTLYCilCW+Cc5wj
SG3em7Uad4eDsjZyMjTMbYt0G7TN7PFLcSrlnPNY3BIaMyn+vReMGWTVCBAA44EK2jFnNDmdgAvR
pcbCFAceGupeV5Qho/keejxJqY1TGX+D7x9IRDyAQd67F5URZGXM6k7m66WiAfatJJyS1LkgAPc7
k0apq897suAHauXLQn5OoeTeADil9tW9rkiyPfLNH36Jf4JhAf07PkBfpguXEGtE9/ZYVVLRZYMX
6U43zmzMFenwpZb1+U4myCAi9K6Q1g62txE0/Hr58nU5cKVEdzBP6hhni2wu6U1igWLcRCYH5W8d
Ofh6Q/Lz2rcWnwWBv+YEhzH1SENrwJIJKTV1oG4j6WvXpcTOZ/qAz8F5sg+DDXHQE1gmamvV0+a2
RKFAStTgiFt4JgMgNPhXUZDabHvLZYeN/3PDER3EBHj1Xlf3IXQYCpNhIToNYSQbSpoQ7TnRjKZV
nHapcsECdqWi6FHOGQNt0Pr/DckU9tVbhnxjjV2KPmkW2frz3IERfEjvCGiQLpg7ixtbiXXS2gFb
hS5gNZy+ETv7Wn1bVYDzqHIaos4NnG47aMb6sE5W8a1SR5aO+Q2n4vuLzXrU8EyBTh3f8Qr7ziUk
Kr5UeMGB6/liVUZo54nVggiav3imcRpMzD1i1pxIgWL8raNAb8yAYQeVm265y8+lXt9vzYBMitVh
jFSVBrJEnwJNes+Fz1xjAZJpNLjNWzrGYyK3gJcdUqGxoBCJq/Dda3ygH+F/xEiK+k9q/GHBs3bo
Fb9vsL4hMoc8bQpdZ0ga4EiLkt7gRcWLimXSY6ueFROQAQ2te8XfD2Xl8sSm0WSx9AqBby4v0bA4
VLW0hPbIo46QnjpsbrfATZ1D45UQhIG0hcTbZqIQIZqQlhKPZWOxBuZEIEqEYte0jl4+G5ShTgZD
rYA514C0AbQ01fBciR1U4MKfN49b+X/TRe+xfvv/p+XKtwoI4Kr9LfWK7fvh00dX4HwyHde4Axr5
jjKrwckaktr2Z32J//1YogBjZz9qQ24XjxAeVVKDfucYBEenH7RUbtYyLpzu00JCAnPhyKrWZb68
L2EeY6FuiK9KCXUMw5bDWiUguXOXmj1TUn2qIfpa2h5PotujH+xd/ysx5mc/51Z9U94TOFEXLUjK
38yfJO8BcqA4dJ8dCZ1crF3uvQjtX+kMi6VhQV+dfYrqkhaI6NQNKrlmvFuOtuGAsKxaw5pPkUad
J+9NFHwN7R1g92rZF8kYtnZn46mxOR1kulA9AhSPQnBGeg4OX6KpnpZ81syOn0Lplh5cHjgmANoI
a1PZBlO6xJFvIthFckGL7a81CVqRkL2dpgPDvkiGe+9FuQT8Ymbho7HyJ3NOfNywatQver7Hei+e
xMOGiOxsU5z3xdV0PWc37lp6Q8B/hw7l9tC8uJ9ukA2Uu+SVPPRpM/tiYbJ9Zeg+dgS0GUws0LdV
kPdA/quKYNYt4afidG4v7f1Q88kbioTs/x82cBc0nLJ69Hgc+D/yM6vcV6rpHXUbI7pwIzig6ERQ
LfVAyfkF+EJqYJYBGzemwscAny1VU39ZvF2alO2f00S13rKnj/Ocrwu9yU9lTX/ttg6umHIEEAtB
csGXi1QSi7J5Zo68JXNjMTZauYnAQ4V48wv2tfweHzBLCDHxPre3InjPrgLc4cN+RfIzVP8JnXo/
6NEGXhzTaGRNfyXext9YSN8dAh5IdJlAxe5bsUoE7AP8e79BFDWubwQRXXddxSrXkmq/O0miENjS
beV+GCkAhT3GeFnEdtWXrvgRgRKWFO6DNWlJgMoeaRh5VlpEQ09QUcd3uiCR+aZUHmT25i5WVenC
uH1LsNmXU2KzThGi1P80GzTFtcNdAehW3tsU660hnReIGax4QXYTYK6UY2F3a56/q5jFIjc+4J44
A4UL94R2Uq6VZLNiN3sGprX99e5ubSiLbyXFjMmlZgGBo8z9Hn3CiJN4ge8Jdx0b9x5+A/SY23qs
JD92teRkLRHF3H3GhM1IJ5LtZwOhFNgqb22xMbzo3+Wd22kds2WSZQAcoq9qDPYJaSiOM/fTIR9t
3F0e/pq3/wOVmtufltok7fxM4MI3+l0p4sHo56HSVKBUwBB/GP18YD74uIaD1S5BLvU/lIxtkQxO
8zCK878HZqVgIsYiquA86/gh05zaEKgMM3WU1gaaD/ttU/sdcj8pTHkvfMTrdF7q9QOjZeNLq9D5
FnaiWpPX3n5eAWWzFSB7TBAUbI7/AhjynwHZYY/BAJyu3+SLAwg7i7rWAYM/MaaprKuHkFMnbE5j
XeyHp/jXo1e7Cg1xODUO4UprARN3vHhgeWvu7V9ks+OGOUGc3yH972Fokm0qOhqPzqlGZ3Be8cAH
ePo+Ms3qCMEsbSG68Qo20iKSGBtsYG3BN4Dq+xIzHf8ElT4CxQu1pQeuxpfUZRazs1G8muFVIbR8
mRlZTUDLbSESti/NqaEODUKx/vS6uIuyKI27ZXw689+DNUUKIuVt8aCHw0FadFY596RzOGGckMoZ
VTOWL+YRo1s1720wVD/sR2HIyUbEeivTt6gRD6wziPMNUrd+ZgYuyglDhqUE/rd6/c2pPaP75m9L
5GubLE6w1pS+oR9X2laFn6fG97O2zxMuQ9tk9cW/gqs8LK4xdcSBR8EmxN4Q34wJ/5AoaSWaETfL
TYsfUFQ3I8Cdxc8nLunzWNIGOcDcDOgrpe+veJoIW6x11bzW6dgI3d8JE1d9o4PRp0YB6mQu5lOj
EPmNrzegbnKAwVf1guIUnzmkCRqZkC6eX0jkdeehPAxG3QwcLaccbtioGR4C4xFsU4FjKmByqp1m
2WFmKPVxyDe/I79KeGOQ30ICtOLgF1B30s+6DEN1vHe90oO3Z7z6ofd83xyKVvq0E7I2SuXd0nDt
1RDs6oHZfvsksOnUS1RZfmb2M57sHwphFgazON+LCTai9p3QCtkFpfVOOQ/Atu5us1hRFvbjnwHn
sVyyRuohyKgmsXnATlBFav2GW1FvXdg4UugYq/OfBw2WPv7KCxWMKlgSub0tbbcm3yLcwBVkFGP9
AD1Kw7Q+SjLTn8OuSKEEaHOkWcaGxwOeFkHbBIbIQrr5x0d8reNlwd43M2oAe1Bg6WzKGYXKQYLk
Z8C2LyG/FSGr+vkt/A3Lj8Ennza4XW8UJW9qS0PKins2FNBeRw9Fkj7QFOwzMAAXqiRKVXsdapeV
GcGfPnaqrYJ16nvC04ZnBnzCgcz0IayCpEqrPCYn1Ha/OmlxcRnXLFpILjqStRtpphQT77HkGIo4
yOJSgixyrbJumFeNC94JO5yk/q7N/2CRlFGuvyQsMPqM/xNPTWIp6OarTDreGYWDIOoGj59dEl4j
CXHnG5PeS9ll45GjHcyEBccH1rbxdgandINwpy4TTArES89AB7074VMRAOuiQNa7TKH+pNTxUo6f
qaL5xkJ4zpCMCQCAVPbyYBt7oGcZNwREJCilSMzQCLpwO9XwvTqHufZRCxX2ZQ/MloinyFatLCfs
jHDiza7q+2zYyXiOy2PeG8XLuNxXTrOluDHjvYclY2c1uNv3S7eCEnc6Z8R5GwkxGtTLRuuZ2RKl
R9J4RDHC2UU3LGJz4b0SCsyKMPAzGsVa9cPQEux7SGF20V5XsMrBceruJcjhwoeCoFjFc0QRrjU0
tmkbi2JpzGdzb915QrzptHTehROAmggNNJHlTiKLqJYsj2v8vDtLMOlZlRp037zh1VdsCAuwkTqX
n6lWWV9774EEpgZNOmyemWCWMWKeKs8duHYIYzY4XCCfH6GnJWcYw3mgi5sao29XIf6UV2nTkJhg
7JmzyAYn82Vth9e9c7aVZxiSwVe1v4m0ytvScGYDcMLfKfBQl8ZsFhUxLaXNNOT5fXUvMn1j1wVz
rkG913muWUg47mGvLXF14YoaRe8ey8Mkv4dAj/kO9tZgiAq/ps9dVd2pnjIjeHECAFzFIgANJwOq
be6c7qf0+qKMK6tquzstHC/KH/pJ0+XEA8wYdg5m10mp5R0qSAFHnmUGhNLYPTDXO+we0y9sHyuX
wlEeh0eLzTFidV9IzuNNMAiv2fbtYcG7mDgC/TUdRkfz3hysOnTNBPl+My8pJZ/JAK1m8IY9cIAi
afgtNR0F0r1vv4AO5c5a6ad53EbmwuEfAtEJQzeBWYWucrS7DHenv1sNRdMcxpbRNG8Bc+5J+O4z
fiHBcgamfwOTYJq6yMltF/cuJmrffjESjjrO2oBGX3YV/Ule+KoHnW3I7dp9rIfnDzoViMmI9HYT
W6fCsQW967HG4TYKQ88r7vfT6yLzCvzW0KYsLo9OKN9UDScyzlMzay8SD3/7QxJSKCWYOfNVlQ==
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
