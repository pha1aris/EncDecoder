// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Wed Nov 19 10:54:13 2025
// Host        : FSO-A running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/PC/Desktop/fps/EnDec/project_1/project_1.gen/sources_1/ip/fifo_0/fifo_0_sim_netlist.v
// Design      : fifo_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu15eg-ffvb1156-2-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "fifo_0,fifo_generator_v13_2_11,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "fifo_generator_v13_2_11,Vivado 2024.2" *) 
(* NotValidForBitStream *)
module fifo_0
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
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_DATA" *) (* x_interface_mode = "slave FIFO_WRITE" *) input [7:0]din;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_EN" *) input wr_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_EN" *) (* x_interface_mode = "slave FIFO_READ" *) input rd_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_DATA" *) output [7:0]dout;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE FULL" *) output full;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ EMPTY" *) output empty;
  output wr_rst_busy;
  output rd_rst_busy;

  wire [7:0]din;
  wire [7:0]dout;
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
  wire [10:0]NLW_U0_data_count_UNCONNECTED;
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
  wire [10:0]NLW_U0_rd_data_count_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_buser_UNCONNECTED;
  wire [63:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_ruser_UNCONNECTED;
  wire [10:0]NLW_U0_wr_data_count_UNCONNECTED;

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
  (* C_DATA_COUNT_WIDTH = "11" *) 
  (* C_DEFAULT_VALUE = "BlankString" *) 
  (* C_DIN_WIDTH = "8" *) 
  (* C_DIN_WIDTH_AXIS = "1" *) 
  (* C_DIN_WIDTH_RACH = "32" *) 
  (* C_DIN_WIDTH_RDCH = "64" *) 
  (* C_DIN_WIDTH_WACH = "1" *) 
  (* C_DIN_WIDTH_WDCH = "64" *) 
  (* C_DIN_WIDTH_WRCH = "2" *) 
  (* C_DOUT_RST_VAL = "0" *) 
  (* C_DOUT_WIDTH = "8" *) 
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
  (* C_PRIM_FIFO_TYPE = "2kx9" *) 
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
  (* C_PROG_FULL_THRESH_ASSERT_VAL = "2047" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_AXIS = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WRCH = "1023" *) 
  (* C_PROG_FULL_THRESH_NEGATE_VAL = "2046" *) 
  (* C_PROG_FULL_TYPE = "0" *) 
  (* C_PROG_FULL_TYPE_AXIS = "0" *) 
  (* C_PROG_FULL_TYPE_RACH = "0" *) 
  (* C_PROG_FULL_TYPE_RDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WACH = "0" *) 
  (* C_PROG_FULL_TYPE_WDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WRCH = "0" *) 
  (* C_RACH_TYPE = "0" *) 
  (* C_RDCH_TYPE = "0" *) 
  (* C_RD_DATA_COUNT_WIDTH = "11" *) 
  (* C_RD_DEPTH = "2048" *) 
  (* C_RD_FREQ = "1" *) 
  (* C_RD_PNTR_WIDTH = "11" *) 
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
  (* C_USE_EMBEDDED_REG = "0" *) 
  (* C_USE_FIFO16_FLAGS = "0" *) 
  (* C_USE_FWFT_DATA_COUNT = "0" *) 
  (* C_USE_PIPELINE_REG = "0" *) 
  (* C_VALID_LOW = "0" *) 
  (* C_WACH_TYPE = "0" *) 
  (* C_WDCH_TYPE = "0" *) 
  (* C_WRCH_TYPE = "0" *) 
  (* C_WR_ACK_LOW = "0" *) 
  (* C_WR_DATA_COUNT_WIDTH = "11" *) 
  (* C_WR_DEPTH = "2048" *) 
  (* C_WR_DEPTH_AXIS = "1024" *) 
  (* C_WR_DEPTH_RACH = "16" *) 
  (* C_WR_DEPTH_RDCH = "1024" *) 
  (* C_WR_DEPTH_WACH = "16" *) 
  (* C_WR_DEPTH_WDCH = "1024" *) 
  (* C_WR_DEPTH_WRCH = "16" *) 
  (* C_WR_FREQ = "1" *) 
  (* C_WR_PNTR_WIDTH = "11" *) 
  (* C_WR_PNTR_WIDTH_AXIS = "10" *) 
  (* C_WR_PNTR_WIDTH_RACH = "4" *) 
  (* C_WR_PNTR_WIDTH_RDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WACH = "4" *) 
  (* C_WR_PNTR_WIDTH_WDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WRCH = "4" *) 
  (* C_WR_RESPONSE_LATENCY = "1" *) 
  (* is_du_within_envelope = "true" *) 
  fifo_0_fifo_generator_v13_2_11 U0
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
        .data_count(NLW_U0_data_count_UNCONNECTED[10:0]),
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
        .prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full(NLW_U0_prog_full_UNCONNECTED),
        .prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .rd_clk(rd_clk),
        .rd_data_count(NLW_U0_rd_data_count_UNCONNECTED[10:0]),
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
        .wr_data_count(NLW_U0_wr_data_count_UNCONNECTED[10:0]),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 51296)
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
