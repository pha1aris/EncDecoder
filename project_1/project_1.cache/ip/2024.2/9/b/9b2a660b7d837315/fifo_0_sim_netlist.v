// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Wed Nov 19 10:54:12 2025
// Host        : FSO-A running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ fifo_0_sim_netlist.v
// Design      : fifo_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu15eg-ffvb1156-2-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "fifo_0,fifo_generator_v13_2_11,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "fifo_generator_v13_2_11,Vivado 2024.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 51424)
`pragma protect data_block
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
U00xsYKdvUWzGA==
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
