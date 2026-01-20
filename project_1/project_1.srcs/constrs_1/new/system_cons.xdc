################====== GTH =======##################
# GTH reference clock
set_property PACKAGE_PIN L7 [get_ports mgtrefclk0_x1y1_n]
set_property PACKAGE_PIN L8 [get_ports mgtrefclk0_x1y1_p]

# Tx Disable Constraints
set_property PACKAGE_PIN G13 [get_ports {tx_disable[0]}]
set_property PACKAGE_PIN H12 [get_ports {tx_disable[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {tx_disable[*]}]
# set_property SLEW SLOW [get_ports {tx_disable[*]}]
set_property PACKAGE_PIN H13 [get_ports {sfp_loss[0]}]
set_property PACKAGE_PIN J12 [get_ports {sfp_loss[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sfp_loss[*]}]
############### ====== sys ===== ###############
set_property PACKAGE_PIN AL8 [get_ports sys_clk_p]
set_property PACKAGE_PIN AL7 [get_ports sys_clk_n]
set_property IOSTANDARD DIFF_SSTL12 [get_ports sys_clk_p]
set_property IOSTANDARD DIFF_SSTL12 [get_ports sys_clk_n]

set_property PACKAGE_PIN AN12 [get_ports sys_rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports sys_rst_n]

##################### LED ###########################
# set_property PACKAGE_PIN AM13 [get_ports pl_led1]
# set_property IOSTANDARD LVCMOS33 [get_ports pl_led1]
# set_property PACKAGE_PIN AP12 [get_ports pl_led2]
# set_property IOSTANDARD LVCMOS33 [get_ports pl_led2]





create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 2048 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list core_clk]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 16 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {rx_block_id[0]} {rx_block_id[1]} {rx_block_id[2]} {rx_block_id[3]} {rx_block_id[4]} {rx_block_id[5]} {rx_block_id[6]} {rx_block_id[7]} {rx_block_id[8]} {rx_block_id[9]} {rx_block_id[10]} {rx_block_id[11]} {rx_block_id[12]} {rx_block_id[13]} {rx_block_id[14]} {rx_block_id[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 96 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {m_axis_dout_tdata[0]} {m_axis_dout_tdata[1]} {m_axis_dout_tdata[2]} {m_axis_dout_tdata[3]} {m_axis_dout_tdata[4]} {m_axis_dout_tdata[5]} {m_axis_dout_tdata[6]} {m_axis_dout_tdata[7]} {m_axis_dout_tdata[8]} {m_axis_dout_tdata[9]} {m_axis_dout_tdata[10]} {m_axis_dout_tdata[11]} {m_axis_dout_tdata[12]} {m_axis_dout_tdata[13]} {m_axis_dout_tdata[14]} {m_axis_dout_tdata[15]} {m_axis_dout_tdata[16]} {m_axis_dout_tdata[17]} {m_axis_dout_tdata[18]} {m_axis_dout_tdata[19]} {m_axis_dout_tdata[20]} {m_axis_dout_tdata[21]} {m_axis_dout_tdata[22]} {m_axis_dout_tdata[23]} {m_axis_dout_tdata[24]} {m_axis_dout_tdata[25]} {m_axis_dout_tdata[26]} {m_axis_dout_tdata[27]} {m_axis_dout_tdata[28]} {m_axis_dout_tdata[29]} {m_axis_dout_tdata[30]} {m_axis_dout_tdata[31]} {m_axis_dout_tdata[32]} {m_axis_dout_tdata[33]} {m_axis_dout_tdata[34]} {m_axis_dout_tdata[35]} {m_axis_dout_tdata[36]} {m_axis_dout_tdata[37]} {m_axis_dout_tdata[38]} {m_axis_dout_tdata[39]} {m_axis_dout_tdata[40]} {m_axis_dout_tdata[41]} {m_axis_dout_tdata[42]} {m_axis_dout_tdata[43]} {m_axis_dout_tdata[44]} {m_axis_dout_tdata[45]} {m_axis_dout_tdata[46]} {m_axis_dout_tdata[47]} {m_axis_dout_tdata[48]} {m_axis_dout_tdata[49]} {m_axis_dout_tdata[50]} {m_axis_dout_tdata[51]} {m_axis_dout_tdata[52]} {m_axis_dout_tdata[53]} {m_axis_dout_tdata[54]} {m_axis_dout_tdata[55]} {m_axis_dout_tdata[56]} {m_axis_dout_tdata[57]} {m_axis_dout_tdata[58]} {m_axis_dout_tdata[59]} {m_axis_dout_tdata[60]} {m_axis_dout_tdata[61]} {m_axis_dout_tdata[62]} {m_axis_dout_tdata[63]} {m_axis_dout_tdata[64]} {m_axis_dout_tdata[65]} {m_axis_dout_tdata[66]} {m_axis_dout_tdata[67]} {m_axis_dout_tdata[68]} {m_axis_dout_tdata[69]} {m_axis_dout_tdata[70]} {m_axis_dout_tdata[71]} {m_axis_dout_tdata[72]} {m_axis_dout_tdata[73]} {m_axis_dout_tdata[74]} {m_axis_dout_tdata[75]} {m_axis_dout_tdata[76]} {m_axis_dout_tdata[77]} {m_axis_dout_tdata[78]} {m_axis_dout_tdata[79]} {m_axis_dout_tdata[80]} {m_axis_dout_tdata[81]} {m_axis_dout_tdata[82]} {m_axis_dout_tdata[83]} {m_axis_dout_tdata[84]} {m_axis_dout_tdata[85]} {m_axis_dout_tdata[86]} {m_axis_dout_tdata[87]} {m_axis_dout_tdata[88]} {m_axis_dout_tdata[89]} {m_axis_dout_tdata[90]} {m_axis_dout_tdata[91]} {m_axis_dout_tdata[92]} {m_axis_dout_tdata[93]} {m_axis_dout_tdata[94]} {m_axis_dout_tdata[95]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 16 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {rx_frame_index[0]} {rx_frame_index[1]} {rx_frame_index[2]} {rx_frame_index[3]} {rx_frame_index[4]} {rx_frame_index[5]} {rx_frame_index[6]} {rx_frame_index[7]} {rx_frame_index[8]} {rx_frame_index[9]} {rx_frame_index[10]} {rx_frame_index[11]} {rx_frame_index[12]} {rx_frame_index[13]} {rx_frame_index[14]} {rx_frame_index[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 16 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {rx_frame_in_block[0]} {rx_frame_in_block[1]} {rx_frame_in_block[2]} {rx_frame_in_block[3]} {rx_frame_in_block[4]} {rx_frame_in_block[5]} {rx_frame_in_block[6]} {rx_frame_in_block[7]} {rx_frame_in_block[8]} {rx_frame_in_block[9]} {rx_frame_in_block[10]} {rx_frame_in_block[11]} {rx_frame_in_block[12]} {rx_frame_in_block[13]} {rx_frame_in_block[14]} {rx_frame_in_block[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 16 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {mask_cnt[0]} {mask_cnt[1]} {mask_cnt[2]} {mask_cnt[3]} {mask_cnt[4]} {mask_cnt[5]} {mask_cnt[6]} {mask_cnt[7]} {mask_cnt[8]} {mask_cnt[9]} {mask_cnt[10]} {mask_cnt[11]} {mask_cnt[12]} {mask_cnt[13]} {mask_cnt[14]} {mask_cnt[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 8 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {rx_data_idx[0]} {rx_data_idx[1]} {rx_data_idx[2]} {rx_data_idx[3]} {rx_data_idx[4]} {rx_data_idx[5]} {rx_data_idx[6]} {rx_data_idx[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 8 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {prbs_err_vec[0]} {prbs_err_vec[1]} {prbs_err_vec[2]} {prbs_err_vec[3]} {prbs_err_vec[4]} {prbs_err_vec[5]} {prbs_err_vec[6]} {prbs_err_vec[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 8 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {src_data[0]} {src_data[1]} {src_data[2]} {src_data[3]} {src_data[4]} {src_data[5]} {src_data[6]} {src_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 32 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {ber_q32_reg[0]} {ber_q32_reg[1]} {ber_q32_reg[2]} {ber_q32_reg[3]} {ber_q32_reg[4]} {ber_q32_reg[5]} {ber_q32_reg[6]} {ber_q32_reg[7]} {ber_q32_reg[8]} {ber_q32_reg[9]} {ber_q32_reg[10]} {ber_q32_reg[11]} {ber_q32_reg[12]} {ber_q32_reg[13]} {ber_q32_reg[14]} {ber_q32_reg[15]} {ber_q32_reg[16]} {ber_q32_reg[17]} {ber_q32_reg[18]} {ber_q32_reg[19]} {ber_q32_reg[20]} {ber_q32_reg[21]} {ber_q32_reg[22]} {ber_q32_reg[23]} {ber_q32_reg[24]} {ber_q32_reg[25]} {ber_q32_reg[26]} {ber_q32_reg[27]} {ber_q32_reg[28]} {ber_q32_reg[29]} {ber_q32_reg[30]} {ber_q32_reg[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 64 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {total_bits_cnt[0]} {total_bits_cnt[1]} {total_bits_cnt[2]} {total_bits_cnt[3]} {total_bits_cnt[4]} {total_bits_cnt[5]} {total_bits_cnt[6]} {total_bits_cnt[7]} {total_bits_cnt[8]} {total_bits_cnt[9]} {total_bits_cnt[10]} {total_bits_cnt[11]} {total_bits_cnt[12]} {total_bits_cnt[13]} {total_bits_cnt[14]} {total_bits_cnt[15]} {total_bits_cnt[16]} {total_bits_cnt[17]} {total_bits_cnt[18]} {total_bits_cnt[19]} {total_bits_cnt[20]} {total_bits_cnt[21]} {total_bits_cnt[22]} {total_bits_cnt[23]} {total_bits_cnt[24]} {total_bits_cnt[25]} {total_bits_cnt[26]} {total_bits_cnt[27]} {total_bits_cnt[28]} {total_bits_cnt[29]} {total_bits_cnt[30]} {total_bits_cnt[31]} {total_bits_cnt[32]} {total_bits_cnt[33]} {total_bits_cnt[34]} {total_bits_cnt[35]} {total_bits_cnt[36]} {total_bits_cnt[37]} {total_bits_cnt[38]} {total_bits_cnt[39]} {total_bits_cnt[40]} {total_bits_cnt[41]} {total_bits_cnt[42]} {total_bits_cnt[43]} {total_bits_cnt[44]} {total_bits_cnt[45]} {total_bits_cnt[46]} {total_bits_cnt[47]} {total_bits_cnt[48]} {total_bits_cnt[49]} {total_bits_cnt[50]} {total_bits_cnt[51]} {total_bits_cnt[52]} {total_bits_cnt[53]} {total_bits_cnt[54]} {total_bits_cnt[55]} {total_bits_cnt[56]} {total_bits_cnt[57]} {total_bits_cnt[58]} {total_bits_cnt[59]} {total_bits_cnt[60]} {total_bits_cnt[61]} {total_bits_cnt[62]} {total_bits_cnt[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 64 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {total_err_cnt[0]} {total_err_cnt[1]} {total_err_cnt[2]} {total_err_cnt[3]} {total_err_cnt[4]} {total_err_cnt[5]} {total_err_cnt[6]} {total_err_cnt[7]} {total_err_cnt[8]} {total_err_cnt[9]} {total_err_cnt[10]} {total_err_cnt[11]} {total_err_cnt[12]} {total_err_cnt[13]} {total_err_cnt[14]} {total_err_cnt[15]} {total_err_cnt[16]} {total_err_cnt[17]} {total_err_cnt[18]} {total_err_cnt[19]} {total_err_cnt[20]} {total_err_cnt[21]} {total_err_cnt[22]} {total_err_cnt[23]} {total_err_cnt[24]} {total_err_cnt[25]} {total_err_cnt[26]} {total_err_cnt[27]} {total_err_cnt[28]} {total_err_cnt[29]} {total_err_cnt[30]} {total_err_cnt[31]} {total_err_cnt[32]} {total_err_cnt[33]} {total_err_cnt[34]} {total_err_cnt[35]} {total_err_cnt[36]} {total_err_cnt[37]} {total_err_cnt[38]} {total_err_cnt[39]} {total_err_cnt[40]} {total_err_cnt[41]} {total_err_cnt[42]} {total_err_cnt[43]} {total_err_cnt[44]} {total_err_cnt[45]} {total_err_cnt[46]} {total_err_cnt[47]} {total_err_cnt[48]} {total_err_cnt[49]} {total_err_cnt[50]} {total_err_cnt[51]} {total_err_cnt[52]} {total_err_cnt[53]} {total_err_cnt[54]} {total_err_cnt[55]} {total_err_cnt[56]} {total_err_cnt[57]} {total_err_cnt[58]} {total_err_cnt[59]} {total_err_cnt[60]} {total_err_cnt[61]} {total_err_cnt[62]} {total_err_cnt[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 32 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {good_cnt[0]} {good_cnt[1]} {good_cnt[2]} {good_cnt[3]} {good_cnt[4]} {good_cnt[5]} {good_cnt[6]} {good_cnt[7]} {good_cnt[8]} {good_cnt[9]} {good_cnt[10]} {good_cnt[11]} {good_cnt[12]} {good_cnt[13]} {good_cnt[14]} {good_cnt[15]} {good_cnt[16]} {good_cnt[17]} {good_cnt[18]} {good_cnt[19]} {good_cnt[20]} {good_cnt[21]} {good_cnt[22]} {good_cnt[23]} {good_cnt[24]} {good_cnt[25]} {good_cnt[26]} {good_cnt[27]} {good_cnt[28]} {good_cnt[29]} {good_cnt[30]} {good_cnt[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 8 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {u_fec_rx/deintlv_data[0]} {u_fec_rx/deintlv_data[1]} {u_fec_rx/deintlv_data[2]} {u_fec_rx/deintlv_data[3]} {u_fec_rx/deintlv_data[4]} {u_fec_rx/deintlv_data[5]} {u_fec_rx/deintlv_data[6]} {u_fec_rx/deintlv_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 33 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {u_fec_rx/fifo_s_tdata[0]} {u_fec_rx/fifo_s_tdata[1]} {u_fec_rx/fifo_s_tdata[2]} {u_fec_rx/fifo_s_tdata[3]} {u_fec_rx/fifo_s_tdata[4]} {u_fec_rx/fifo_s_tdata[5]} {u_fec_rx/fifo_s_tdata[6]} {u_fec_rx/fifo_s_tdata[7]} {u_fec_rx/fifo_s_tdata[8]} {u_fec_rx/fifo_s_tdata[9]} {u_fec_rx/fifo_s_tdata[10]} {u_fec_rx/fifo_s_tdata[11]} {u_fec_rx/fifo_s_tdata[12]} {u_fec_rx/fifo_s_tdata[13]} {u_fec_rx/fifo_s_tdata[14]} {u_fec_rx/fifo_s_tdata[15]} {u_fec_rx/fifo_s_tdata[16]} {u_fec_rx/fifo_s_tdata[17]} {u_fec_rx/fifo_s_tdata[18]} {u_fec_rx/fifo_s_tdata[19]} {u_fec_rx/fifo_s_tdata[20]} {u_fec_rx/fifo_s_tdata[21]} {u_fec_rx/fifo_s_tdata[22]} {u_fec_rx/fifo_s_tdata[23]} {u_fec_rx/fifo_s_tdata[24]} {u_fec_rx/fifo_s_tdata[25]} {u_fec_rx/fifo_s_tdata[26]} {u_fec_rx/fifo_s_tdata[27]} {u_fec_rx/fifo_s_tdata[28]} {u_fec_rx/fifo_s_tdata[29]} {u_fec_rx/fifo_s_tdata[30]} {u_fec_rx/fifo_s_tdata[31]} {u_fec_rx/fifo_s_tdata[32]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 33 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {u_fec_rx/fifo_m_tdata[0]} {u_fec_rx/fifo_m_tdata[1]} {u_fec_rx/fifo_m_tdata[2]} {u_fec_rx/fifo_m_tdata[3]} {u_fec_rx/fifo_m_tdata[4]} {u_fec_rx/fifo_m_tdata[5]} {u_fec_rx/fifo_m_tdata[6]} {u_fec_rx/fifo_m_tdata[7]} {u_fec_rx/fifo_m_tdata[8]} {u_fec_rx/fifo_m_tdata[9]} {u_fec_rx/fifo_m_tdata[10]} {u_fec_rx/fifo_m_tdata[11]} {u_fec_rx/fifo_m_tdata[12]} {u_fec_rx/fifo_m_tdata[13]} {u_fec_rx/fifo_m_tdata[14]} {u_fec_rx/fifo_m_tdata[15]} {u_fec_rx/fifo_m_tdata[16]} {u_fec_rx/fifo_m_tdata[17]} {u_fec_rx/fifo_m_tdata[18]} {u_fec_rx/fifo_m_tdata[19]} {u_fec_rx/fifo_m_tdata[20]} {u_fec_rx/fifo_m_tdata[21]} {u_fec_rx/fifo_m_tdata[22]} {u_fec_rx/fifo_m_tdata[23]} {u_fec_rx/fifo_m_tdata[24]} {u_fec_rx/fifo_m_tdata[25]} {u_fec_rx/fifo_m_tdata[26]} {u_fec_rx/fifo_m_tdata[27]} {u_fec_rx/fifo_m_tdata[28]} {u_fec_rx/fifo_m_tdata[29]} {u_fec_rx/fifo_m_tdata[30]} {u_fec_rx/fifo_m_tdata[31]} {u_fec_rx/fifo_m_tdata[32]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 8 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {u_fec_rx/gb8_data[0]} {u_fec_rx/gb8_data[1]} {u_fec_rx/gb8_data[2]} {u_fec_rx/gb8_data[3]} {u_fec_rx/gb8_data[4]} {u_fec_rx/gb8_data[5]} {u_fec_rx/gb8_data[6]} {u_fec_rx/gb8_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 8 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {u_fec_rx/dec_data[0]} {u_fec_rx/dec_data[1]} {u_fec_rx/dec_data[2]} {u_fec_rx/dec_data[3]} {u_fec_rx/dec_data[4]} {u_fec_rx/dec_data[5]} {u_fec_rx/dec_data[6]} {u_fec_rx/dec_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 8 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {u_fec_rx/rs_byte_cnt[0]} {u_fec_rx/rs_byte_cnt[1]} {u_fec_rx/rs_byte_cnt[2]} {u_fec_rx/rs_byte_cnt[3]} {u_fec_rx/rs_byte_cnt[4]} {u_fec_rx/rs_byte_cnt[5]} {u_fec_rx/rs_byte_cnt[6]} {u_fec_rx/rs_byte_cnt[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list ber_enable]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list bit_locked]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list u_fec_rx/dec_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list u_fec_rx/deintlv_block_start]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list u_fec_rx/deintlv_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list u_fec_rx/fifo_m_tready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list u_fec_rx/fifo_m_tvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 1 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list u_fec_rx/fifo_s_tready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 1 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list u_fec_rx/fifo_s_tvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 1 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list u_fec_rx/gb8_blk_rst_req]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 1 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list u_fec_rx/gb8_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 1 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list u_fec_rx/gb8_sync_rst]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 1 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list u_fec_rx/gb8_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 1 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list u_fec_rx/gb32_in_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 1 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list m_axis_dout_tvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 1 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list prbs_locked_internal]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
set_property port_width 1 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list prbs_match_fail]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe35]
set_property port_width 1 [get_debug_ports u_ila_0/probe35]
connect_debug_port u_ila_0/probe35 [get_nets [list prbs_match_raw]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe36]
set_property port_width 1 [get_debug_ports u_ila_0/probe36]
connect_debug_port u_ila_0/probe36 [get_nets [list prbs_meas_ok]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe37]
set_property port_width 1 [get_debug_ports u_ila_0/probe37]
connect_debug_port u_ila_0/probe37 [get_nets [list u_fec_rx/rs_fire]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe38]
set_property port_width 1 [get_debug_ports u_ila_0/probe38]
connect_debug_port u_ila_0/probe38 [get_nets [list u_fec_rx/rs_in_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe39]
set_property port_width 1 [get_debug_ports u_ila_0/probe39]
connect_debug_port u_ila_0/probe39 [get_nets [list u_fec_rx/rs_tlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe40]
set_property port_width 1 [get_debug_ports u_ila_0/probe40]
connect_debug_port u_ila_0/probe40 [get_nets [list s_axis_dividend_tready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe41]
set_property port_width 1 [get_debug_ports u_ila_0/probe41]
connect_debug_port u_ila_0/probe41 [get_nets [list s_axis_divisor_tready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe42]
set_property port_width 1 [get_debug_ports u_ila_0/probe42]
connect_debug_port u_ila_0/probe42 [get_nets [list src_valid]]
create_debug_core u_ila_1 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_1]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_1]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_1]
set_property C_DATA_DEPTH 2048 [get_debug_cores u_ila_1]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_1]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_1]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_1]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_1]
set_property port_width 1 [get_debug_ports u_ila_1/clk]
connect_debug_port u_ila_1/clk [get_nets [list u_gth_raw/rx_usr_clk]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe0]
set_property port_width 1 [get_debug_ports u_ila_1/probe0]
connect_debug_port u_ila_1/probe0 [get_nets [list cdr_stable_line]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe1]
set_property port_width 1 [get_debug_ports u_ila_1/probe1]
connect_debug_port u_ila_1/probe1 [get_nets [list rx_active_line]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe2]
set_property port_width 1 [get_debug_ports u_ila_1/probe2]
connect_debug_port u_ila_1/probe2 [get_nets [list rx_word_valid_line]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets core_clk]
