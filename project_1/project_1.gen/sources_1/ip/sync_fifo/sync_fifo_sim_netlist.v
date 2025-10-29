// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Thu Oct 23 20:32:45 2025
// Host        : FSO-A running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/PC/Desktop/fps/EnDec/project_1/project_1.gen/sources_1/ip/sync_fifo/sync_fifo_sim_netlist.v
// Design      : sync_fifo
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu15eg-ffvb1156-2-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "sync_fifo,fifo_generator_v13_2_11,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "fifo_generator_v13_2_11,Vivado 2024.2" *) 
(* NotValidForBitStream *)
module sync_fifo
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
  sync_fifo_fifo_generator_v13_2_11 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 54640)
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
