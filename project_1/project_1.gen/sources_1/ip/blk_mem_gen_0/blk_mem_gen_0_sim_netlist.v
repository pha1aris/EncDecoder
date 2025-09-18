// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Thu Sep 18 20:48:16 2025
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
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [7:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_mode = "slave BRAM_PORTB" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB WE" *) input [0:0]web;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [7:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DIN" *) input [31:0]dinb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [31:0]doutb;

  wire [7:0]addra;
  wire [7:0]addrb;
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
  wire [7:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "8" *) 
  (* C_ADDRB_WIDTH = "8" *) 
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
  (* C_READ_DEPTH_A = "256" *) 
  (* C_READ_DEPTH_B = "256" *) 
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
  (* C_WRITE_DEPTH_A = "256" *) 
  (* C_WRITE_DEPTH_B = "256" *) 
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
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[7:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[7:0]),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 30128)
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
