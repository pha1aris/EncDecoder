
################======gth=======##################
# create_clock -name freerun_clk -period 32.000 [get_pins clk_wiz_0/clk_out1]
set_property PACKAGE_PIN L7 [get_ports mgtrefclk0_x1y1_n]
set_property PACKAGE_PIN L8 [get_ports mgtrefclk0_x1y1_p]
# ============Tx Disable Constraints==============
set_property PACKAGE_PIN G13 [get_ports {tx_disable[0]}]
set_property PACKAGE_PIN H12 [get_ports {tx_disable[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {tx_disable[*]}]
# set_property SLEW       SLOW     [get_ports {tx_disable[*]}]

############### ====== sys ===== ###############
set_property PACKAGE_PIN AL8 [get_ports sys_clk_p]
set_property PACKAGE_PIN AL7 [get_ports sys_clk_n]
set_property IOSTANDARD DIFF_SSTL12 [get_ports sys_clk_p]
set_property IOSTANDARD DIFF_SSTL12 [get_ports sys_clk_n]

set_property PACKAGE_PIN AN12 [get_ports sys_rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports sys_rst_n]

##################### led ###########################
# set_property PACKAGE_PIN AM13 [get_ports pl_led1]
# set_property IOSTANDARD LVCMOS33 [get_ports pl_led1]
# set_property PACKAGE_PIN AP12 [get_ports pl_led2]
# set_property IOSTANDARD LVCMOS33 [get_ports pl_led2]
# # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

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
connect_debug_port u_ila_0/probe1 [get_nets [list {prbs_err_bits[0]} {prbs_err_bits[1]} {prbs_err_bits[2]} {prbs_err_bits[3]} {prbs_err_bits[4]} {prbs_err_bits[5]} {prbs_err_bits[6]} {prbs_err_bits[7]} {prbs_err_bits[8]} {prbs_err_bits[9]} {prbs_err_bits[10]} {prbs_err_bits[11]} {prbs_err_bits[12]} {prbs_err_bits[13]} {prbs_err_bits[14]} {prbs_err_bits[15]} {prbs_err_bits[16]} {prbs_err_bits[17]} {prbs_err_bits[18]} {prbs_err_bits[19]} {prbs_err_bits[20]} {prbs_err_bits[21]} {prbs_err_bits[22]} {prbs_err_bits[23]} {prbs_err_bits[24]} {prbs_err_bits[25]} {prbs_err_bits[26]} {prbs_err_bits[27]} {prbs_err_bits[28]} {prbs_err_bits[29]} {prbs_err_bits[30]} {prbs_err_bits[31]} {prbs_err_bits[32]} {prbs_err_bits[33]} {prbs_err_bits[34]} {prbs_err_bits[35]} {prbs_err_bits[36]} {prbs_err_bits[37]} {prbs_err_bits[38]} {prbs_err_bits[39]} {prbs_err_bits[40]} {prbs_err_bits[41]} {prbs_err_bits[42]} {prbs_err_bits[43]} {prbs_err_bits[44]} {prbs_err_bits[45]} {prbs_err_bits[46]} {prbs_err_bits[47]} {prbs_err_bits[48]} {prbs_err_bits[49]} {prbs_err_bits[50]} {prbs_err_bits[51]} {prbs_err_bits[52]} {prbs_err_bits[53]} {prbs_err_bits[54]} {prbs_err_bits[55]} {prbs_err_bits[56]} {prbs_err_bits[57]} {prbs_err_bits[58]} {prbs_err_bits[59]} {prbs_err_bits[60]} {prbs_err_bits[61]} {prbs_err_bits[62]} {prbs_err_bits[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {ber_q32[0]} {ber_q32[1]} {ber_q32[2]} {ber_q32[3]} {ber_q32[4]} {ber_q32[5]} {ber_q32[6]} {ber_q32[7]} {ber_q32[8]} {ber_q32[9]} {ber_q32[10]} {ber_q32[11]} {ber_q32[12]} {ber_q32[13]} {ber_q32[14]} {ber_q32[15]} {ber_q32[16]} {ber_q32[17]} {ber_q32[18]} {ber_q32[19]} {ber_q32[20]} {ber_q32[21]} {ber_q32[22]} {ber_q32[23]} {ber_q32[24]} {ber_q32[25]} {ber_q32[26]} {ber_q32[27]} {ber_q32[28]} {ber_q32[29]} {ber_q32[30]} {ber_q32[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 8 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {fec_rx_data[0]} {fec_rx_data[1]} {fec_rx_data[2]} {fec_rx_data[3]} {fec_rx_data[4]} {fec_rx_data[5]} {fec_rx_data[6]} {fec_rx_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 64 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {prbs_rx_bits[0]} {prbs_rx_bits[1]} {prbs_rx_bits[2]} {prbs_rx_bits[3]} {prbs_rx_bits[4]} {prbs_rx_bits[5]} {prbs_rx_bits[6]} {prbs_rx_bits[7]} {prbs_rx_bits[8]} {prbs_rx_bits[9]} {prbs_rx_bits[10]} {prbs_rx_bits[11]} {prbs_rx_bits[12]} {prbs_rx_bits[13]} {prbs_rx_bits[14]} {prbs_rx_bits[15]} {prbs_rx_bits[16]} {prbs_rx_bits[17]} {prbs_rx_bits[18]} {prbs_rx_bits[19]} {prbs_rx_bits[20]} {prbs_rx_bits[21]} {prbs_rx_bits[22]} {prbs_rx_bits[23]} {prbs_rx_bits[24]} {prbs_rx_bits[25]} {prbs_rx_bits[26]} {prbs_rx_bits[27]} {prbs_rx_bits[28]} {prbs_rx_bits[29]} {prbs_rx_bits[30]} {prbs_rx_bits[31]} {prbs_rx_bits[32]} {prbs_rx_bits[33]} {prbs_rx_bits[34]} {prbs_rx_bits[35]} {prbs_rx_bits[36]} {prbs_rx_bits[37]} {prbs_rx_bits[38]} {prbs_rx_bits[39]} {prbs_rx_bits[40]} {prbs_rx_bits[41]} {prbs_rx_bits[42]} {prbs_rx_bits[43]} {prbs_rx_bits[44]} {prbs_rx_bits[45]} {prbs_rx_bits[46]} {prbs_rx_bits[47]} {prbs_rx_bits[48]} {prbs_rx_bits[49]} {prbs_rx_bits[50]} {prbs_rx_bits[51]} {prbs_rx_bits[52]} {prbs_rx_bits[53]} {prbs_rx_bits[54]} {prbs_rx_bits[55]} {prbs_rx_bits[56]} {prbs_rx_bits[57]} {prbs_rx_bits[58]} {prbs_rx_bits[59]} {prbs_rx_bits[60]} {prbs_rx_bits[61]} {prbs_rx_bits[62]} {prbs_rx_bits[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list err_detect_reg]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list fec_rx_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list prbs_lock_reg]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list prbs_tx_ready]]
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
connect_debug_port u_ila_1/probe0 [get_nets [list {fec_tx_data_line[0]} {fec_tx_data_line[1]} {fec_tx_data_line[2]} {fec_tx_data_line[3]} {fec_tx_data_line[4]} {fec_tx_data_line[5]} {fec_tx_data_line[6]} {fec_tx_data_line[7]} {fec_tx_data_line[8]} {fec_tx_data_line[9]} {fec_tx_data_line[10]} {fec_tx_data_line[11]} {fec_tx_data_line[12]} {fec_tx_data_line[13]} {fec_tx_data_line[14]} {fec_tx_data_line[15]} {fec_tx_data_line[16]} {fec_tx_data_line[17]} {fec_tx_data_line[18]} {fec_tx_data_line[19]} {fec_tx_data_line[20]} {fec_tx_data_line[21]} {fec_tx_data_line[22]} {fec_tx_data_line[23]} {fec_tx_data_line[24]} {fec_tx_data_line[25]} {fec_tx_data_line[26]} {fec_tx_data_line[27]} {fec_tx_data_line[28]} {fec_tx_data_line[29]} {fec_tx_data_line[30]} {fec_tx_data_line[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe1]
set_property port_width 8 [get_debug_ports u_ila_1/probe1]
connect_debug_port u_ila_1/probe1 [get_nets [list {prbs_tx_data[0]} {prbs_tx_data[1]} {prbs_tx_data[2]} {prbs_tx_data[3]} {prbs_tx_data[4]} {prbs_tx_data[5]} {prbs_tx_data[6]} {prbs_tx_data[7]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe2]
set_property port_width 32 [get_debug_ports u_ila_1/probe2]
connect_debug_port u_ila_1/probe2 [get_nets [list {tx_data_to_gth[0]} {tx_data_to_gth[1]} {tx_data_to_gth[2]} {tx_data_to_gth[3]} {tx_data_to_gth[4]} {tx_data_to_gth[5]} {tx_data_to_gth[6]} {tx_data_to_gth[7]} {tx_data_to_gth[8]} {tx_data_to_gth[9]} {tx_data_to_gth[10]} {tx_data_to_gth[11]} {tx_data_to_gth[12]} {tx_data_to_gth[13]} {tx_data_to_gth[14]} {tx_data_to_gth[15]} {tx_data_to_gth[16]} {tx_data_to_gth[17]} {tx_data_to_gth[18]} {tx_data_to_gth[19]} {tx_data_to_gth[20]} {tx_data_to_gth[21]} {tx_data_to_gth[22]} {tx_data_to_gth[23]} {tx_data_to_gth[24]} {tx_data_to_gth[25]} {tx_data_to_gth[26]} {tx_data_to_gth[27]} {tx_data_to_gth[28]} {tx_data_to_gth[29]} {tx_data_to_gth[30]} {tx_data_to_gth[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe3]
set_property port_width 1 [get_debug_ports u_ila_1/probe3]
connect_debug_port u_ila_1/probe3 [get_nets [list fec_tx_valid_line]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe4]
set_property port_width 1 [get_debug_ports u_ila_1/probe4]
connect_debug_port u_ila_1/probe4 [get_nets [list tx_active]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe5]
set_property port_width 1 [get_debug_ports u_ila_1/probe5]
connect_debug_port u_ila_1/probe5 [get_nets [list tx_done]]
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
connect_debug_port u_ila_2/probe2 [get_nets [list rx_active]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe3]
set_property port_width 1 [get_debug_ports u_ila_2/probe3]
connect_debug_port u_ila_2/probe3 [get_nets [list rx_done]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe4]
set_property port_width 1 [get_debug_ports u_ila_2/probe4]
connect_debug_port u_ila_2/probe4 [get_nets [list rx_slide_req]]
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
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets core_clk]
