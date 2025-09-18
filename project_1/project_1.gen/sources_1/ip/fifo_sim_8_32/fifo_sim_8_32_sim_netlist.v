// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Tue Sep  9 16:20:16 2025
// Host        : MSI running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/phalaris/Desktop/prj_real/rs_en_dec/vivado_prj_errctrl/crc8.gen/sources_1/ip/fifo_sim_8_32/fifo_sim_8_32_sim_netlist.v
// Design      : fifo_sim_8_32
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu15eg-ffvb1156-2-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "fifo_sim_8_32,fifo_generator_v13_2_11,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "fifo_generator_v13_2_11,Vivado 2024.2" *) 
(* NotValidForBitStream *)
module fifo_sim_8_32
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
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_DATA" *) output [31:0]dout;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE FULL" *) output full;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ EMPTY" *) output empty;
  output wr_rst_busy;
  output rd_rst_busy;

  wire [7:0]din;
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
  wire [8:0]NLW_U0_rd_data_count_UNCONNECTED;
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
  (* C_PRIM_FIFO_TYPE = "2kx9" *) 
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
  (* C_RD_DATA_COUNT_WIDTH = "9" *) 
  (* C_RD_DEPTH = "512" *) 
  (* C_RD_FREQ = "1" *) 
  (* C_RD_PNTR_WIDTH = "9" *) 
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
  fifo_sim_8_32_fifo_generator_v13_2_11 U0
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
        .prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full(NLW_U0_prog_full_UNCONNECTED),
        .prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .rd_clk(rd_clk),
        .rd_data_count(NLW_U0_rd_data_count_UNCONNECTED[8:0]),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 51360)
`pragma protect data_block
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
v3xB
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
