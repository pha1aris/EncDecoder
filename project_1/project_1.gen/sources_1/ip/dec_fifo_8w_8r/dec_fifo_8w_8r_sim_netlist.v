// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Fri Sep  5 15:05:39 2025
// Host        : FSO-A running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top dec_fifo_8w_8r -prefix
//               dec_fifo_8w_8r_ dec_fifo_8w_8r_sim_netlist.v
// Design      : dec_fifo_8w_8r
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu15eg-ffvb1156-2-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dec_fifo_8w_8r,fifo_generator_v13_2_11,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "fifo_generator_v13_2_11,Vivado 2024.2" *) 
(* NotValidForBitStream *)
module dec_fifo_8w_8r
   (rst,
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
  input rst;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 write_clk CLK" *) (* x_interface_mode = "slave write_clk" *) (* x_interface_parameter = "XIL_INTERFACENAME write_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *) input wr_clk;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 read_clk CLK" *) (* x_interface_mode = "slave read_clk" *) (* x_interface_parameter = "XIL_INTERFACENAME read_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *) input rd_clk;
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
  wire rst;
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
  wire [5:0]NLW_U0_data_count_UNCONNECTED;
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
  wire [5:0]NLW_U0_rd_data_count_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_buser_UNCONNECTED;
  wire [63:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_ruser_UNCONNECTED;
  wire [5:0]NLW_U0_wr_data_count_UNCONNECTED;

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
  (* C_DATA_COUNT_WIDTH = "6" *) 
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
  (* C_EN_SAFETY_CKT = "1" *) 
  (* C_ERROR_INJECTION_TYPE = "0" *) 
  (* C_ERROR_INJECTION_TYPE_AXIS = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WRCH = "0" *) 
  (* C_FAMILY = "zynquplus" *) 
  (* C_FULL_FLAGS_RST_VAL = "1" *) 
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
  (* C_HAS_RST = "1" *) 
  (* C_HAS_SLAVE_CE = "0" *) 
  (* C_HAS_SRST = "0" *) 
  (* C_HAS_UNDERFLOW = "0" *) 
  (* C_HAS_VALID = "0" *) 
  (* C_HAS_WR_ACK = "0" *) 
  (* C_HAS_WR_DATA_COUNT = "0" *) 
  (* C_HAS_WR_RST = "0" *) 
  (* C_IMPLEMENTATION_TYPE = "2" *) 
  (* C_IMPLEMENTATION_TYPE_AXIS = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RACH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WACH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WRCH = "1" *) 
  (* C_INIT_WR_PNTR_VAL = "0" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_MEMORY_TYPE = "1" *) 
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
  (* C_PROG_FULL_THRESH_ASSERT_VAL = "63" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_AXIS = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WRCH = "1023" *) 
  (* C_PROG_FULL_THRESH_NEGATE_VAL = "62" *) 
  (* C_PROG_FULL_TYPE = "0" *) 
  (* C_PROG_FULL_TYPE_AXIS = "0" *) 
  (* C_PROG_FULL_TYPE_RACH = "0" *) 
  (* C_PROG_FULL_TYPE_RDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WACH = "0" *) 
  (* C_PROG_FULL_TYPE_WDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WRCH = "0" *) 
  (* C_RACH_TYPE = "0" *) 
  (* C_RDCH_TYPE = "0" *) 
  (* C_RD_DATA_COUNT_WIDTH = "6" *) 
  (* C_RD_DEPTH = "64" *) 
  (* C_RD_FREQ = "1" *) 
  (* C_RD_PNTR_WIDTH = "6" *) 
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
  (* C_WR_DATA_COUNT_WIDTH = "6" *) 
  (* C_WR_DEPTH = "64" *) 
  (* C_WR_DEPTH_AXIS = "1024" *) 
  (* C_WR_DEPTH_RACH = "16" *) 
  (* C_WR_DEPTH_RDCH = "1024" *) 
  (* C_WR_DEPTH_WACH = "16" *) 
  (* C_WR_DEPTH_WDCH = "1024" *) 
  (* C_WR_DEPTH_WRCH = "16" *) 
  (* C_WR_FREQ = "1" *) 
  (* C_WR_PNTR_WIDTH = "6" *) 
  (* C_WR_PNTR_WIDTH_AXIS = "10" *) 
  (* C_WR_PNTR_WIDTH_RACH = "4" *) 
  (* C_WR_PNTR_WIDTH_RDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WACH = "4" *) 
  (* C_WR_PNTR_WIDTH_WDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WRCH = "4" *) 
  (* C_WR_RESPONSE_LATENCY = "1" *) 
  (* is_du_within_envelope = "true" *) 
  dec_fifo_8w_8r_fifo_generator_v13_2_11 U0
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
        .data_count(NLW_U0_data_count_UNCONNECTED[5:0]),
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
        .prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full(NLW_U0_prog_full_UNCONNECTED),
        .prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .rd_clk(rd_clk),
        .rd_data_count(NLW_U0_rd_data_count_UNCONNECTED[5:0]),
        .rd_en(rd_en),
        .rd_rst(1'b0),
        .rd_rst_busy(rd_rst_busy),
        .rst(rst),
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
        .srst(1'b0),
        .underflow(NLW_U0_underflow_UNCONNECTED),
        .valid(NLW_U0_valid_UNCONNECTED),
        .wr_ack(NLW_U0_wr_ack_UNCONNECTED),
        .wr_clk(wr_clk),
        .wr_data_count(NLW_U0_wr_data_count_UNCONNECTED[5:0]),
        .wr_en(wr_en),
        .wr_rst(1'b0),
        .wr_rst_busy(wr_rst_busy));
endmodule

(* DEST_SYNC_FF = "2" *) (* INIT_SYNC_FF = "0" *) (* REG_OUTPUT = "1" *) 
(* SIM_ASSERT_CHK = "0" *) (* SIM_LOSSLESS_GRAY_CHK = "0" *) (* VERSION = "0" *) 
(* WIDTH = "6" *) (* XPM_MODULE = "TRUE" *) (* is_du_within_envelope = "true" *) 
(* keep_hierarchy = "true" *) (* xpm_cdc = "GRAY" *) 
module dec_fifo_8w_8r_xpm_cdc_gray
   (src_clk,
    src_in_bin,
    dest_clk,
    dest_out_bin);
  input src_clk;
  input [5:0]src_in_bin;
  input dest_clk;
  output [5:0]dest_out_bin;

  wire [5:0]async_path;
  wire [4:0]binval;
  wire dest_clk;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "GRAY" *) wire [5:0]\dest_graysync_ff[0] ;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "GRAY" *) wire [5:0]\dest_graysync_ff[1] ;
  wire [5:0]dest_out_bin;
  wire [4:0]gray_enc;
  wire src_clk;
  wire [5:0]src_in_bin;

  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[0]),
        .Q(\dest_graysync_ff[0] [0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[1]),
        .Q(\dest_graysync_ff[0] [1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[2]),
        .Q(\dest_graysync_ff[0] [2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[3]),
        .Q(\dest_graysync_ff[0] [3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[4]),
        .Q(\dest_graysync_ff[0] [4]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[5]),
        .Q(\dest_graysync_ff[0] [5]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [0]),
        .Q(\dest_graysync_ff[1] [0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [1]),
        .Q(\dest_graysync_ff[1] [1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [2]),
        .Q(\dest_graysync_ff[1] [2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [3]),
        .Q(\dest_graysync_ff[1] [3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [4]),
        .Q(\dest_graysync_ff[1] [4]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [5]),
        .Q(\dest_graysync_ff[1] [5]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \dest_out_bin_ff[0]_i_1 
       (.I0(\dest_graysync_ff[1] [0]),
        .I1(\dest_graysync_ff[1] [2]),
        .I2(\dest_graysync_ff[1] [4]),
        .I3(\dest_graysync_ff[1] [5]),
        .I4(\dest_graysync_ff[1] [3]),
        .I5(\dest_graysync_ff[1] [1]),
        .O(binval[0]));
  LUT5 #(
    .INIT(32'h96696996)) 
    \dest_out_bin_ff[1]_i_1 
       (.I0(\dest_graysync_ff[1] [1]),
        .I1(\dest_graysync_ff[1] [3]),
        .I2(\dest_graysync_ff[1] [5]),
        .I3(\dest_graysync_ff[1] [4]),
        .I4(\dest_graysync_ff[1] [2]),
        .O(binval[1]));
  LUT4 #(
    .INIT(16'h6996)) 
    \dest_out_bin_ff[2]_i_1 
       (.I0(\dest_graysync_ff[1] [2]),
        .I1(\dest_graysync_ff[1] [4]),
        .I2(\dest_graysync_ff[1] [5]),
        .I3(\dest_graysync_ff[1] [3]),
        .O(binval[2]));
  LUT3 #(
    .INIT(8'h96)) 
    \dest_out_bin_ff[3]_i_1 
       (.I0(\dest_graysync_ff[1] [3]),
        .I1(\dest_graysync_ff[1] [5]),
        .I2(\dest_graysync_ff[1] [4]),
        .O(binval[3]));
  LUT2 #(
    .INIT(4'h6)) 
    \dest_out_bin_ff[4]_i_1 
       (.I0(\dest_graysync_ff[1] [4]),
        .I1(\dest_graysync_ff[1] [5]),
        .O(binval[4]));
  FDRE \dest_out_bin_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[0]),
        .Q(dest_out_bin[0]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[1]),
        .Q(dest_out_bin[1]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[2]),
        .Q(dest_out_bin[2]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[3]),
        .Q(dest_out_bin[3]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[4]),
        .Q(dest_out_bin[4]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[1] [5]),
        .Q(dest_out_bin[5]),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[0]_i_1 
       (.I0(src_in_bin[1]),
        .I1(src_in_bin[0]),
        .O(gray_enc[0]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[1]_i_1 
       (.I0(src_in_bin[2]),
        .I1(src_in_bin[1]),
        .O(gray_enc[1]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[2]_i_1 
       (.I0(src_in_bin[3]),
        .I1(src_in_bin[2]),
        .O(gray_enc[2]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[3]_i_1 
       (.I0(src_in_bin[4]),
        .I1(src_in_bin[3]),
        .O(gray_enc[3]));
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[4]_i_1 
       (.I0(src_in_bin[5]),
        .I1(src_in_bin[4]),
        .O(gray_enc[4]));
  FDRE \src_gray_ff_reg[0] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[0]),
        .Q(async_path[0]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[1] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[1]),
        .Q(async_path[1]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[2] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[2]),
        .Q(async_path[2]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[3] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[3]),
        .Q(async_path[3]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[4] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[4]),
        .Q(async_path[4]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[5] 
       (.C(src_clk),
        .CE(1'b1),
        .D(src_in_bin[5]),
        .Q(async_path[5]),
        .R(1'b0));
endmodule

(* DEST_SYNC_FF = "2" *) (* INIT_SYNC_FF = "0" *) (* ORIG_REF_NAME = "xpm_cdc_gray" *) 
(* REG_OUTPUT = "1" *) (* SIM_ASSERT_CHK = "0" *) (* SIM_LOSSLESS_GRAY_CHK = "0" *) 
(* VERSION = "0" *) (* WIDTH = "6" *) (* XPM_MODULE = "TRUE" *) 
(* is_du_within_envelope = "true" *) (* keep_hierarchy = "true" *) (* xpm_cdc = "GRAY" *) 
module dec_fifo_8w_8r_xpm_cdc_gray__2
   (src_clk,
    src_in_bin,
    dest_clk,
    dest_out_bin);
  input src_clk;
  input [5:0]src_in_bin;
  input dest_clk;
  output [5:0]dest_out_bin;

  wire [5:0]async_path;
  wire [4:0]binval;
  wire dest_clk;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "GRAY" *) wire [5:0]\dest_graysync_ff[0] ;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "GRAY" *) wire [5:0]\dest_graysync_ff[1] ;
  wire [5:0]dest_out_bin;
  wire [4:0]gray_enc;
  wire src_clk;
  wire [5:0]src_in_bin;

  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[0]),
        .Q(\dest_graysync_ff[0] [0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[1]),
        .Q(\dest_graysync_ff[0] [1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[2]),
        .Q(\dest_graysync_ff[0] [2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[3]),
        .Q(\dest_graysync_ff[0] [3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[4]),
        .Q(\dest_graysync_ff[0] [4]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[5]),
        .Q(\dest_graysync_ff[0] [5]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [0]),
        .Q(\dest_graysync_ff[1] [0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [1]),
        .Q(\dest_graysync_ff[1] [1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [2]),
        .Q(\dest_graysync_ff[1] [2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [3]),
        .Q(\dest_graysync_ff[1] [3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [4]),
        .Q(\dest_graysync_ff[1] [4]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [5]),
        .Q(\dest_graysync_ff[1] [5]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \dest_out_bin_ff[0]_i_1 
       (.I0(\dest_graysync_ff[1] [0]),
        .I1(\dest_graysync_ff[1] [2]),
        .I2(\dest_graysync_ff[1] [4]),
        .I3(\dest_graysync_ff[1] [5]),
        .I4(\dest_graysync_ff[1] [3]),
        .I5(\dest_graysync_ff[1] [1]),
        .O(binval[0]));
  LUT5 #(
    .INIT(32'h96696996)) 
    \dest_out_bin_ff[1]_i_1 
       (.I0(\dest_graysync_ff[1] [1]),
        .I1(\dest_graysync_ff[1] [3]),
        .I2(\dest_graysync_ff[1] [5]),
        .I3(\dest_graysync_ff[1] [4]),
        .I4(\dest_graysync_ff[1] [2]),
        .O(binval[1]));
  LUT4 #(
    .INIT(16'h6996)) 
    \dest_out_bin_ff[2]_i_1 
       (.I0(\dest_graysync_ff[1] [2]),
        .I1(\dest_graysync_ff[1] [4]),
        .I2(\dest_graysync_ff[1] [5]),
        .I3(\dest_graysync_ff[1] [3]),
        .O(binval[2]));
  LUT3 #(
    .INIT(8'h96)) 
    \dest_out_bin_ff[3]_i_1 
       (.I0(\dest_graysync_ff[1] [3]),
        .I1(\dest_graysync_ff[1] [5]),
        .I2(\dest_graysync_ff[1] [4]),
        .O(binval[3]));
  LUT2 #(
    .INIT(4'h6)) 
    \dest_out_bin_ff[4]_i_1 
       (.I0(\dest_graysync_ff[1] [4]),
        .I1(\dest_graysync_ff[1] [5]),
        .O(binval[4]));
  FDRE \dest_out_bin_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[0]),
        .Q(dest_out_bin[0]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[1]),
        .Q(dest_out_bin[1]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[2]),
        .Q(dest_out_bin[2]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[3]),
        .Q(dest_out_bin[3]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[4]),
        .Q(dest_out_bin[4]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[1] [5]),
        .Q(dest_out_bin[5]),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[0]_i_1 
       (.I0(src_in_bin[1]),
        .I1(src_in_bin[0]),
        .O(gray_enc[0]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[1]_i_1 
       (.I0(src_in_bin[2]),
        .I1(src_in_bin[1]),
        .O(gray_enc[1]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[2]_i_1 
       (.I0(src_in_bin[3]),
        .I1(src_in_bin[2]),
        .O(gray_enc[2]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[3]_i_1 
       (.I0(src_in_bin[4]),
        .I1(src_in_bin[3]),
        .O(gray_enc[3]));
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[4]_i_1 
       (.I0(src_in_bin[5]),
        .I1(src_in_bin[4]),
        .O(gray_enc[4]));
  FDRE \src_gray_ff_reg[0] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[0]),
        .Q(async_path[0]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[1] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[1]),
        .Q(async_path[1]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[2] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[2]),
        .Q(async_path[2]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[3] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[3]),
        .Q(async_path[3]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[4] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[4]),
        .Q(async_path[4]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[5] 
       (.C(src_clk),
        .CE(1'b1),
        .D(src_in_bin[5]),
        .Q(async_path[5]),
        .R(1'b0));
endmodule

(* DEST_SYNC_FF = "5" *) (* INIT_SYNC_FF = "0" *) (* SIM_ASSERT_CHK = "0" *) 
(* SRC_INPUT_REG = "0" *) (* VERSION = "0" *) (* XPM_MODULE = "TRUE" *) 
(* is_du_within_envelope = "true" *) (* keep_hierarchy = "true" *) (* xpm_cdc = "SINGLE" *) 
module dec_fifo_8w_8r_xpm_cdc_single
   (src_clk,
    src_in,
    dest_clk,
    dest_out);
  input src_clk;
  input src_in;
  input dest_clk;
  output dest_out;

  wire dest_clk;
  wire src_in;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "SINGLE" *) wire [4:0]syncstages_ff;

  assign dest_out = syncstages_ff[4];
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(src_in),
        .Q(syncstages_ff[0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[0]),
        .Q(syncstages_ff[1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[1]),
        .Q(syncstages_ff[2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[2]),
        .Q(syncstages_ff[3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[3]),
        .Q(syncstages_ff[4]),
        .R(1'b0));
endmodule

(* DEST_SYNC_FF = "5" *) (* INIT_SYNC_FF = "0" *) (* ORIG_REF_NAME = "xpm_cdc_single" *) 
(* SIM_ASSERT_CHK = "0" *) (* SRC_INPUT_REG = "0" *) (* VERSION = "0" *) 
(* XPM_MODULE = "TRUE" *) (* is_du_within_envelope = "true" *) (* keep_hierarchy = "true" *) 
(* xpm_cdc = "SINGLE" *) 
module dec_fifo_8w_8r_xpm_cdc_single__2
   (src_clk,
    src_in,
    dest_clk,
    dest_out);
  input src_clk;
  input src_in;
  input dest_clk;
  output dest_out;

  wire dest_clk;
  wire src_in;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "SINGLE" *) wire [4:0]syncstages_ff;

  assign dest_out = syncstages_ff[4];
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(src_in),
        .Q(syncstages_ff[0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[0]),
        .Q(syncstages_ff[1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[1]),
        .Q(syncstages_ff[2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[2]),
        .Q(syncstages_ff[3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[3]),
        .Q(syncstages_ff[4]),
        .R(1'b0));
endmodule

(* DEF_VAL = "1'b1" *) (* DEST_SYNC_FF = "5" *) (* INIT = "1" *) 
(* INIT_SYNC_FF = "0" *) (* SIM_ASSERT_CHK = "0" *) (* VERSION = "0" *) 
(* XPM_MODULE = "TRUE" *) (* is_du_within_envelope = "true" *) (* keep_hierarchy = "true" *) 
(* xpm_cdc = "SYNC_RST" *) 
module dec_fifo_8w_8r_xpm_cdc_sync_rst
   (src_rst,
    dest_clk,
    dest_rst);
  input src_rst;
  input dest_clk;
  output dest_rst;

  wire dest_clk;
  wire src_rst;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "SYNC_RST" *) wire [4:0]syncstages_ff;

  assign dest_rst = syncstages_ff[4];
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(src_rst),
        .Q(syncstages_ff[0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[0]),
        .Q(syncstages_ff[1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[1]),
        .Q(syncstages_ff[2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[2]),
        .Q(syncstages_ff[3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[3]),
        .Q(syncstages_ff[4]),
        .R(1'b0));
endmodule

(* DEF_VAL = "1'b1" *) (* DEST_SYNC_FF = "5" *) (* INIT = "1" *) 
(* INIT_SYNC_FF = "0" *) (* ORIG_REF_NAME = "xpm_cdc_sync_rst" *) (* SIM_ASSERT_CHK = "0" *) 
(* VERSION = "0" *) (* XPM_MODULE = "TRUE" *) (* is_du_within_envelope = "true" *) 
(* keep_hierarchy = "true" *) (* xpm_cdc = "SYNC_RST" *) 
module dec_fifo_8w_8r_xpm_cdc_sync_rst__2
   (src_rst,
    dest_clk,
    dest_rst);
  input src_rst;
  input dest_clk;
  output dest_rst;

  wire dest_clk;
  wire src_rst;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "SYNC_RST" *) wire [4:0]syncstages_ff;

  assign dest_rst = syncstages_ff[4];
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(src_rst),
        .Q(syncstages_ff[0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[0]),
        .Q(syncstages_ff[1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[1]),
        .Q(syncstages_ff[2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[2]),
        .Q(syncstages_ff[3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[3]),
        .Q(syncstages_ff[4]),
        .R(1'b0));
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 107056)
`pragma protect data_block
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
aYj71oNzWYVLRMgGdEX1kni9Nw8VVgOVHnvo1cjVA6PH6DctAW2g8cEO1FsrTAg68oryybSsr1OP
VZEHujncs4uScHlESEsLTOCr8hIY0+aZ8oimwRZQVPmmEZZ9ileJHvyogswwMpHBD3h+3dKDHLUM
pUmHrvj9Bb+Lx3/Ff0MGhSK2P+KO7EdMtTYnTAOVMo86lL9y6IxxaAOju7gq3n46mgpz4+xkJku+
/MJl6xWYTx6s26U0Y7oa9P4HC03c4qIVt3s+1X+lMUEMcZITmWY6aIX+X6jBm0Z4ybea0q/rn1LS
8O+XyzjYqPLl3W17fbBhlO+VsgOh9QO4vcYt88mdNa9J3SqvXTORDWrwE6bBeX1j3lXGSG5grOZl
oxx5/6ItnIYU7kTvNJjUGpubcb5NzzB9NQKG+oTzwI/A9EMUyO9E7EIF3sjmwr1vGvblz/5BMX4S
nbQ6DT3oInvBuan/Vvern2TOfqmsTlvrB3d6fbEELCx7uSYADIkH9jiUo/8G/PfrGyB905tVgeKM
9qLjgwjzq21PsC3Dr/ecniQsRVBvUh3Q4buIYAFSaEZtf47xZnYzl39L6kuMbGhRdy7wIGHK+kQO
Ho3Rjenee9E52jDtuHWDxxugpFlzZNhRrdpWpCk7Z25hEFL32MQdskIvKZC6xIkBEMY7Om7Agp3o
++LqRWpmdXjchweRZi8OQhwpcNbEnYchm8v0qYVXX03D7bEnbpLzURQlOCrTkxiCbS2J4y6FMf7Q
MT1bwgM6T533i83qpgTK/jEvlkPl5Xguu8pdpwi1x5mmOoCK7SYxkVxM4fhKOHoJjvJIX3csQW30
JCerpPpStgx+vW3PRVWnWgmqdj52PQXEL85H6piSk6opvr17jzKYSeyUbHCjqYQ1rlwonlV4tbSt
W5bqKWoFf33a3l2dliZDjwmL2wFZNInCftFtdtgoJJJJSMKJQ87rKN6T3lLvQJWv7VI2VkSveRRK
pHdIWv2fT/bK7tgyYwiaerVQEg6Aq2fnqZBiqQIASA2/uQgv5z9FPnqh3GVaDBr9WDMQxXjFVwsj
TmJyfbTVtMdqCzS7LnO58fTpzgvjBo2fzz0l8Fj+Vfv7XdG/MYuGaIxRSUdOOdU6T2ony2jdtzgi
cUPSo7+/Xf9Ly9YUgE0ZSQ0ko0MzQusLA3zkvQTHSFT9dR7G8/wdq2v89nLKG/09jW0qKdPGVDOI
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
JOmzcGQ6HcUwaA==
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
