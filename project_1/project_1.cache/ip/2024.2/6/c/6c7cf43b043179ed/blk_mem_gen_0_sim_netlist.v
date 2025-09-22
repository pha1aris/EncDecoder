// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Sat Sep 20 17:21:43 2025
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 30224)
`pragma protect data_block
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
Pq1crUnecdaJHpA1lPQ=
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
