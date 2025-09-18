// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Thu Sep 18 20:48:16 2025
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 30160)
`pragma protect data_block
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
V2whd8j9hQ==
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
