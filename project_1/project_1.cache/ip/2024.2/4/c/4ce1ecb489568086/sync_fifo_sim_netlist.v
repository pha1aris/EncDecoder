// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Thu Oct 23 20:32:44 2025
// Host        : FSO-A running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ sync_fifo_sim_netlist.v
// Design      : sync_fifo
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu15eg-ffvb1156-2-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "sync_fifo,fifo_generator_v13_2_11,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "fifo_generator_v13_2_11,Vivado 2024.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (clk,
    srst,
    din,
    wr_en,
    rd_en,
    dout,
    full,
    empty,
    wr_rst_busy,
    rd_rst_busy);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 core_clk CLK" *) (* x_interface_mode = "slave core_clk" *) (* x_interface_parameter = "XIL_INTERFACENAME core_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *) input clk;
  input srst;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_DATA" *) (* x_interface_mode = "slave FIFO_WRITE" *) input [32:0]din;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_EN" *) input wr_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_EN" *) (* x_interface_mode = "slave FIFO_READ" *) input rd_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_DATA" *) output [32:0]dout;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE FULL" *) output full;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ EMPTY" *) output empty;
  output wr_rst_busy;
  output rd_rst_busy;

  wire clk;
  wire [32:0]din;
  wire [32:0]dout;
  wire empty;
  wire full;
  wire rd_en;
  wire rd_rst_busy;
  wire srst;
  wire wr_en;
  wire wr_rst_busy;
  wire NLW_U0_almost_empty_UNCONNECTED;
  wire NLW_U0_almost_full_UNCONNECTED;
  wire NLW_U0_axi_ar_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_ar_overflow_UNCONNECTED;
  wire NLW_U0_axi_ar_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_ar_prog_full_UNCONNECTED;
  wire NLW_U0_axi_ar_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_ar_underflow_UNCONNECTED;
  wire NLW_U0_axi_aw_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_aw_overflow_UNCONNECTED;
  wire NLW_U0_axi_aw_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_aw_prog_full_UNCONNECTED;
  wire NLW_U0_axi_aw_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_aw_underflow_UNCONNECTED;
  wire NLW_U0_axi_b_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_b_overflow_UNCONNECTED;
  wire NLW_U0_axi_b_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_b_prog_full_UNCONNECTED;
  wire NLW_U0_axi_b_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_b_underflow_UNCONNECTED;
  wire NLW_U0_axi_r_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_r_overflow_UNCONNECTED;
  wire NLW_U0_axi_r_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_r_prog_full_UNCONNECTED;
  wire NLW_U0_axi_r_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_r_underflow_UNCONNECTED;
  wire NLW_U0_axi_w_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_w_overflow_UNCONNECTED;
  wire NLW_U0_axi_w_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_w_prog_full_UNCONNECTED;
  wire NLW_U0_axi_w_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_w_underflow_UNCONNECTED;
  wire NLW_U0_axis_dbiterr_UNCONNECTED;
  wire NLW_U0_axis_overflow_UNCONNECTED;
  wire NLW_U0_axis_prog_empty_UNCONNECTED;
  wire NLW_U0_axis_prog_full_UNCONNECTED;
  wire NLW_U0_axis_sbiterr_UNCONNECTED;
  wire NLW_U0_axis_underflow_UNCONNECTED;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_m_axi_arvalid_UNCONNECTED;
  wire NLW_U0_m_axi_awvalid_UNCONNECTED;
  wire NLW_U0_m_axi_bready_UNCONNECTED;
  wire NLW_U0_m_axi_rready_UNCONNECTED;
  wire NLW_U0_m_axi_wlast_UNCONNECTED;
  wire NLW_U0_m_axi_wvalid_UNCONNECTED;
  wire NLW_U0_m_axis_tlast_UNCONNECTED;
  wire NLW_U0_m_axis_tvalid_UNCONNECTED;
  wire NLW_U0_overflow_UNCONNECTED;
  wire NLW_U0_prog_empty_UNCONNECTED;
  wire NLW_U0_prog_full_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_s_axis_tready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire NLW_U0_underflow_UNCONNECTED;
  wire NLW_U0_valid_UNCONNECTED;
  wire NLW_U0_wr_ack_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_wr_data_count_UNCONNECTED;
  wire [9:0]NLW_U0_data_count_UNCONNECTED;
  wire [31:0]NLW_U0_m_axi_araddr_UNCONNECTED;
  wire [1:0]NLW_U0_m_axi_arburst_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arcache_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_arid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_arlen_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_arlock_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_arprot_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arqos_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arregion_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_arsize_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_aruser_UNCONNECTED;
  wire [31:0]NLW_U0_m_axi_awaddr_UNCONNECTED;
  wire [1:0]NLW_U0_m_axi_awburst_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awcache_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_awlen_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awlock_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_awprot_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awqos_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awregion_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_awsize_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awuser_UNCONNECTED;
  wire [63:0]NLW_U0_m_axi_wdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_wid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_wstrb_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_wuser_UNCONNECTED;
  wire [7:0]NLW_U0_m_axis_tdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tdest_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tid_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tkeep_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tstrb_UNCONNECTED;
  wire [3:0]NLW_U0_m_axis_tuser_UNCONNECTED;
  wire [9:0]NLW_U0_rd_data_count_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_buser_UNCONNECTED;
  wire [63:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_ruser_UNCONNECTED;
  wire [9:0]NLW_U0_wr_data_count_UNCONNECTED;

  (* C_ADD_NGC_CONSTRAINT = "0" *) 
  (* C_APPLICATION_TYPE_AXIS = "0" *) 
  (* C_APPLICATION_TYPE_RACH = "0" *) 
  (* C_APPLICATION_TYPE_RDCH = "0" *) 
  (* C_APPLICATION_TYPE_WACH = "0" *) 
  (* C_APPLICATION_TYPE_WDCH = "0" *) 
  (* C_APPLICATION_TYPE_WRCH = "0" *) 
  (* C_AXIS_TDATA_WIDTH = "8" *) 
  (* C_AXIS_TDEST_WIDTH = "1" *) 
  (* C_AXIS_TID_WIDTH = "1" *) 
  (* C_AXIS_TKEEP_WIDTH = "1" *) 
  (* C_AXIS_TSTRB_WIDTH = "1" *) 
  (* C_AXIS_TUSER_WIDTH = "4" *) 
  (* C_AXIS_TYPE = "0" *) 
  (* C_AXI_ADDR_WIDTH = "32" *) 
  (* C_AXI_ARUSER_WIDTH = "1" *) 
  (* C_AXI_AWUSER_WIDTH = "1" *) 
  (* C_AXI_BUSER_WIDTH = "1" *) 
  (* C_AXI_DATA_WIDTH = "64" *) 
  (* C_AXI_ID_WIDTH = "1" *) 
  (* C_AXI_LEN_WIDTH = "8" *) 
  (* C_AXI_LOCK_WIDTH = "1" *) 
  (* C_AXI_RUSER_WIDTH = "1" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_AXI_WUSER_WIDTH = "1" *) 
  (* C_COMMON_CLOCK = "1" *) 
  (* C_COUNT_TYPE = "0" *) 
  (* C_DATA_COUNT_WIDTH = "10" *) 
  (* C_DEFAULT_VALUE = "BlankString" *) 
  (* C_DIN_WIDTH = "33" *) 
  (* C_DIN_WIDTH_AXIS = "1" *) 
  (* C_DIN_WIDTH_RACH = "32" *) 
  (* C_DIN_WIDTH_RDCH = "64" *) 
  (* C_DIN_WIDTH_WACH = "1" *) 
  (* C_DIN_WIDTH_WDCH = "64" *) 
  (* C_DIN_WIDTH_WRCH = "2" *) 
  (* C_DOUT_RST_VAL = "0" *) 
  (* C_DOUT_WIDTH = "33" *) 
  (* C_ENABLE_RLOCS = "0" *) 
  (* C_ENABLE_RST_SYNC = "1" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_ERROR_INJECTION_TYPE = "0" *) 
  (* C_ERROR_INJECTION_TYPE_AXIS = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WRCH = "0" *) 
  (* C_FAMILY = "zynquplus" *) 
  (* C_FULL_FLAGS_RST_VAL = "0" *) 
  (* C_HAS_ALMOST_EMPTY = "0" *) 
  (* C_HAS_ALMOST_FULL = "0" *) 
  (* C_HAS_AXIS_TDATA = "1" *) 
  (* C_HAS_AXIS_TDEST = "0" *) 
  (* C_HAS_AXIS_TID = "0" *) 
  (* C_HAS_AXIS_TKEEP = "0" *) 
  (* C_HAS_AXIS_TLAST = "0" *) 
  (* C_HAS_AXIS_TREADY = "1" *) 
  (* C_HAS_AXIS_TSTRB = "0" *) 
  (* C_HAS_AXIS_TUSER = "1" *) 
  (* C_HAS_AXI_ARUSER = "0" *) 
  (* C_HAS_AXI_AWUSER = "0" *) 
  (* C_HAS_AXI_BUSER = "0" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_AXI_RD_CHANNEL = "1" *) 
  (* C_HAS_AXI_RUSER = "0" *) 
  (* C_HAS_AXI_WR_CHANNEL = "1" *) 
  (* C_HAS_AXI_WUSER = "0" *) 
  (* C_HAS_BACKUP = "0" *) 
  (* C_HAS_DATA_COUNT = "0" *) 
  (* C_HAS_DATA_COUNTS_AXIS = "0" *) 
  (* C_HAS_DATA_COUNTS_RACH = "0" *) 
  (* C_HAS_DATA_COUNTS_RDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WACH = "0" *) 
  (* C_HAS_DATA_COUNTS_WDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WRCH = "0" *) 
  (* C_HAS_INT_CLK = "0" *) 
  (* C_HAS_MASTER_CE = "0" *) 
  (* C_HAS_MEMINIT_FILE = "0" *) 
  (* C_HAS_OVERFLOW = "0" *) 
  (* C_HAS_PROG_FLAGS_AXIS = "0" *) 
  (* C_HAS_PROG_FLAGS_RACH = "0" *) 
  (* C_HAS_PROG_FLAGS_RDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WACH = "0" *) 
  (* C_HAS_PROG_FLAGS_WDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WRCH = "0" *) 
  (* C_HAS_RD_DATA_COUNT = "0" *) 
  (* C_HAS_RD_RST = "0" *) 
  (* C_HAS_RST = "0" *) 
  (* C_HAS_SLAVE_CE = "0" *) 
  (* C_HAS_SRST = "1" *) 
  (* C_HAS_UNDERFLOW = "0" *) 
  (* C_HAS_VALID = "0" *) 
  (* C_HAS_WR_ACK = "0" *) 
  (* C_HAS_WR_DATA_COUNT = "0" *) 
  (* C_HAS_WR_RST = "0" *) 
  (* C_IMPLEMENTATION_TYPE = "6" *) 
  (* C_IMPLEMENTATION_TYPE_AXIS = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RACH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WACH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WRCH = "1" *) 
  (* C_INIT_WR_PNTR_VAL = "0" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_MEMORY_TYPE = "4" *) 
  (* C_MIF_FILE_NAME = "BlankString" *) 
  (* C_MSGON_VAL = "1" *) 
  (* C_OPTIMIZATION_MODE = "0" *) 
  (* C_OVERFLOW_LOW = "0" *) 
  (* C_POWER_SAVING_MODE = "0" *) 
  (* C_PRELOAD_LATENCY = "0" *) 
  (* C_PRELOAD_REGS = "1" *) 
  (* C_PRIM_FIFO_TYPE = "1kx36" *) 
  (* C_PRIM_FIFO_TYPE_AXIS = "1kx18" *) 
  (* C_PRIM_FIFO_TYPE_RACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_RDCH = "512x72" *) 
  (* C_PRIM_FIFO_TYPE_WACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_WDCH = "512x72" *) 
  (* C_PRIM_FIFO_TYPE_WRCH = "512x36" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL = "4" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_AXIS = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WRCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_NEGATE_VAL = "5" *) 
  (* C_PROG_EMPTY_TYPE = "0" *) 
  (* C_PROG_EMPTY_TYPE_AXIS = "0" *) 
  (* C_PROG_EMPTY_TYPE_RACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_RDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WRCH = "0" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_AXIS = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WRCH = "1023" *) 
  (* C_PROG_FULL_THRESH_NEGATE_VAL = "1022" *) 
  (* C_PROG_FULL_TYPE = "0" *) 
  (* C_PROG_FULL_TYPE_AXIS = "0" *) 
  (* C_PROG_FULL_TYPE_RACH = "0" *) 
  (* C_PROG_FULL_TYPE_RDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WACH = "0" *) 
  (* C_PROG_FULL_TYPE_WDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WRCH = "0" *) 
  (* C_RACH_TYPE = "0" *) 
  (* C_RDCH_TYPE = "0" *) 
  (* C_RD_DATA_COUNT_WIDTH = "10" *) 
  (* C_RD_DEPTH = "1024" *) 
  (* C_RD_FREQ = "1" *) 
  (* C_RD_PNTR_WIDTH = "10" *) 
  (* C_REG_SLICE_MODE_AXIS = "0" *) 
  (* C_REG_SLICE_MODE_RACH = "0" *) 
  (* C_REG_SLICE_MODE_RDCH = "0" *) 
  (* C_REG_SLICE_MODE_WACH = "0" *) 
  (* C_REG_SLICE_MODE_WDCH = "0" *) 
  (* C_REG_SLICE_MODE_WRCH = "0" *) 
  (* C_SELECT_XPM = "0" *) 
  (* C_SYNCHRONIZER_STAGE = "2" *) 
  (* C_UNDERFLOW_LOW = "0" *) 
  (* C_USE_COMMON_OVERFLOW = "0" *) 
  (* C_USE_COMMON_UNDERFLOW = "0" *) 
  (* C_USE_DEFAULT_SETTINGS = "0" *) 
  (* C_USE_DOUT_RST = "1" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_ECC_AXIS = "0" *) 
  (* C_USE_ECC_RACH = "0" *) 
  (* C_USE_ECC_RDCH = "0" *) 
  (* C_USE_ECC_WACH = "0" *) 
  (* C_USE_ECC_WDCH = "0" *) 
  (* C_USE_ECC_WRCH = "0" *) 
  (* C_USE_EMBEDDED_REG = "1" *) 
  (* C_USE_FIFO16_FLAGS = "0" *) 
  (* C_USE_FWFT_DATA_COUNT = "0" *) 
  (* C_USE_PIPELINE_REG = "0" *) 
  (* C_VALID_LOW = "0" *) 
  (* C_WACH_TYPE = "0" *) 
  (* C_WDCH_TYPE = "0" *) 
  (* C_WRCH_TYPE = "0" *) 
  (* C_WR_ACK_LOW = "0" *) 
  (* C_WR_DATA_COUNT_WIDTH = "10" *) 
  (* C_WR_DEPTH = "1024" *) 
  (* C_WR_DEPTH_AXIS = "1024" *) 
  (* C_WR_DEPTH_RACH = "16" *) 
  (* C_WR_DEPTH_RDCH = "1024" *) 
  (* C_WR_DEPTH_WACH = "16" *) 
  (* C_WR_DEPTH_WDCH = "1024" *) 
  (* C_WR_DEPTH_WRCH = "16" *) 
  (* C_WR_FREQ = "1" *) 
  (* C_WR_PNTR_WIDTH = "10" *) 
  (* C_WR_PNTR_WIDTH_AXIS = "10" *) 
  (* C_WR_PNTR_WIDTH_RACH = "4" *) 
  (* C_WR_PNTR_WIDTH_RDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WACH = "4" *) 
  (* C_WR_PNTR_WIDTH_WDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WRCH = "4" *) 
  (* C_WR_RESPONSE_LATENCY = "1" *) 
  (* is_du_within_envelope = "true" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_fifo_generator_v13_2_11 U0
       (.almost_empty(NLW_U0_almost_empty_UNCONNECTED),
        .almost_full(NLW_U0_almost_full_UNCONNECTED),
        .axi_ar_data_count(NLW_U0_axi_ar_data_count_UNCONNECTED[4:0]),
        .axi_ar_dbiterr(NLW_U0_axi_ar_dbiterr_UNCONNECTED),
        .axi_ar_injectdbiterr(1'b0),
        .axi_ar_injectsbiterr(1'b0),
        .axi_ar_overflow(NLW_U0_axi_ar_overflow_UNCONNECTED),
        .axi_ar_prog_empty(NLW_U0_axi_ar_prog_empty_UNCONNECTED),
        .axi_ar_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_ar_prog_full(NLW_U0_axi_ar_prog_full_UNCONNECTED),
        .axi_ar_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_ar_rd_data_count(NLW_U0_axi_ar_rd_data_count_UNCONNECTED[4:0]),
        .axi_ar_sbiterr(NLW_U0_axi_ar_sbiterr_UNCONNECTED),
        .axi_ar_underflow(NLW_U0_axi_ar_underflow_UNCONNECTED),
        .axi_ar_wr_data_count(NLW_U0_axi_ar_wr_data_count_UNCONNECTED[4:0]),
        .axi_aw_data_count(NLW_U0_axi_aw_data_count_UNCONNECTED[4:0]),
        .axi_aw_dbiterr(NLW_U0_axi_aw_dbiterr_UNCONNECTED),
        .axi_aw_injectdbiterr(1'b0),
        .axi_aw_injectsbiterr(1'b0),
        .axi_aw_overflow(NLW_U0_axi_aw_overflow_UNCONNECTED),
        .axi_aw_prog_empty(NLW_U0_axi_aw_prog_empty_UNCONNECTED),
        .axi_aw_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_aw_prog_full(NLW_U0_axi_aw_prog_full_UNCONNECTED),
        .axi_aw_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_aw_rd_data_count(NLW_U0_axi_aw_rd_data_count_UNCONNECTED[4:0]),
        .axi_aw_sbiterr(NLW_U0_axi_aw_sbiterr_UNCONNECTED),
        .axi_aw_underflow(NLW_U0_axi_aw_underflow_UNCONNECTED),
        .axi_aw_wr_data_count(NLW_U0_axi_aw_wr_data_count_UNCONNECTED[4:0]),
        .axi_b_data_count(NLW_U0_axi_b_data_count_UNCONNECTED[4:0]),
        .axi_b_dbiterr(NLW_U0_axi_b_dbiterr_UNCONNECTED),
        .axi_b_injectdbiterr(1'b0),
        .axi_b_injectsbiterr(1'b0),
        .axi_b_overflow(NLW_U0_axi_b_overflow_UNCONNECTED),
        .axi_b_prog_empty(NLW_U0_axi_b_prog_empty_UNCONNECTED),
        .axi_b_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_b_prog_full(NLW_U0_axi_b_prog_full_UNCONNECTED),
        .axi_b_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_b_rd_data_count(NLW_U0_axi_b_rd_data_count_UNCONNECTED[4:0]),
        .axi_b_sbiterr(NLW_U0_axi_b_sbiterr_UNCONNECTED),
        .axi_b_underflow(NLW_U0_axi_b_underflow_UNCONNECTED),
        .axi_b_wr_data_count(NLW_U0_axi_b_wr_data_count_UNCONNECTED[4:0]),
        .axi_r_data_count(NLW_U0_axi_r_data_count_UNCONNECTED[10:0]),
        .axi_r_dbiterr(NLW_U0_axi_r_dbiterr_UNCONNECTED),
        .axi_r_injectdbiterr(1'b0),
        .axi_r_injectsbiterr(1'b0),
        .axi_r_overflow(NLW_U0_axi_r_overflow_UNCONNECTED),
        .axi_r_prog_empty(NLW_U0_axi_r_prog_empty_UNCONNECTED),
        .axi_r_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_r_prog_full(NLW_U0_axi_r_prog_full_UNCONNECTED),
        .axi_r_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_r_rd_data_count(NLW_U0_axi_r_rd_data_count_UNCONNECTED[10:0]),
        .axi_r_sbiterr(NLW_U0_axi_r_sbiterr_UNCONNECTED),
        .axi_r_underflow(NLW_U0_axi_r_underflow_UNCONNECTED),
        .axi_r_wr_data_count(NLW_U0_axi_r_wr_data_count_UNCONNECTED[10:0]),
        .axi_w_data_count(NLW_U0_axi_w_data_count_UNCONNECTED[10:0]),
        .axi_w_dbiterr(NLW_U0_axi_w_dbiterr_UNCONNECTED),
        .axi_w_injectdbiterr(1'b0),
        .axi_w_injectsbiterr(1'b0),
        .axi_w_overflow(NLW_U0_axi_w_overflow_UNCONNECTED),
        .axi_w_prog_empty(NLW_U0_axi_w_prog_empty_UNCONNECTED),
        .axi_w_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_w_prog_full(NLW_U0_axi_w_prog_full_UNCONNECTED),
        .axi_w_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_w_rd_data_count(NLW_U0_axi_w_rd_data_count_UNCONNECTED[10:0]),
        .axi_w_sbiterr(NLW_U0_axi_w_sbiterr_UNCONNECTED),
        .axi_w_underflow(NLW_U0_axi_w_underflow_UNCONNECTED),
        .axi_w_wr_data_count(NLW_U0_axi_w_wr_data_count_UNCONNECTED[10:0]),
        .axis_data_count(NLW_U0_axis_data_count_UNCONNECTED[10:0]),
        .axis_dbiterr(NLW_U0_axis_dbiterr_UNCONNECTED),
        .axis_injectdbiterr(1'b0),
        .axis_injectsbiterr(1'b0),
        .axis_overflow(NLW_U0_axis_overflow_UNCONNECTED),
        .axis_prog_empty(NLW_U0_axis_prog_empty_UNCONNECTED),
        .axis_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axis_prog_full(NLW_U0_axis_prog_full_UNCONNECTED),
        .axis_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axis_rd_data_count(NLW_U0_axis_rd_data_count_UNCONNECTED[10:0]),
        .axis_sbiterr(NLW_U0_axis_sbiterr_UNCONNECTED),
        .axis_underflow(NLW_U0_axis_underflow_UNCONNECTED),
        .axis_wr_data_count(NLW_U0_axis_wr_data_count_UNCONNECTED[10:0]),
        .backup(1'b0),
        .backup_marker(1'b0),
        .clk(clk),
        .data_count(NLW_U0_data_count_UNCONNECTED[9:0]),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .int_clk(1'b0),
        .m_aclk(1'b0),
        .m_aclk_en(1'b0),
        .m_axi_araddr(NLW_U0_m_axi_araddr_UNCONNECTED[31:0]),
        .m_axi_arburst(NLW_U0_m_axi_arburst_UNCONNECTED[1:0]),
        .m_axi_arcache(NLW_U0_m_axi_arcache_UNCONNECTED[3:0]),
        .m_axi_arid(NLW_U0_m_axi_arid_UNCONNECTED[0]),
        .m_axi_arlen(NLW_U0_m_axi_arlen_UNCONNECTED[7:0]),
        .m_axi_arlock(NLW_U0_m_axi_arlock_UNCONNECTED[0]),
        .m_axi_arprot(NLW_U0_m_axi_arprot_UNCONNECTED[2:0]),
        .m_axi_arqos(NLW_U0_m_axi_arqos_UNCONNECTED[3:0]),
        .m_axi_arready(1'b0),
        .m_axi_arregion(NLW_U0_m_axi_arregion_UNCONNECTED[3:0]),
        .m_axi_arsize(NLW_U0_m_axi_arsize_UNCONNECTED[2:0]),
        .m_axi_aruser(NLW_U0_m_axi_aruser_UNCONNECTED[0]),
        .m_axi_arvalid(NLW_U0_m_axi_arvalid_UNCONNECTED),
        .m_axi_awaddr(NLW_U0_m_axi_awaddr_UNCONNECTED[31:0]),
        .m_axi_awburst(NLW_U0_m_axi_awburst_UNCONNECTED[1:0]),
        .m_axi_awcache(NLW_U0_m_axi_awcache_UNCONNECTED[3:0]),
        .m_axi_awid(NLW_U0_m_axi_awid_UNCONNECTED[0]),
        .m_axi_awlen(NLW_U0_m_axi_awlen_UNCONNECTED[7:0]),
        .m_axi_awlock(NLW_U0_m_axi_awlock_UNCONNECTED[0]),
        .m_axi_awprot(NLW_U0_m_axi_awprot_UNCONNECTED[2:0]),
        .m_axi_awqos(NLW_U0_m_axi_awqos_UNCONNECTED[3:0]),
        .m_axi_awready(1'b0),
        .m_axi_awregion(NLW_U0_m_axi_awregion_UNCONNECTED[3:0]),
        .m_axi_awsize(NLW_U0_m_axi_awsize_UNCONNECTED[2:0]),
        .m_axi_awuser(NLW_U0_m_axi_awuser_UNCONNECTED[0]),
        .m_axi_awvalid(NLW_U0_m_axi_awvalid_UNCONNECTED),
        .m_axi_bid(1'b0),
        .m_axi_bready(NLW_U0_m_axi_bready_UNCONNECTED),
        .m_axi_bresp({1'b0,1'b0}),
        .m_axi_buser(1'b0),
        .m_axi_bvalid(1'b0),
        .m_axi_rdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .m_axi_rid(1'b0),
        .m_axi_rlast(1'b0),
        .m_axi_rready(NLW_U0_m_axi_rready_UNCONNECTED),
        .m_axi_rresp({1'b0,1'b0}),
        .m_axi_ruser(1'b0),
        .m_axi_rvalid(1'b0),
        .m_axi_wdata(NLW_U0_m_axi_wdata_UNCONNECTED[63:0]),
        .m_axi_wid(NLW_U0_m_axi_wid_UNCONNECTED[0]),
        .m_axi_wlast(NLW_U0_m_axi_wlast_UNCONNECTED),
        .m_axi_wready(1'b0),
        .m_axi_wstrb(NLW_U0_m_axi_wstrb_UNCONNECTED[7:0]),
        .m_axi_wuser(NLW_U0_m_axi_wuser_UNCONNECTED[0]),
        .m_axi_wvalid(NLW_U0_m_axi_wvalid_UNCONNECTED),
        .m_axis_tdata(NLW_U0_m_axis_tdata_UNCONNECTED[7:0]),
        .m_axis_tdest(NLW_U0_m_axis_tdest_UNCONNECTED[0]),
        .m_axis_tid(NLW_U0_m_axis_tid_UNCONNECTED[0]),
        .m_axis_tkeep(NLW_U0_m_axis_tkeep_UNCONNECTED[0]),
        .m_axis_tlast(NLW_U0_m_axis_tlast_UNCONNECTED),
        .m_axis_tready(1'b0),
        .m_axis_tstrb(NLW_U0_m_axis_tstrb_UNCONNECTED[0]),
        .m_axis_tuser(NLW_U0_m_axis_tuser_UNCONNECTED[3:0]),
        .m_axis_tvalid(NLW_U0_m_axis_tvalid_UNCONNECTED),
        .overflow(NLW_U0_overflow_UNCONNECTED),
        .prog_empty(NLW_U0_prog_empty_UNCONNECTED),
        .prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full(NLW_U0_prog_full_UNCONNECTED),
        .prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .rd_clk(1'b0),
        .rd_data_count(NLW_U0_rd_data_count_UNCONNECTED[9:0]),
        .rd_en(rd_en),
        .rd_rst(1'b0),
        .rd_rst_busy(rd_rst_busy),
        .rst(1'b0),
        .s_aclk(1'b0),
        .s_aclk_en(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arcache({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arid(1'b0),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlock(1'b0),
        .s_axi_arprot({1'b0,1'b0,1'b0}),
        .s_axi_arqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_aruser(1'b0),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awcache({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awid(1'b0),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlock(1'b0),
        .s_axi_awprot({1'b0,1'b0,1'b0}),
        .s_axi_awqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awuser(1'b0),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_buser(NLW_U0_s_axi_buser_UNCONNECTED[0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[63:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_ruser(NLW_U0_s_axi_ruser_UNCONNECTED[0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wid(1'b0),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wuser(1'b0),
        .s_axi_wvalid(1'b0),
        .s_axis_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tdest(1'b0),
        .s_axis_tid(1'b0),
        .s_axis_tkeep(1'b0),
        .s_axis_tlast(1'b0),
        .s_axis_tready(NLW_U0_s_axis_tready_UNCONNECTED),
        .s_axis_tstrb(1'b0),
        .s_axis_tuser({1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .sleep(1'b0),
        .srst(srst),
        .underflow(NLW_U0_underflow_UNCONNECTED),
        .valid(NLW_U0_valid_UNCONNECTED),
        .wr_ack(NLW_U0_wr_ack_UNCONNECTED),
        .wr_clk(1'b0),
        .wr_data_count(NLW_U0_wr_data_count_UNCONNECTED[9:0]),
        .wr_en(wr_en),
        .wr_rst(1'b0),
        .wr_rst_busy(wr_rst_busy));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2024.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
md0AksSCeI3fOZtF7nrw91OgSzGoACBon4GH9ENTzaI4jlg22H1uTtXayX2Kz+g4ZH2j52rtMH8H
Xc49HVcThMzO1cRXu+SkL59MRQ87klGca4XtjrTtunJoQ+jyOKRwRBeIMHUdntbk2T1kbXHf9KkB
bNYGEMqSrbiDt7IJUx8=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
r6CzxR0T3O2wvZRQe25aX3/CWOx/3d/3vJvvS/XsrKr7v852GNQNqCBn+PKsunj0Ncep8DqHtVie
BE6tKIqZW+3txAUjrhSri5liuFWSnzAk+Drsb4RnvIy7BeOdAK6NhVhn8ZyplkJSHVwaGjN8gtPE
LeWEHPHf5qLnzqGKV7B6oIC7POGV6Vamos1p2z1xv2cEw4udvmtZ5EjzeyCMf+omtxEPxhPi6Z2h
ENlGOmuPMkWGMjP6HQCZ1Mi0uiST/zDo29UDIMmOGcsDMe97imU/z2ekKTPXXwjcV+9q+4zHRgJV
6JWWgjU9cztV5OMaEfpBgRBWae/ijWpPZaGuFA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
glFrHilvyO7nq7/OYhnyb9uU9d8UNGJruNnkmJWuTpgvyCDmtx7iVKPBPe1Bj9jUDT/HM9AGxvu0
g7b4TuMdVkegkVPeHhw31IW0HoTL8wPnrLEpzDVK+B7xl953hPKPe0vn+0EQh2UKeL5K8VLxmsSv
gbpEeToeR90yzlSUzDE=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
D4uBhES8Mkd0GCwY2aQOmEzTqz6hO5B9Wa2oyfVBEODkWyt+AHkIXn4tuBN05FcP2FVmgtVbvZX5
K6iog51IoPw5tv+pM5x8+bQBX/aZpf0c4to3qiX6RZuITpuSUWq/7sqQDqtMqDWOFMMnUBpTX+qI
t61NvyIZcfqRWo4yvIUV2Zh1etqYKDlhqRnMoBZKMeHFpVsp19nU4sf5Km7sSlPQ08vYD8qtJqgJ
ZDYC2KWFTHsnT+5anHvc80FgHt4zBHpPrGprgpltQmVmMZxUD6NRC9EvvXf+pBhgfwPHHePWIKUn
elLld/HEVeFw76SlVV8i4LsS4KWWOM+KmMprEg==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
EW9gHDqS12MVhy+y/xQVscLd4qOim+cNTepYzlas7WzqDJogZthddOuGjpm3a3fS/cMbF/h0O1Hb
Wjow664GIga0y96lkbkcJ3W8x/IGAsvgyrYT6ScsFhyq7tSd1HjvRG81BhhGM1mmpxfzh0Uqbfso
q+uVKPUmPnbQ/Gdu9YRoxmYVJdmUTpXJ5waYOdib8WNMPLdDfIo/FGrYrx2zYQBtpU5DwwVUTMrB
ZasEyxOj++icI5k5lR3Tx+3gdCFTy4XYQfcj2COm4gnVZ8FN/X1/+0ywsVGAc/OKL+mjMYH3NNH3
zfDO/TpYft+HaVl+CfF/U6IgJJeJs4qI4gB4FA==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2023_11", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Myfv5Skg7QCxlNBoFiSTLAeIRYS0J0ArRihYk7dGAHZWAFlxJLgqo51W9P9zTVBurMJjZLtonoDJ
19RfxQj5GqhqN1A20s8xOFfLq6+uDG/V39xQFY32O626Kh4MMlH07hNJL5u1NjJWg1yze0XdFEe9
oLwKQz5lSKGMIh+VPXDuCGhShS+KhHwGEdS0lmA/IHPFNlRG1LsK0zQmUiNkG4kQ5OEVkQgvknNC
B6++ZDIYlT9WbZPs5giRY0zAhUepLPaO+N9F3fIBKVGw4ejbZOt0kXKixF86DDfLmF2+dov+PrTX
1MXJaea3YoQdR2c2MSHAk/TTkzg9ayjvxKaXpg==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
ks9l+EPHXfDNnWd0exs1j0Q9iSNYaIExwQnpsi8TFJimjPtOkX050wFklsLBM83WyfuD+F2KLNnZ
Jg/aiIiGe9o424jOiEFdnAJuzrD0QL9WmhQ3W9iRJ7uPhha6NfR2WGTCCM4TpN8rTKLQDKxenVfv
6x83rnL5NQxvpp9cQh3zMma73qoEJjhTR9MD9cwA4VeKq2u/R0iTWBplX81vYFd9TW2qW5/Qyzzj
A0+pXzczcJKdggV8h8bYcO+PRC3t2XrufhnjvhjMLG2tPHSMW/soDH/v8KorXyWe5N/q12fo5auN
SXr3olNuB5kpiVS3mJAPV0z4UsFfu2A4hLH7MQ==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
e3AJKDEM9byJqwpkFZqMIMKMQPOR1VrLFkshor7HR0C+ol7Uv3XTGyvQrINdBEArX0eazF0cHWjC
9B4BhDnysAhT6SENcNHIYHUGQE7uiF7zgL7WhCxClwEnIAVj+PU9FmqlvbreEikHQfbeIDPyCLii
NAS97RDxWki/MfR33zvZX4eEolA/oTyRzr1MagBs7LN1UXyGPvnze8JzHxA3zHVedIIrBrZxkfoj
Loqe6tLYRlC45h1Yr3Wa2gh3LJGtOSji+m7E9Xua/pPh8A/CAD+TNBa5d/X7C3a4AWl2bYTi7HBY
Y8vaIjHiSosru5F2UOEQG9xekCbNRK1Apew1UIvntzCmDMMhlAgB78AUOE2YEWKd9GOl+aTZjMS3
GxAYzrtv/bDRkPOYbcG0SNT9xf+izRM3lX1E2vN3i3uU2Qrh73fjU1lk3PIe/A/H56UrNPDnGT9W
TvlJR47bLDtGyX2+dLvfTaZGRP8aepePOXXLIlvqwCJSMVhCB/hIbz7E

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
TfuXOFQtE7YhtTL4354NvKETmBCLSVnb+pbrT8gtzjU7pERE1Hu2ZVzHgVQXwt5RvwG1R/z2je+U
PzszCBhPNqUaXEhuJ0A/q0S/vvOOa6h6tW9MhiB3gnuqEFVWz5pbHZNfgrwh2gT8XyqLI8f1CoJM
xpcB2TbREV/kAAFMxIfH1Dg0KSO2dCeVV1na6N0AiMOQPvXZOB7QpXwNDbYfarWLtF0/l0hi4Fxu
Kgho2ggrUhajP0aKlrCQ9mLsqOyqJELeJldeD+vuUUqhYq4K4RrwtQF+B67lYc4AjznwQ92tUvYJ
ZspFoHJEScNvdFoHFTA2TQ2KToepsqXRiOCL1A==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
tmfbBpNtCYJ7zsgNxUzw7Dvn+hNn2PPUBeRfXSci/q2/OcQeF/eAAML8YIN1V+AEoAqZTE2/xRQz
+6zwVOLyAOLynMIBQ7EG7xReDJ9kEEiBjnMGO6NWdAsa/VcreVHrLD1PFtA1+WoVe6yOvNGK+Nbh
HjPkXyycyP6RQ4Rx/PtTxw31LOFVezddSgRlaKHTprKTP4LbjPG//onRBg3fAl8zwU1wYYNLzYCX
jwY7xfMkQyhUSpV2Tx3seqy2IYVl8jjxynFxfyxulvrJiqmc6aaKKBdkoOVbJ5eO2sCXFJB1mKEU
WR2Ee2ozisABzk9IcGILewCW7ghdLP82CRZv4A==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
GfDCxx9db4ripD5mvQy16BVlwPYfeC7ZobZXaX1my6WUDiKwd69J5SreUXKYD9lvZfI7djLgHkYm
5G247T4NX7zoBwc88bUD+tNvGNmzWFfSVVZqu8hjgd31lZXjy9uYdXA/gsE+T+JqEfRYdV8YoGgm
sREyiJjWRPDbx6kc8um8vlAK/Rjwz0EGVkGUoi/+UvxcnjG1PqCl7GSMOQ3gFMEOaxIflShnF2/c
//ioADxl3WjUGyTstMK54XlP8G1Hk95sSe/7Y+SbaIyoG8t6gGDimDJNuGs4JjDUi1V7Gxfzxk9+
O2J++9clyLkMZ3rRyxSvR+Xyrmn3YxjVC68GXw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 54720)
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
