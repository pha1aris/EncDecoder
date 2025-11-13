
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

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




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
connect_debug_port u_ila_0/clk [get_nets [list {gth_top/u_gt/inst/gen_gtwizard_gthe4_top.gtwizard_ultrascale_1_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_rx_user_clocking_internal.gen_single_instance.gtwiz_userclk_rx_inst/gtwiz_userclk_rx_usrclk2_out[0]}]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {sync_dout[0]} {sync_dout[1]} {sync_dout[2]} {sync_dout[3]} {sync_dout[4]} {sync_dout[5]} {sync_dout[6]} {sync_dout[7]} {sync_dout[8]} {sync_dout[9]} {sync_dout[10]} {sync_dout[11]} {sync_dout[12]} {sync_dout[13]} {sync_dout[14]} {sync_dout[15]} {sync_dout[16]} {sync_dout[17]} {sync_dout[18]} {sync_dout[19]} {sync_dout[20]} {sync_dout[21]} {sync_dout[22]} {sync_dout[23]} {sync_dout[24]} {sync_dout[25]} {sync_dout[26]} {sync_dout[27]} {sync_dout[28]} {sync_dout[29]} {sync_dout[30]} {sync_dout[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {userdata_rx_out[0]} {userdata_rx_out[1]} {userdata_rx_out[2]} {userdata_rx_out[3]} {userdata_rx_out[4]} {userdata_rx_out[5]} {userdata_rx_out[6]} {userdata_rx_out[7]} {userdata_rx_out[8]} {userdata_rx_out[9]} {userdata_rx_out[10]} {userdata_rx_out[11]} {userdata_rx_out[12]} {userdata_rx_out[13]} {userdata_rx_out[14]} {userdata_rx_out[15]} {userdata_rx_out[16]} {userdata_rx_out[17]} {userdata_rx_out[18]} {userdata_rx_out[19]} {userdata_rx_out[20]} {userdata_rx_out[21]} {userdata_rx_out[22]} {userdata_rx_out[23]} {userdata_rx_out[24]} {userdata_rx_out[25]} {userdata_rx_out[26]} {userdata_rx_out[27]} {userdata_rx_out[28]} {userdata_rx_out[29]} {userdata_rx_out[30]} {userdata_rx_out[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 4 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {charisk[0]} {charisk[1]} {charisk[2]} {charisk[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 2 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {u_frame_sync/state[0]} {u_frame_sync/state[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 2 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {u_frame_sync/next_state[0]} {u_frame_sync/next_state[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {data_o[0]} {data_o[1]} {data_o[2]} {data_o[3]} {data_o[4]} {data_o[5]} {data_o[6]} {data_o[7]} {data_o[8]} {data_o[9]} {data_o[10]} {data_o[11]} {data_o[12]} {data_o[13]} {data_o[14]} {data_o[15]} {data_o[16]} {data_o[17]} {data_o[18]} {data_o[19]} {data_o[20]} {data_o[21]} {data_o[22]} {data_o[23]} {data_o[24]} {data_o[25]} {data_o[26]} {data_o[27]} {data_o[28]} {data_o[29]} {data_o[30]} {data_o[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list data_valid_o]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list frame_is_locked]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list gth_top/rx_cdr_stable]]
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
connect_debug_port u_ila_1/clk [get_nets [list {gth_top/u_gt/inst/gen_gtwizard_gthe4_top.gtwizard_ultrascale_1_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_tx_user_clocking_internal.gen_single_instance.gtwiz_userclk_tx_inst/gtwiz_userclk_tx_usrclk2_out[0]}]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe0]
set_property port_width 32 [get_debug_ports u_ila_1/probe0]
connect_debug_port u_ila_1/probe0 [get_nets [list {prbs_data[0]} {prbs_data[1]} {prbs_data[2]} {prbs_data[3]} {prbs_data[4]} {prbs_data[5]} {prbs_data[6]} {prbs_data[7]} {prbs_data[8]} {prbs_data[9]} {prbs_data[10]} {prbs_data[11]} {prbs_data[12]} {prbs_data[13]} {prbs_data[14]} {prbs_data[15]} {prbs_data[16]} {prbs_data[17]} {prbs_data[18]} {prbs_data[19]} {prbs_data[20]} {prbs_data[21]} {prbs_data[22]} {prbs_data[23]} {prbs_data[24]} {prbs_data[25]} {prbs_data[26]} {prbs_data[27]} {prbs_data[28]} {prbs_data[29]} {prbs_data[30]} {prbs_data[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe1]
set_property port_width 32 [get_debug_ports u_ila_1/probe1]
connect_debug_port u_ila_1/probe1 [get_nets [list {framed_tx_data[0]} {framed_tx_data[1]} {framed_tx_data[2]} {framed_tx_data[3]} {framed_tx_data[4]} {framed_tx_data[5]} {framed_tx_data[6]} {framed_tx_data[7]} {framed_tx_data[8]} {framed_tx_data[9]} {framed_tx_data[10]} {framed_tx_data[11]} {framed_tx_data[12]} {framed_tx_data[13]} {framed_tx_data[14]} {framed_tx_data[15]} {framed_tx_data[16]} {framed_tx_data[17]} {framed_tx_data[18]} {framed_tx_data[19]} {framed_tx_data[20]} {framed_tx_data[21]} {framed_tx_data[22]} {framed_tx_data[23]} {framed_tx_data[24]} {framed_tx_data[25]} {framed_tx_data[26]} {framed_tx_data[27]} {framed_tx_data[28]} {framed_tx_data[29]} {framed_tx_data[30]} {framed_tx_data[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe2]
set_property port_width 2 [get_debug_ports u_ila_1/probe2]
connect_debug_port u_ila_1/probe2 [get_nets [list {gth_top/rxclkcorcnt_out[0]} {gth_top/rxclkcorcnt_out[1]}]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets freerun_clk]
