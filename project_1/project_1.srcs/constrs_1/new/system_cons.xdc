
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
set_property PACKAGE_PIN AM13 [get_ports pl_led1]
set_property IOSTANDARD LVCMOS33 [get_ports pl_led1]
set_property PACKAGE_PIN AP12 [get_ports pl_led2]
set_property IOSTANDARD LVCMOS33 [get_ports pl_led2]
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
connect_debug_port u_ila_0/clk [get_nets [list rxusrclk2]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {prbs_err_bits[0]} {prbs_err_bits[1]} {prbs_err_bits[2]} {prbs_err_bits[3]} {prbs_err_bits[4]} {prbs_err_bits[5]} {prbs_err_bits[6]} {prbs_err_bits[7]} {prbs_err_bits[8]} {prbs_err_bits[9]} {prbs_err_bits[10]} {prbs_err_bits[11]} {prbs_err_bits[12]} {prbs_err_bits[13]} {prbs_err_bits[14]} {prbs_err_bits[15]} {prbs_err_bits[16]} {prbs_err_bits[17]} {prbs_err_bits[18]} {prbs_err_bits[19]} {prbs_err_bits[20]} {prbs_err_bits[21]} {prbs_err_bits[22]} {prbs_err_bits[23]} {prbs_err_bits[24]} {prbs_err_bits[25]} {prbs_err_bits[26]} {prbs_err_bits[27]} {prbs_err_bits[28]} {prbs_err_bits[29]} {prbs_err_bits[30]} {prbs_err_bits[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {aligned_data[0]} {aligned_data[1]} {aligned_data[2]} {aligned_data[3]} {aligned_data[4]} {aligned_data[5]} {aligned_data[6]} {aligned_data[7]} {aligned_data[8]} {aligned_data[9]} {aligned_data[10]} {aligned_data[11]} {aligned_data[12]} {aligned_data[13]} {aligned_data[14]} {aligned_data[15]} {aligned_data[16]} {aligned_data[17]} {aligned_data[18]} {aligned_data[19]} {aligned_data[20]} {aligned_data[21]} {aligned_data[22]} {aligned_data[23]} {aligned_data[24]} {aligned_data[25]} {aligned_data[26]} {aligned_data[27]} {aligned_data[28]} {aligned_data[29]} {aligned_data[30]} {aligned_data[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {total_err_cnt[0]} {total_err_cnt[1]} {total_err_cnt[2]} {total_err_cnt[3]} {total_err_cnt[4]} {total_err_cnt[5]} {total_err_cnt[6]} {total_err_cnt[7]} {total_err_cnt[8]} {total_err_cnt[9]} {total_err_cnt[10]} {total_err_cnt[11]} {total_err_cnt[12]} {total_err_cnt[13]} {total_err_cnt[14]} {total_err_cnt[15]} {total_err_cnt[16]} {total_err_cnt[17]} {total_err_cnt[18]} {total_err_cnt[19]} {total_err_cnt[20]} {total_err_cnt[21]} {total_err_cnt[22]} {total_err_cnt[23]} {total_err_cnt[24]} {total_err_cnt[25]} {total_err_cnt[26]} {total_err_cnt[27]} {total_err_cnt[28]} {total_err_cnt[29]} {total_err_cnt[30]} {total_err_cnt[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list aligner_locked]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list prbs_error_detected]]
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
connect_debug_port u_ila_1/clk [get_nets [list txusrclk2]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe0]
set_property port_width 32 [get_debug_ports u_ila_1/probe0]
connect_debug_port u_ila_1/probe0 [get_nets [list {prbs_tx_data[0]} {prbs_tx_data[1]} {prbs_tx_data[2]} {prbs_tx_data[3]} {prbs_tx_data[4]} {prbs_tx_data[5]} {prbs_tx_data[6]} {prbs_tx_data[7]} {prbs_tx_data[8]} {prbs_tx_data[9]} {prbs_tx_data[10]} {prbs_tx_data[11]} {prbs_tx_data[12]} {prbs_tx_data[13]} {prbs_tx_data[14]} {prbs_tx_data[15]} {prbs_tx_data[16]} {prbs_tx_data[17]} {prbs_tx_data[18]} {prbs_tx_data[19]} {prbs_tx_data[20]} {prbs_tx_data[21]} {prbs_tx_data[22]} {prbs_tx_data[23]} {prbs_tx_data[24]} {prbs_tx_data[25]} {prbs_tx_data[26]} {prbs_tx_data[27]} {prbs_tx_data[28]} {prbs_tx_data[29]} {prbs_tx_data[30]} {prbs_tx_data[31]}]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets txusrclk2]
