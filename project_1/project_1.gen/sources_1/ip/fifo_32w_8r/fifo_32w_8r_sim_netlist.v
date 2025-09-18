// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Fri Sep  5 11:54:17 2025
// Host        : FSO-A running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top fifo_32w_8r -prefix
//               fifo_32w_8r_ fifo_32w_8r_sim_netlist.v
// Design      : fifo_32w_8r
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu15eg-ffvb1156-2-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "fifo_32w_8r,fifo_generator_v13_2_11,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "fifo_generator_v13_2_11,Vivado 2024.2" *) 
(* NotValidForBitStream *)
module fifo_32w_8r
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
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_DATA" *) output [7:0]dout;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE FULL" *) output full;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ EMPTY" *) output empty;
  output wr_rst_busy;
  output rd_rst_busy;

  wire [31:0]din;
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
  wire [8:0]NLW_U0_data_count_UNCONNECTED;
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
  wire [8:0]NLW_U0_wr_data_count_UNCONNECTED;

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
  (* C_DATA_COUNT_WIDTH = "9" *) 
  (* C_DEFAULT_VALUE = "BlankString" *) 
  (* C_DIN_WIDTH = "32" *) 
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
  (* C_PRIM_FIFO_TYPE = "512x36" *) 
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
  (* C_PROG_FULL_THRESH_ASSERT_VAL = "509" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_AXIS = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WRCH = "1023" *) 
  (* C_PROG_FULL_THRESH_NEGATE_VAL = "508" *) 
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
  (* C_USE_EMBEDDED_REG = "1" *) 
  (* C_USE_FIFO16_FLAGS = "0" *) 
  (* C_USE_FWFT_DATA_COUNT = "0" *) 
  (* C_USE_PIPELINE_REG = "0" *) 
  (* C_VALID_LOW = "0" *) 
  (* C_WACH_TYPE = "0" *) 
  (* C_WDCH_TYPE = "0" *) 
  (* C_WRCH_TYPE = "0" *) 
  (* C_WR_ACK_LOW = "0" *) 
  (* C_WR_DATA_COUNT_WIDTH = "9" *) 
  (* C_WR_DEPTH = "512" *) 
  (* C_WR_DEPTH_AXIS = "1024" *) 
  (* C_WR_DEPTH_RACH = "16" *) 
  (* C_WR_DEPTH_RDCH = "1024" *) 
  (* C_WR_DEPTH_WACH = "16" *) 
  (* C_WR_DEPTH_WDCH = "1024" *) 
  (* C_WR_DEPTH_WRCH = "16" *) 
  (* C_WR_FREQ = "1" *) 
  (* C_WR_PNTR_WIDTH = "9" *) 
  (* C_WR_PNTR_WIDTH_AXIS = "10" *) 
  (* C_WR_PNTR_WIDTH_RACH = "4" *) 
  (* C_WR_PNTR_WIDTH_RDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WACH = "4" *) 
  (* C_WR_PNTR_WIDTH_WDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WRCH = "4" *) 
  (* C_WR_RESPONSE_LATENCY = "1" *) 
  (* is_du_within_envelope = "true" *) 
  fifo_32w_8r_fifo_generator_v13_2_11 U0
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
        .data_count(NLW_U0_data_count_UNCONNECTED[8:0]),
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
        .prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
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
        .wr_data_count(NLW_U0_wr_data_count_UNCONNECTED[8:0]),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 50832)
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
