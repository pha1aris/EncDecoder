// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Thu Sep 18 10:38:47 2025
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
    ena,
    wea,
    addra,
    dina,
    douta,
    clkb,
    enb,
    web,
    addrb,
    dinb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [5:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_mode = "slave BRAM_PORTB" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB EN" *) input enb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB WE" *) input [0:0]web;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [5:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DIN" *) input [31:0]dinb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [31:0]doutb;

  wire [5:0]addra;
  wire [5:0]addrb;
  wire clka;
  wire clkb;
  wire [31:0]dina;
  wire [31:0]dinb;
  wire [31:0]douta;
  wire [31:0]doutb;
  wire ena;
  wire enb;
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
  wire [5:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [5:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "6" *) 
  (* C_ADDRB_WIDTH = "6" *) 
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
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "1" *) 
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
  (* C_READ_DEPTH_A = "64" *) 
  (* C_READ_DEPTH_B = "64" *) 
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
  (* C_WRITE_DEPTH_A = "64" *) 
  (* C_WRITE_DEPTH_B = "64" *) 
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
        .ena(ena),
        .enb(enb),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[5:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[5:0]),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 30544)
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
