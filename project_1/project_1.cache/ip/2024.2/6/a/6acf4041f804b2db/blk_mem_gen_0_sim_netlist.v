// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Thu Sep 18 20:40:41 2025
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
    enb,
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
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB EN" *) input enb;
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
        .enb(enb),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 30432)
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
