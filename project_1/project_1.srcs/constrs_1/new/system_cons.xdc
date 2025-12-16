################====== GTH =======##################
# GTH reference clock
set_property PACKAGE_PIN L7 [get_ports mgtrefclk0_x1y1_n]
set_property PACKAGE_PIN L8 [get_ports mgtrefclk0_x1y1_p]

# Tx Disable Constraints
set_property PACKAGE_PIN G13 [get_ports {tx_disable[0]}]
set_property PACKAGE_PIN H12 [get_ports {tx_disable[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {tx_disable[*]}]
# set_property SLEW SLOW [get_ports {tx_disable[*]}]

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
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list u_clk_wiz/inst/clk_out2]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 16 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {tx_frame_index[0]} {tx_frame_index[1]} {tx_frame_index[2]} {tx_frame_index[3]} {tx_frame_index[4]} {tx_frame_index[5]} {tx_frame_index[6]} {tx_frame_index[7]} {tx_frame_index[8]} {tx_frame_index[9]} {tx_frame_index[10]} {tx_frame_index[11]} {tx_frame_index[12]} {tx_frame_index[13]} {tx_frame_index[14]} {tx_frame_index[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 64 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {total_bits_cnt[0]} {total_bits_cnt[1]} {total_bits_cnt[2]} {total_bits_cnt[3]} {total_bits_cnt[4]} {total_bits_cnt[5]} {total_bits_cnt[6]} {total_bits_cnt[7]} {total_bits_cnt[8]} {total_bits_cnt[9]} {total_bits_cnt[10]} {total_bits_cnt[11]} {total_bits_cnt[12]} {total_bits_cnt[13]} {total_bits_cnt[14]} {total_bits_cnt[15]} {total_bits_cnt[16]} {total_bits_cnt[17]} {total_bits_cnt[18]} {total_bits_cnt[19]} {total_bits_cnt[20]} {total_bits_cnt[21]} {total_bits_cnt[22]} {total_bits_cnt[23]} {total_bits_cnt[24]} {total_bits_cnt[25]} {total_bits_cnt[26]} {total_bits_cnt[27]} {total_bits_cnt[28]} {total_bits_cnt[29]} {total_bits_cnt[30]} {total_bits_cnt[31]} {total_bits_cnt[32]} {total_bits_cnt[33]} {total_bits_cnt[34]} {total_bits_cnt[35]} {total_bits_cnt[36]} {total_bits_cnt[37]} {total_bits_cnt[38]} {total_bits_cnt[39]} {total_bits_cnt[40]} {total_bits_cnt[41]} {total_bits_cnt[42]} {total_bits_cnt[43]} {total_bits_cnt[44]} {total_bits_cnt[45]} {total_bits_cnt[46]} {total_bits_cnt[47]} {total_bits_cnt[48]} {total_bits_cnt[49]} {total_bits_cnt[50]} {total_bits_cnt[51]} {total_bits_cnt[52]} {total_bits_cnt[53]} {total_bits_cnt[54]} {total_bits_cnt[55]} {total_bits_cnt[56]} {total_bits_cnt[57]} {total_bits_cnt[58]} {total_bits_cnt[59]} {total_bits_cnt[60]} {total_bits_cnt[61]} {total_bits_cnt[62]} {total_bits_cnt[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 8 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {prbs_err_vec[0]} {prbs_err_vec[1]} {prbs_err_vec[2]} {prbs_err_vec[3]} {prbs_err_vec[4]} {prbs_err_vec[5]} {prbs_err_vec[6]} {prbs_err_vec[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 8 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {src_data[0]} {src_data[1]} {src_data[2]} {src_data[3]} {src_data[4]} {src_data[5]} {src_data[6]} {src_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 64 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {total_err_cnt[0]} {total_err_cnt[1]} {total_err_cnt[2]} {total_err_cnt[3]} {total_err_cnt[4]} {total_err_cnt[5]} {total_err_cnt[6]} {total_err_cnt[7]} {total_err_cnt[8]} {total_err_cnt[9]} {total_err_cnt[10]} {total_err_cnt[11]} {total_err_cnt[12]} {total_err_cnt[13]} {total_err_cnt[14]} {total_err_cnt[15]} {total_err_cnt[16]} {total_err_cnt[17]} {total_err_cnt[18]} {total_err_cnt[19]} {total_err_cnt[20]} {total_err_cnt[21]} {total_err_cnt[22]} {total_err_cnt[23]} {total_err_cnt[24]} {total_err_cnt[25]} {total_err_cnt[26]} {total_err_cnt[27]} {total_err_cnt[28]} {total_err_cnt[29]} {total_err_cnt[30]} {total_err_cnt[31]} {total_err_cnt[32]} {total_err_cnt[33]} {total_err_cnt[34]} {total_err_cnt[35]} {total_err_cnt[36]} {total_err_cnt[37]} {total_err_cnt[38]} {total_err_cnt[39]} {total_err_cnt[40]} {total_err_cnt[41]} {total_err_cnt[42]} {total_err_cnt[43]} {total_err_cnt[44]} {total_err_cnt[45]} {total_err_cnt[46]} {total_err_cnt[47]} {total_err_cnt[48]} {total_err_cnt[49]} {total_err_cnt[50]} {total_err_cnt[51]} {total_err_cnt[52]} {total_err_cnt[53]} {total_err_cnt[54]} {total_err_cnt[55]} {total_err_cnt[56]} {total_err_cnt[57]} {total_err_cnt[58]} {total_err_cnt[59]} {total_err_cnt[60]} {total_err_cnt[61]} {total_err_cnt[62]} {total_err_cnt[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 96 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {m_axis_dout_tdata[0]} {m_axis_dout_tdata[1]} {m_axis_dout_tdata[2]} {m_axis_dout_tdata[3]} {m_axis_dout_tdata[4]} {m_axis_dout_tdata[5]} {m_axis_dout_tdata[6]} {m_axis_dout_tdata[7]} {m_axis_dout_tdata[8]} {m_axis_dout_tdata[9]} {m_axis_dout_tdata[10]} {m_axis_dout_tdata[11]} {m_axis_dout_tdata[12]} {m_axis_dout_tdata[13]} {m_axis_dout_tdata[14]} {m_axis_dout_tdata[15]} {m_axis_dout_tdata[16]} {m_axis_dout_tdata[17]} {m_axis_dout_tdata[18]} {m_axis_dout_tdata[19]} {m_axis_dout_tdata[20]} {m_axis_dout_tdata[21]} {m_axis_dout_tdata[22]} {m_axis_dout_tdata[23]} {m_axis_dout_tdata[24]} {m_axis_dout_tdata[25]} {m_axis_dout_tdata[26]} {m_axis_dout_tdata[27]} {m_axis_dout_tdata[28]} {m_axis_dout_tdata[29]} {m_axis_dout_tdata[30]} {m_axis_dout_tdata[31]} {m_axis_dout_tdata[32]} {m_axis_dout_tdata[33]} {m_axis_dout_tdata[34]} {m_axis_dout_tdata[35]} {m_axis_dout_tdata[36]} {m_axis_dout_tdata[37]} {m_axis_dout_tdata[38]} {m_axis_dout_tdata[39]} {m_axis_dout_tdata[40]} {m_axis_dout_tdata[41]} {m_axis_dout_tdata[42]} {m_axis_dout_tdata[43]} {m_axis_dout_tdata[44]} {m_axis_dout_tdata[45]} {m_axis_dout_tdata[46]} {m_axis_dout_tdata[47]} {m_axis_dout_tdata[48]} {m_axis_dout_tdata[49]} {m_axis_dout_tdata[50]} {m_axis_dout_tdata[51]} {m_axis_dout_tdata[52]} {m_axis_dout_tdata[53]} {m_axis_dout_tdata[54]} {m_axis_dout_tdata[55]} {m_axis_dout_tdata[56]} {m_axis_dout_tdata[57]} {m_axis_dout_tdata[58]} {m_axis_dout_tdata[59]} {m_axis_dout_tdata[60]} {m_axis_dout_tdata[61]} {m_axis_dout_tdata[62]} {m_axis_dout_tdata[63]} {m_axis_dout_tdata[64]} {m_axis_dout_tdata[65]} {m_axis_dout_tdata[66]} {m_axis_dout_tdata[67]} {m_axis_dout_tdata[68]} {m_axis_dout_tdata[69]} {m_axis_dout_tdata[70]} {m_axis_dout_tdata[71]} {m_axis_dout_tdata[72]} {m_axis_dout_tdata[73]} {m_axis_dout_tdata[74]} {m_axis_dout_tdata[75]} {m_axis_dout_tdata[76]} {m_axis_dout_tdata[77]} {m_axis_dout_tdata[78]} {m_axis_dout_tdata[79]} {m_axis_dout_tdata[80]} {m_axis_dout_tdata[81]} {m_axis_dout_tdata[82]} {m_axis_dout_tdata[83]} {m_axis_dout_tdata[84]} {m_axis_dout_tdata[85]} {m_axis_dout_tdata[86]} {m_axis_dout_tdata[87]} {m_axis_dout_tdata[88]} {m_axis_dout_tdata[89]} {m_axis_dout_tdata[90]} {m_axis_dout_tdata[91]} {m_axis_dout_tdata[92]} {m_axis_dout_tdata[93]} {m_axis_dout_tdata[94]} {m_axis_dout_tdata[95]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 8 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {prbs_tx_data[0]} {prbs_tx_data[1]} {prbs_tx_data[2]} {prbs_tx_data[3]} {prbs_tx_data[4]} {prbs_tx_data[5]} {prbs_tx_data[6]} {prbs_tx_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 32 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {good_cnt[0]} {good_cnt[1]} {good_cnt[2]} {good_cnt[3]} {good_cnt[4]} {good_cnt[5]} {good_cnt[6]} {good_cnt[7]} {good_cnt[8]} {good_cnt[9]} {good_cnt[10]} {good_cnt[11]} {good_cnt[12]} {good_cnt[13]} {good_cnt[14]} {good_cnt[15]} {good_cnt[16]} {good_cnt[17]} {good_cnt[18]} {good_cnt[19]} {good_cnt[20]} {good_cnt[21]} {good_cnt[22]} {good_cnt[23]} {good_cnt[24]} {good_cnt[25]} {good_cnt[26]} {good_cnt[27]} {good_cnt[28]} {good_cnt[29]} {good_cnt[30]} {good_cnt[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 16 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {mask_cnt[0]} {mask_cnt[1]} {mask_cnt[2]} {mask_cnt[3]} {mask_cnt[4]} {mask_cnt[5]} {mask_cnt[6]} {mask_cnt[7]} {mask_cnt[8]} {mask_cnt[9]} {mask_cnt[10]} {mask_cnt[11]} {mask_cnt[12]} {mask_cnt[13]} {mask_cnt[14]} {mask_cnt[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 32 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {rx_cnt_word[0]} {rx_cnt_word[1]} {rx_cnt_word[2]} {rx_cnt_word[3]} {rx_cnt_word[4]} {rx_cnt_word[5]} {rx_cnt_word[6]} {rx_cnt_word[7]} {rx_cnt_word[8]} {rx_cnt_word[9]} {rx_cnt_word[10]} {rx_cnt_word[11]} {rx_cnt_word[12]} {rx_cnt_word[13]} {rx_cnt_word[14]} {rx_cnt_word[15]} {rx_cnt_word[16]} {rx_cnt_word[17]} {rx_cnt_word[18]} {rx_cnt_word[19]} {rx_cnt_word[20]} {rx_cnt_word[21]} {rx_cnt_word[22]} {rx_cnt_word[23]} {rx_cnt_word[24]} {rx_cnt_word[25]} {rx_cnt_word[26]} {rx_cnt_word[27]} {rx_cnt_word[28]} {rx_cnt_word[29]} {rx_cnt_word[30]} {rx_cnt_word[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 8 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {u_fec_rx/rs_byte_cnt[0]} {u_fec_rx/rs_byte_cnt[1]} {u_fec_rx/rs_byte_cnt[2]} {u_fec_rx/rs_byte_cnt[3]} {u_fec_rx/rs_byte_cnt[4]} {u_fec_rx/rs_byte_cnt[5]} {u_fec_rx/rs_byte_cnt[6]} {u_fec_rx/rs_byte_cnt[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 8 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {u_fec_rx/rs_in_data[0]} {u_fec_rx/rs_in_data[1]} {u_fec_rx/rs_in_data[2]} {u_fec_rx/rs_in_data[3]} {u_fec_rx/rs_in_data[4]} {u_fec_rx/rs_in_data[5]} {u_fec_rx/rs_in_data[6]} {u_fec_rx/rs_in_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 8 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {u_fec_rx/deintlv_data[0]} {u_fec_rx/deintlv_data[1]} {u_fec_rx/deintlv_data[2]} {u_fec_rx/deintlv_data[3]} {u_fec_rx/deintlv_data[4]} {u_fec_rx/deintlv_data[5]} {u_fec_rx/deintlv_data[6]} {u_fec_rx/deintlv_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 16 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {u_fec_rx/frame_index_rx[0]} {u_fec_rx/frame_index_rx[1]} {u_fec_rx/frame_index_rx[2]} {u_fec_rx/frame_index_rx[3]} {u_fec_rx/frame_index_rx[4]} {u_fec_rx/frame_index_rx[5]} {u_fec_rx/frame_index_rx[6]} {u_fec_rx/frame_index_rx[7]} {u_fec_rx/frame_index_rx[8]} {u_fec_rx/frame_index_rx[9]} {u_fec_rx/frame_index_rx[10]} {u_fec_rx/frame_index_rx[11]} {u_fec_rx/frame_index_rx[12]} {u_fec_rx/frame_index_rx[13]} {u_fec_rx/frame_index_rx[14]} {u_fec_rx/frame_index_rx[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 16 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {u_fec_rx/frame_in_block_rx[0]} {u_fec_rx/frame_in_block_rx[1]} {u_fec_rx/frame_in_block_rx[2]} {u_fec_rx/frame_in_block_rx[3]} {u_fec_rx/frame_in_block_rx[4]} {u_fec_rx/frame_in_block_rx[5]} {u_fec_rx/frame_in_block_rx[6]} {u_fec_rx/frame_in_block_rx[7]} {u_fec_rx/frame_in_block_rx[8]} {u_fec_rx/frame_in_block_rx[9]} {u_fec_rx/frame_in_block_rx[10]} {u_fec_rx/frame_in_block_rx[11]} {u_fec_rx/frame_in_block_rx[12]} {u_fec_rx/frame_in_block_rx[13]} {u_fec_rx/frame_in_block_rx[14]} {u_fec_rx/frame_in_block_rx[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 16 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {u_fec_rx/block_id_rx[0]} {u_fec_rx/block_id_rx[1]} {u_fec_rx/block_id_rx[2]} {u_fec_rx/block_id_rx[3]} {u_fec_rx/block_id_rx[4]} {u_fec_rx/block_id_rx[5]} {u_fec_rx/block_id_rx[6]} {u_fec_rx/block_id_rx[7]} {u_fec_rx/block_id_rx[8]} {u_fec_rx/block_id_rx[9]} {u_fec_rx/block_id_rx[10]} {u_fec_rx/block_id_rx[11]} {u_fec_rx/block_id_rx[12]} {u_fec_rx/block_id_rx[13]} {u_fec_rx/block_id_rx[14]} {u_fec_rx/block_id_rx[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 8 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {u_fec_rx/dec_data[0]} {u_fec_rx/dec_data[1]} {u_fec_rx/dec_data[2]} {u_fec_rx/dec_data[3]} {u_fec_rx/dec_data[4]} {u_fec_rx/dec_data[5]} {u_fec_rx/dec_data[6]} {u_fec_rx/dec_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 8 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {u_fec_rx/gb8_data[0]} {u_fec_rx/gb8_data[1]} {u_fec_rx/gb8_data[2]} {u_fec_rx/gb8_data[3]} {u_fec_rx/gb8_data[4]} {u_fec_rx/gb8_data[5]} {u_fec_rx/gb8_data[6]} {u_fec_rx/gb8_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 32 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {u_fec_rx/rx_payload_data[0]} {u_fec_rx/rx_payload_data[1]} {u_fec_rx/rx_payload_data[2]} {u_fec_rx/rx_payload_data[3]} {u_fec_rx/rx_payload_data[4]} {u_fec_rx/rx_payload_data[5]} {u_fec_rx/rx_payload_data[6]} {u_fec_rx/rx_payload_data[7]} {u_fec_rx/rx_payload_data[8]} {u_fec_rx/rx_payload_data[9]} {u_fec_rx/rx_payload_data[10]} {u_fec_rx/rx_payload_data[11]} {u_fec_rx/rx_payload_data[12]} {u_fec_rx/rx_payload_data[13]} {u_fec_rx/rx_payload_data[14]} {u_fec_rx/rx_payload_data[15]} {u_fec_rx/rx_payload_data[16]} {u_fec_rx/rx_payload_data[17]} {u_fec_rx/rx_payload_data[18]} {u_fec_rx/rx_payload_data[19]} {u_fec_rx/rx_payload_data[20]} {u_fec_rx/rx_payload_data[21]} {u_fec_rx/rx_payload_data[22]} {u_fec_rx/rx_payload_data[23]} {u_fec_rx/rx_payload_data[24]} {u_fec_rx/rx_payload_data[25]} {u_fec_rx/rx_payload_data[26]} {u_fec_rx/rx_payload_data[27]} {u_fec_rx/rx_payload_data[28]} {u_fec_rx/rx_payload_data[29]} {u_fec_rx/rx_payload_data[30]} {u_fec_rx/rx_payload_data[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 32 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {cnt_bad_word_cnt[0]} {cnt_bad_word_cnt[1]} {cnt_bad_word_cnt[2]} {cnt_bad_word_cnt[3]} {cnt_bad_word_cnt[4]} {cnt_bad_word_cnt[5]} {cnt_bad_word_cnt[6]} {cnt_bad_word_cnt[7]} {cnt_bad_word_cnt[8]} {cnt_bad_word_cnt[9]} {cnt_bad_word_cnt[10]} {cnt_bad_word_cnt[11]} {cnt_bad_word_cnt[12]} {cnt_bad_word_cnt[13]} {cnt_bad_word_cnt[14]} {cnt_bad_word_cnt[15]} {cnt_bad_word_cnt[16]} {cnt_bad_word_cnt[17]} {cnt_bad_word_cnt[18]} {cnt_bad_word_cnt[19]} {cnt_bad_word_cnt[20]} {cnt_bad_word_cnt[21]} {cnt_bad_word_cnt[22]} {cnt_bad_word_cnt[23]} {cnt_bad_word_cnt[24]} {cnt_bad_word_cnt[25]} {cnt_bad_word_cnt[26]} {cnt_bad_word_cnt[27]} {cnt_bad_word_cnt[28]} {cnt_bad_word_cnt[29]} {cnt_bad_word_cnt[30]} {cnt_bad_word_cnt[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 64 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {cnt_total_err_cnt[0]} {cnt_total_err_cnt[1]} {cnt_total_err_cnt[2]} {cnt_total_err_cnt[3]} {cnt_total_err_cnt[4]} {cnt_total_err_cnt[5]} {cnt_total_err_cnt[6]} {cnt_total_err_cnt[7]} {cnt_total_err_cnt[8]} {cnt_total_err_cnt[9]} {cnt_total_err_cnt[10]} {cnt_total_err_cnt[11]} {cnt_total_err_cnt[12]} {cnt_total_err_cnt[13]} {cnt_total_err_cnt[14]} {cnt_total_err_cnt[15]} {cnt_total_err_cnt[16]} {cnt_total_err_cnt[17]} {cnt_total_err_cnt[18]} {cnt_total_err_cnt[19]} {cnt_total_err_cnt[20]} {cnt_total_err_cnt[21]} {cnt_total_err_cnt[22]} {cnt_total_err_cnt[23]} {cnt_total_err_cnt[24]} {cnt_total_err_cnt[25]} {cnt_total_err_cnt[26]} {cnt_total_err_cnt[27]} {cnt_total_err_cnt[28]} {cnt_total_err_cnt[29]} {cnt_total_err_cnt[30]} {cnt_total_err_cnt[31]} {cnt_total_err_cnt[32]} {cnt_total_err_cnt[33]} {cnt_total_err_cnt[34]} {cnt_total_err_cnt[35]} {cnt_total_err_cnt[36]} {cnt_total_err_cnt[37]} {cnt_total_err_cnt[38]} {cnt_total_err_cnt[39]} {cnt_total_err_cnt[40]} {cnt_total_err_cnt[41]} {cnt_total_err_cnt[42]} {cnt_total_err_cnt[43]} {cnt_total_err_cnt[44]} {cnt_total_err_cnt[45]} {cnt_total_err_cnt[46]} {cnt_total_err_cnt[47]} {cnt_total_err_cnt[48]} {cnt_total_err_cnt[49]} {cnt_total_err_cnt[50]} {cnt_total_err_cnt[51]} {cnt_total_err_cnt[52]} {cnt_total_err_cnt[53]} {cnt_total_err_cnt[54]} {cnt_total_err_cnt[55]} {cnt_total_err_cnt[56]} {cnt_total_err_cnt[57]} {cnt_total_err_cnt[58]} {cnt_total_err_cnt[59]} {cnt_total_err_cnt[60]} {cnt_total_err_cnt[61]} {cnt_total_err_cnt[62]} {cnt_total_err_cnt[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 8 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list {fec_rx_data[0]} {fec_rx_data[1]} {fec_rx_data[2]} {fec_rx_data[3]} {fec_rx_data[4]} {fec_rx_data[5]} {fec_rx_data[6]} {fec_rx_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 8 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list {u_fec_tx/enc_data[0]} {u_fec_tx/enc_data[1]} {u_fec_tx/enc_data[2]} {u_fec_tx/enc_data[3]} {u_fec_tx/enc_data[4]} {u_fec_tx/enc_data[5]} {u_fec_tx/enc_data[6]} {u_fec_tx/enc_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 32 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list {ber_q32_reg[0]} {ber_q32_reg[1]} {ber_q32_reg[2]} {ber_q32_reg[3]} {ber_q32_reg[4]} {ber_q32_reg[5]} {ber_q32_reg[6]} {ber_q32_reg[7]} {ber_q32_reg[8]} {ber_q32_reg[9]} {ber_q32_reg[10]} {ber_q32_reg[11]} {ber_q32_reg[12]} {ber_q32_reg[13]} {ber_q32_reg[14]} {ber_q32_reg[15]} {ber_q32_reg[16]} {ber_q32_reg[17]} {ber_q32_reg[18]} {ber_q32_reg[19]} {ber_q32_reg[20]} {ber_q32_reg[21]} {ber_q32_reg[22]} {ber_q32_reg[23]} {ber_q32_reg[24]} {ber_q32_reg[25]} {ber_q32_reg[26]} {ber_q32_reg[27]} {ber_q32_reg[28]} {ber_q32_reg[29]} {ber_q32_reg[30]} {ber_q32_reg[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 32 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list {cnt_good_cnt[0]} {cnt_good_cnt[1]} {cnt_good_cnt[2]} {cnt_good_cnt[3]} {cnt_good_cnt[4]} {cnt_good_cnt[5]} {cnt_good_cnt[6]} {cnt_good_cnt[7]} {cnt_good_cnt[8]} {cnt_good_cnt[9]} {cnt_good_cnt[10]} {cnt_good_cnt[11]} {cnt_good_cnt[12]} {cnt_good_cnt[13]} {cnt_good_cnt[14]} {cnt_good_cnt[15]} {cnt_good_cnt[16]} {cnt_good_cnt[17]} {cnt_good_cnt[18]} {cnt_good_cnt[19]} {cnt_good_cnt[20]} {cnt_good_cnt[21]} {cnt_good_cnt[22]} {cnt_good_cnt[23]} {cnt_good_cnt[24]} {cnt_good_cnt[25]} {cnt_good_cnt[26]} {cnt_good_cnt[27]} {cnt_good_cnt[28]} {cnt_good_cnt[29]} {cnt_good_cnt[30]} {cnt_good_cnt[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 12 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list {u_fec_tx/tx_fifo_wrcnt[0]} {u_fec_tx/tx_fifo_wrcnt[1]} {u_fec_tx/tx_fifo_wrcnt[2]} {u_fec_tx/tx_fifo_wrcnt[3]} {u_fec_tx/tx_fifo_wrcnt[4]} {u_fec_tx/tx_fifo_wrcnt[5]} {u_fec_tx/tx_fifo_wrcnt[6]} {u_fec_tx/tx_fifo_wrcnt[7]} {u_fec_tx/tx_fifo_wrcnt[8]} {u_fec_tx/tx_fifo_wrcnt[9]} {u_fec_tx/tx_fifo_wrcnt[10]} {u_fec_tx/tx_fifo_wrcnt[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 8 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list {u_fec_tx/intlv_data[0]} {u_fec_tx/intlv_data[1]} {u_fec_tx/intlv_data[2]} {u_fec_tx/intlv_data[3]} {u_fec_tx/intlv_data[4]} {u_fec_tx/intlv_data[5]} {u_fec_tx/intlv_data[6]} {u_fec_tx/intlv_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 32 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list {u_fec_tx/gb_data[0]} {u_fec_tx/gb_data[1]} {u_fec_tx/gb_data[2]} {u_fec_tx/gb_data[3]} {u_fec_tx/gb_data[4]} {u_fec_tx/gb_data[5]} {u_fec_tx/gb_data[6]} {u_fec_tx/gb_data[7]} {u_fec_tx/gb_data[8]} {u_fec_tx/gb_data[9]} {u_fec_tx/gb_data[10]} {u_fec_tx/gb_data[11]} {u_fec_tx/gb_data[12]} {u_fec_tx/gb_data[13]} {u_fec_tx/gb_data[14]} {u_fec_tx/gb_data[15]} {u_fec_tx/gb_data[16]} {u_fec_tx/gb_data[17]} {u_fec_tx/gb_data[18]} {u_fec_tx/gb_data[19]} {u_fec_tx/gb_data[20]} {u_fec_tx/gb_data[21]} {u_fec_tx/gb_data[22]} {u_fec_tx/gb_data[23]} {u_fec_tx/gb_data[24]} {u_fec_tx/gb_data[25]} {u_fec_tx/gb_data[26]} {u_fec_tx/gb_data[27]} {u_fec_tx/gb_data[28]} {u_fec_tx/gb_data[29]} {u_fec_tx/gb_data[30]} {u_fec_tx/gb_data[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 64 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list {cnt_total_bits_cnt[0]} {cnt_total_bits_cnt[1]} {cnt_total_bits_cnt[2]} {cnt_total_bits_cnt[3]} {cnt_total_bits_cnt[4]} {cnt_total_bits_cnt[5]} {cnt_total_bits_cnt[6]} {cnt_total_bits_cnt[7]} {cnt_total_bits_cnt[8]} {cnt_total_bits_cnt[9]} {cnt_total_bits_cnt[10]} {cnt_total_bits_cnt[11]} {cnt_total_bits_cnt[12]} {cnt_total_bits_cnt[13]} {cnt_total_bits_cnt[14]} {cnt_total_bits_cnt[15]} {cnt_total_bits_cnt[16]} {cnt_total_bits_cnt[17]} {cnt_total_bits_cnt[18]} {cnt_total_bits_cnt[19]} {cnt_total_bits_cnt[20]} {cnt_total_bits_cnt[21]} {cnt_total_bits_cnt[22]} {cnt_total_bits_cnt[23]} {cnt_total_bits_cnt[24]} {cnt_total_bits_cnt[25]} {cnt_total_bits_cnt[26]} {cnt_total_bits_cnt[27]} {cnt_total_bits_cnt[28]} {cnt_total_bits_cnt[29]} {cnt_total_bits_cnt[30]} {cnt_total_bits_cnt[31]} {cnt_total_bits_cnt[32]} {cnt_total_bits_cnt[33]} {cnt_total_bits_cnt[34]} {cnt_total_bits_cnt[35]} {cnt_total_bits_cnt[36]} {cnt_total_bits_cnt[37]} {cnt_total_bits_cnt[38]} {cnt_total_bits_cnt[39]} {cnt_total_bits_cnt[40]} {cnt_total_bits_cnt[41]} {cnt_total_bits_cnt[42]} {cnt_total_bits_cnt[43]} {cnt_total_bits_cnt[44]} {cnt_total_bits_cnt[45]} {cnt_total_bits_cnt[46]} {cnt_total_bits_cnt[47]} {cnt_total_bits_cnt[48]} {cnt_total_bits_cnt[49]} {cnt_total_bits_cnt[50]} {cnt_total_bits_cnt[51]} {cnt_total_bits_cnt[52]} {cnt_total_bits_cnt[53]} {cnt_total_bits_cnt[54]} {cnt_total_bits_cnt[55]} {cnt_total_bits_cnt[56]} {cnt_total_bits_cnt[57]} {cnt_total_bits_cnt[58]} {cnt_total_bits_cnt[59]} {cnt_total_bits_cnt[60]} {cnt_total_bits_cnt[61]} {cnt_total_bits_cnt[62]} {cnt_total_bits_cnt[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 16 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list {cnt_mask_cnt[0]} {cnt_mask_cnt[1]} {cnt_mask_cnt[2]} {cnt_mask_cnt[3]} {cnt_mask_cnt[4]} {cnt_mask_cnt[5]} {cnt_mask_cnt[6]} {cnt_mask_cnt[7]} {cnt_mask_cnt[8]} {cnt_mask_cnt[9]} {cnt_mask_cnt[10]} {cnt_mask_cnt[11]} {cnt_mask_cnt[12]} {cnt_mask_cnt[13]} {cnt_mask_cnt[14]} {cnt_mask_cnt[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 1 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list ber_enable]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 1 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list u_fec_rx/blk_soft_rst]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 1 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list cnt_enable]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 1 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list cnt_locked_internal]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
set_property port_width 1 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list cnt_match]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe35]
set_property port_width 1 [get_debug_ports u_ila_0/probe35]
connect_debug_port u_ila_0/probe35 [get_nets [list cnt_mismatch_any]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe36]
set_property port_width 1 [get_debug_ports u_ila_0/probe36]
connect_debug_port u_ila_0/probe36 [get_nets [list cnt_mismatch_locked]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe37]
set_property port_width 1 [get_debug_ports u_ila_0/probe37]
connect_debug_port u_ila_0/probe37 [get_nets [list cnt_seeded]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe38]
set_property port_width 1 [get_debug_ports u_ila_0/probe38]
connect_debug_port u_ila_0/probe38 [get_nets [list u_fec_rx/dec_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe39]
set_property port_width 1 [get_debug_ports u_ila_0/probe39]
connect_debug_port u_ila_0/probe39 [get_nets [list u_fec_rx/deintlv_block_start]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe40]
set_property port_width 1 [get_debug_ports u_ila_0/probe40]
connect_debug_port u_ila_0/probe40 [get_nets [list u_fec_rx/deintlv_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe41]
set_property port_width 1 [get_debug_ports u_ila_0/probe41]
connect_debug_port u_ila_0/probe41 [get_nets [list u_fec_tx/enc_last]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe42]
set_property port_width 1 [get_debug_ports u_ila_0/probe42]
connect_debug_port u_ila_0/probe42 [get_nets [list u_fec_tx/enc_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe43]
set_property port_width 1 [get_debug_ports u_ila_0/probe43]
connect_debug_port u_ila_0/probe43 [get_nets [list fec_rx_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe44]
set_property port_width 1 [get_debug_ports u_ila_0/probe44]
connect_debug_port u_ila_0/probe44 [get_nets [list u_fec_rx/frame_locked]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe45]
set_property port_width 1 [get_debug_ports u_ila_0/probe45]
connect_debug_port u_ila_0/probe45 [get_nets [list u_fec_rx/frame_start]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe46]
set_property port_width 1 [get_debug_ports u_ila_0/probe46]
connect_debug_port u_ila_0/probe46 [get_nets [list u_fec_rx/gb8_sync_rst]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe47]
set_property port_width 1 [get_debug_ports u_ila_0/probe47]
connect_debug_port u_ila_0/probe47 [get_nets [list u_fec_rx/gb8_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe48]
set_property port_width 1 [get_debug_ports u_ila_0/probe48]
connect_debug_port u_ila_0/probe48 [get_nets [list u_fec_tx/gb_block_start]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe49]
set_property port_width 1 [get_debug_ports u_ila_0/probe49]
connect_debug_port u_ila_0/probe49 [get_nets [list u_fec_tx/gb_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe50]
set_property port_width 1 [get_debug_ports u_ila_0/probe50]
connect_debug_port u_ila_0/probe50 [get_nets [list u_fec_tx/gb_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe51]
set_property port_width 1 [get_debug_ports u_ila_0/probe51]
connect_debug_port u_ila_0/probe51 [get_nets [list u_fec_tx/intlv_block_start]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe52]
set_property port_width 1 [get_debug_ports u_ila_0/probe52]
connect_debug_port u_ila_0/probe52 [get_nets [list u_fec_tx/intlv_out_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe53]
set_property port_width 1 [get_debug_ports u_ila_0/probe53]
connect_debug_port u_ila_0/probe53 [get_nets [list u_fec_tx/intlv_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe54]
set_property port_width 1 [get_debug_ports u_ila_0/probe54]
connect_debug_port u_ila_0/probe54 [get_nets [list m_axis_dout_tvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe55]
set_property port_width 1 [get_debug_ports u_ila_0/probe55]
connect_debug_port u_ila_0/probe55 [get_nets [list prbs_locked_internal]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe56]
set_property port_width 1 [get_debug_ports u_ila_0/probe56]
connect_debug_port u_ila_0/probe56 [get_nets [list prbs_match]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe57]
set_property port_width 1 [get_debug_ports u_ila_0/probe57]
connect_debug_port u_ila_0/probe57 [get_nets [list prbs_match_fail]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe58]
set_property port_width 1 [get_debug_ports u_ila_0/probe58]
connect_debug_port u_ila_0/probe58 [get_nets [list prbs_tx_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe59]
set_property port_width 1 [get_debug_ports u_ila_0/probe59]
connect_debug_port u_ila_0/probe59 [get_nets [list u_fec_rx/realign_req]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe60]
set_property port_width 1 [get_debug_ports u_ila_0/probe60]
connect_debug_port u_ila_0/probe60 [get_nets [list u_fec_rx/rs_in_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe61]
set_property port_width 1 [get_debug_ports u_ila_0/probe61]
connect_debug_port u_ila_0/probe61 [get_nets [list u_fec_rx/rs_in_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe62]
set_property port_width 1 [get_debug_ports u_ila_0/probe62]
connect_debug_port u_ila_0/probe62 [get_nets [list u_fec_rx/rs_tlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe63]
set_property port_width 1 [get_debug_ports u_ila_0/probe63]
connect_debug_port u_ila_0/probe63 [get_nets [list rx_cnt_word_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe64]
set_property port_width 1 [get_debug_ports u_ila_0/probe64]
connect_debug_port u_ila_0/probe64 [get_nets [list u_fec_rx/rx_payload_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe65]
set_property port_width 1 [get_debug_ports u_ila_0/probe65]
connect_debug_port u_ila_0/probe65 [get_nets [list s_axis_dividend_tready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe66]
set_property port_width 1 [get_debug_ports u_ila_0/probe66]
connect_debug_port u_ila_0/probe66 [get_nets [list s_axis_divisor_tready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe67]
set_property port_width 1 [get_debug_ports u_ila_0/probe67]
connect_debug_port u_ila_0/probe67 [get_nets [list src_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe68]
set_property port_width 1 [get_debug_ports u_ila_0/probe68]
connect_debug_port u_ila_0/probe68 [get_nets [list test_prbs_sel]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe69]
set_property port_width 1 [get_debug_ports u_ila_0/probe69]
connect_debug_port u_ila_0/probe69 [get_nets [list u_fec_tx/tx32_wr_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe70]
set_property port_width 1 [get_debug_ports u_ila_0/probe70]
connect_debug_port u_ila_0/probe70 [get_nets [list u_fec_tx/tx32_wr_ready_raw]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe71]
set_property port_width 1 [get_debug_ports u_ila_0/probe71]
connect_debug_port u_ila_0/probe71 [get_nets [list tx_pat_hold]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe72]
set_property port_width 1 [get_debug_ports u_ila_0/probe72]
connect_debug_port u_ila_0/probe72 [get_nets [list tx_pat_sw_pulse]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe73]
set_property port_width 1 [get_debug_ports u_ila_0/probe73]
connect_debug_port u_ila_0/probe73 [get_nets [list u_fec_tx/xpm_input_tready]]
create_debug_core u_ila_1 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_1]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_1]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_1]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_1]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_1]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_1]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_1]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_1]
set_property port_width 1 [get_debug_ports u_ila_1/clk]
connect_debug_port u_ila_1/clk [get_nets [list u_gth_raw/o_tx_clk]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe0]
set_property port_width 32 [get_debug_ports u_ila_1/probe0]
connect_debug_port u_ila_1/probe0 [get_nets [list {tx_data_to_gth[0]} {tx_data_to_gth[1]} {tx_data_to_gth[2]} {tx_data_to_gth[3]} {tx_data_to_gth[4]} {tx_data_to_gth[5]} {tx_data_to_gth[6]} {tx_data_to_gth[7]} {tx_data_to_gth[8]} {tx_data_to_gth[9]} {tx_data_to_gth[10]} {tx_data_to_gth[11]} {tx_data_to_gth[12]} {tx_data_to_gth[13]} {tx_data_to_gth[14]} {tx_data_to_gth[15]} {tx_data_to_gth[16]} {tx_data_to_gth[17]} {tx_data_to_gth[18]} {tx_data_to_gth[19]} {tx_data_to_gth[20]} {tx_data_to_gth[21]} {tx_data_to_gth[22]} {tx_data_to_gth[23]} {tx_data_to_gth[24]} {tx_data_to_gth[25]} {tx_data_to_gth[26]} {tx_data_to_gth[27]} {tx_data_to_gth[28]} {tx_data_to_gth[29]} {tx_data_to_gth[30]} {tx_data_to_gth[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe1]
set_property port_width 32 [get_debug_ports u_ila_1/probe1]
connect_debug_port u_ila_1/probe1 [get_nets [list {fec_tx_data_line[0]} {fec_tx_data_line[1]} {fec_tx_data_line[2]} {fec_tx_data_line[3]} {fec_tx_data_line[4]} {fec_tx_data_line[5]} {fec_tx_data_line[6]} {fec_tx_data_line[7]} {fec_tx_data_line[8]} {fec_tx_data_line[9]} {fec_tx_data_line[10]} {fec_tx_data_line[11]} {fec_tx_data_line[12]} {fec_tx_data_line[13]} {fec_tx_data_line[14]} {fec_tx_data_line[15]} {fec_tx_data_line[16]} {fec_tx_data_line[17]} {fec_tx_data_line[18]} {fec_tx_data_line[19]} {fec_tx_data_line[20]} {fec_tx_data_line[21]} {fec_tx_data_line[22]} {fec_tx_data_line[23]} {fec_tx_data_line[24]} {fec_tx_data_line[25]} {fec_tx_data_line[26]} {fec_tx_data_line[27]} {fec_tx_data_line[28]} {fec_tx_data_line[29]} {fec_tx_data_line[30]} {fec_tx_data_line[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe2]
set_property port_width 12 [get_debug_ports u_ila_1/probe2]
connect_debug_port u_ila_1/probe2 [get_nets [list {u_fec_tx/tx_fifo_rdcnt[0]} {u_fec_tx/tx_fifo_rdcnt[1]} {u_fec_tx/tx_fifo_rdcnt[2]} {u_fec_tx/tx_fifo_rdcnt[3]} {u_fec_tx/tx_fifo_rdcnt[4]} {u_fec_tx/tx_fifo_rdcnt[5]} {u_fec_tx/tx_fifo_rdcnt[6]} {u_fec_tx/tx_fifo_rdcnt[7]} {u_fec_tx/tx_fifo_rdcnt[8]} {u_fec_tx/tx_fifo_rdcnt[9]} {u_fec_tx/tx_fifo_rdcnt[10]} {u_fec_tx/tx_fifo_rdcnt[11]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe3]
set_property port_width 32 [get_debug_ports u_ila_1/probe3]
connect_debug_port u_ila_1/probe3 [get_nets [list {u_fec_tx/tx32_fifo_dout[0]} {u_fec_tx/tx32_fifo_dout[1]} {u_fec_tx/tx32_fifo_dout[2]} {u_fec_tx/tx32_fifo_dout[3]} {u_fec_tx/tx32_fifo_dout[4]} {u_fec_tx/tx32_fifo_dout[5]} {u_fec_tx/tx32_fifo_dout[6]} {u_fec_tx/tx32_fifo_dout[7]} {u_fec_tx/tx32_fifo_dout[8]} {u_fec_tx/tx32_fifo_dout[9]} {u_fec_tx/tx32_fifo_dout[10]} {u_fec_tx/tx32_fifo_dout[11]} {u_fec_tx/tx32_fifo_dout[12]} {u_fec_tx/tx32_fifo_dout[13]} {u_fec_tx/tx32_fifo_dout[14]} {u_fec_tx/tx32_fifo_dout[15]} {u_fec_tx/tx32_fifo_dout[16]} {u_fec_tx/tx32_fifo_dout[17]} {u_fec_tx/tx32_fifo_dout[18]} {u_fec_tx/tx32_fifo_dout[19]} {u_fec_tx/tx32_fifo_dout[20]} {u_fec_tx/tx32_fifo_dout[21]} {u_fec_tx/tx32_fifo_dout[22]} {u_fec_tx/tx32_fifo_dout[23]} {u_fec_tx/tx32_fifo_dout[24]} {u_fec_tx/tx32_fifo_dout[25]} {u_fec_tx/tx32_fifo_dout[26]} {u_fec_tx/tx32_fifo_dout[27]} {u_fec_tx/tx32_fifo_dout[28]} {u_fec_tx/tx32_fifo_dout[29]} {u_fec_tx/tx32_fifo_dout[30]} {u_fec_tx/tx32_fifo_dout[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe4]
set_property port_width 1 [get_debug_ports u_ila_1/probe4]
connect_debug_port u_ila_1/probe4 [get_nets [list fec_tx_valid_line]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe5]
set_property port_width 1 [get_debug_ports u_ila_1/probe5]
connect_debug_port u_ila_1/probe5 [get_nets [list u_fec_tx/tx32_fifo_rd_en]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe6]
set_property port_width 1 [get_debug_ports u_ila_1/probe6]
connect_debug_port u_ila_1/probe6 [get_nets [list tx_done]]
create_debug_core u_ila_2 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_2]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_2]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_2]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_2]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_2]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_2]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_2]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_2]
set_property port_width 1 [get_debug_ports u_ila_2/clk]
connect_debug_port u_ila_2/clk [get_nets [list u_gth_raw/o_rx_clk]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe0]
set_property port_width 32 [get_debug_ports u_ila_2/probe0]
connect_debug_port u_ila_2/probe0 [get_nets [list {rx_data_from_gth[0]} {rx_data_from_gth[1]} {rx_data_from_gth[2]} {rx_data_from_gth[3]} {rx_data_from_gth[4]} {rx_data_from_gth[5]} {rx_data_from_gth[6]} {rx_data_from_gth[7]} {rx_data_from_gth[8]} {rx_data_from_gth[9]} {rx_data_from_gth[10]} {rx_data_from_gth[11]} {rx_data_from_gth[12]} {rx_data_from_gth[13]} {rx_data_from_gth[14]} {rx_data_from_gth[15]} {rx_data_from_gth[16]} {rx_data_from_gth[17]} {rx_data_from_gth[18]} {rx_data_from_gth[19]} {rx_data_from_gth[20]} {rx_data_from_gth[21]} {rx_data_from_gth[22]} {rx_data_from_gth[23]} {rx_data_from_gth[24]} {rx_data_from_gth[25]} {rx_data_from_gth[26]} {rx_data_from_gth[27]} {rx_data_from_gth[28]} {rx_data_from_gth[29]} {rx_data_from_gth[30]} {rx_data_from_gth[31]}]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe1]
set_property port_width 1 [get_debug_ports u_ila_2/probe1]
connect_debug_port u_ila_2/probe1 [get_nets [list bit_locked]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe2]
set_property port_width 1 [get_debug_ports u_ila_2/probe2]
connect_debug_port u_ila_2/probe2 [get_nets [list rx_done]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe3]
set_property port_width 1 [get_debug_ports u_ila_2/probe3]
connect_debug_port u_ila_2/probe3 [get_nets [list rx_slide_req]]
create_debug_core u_ila_3 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_3]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_3]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_3]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_3]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_3]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_3]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_3]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_3]
set_property port_width 1 [get_debug_ports u_ila_3/clk]
connect_debug_port u_ila_3/clk [get_nets [list u_clk_wiz/inst/clk_out1]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_3/probe0]
set_property port_width 1 [get_debug_ports u_ila_3/probe0]
connect_debug_port u_ila_3/probe0 [get_nets [list cdr_stable]]
create_debug_port u_ila_3 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_3/probe1]
set_property port_width 1 [get_debug_ports u_ila_3/probe1]
connect_debug_port u_ila_3/probe1 [get_nets [list rx_active]]
create_debug_port u_ila_3 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_3/probe2]
set_property port_width 1 [get_debug_ports u_ila_3/probe2]
connect_debug_port u_ila_3/probe2 [get_nets [list tx_active]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets freerun_clk]
