// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Thu Oct 23 20:25:50 2025
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
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_DATA" *) (* x_interface_mode = "slave FIFO_WRITE" *) input [31:0]din;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_EN" *) input wr_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_EN" *) (* x_interface_mode = "slave FIFO_READ" *) input rd_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_DATA" *) output [31:0]dout;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE FULL" *) output full;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ EMPTY" *) output empty;
  output wr_rst_busy;
  output rd_rst_busy;

  wire clk;
  wire [31:0]din;
  wire [31:0]dout;
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 54768)
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
