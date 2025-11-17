// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Mon Nov 17 21:02:03 2025
// Host        : FSO-A running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ async_fifo_32w_32r_sim_netlist.v
// Design      : async_fifo_32w_32r
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu15eg-ffvb1156-2-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "async_fifo_32w_32r,fifo_generator_v13_2_11,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "fifo_generator_v13_2_11,Vivado 2024.2" *) 
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 55296)
`pragma protect data_block
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
Wu3NH6Gd
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
