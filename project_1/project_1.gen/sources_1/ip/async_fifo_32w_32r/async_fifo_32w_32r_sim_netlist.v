// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Mon Nov 17 21:02:03 2025
// Host        : FSO-A running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/PC/Desktop/fps/EnDec/project_1/project_1.gen/sources_1/ip/async_fifo_32w_32r/async_fifo_32w_32r_sim_netlist.v
// Design      : async_fifo_32w_32r
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu15eg-ffvb1156-2-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "async_fifo_32w_32r,fifo_generator_v13_2_11,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "fifo_generator_v13_2_11,Vivado 2024.2" *) 
(* NotValidForBitStream *)
module async_fifo_32w_32r
   (srst,
    wr_clk,
    rd_clk,
    din,
    wr_en,
    rd_en,
    dout,
    full,
    empty,
    wr_rst_busy,
    rd_rst_busy);
  input srst;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 write_clk CLK" *) (* x_interface_mode = "slave write_clk" *) (* x_interface_parameter = "XIL_INTERFACENAME write_clk, FREQ_HZ 1000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *) input wr_clk;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 read_clk CLK" *) (* x_interface_mode = "slave read_clk" *) (* x_interface_parameter = "XIL_INTERFACENAME read_clk, FREQ_HZ 1000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *) input rd_clk;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_DATA" *) (* x_interface_mode = "slave FIFO_WRITE" *) input [31:0]din;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_EN" *) input wr_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_EN" *) (* x_interface_mode = "slave FIFO_READ" *) input rd_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_DATA" *) output [31:0]dout;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE FULL" *) output full;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ EMPTY" *) output empty;
  output wr_rst_busy;
  output rd_rst_busy;

  wire [31:0]din;
  wire [31:0]dout;
  wire empty;
  wire full;
  wire rd_clk;
  wire rd_en;
  wire rd_rst_busy;
  wire srst;
  wire wr_clk;
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
  (* C_COMMON_CLOCK = "0" *) 
  (* C_COUNT_TYPE = "0" *) 
  (* C_DATA_COUNT_WIDTH = "10" *) 
  (* C_DEFAULT_VALUE = "BlankString" *) 
  (* C_DIN_WIDTH = "32" *) 
  (* C_DIN_WIDTH_AXIS = "1" *) 
  (* C_DIN_WIDTH_RACH = "32" *) 
  (* C_DIN_WIDTH_RDCH = "64" *) 
  (* C_DIN_WIDTH_WACH = "1" *) 
  (* C_DIN_WIDTH_WDCH = "64" *) 
  (* C_DIN_WIDTH_WRCH = "2" *) 
  (* C_DOUT_RST_VAL = "0" *) 
  (* C_DOUT_WIDTH = "32" *) 
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
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL = "6" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_AXIS = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WRCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_NEGATE_VAL = "7" *) 
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
  async_fifo_32w_32r_fifo_generator_v13_2_11 U0
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
        .clk(1'b0),
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
        .rd_clk(rd_clk),
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
        .wr_clk(wr_clk),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 55328)
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
