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
##################### uart ###########################
set_property PACKAGE_PIN D10 [get_ports uart_txd]
set_property IOSTANDARD LVCMOS33 [get_ports uart_txd]
set_property PACKAGE_PIN D11 [get_ports uart_rxd]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rxd]
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
set_property port_width 8 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {cnt_data[0]} {cnt_data[1]} {cnt_data[2]} {cnt_data[3]} {cnt_data[4]} {cnt_data[5]} {cnt_data[6]} {cnt_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 8 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {fec_rx_data[0]} {fec_rx_data[1]} {fec_rx_data[2]} {fec_rx_data[3]} {fec_rx_data[4]} {fec_rx_data[5]} {fec_rx_data[6]} {fec_rx_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 8 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {u_fec_rx/dec_data[0]} {u_fec_rx/dec_data[1]} {u_fec_rx/dec_data[2]} {u_fec_rx/dec_data[3]} {u_fec_rx/dec_data[4]} {u_fec_rx/dec_data[5]} {u_fec_rx/dec_data[6]} {u_fec_rx/dec_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 8 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {u_fec_rx/deintlv_data[0]} {u_fec_rx/deintlv_data[1]} {u_fec_rx/deintlv_data[2]} {u_fec_rx/deintlv_data[3]} {u_fec_rx/deintlv_data[4]} {u_fec_rx/deintlv_data[5]} {u_fec_rx/deintlv_data[6]} {u_fec_rx/deintlv_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 33 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {u_fec_rx/fifo_m_tdata[0]} {u_fec_rx/fifo_m_tdata[1]} {u_fec_rx/fifo_m_tdata[2]} {u_fec_rx/fifo_m_tdata[3]} {u_fec_rx/fifo_m_tdata[4]} {u_fec_rx/fifo_m_tdata[5]} {u_fec_rx/fifo_m_tdata[6]} {u_fec_rx/fifo_m_tdata[7]} {u_fec_rx/fifo_m_tdata[8]} {u_fec_rx/fifo_m_tdata[9]} {u_fec_rx/fifo_m_tdata[10]} {u_fec_rx/fifo_m_tdata[11]} {u_fec_rx/fifo_m_tdata[12]} {u_fec_rx/fifo_m_tdata[13]} {u_fec_rx/fifo_m_tdata[14]} {u_fec_rx/fifo_m_tdata[15]} {u_fec_rx/fifo_m_tdata[16]} {u_fec_rx/fifo_m_tdata[17]} {u_fec_rx/fifo_m_tdata[18]} {u_fec_rx/fifo_m_tdata[19]} {u_fec_rx/fifo_m_tdata[20]} {u_fec_rx/fifo_m_tdata[21]} {u_fec_rx/fifo_m_tdata[22]} {u_fec_rx/fifo_m_tdata[23]} {u_fec_rx/fifo_m_tdata[24]} {u_fec_rx/fifo_m_tdata[25]} {u_fec_rx/fifo_m_tdata[26]} {u_fec_rx/fifo_m_tdata[27]} {u_fec_rx/fifo_m_tdata[28]} {u_fec_rx/fifo_m_tdata[29]} {u_fec_rx/fifo_m_tdata[30]} {u_fec_rx/fifo_m_tdata[31]} {u_fec_rx/fifo_m_tdata[32]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 33 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {u_fec_rx/fifo_s_tdata[0]} {u_fec_rx/fifo_s_tdata[1]} {u_fec_rx/fifo_s_tdata[2]} {u_fec_rx/fifo_s_tdata[3]} {u_fec_rx/fifo_s_tdata[4]} {u_fec_rx/fifo_s_tdata[5]} {u_fec_rx/fifo_s_tdata[6]} {u_fec_rx/fifo_s_tdata[7]} {u_fec_rx/fifo_s_tdata[8]} {u_fec_rx/fifo_s_tdata[9]} {u_fec_rx/fifo_s_tdata[10]} {u_fec_rx/fifo_s_tdata[11]} {u_fec_rx/fifo_s_tdata[12]} {u_fec_rx/fifo_s_tdata[13]} {u_fec_rx/fifo_s_tdata[14]} {u_fec_rx/fifo_s_tdata[15]} {u_fec_rx/fifo_s_tdata[16]} {u_fec_rx/fifo_s_tdata[17]} {u_fec_rx/fifo_s_tdata[18]} {u_fec_rx/fifo_s_tdata[19]} {u_fec_rx/fifo_s_tdata[20]} {u_fec_rx/fifo_s_tdata[21]} {u_fec_rx/fifo_s_tdata[22]} {u_fec_rx/fifo_s_tdata[23]} {u_fec_rx/fifo_s_tdata[24]} {u_fec_rx/fifo_s_tdata[25]} {u_fec_rx/fifo_s_tdata[26]} {u_fec_rx/fifo_s_tdata[27]} {u_fec_rx/fifo_s_tdata[28]} {u_fec_rx/fifo_s_tdata[29]} {u_fec_rx/fifo_s_tdata[30]} {u_fec_rx/fifo_s_tdata[31]} {u_fec_rx/fifo_s_tdata[32]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 8 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {u_fec_rx/gb8_data[0]} {u_fec_rx/gb8_data[1]} {u_fec_rx/gb8_data[2]} {u_fec_rx/gb8_data[3]} {u_fec_rx/gb8_data[4]} {u_fec_rx/gb8_data[5]} {u_fec_rx/gb8_data[6]} {u_fec_rx/gb8_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 8 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {u_fec_rx/rs_byte_cnt[0]} {u_fec_rx/rs_byte_cnt[1]} {u_fec_rx/rs_byte_cnt[2]} {u_fec_rx/rs_byte_cnt[3]} {u_fec_rx/rs_byte_cnt[4]} {u_fec_rx/rs_byte_cnt[5]} {u_fec_rx/rs_byte_cnt[6]} {u_fec_rx/rs_byte_cnt[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list u_fec_rx/dec_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list u_fec_rx/deintlv_block_start]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list u_fec_rx/deintlv_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list u_fec_rx/df_m_tready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list u_fec_rx/df_m_tvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list u_fec_rx/df_s_tready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list u_fec_rx/df_s_tvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list fec_rx_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list u_fec_rx/fifo_m_tready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list u_fec_rx/fifo_m_tvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list u_fec_rx/fifo_s_tready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list u_fec_rx/fifo_s_tvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list u_fec_rx/gb8_blk_rst_req]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list u_fec_rx/gb8_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list u_fec_rx/gb8_sync_rst]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list u_fec_rx/gb8_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list u_fec_rx/gb32_in_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 1 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list u_fec_rx/rs_fire]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 1 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list u_fec_rx/rs_in_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 1 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list u_fec_rx/rs_tlast]]
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
connect_debug_port u_ila_1/clk [get_nets [list u_gth_raw/u_bufg_rx_0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe0]
set_property port_width 32 [get_debug_ports u_ila_1/probe0]
connect_debug_port u_ila_1/probe0 [get_nets [list {u_fec_rx/rx32_fifo_drop_cnt[0]} {u_fec_rx/rx32_fifo_drop_cnt[1]} {u_fec_rx/rx32_fifo_drop_cnt[2]} {u_fec_rx/rx32_fifo_drop_cnt[3]} {u_fec_rx/rx32_fifo_drop_cnt[4]} {u_fec_rx/rx32_fifo_drop_cnt[5]} {u_fec_rx/rx32_fifo_drop_cnt[6]} {u_fec_rx/rx32_fifo_drop_cnt[7]} {u_fec_rx/rx32_fifo_drop_cnt[8]} {u_fec_rx/rx32_fifo_drop_cnt[9]} {u_fec_rx/rx32_fifo_drop_cnt[10]} {u_fec_rx/rx32_fifo_drop_cnt[11]} {u_fec_rx/rx32_fifo_drop_cnt[12]} {u_fec_rx/rx32_fifo_drop_cnt[13]} {u_fec_rx/rx32_fifo_drop_cnt[14]} {u_fec_rx/rx32_fifo_drop_cnt[15]} {u_fec_rx/rx32_fifo_drop_cnt[16]} {u_fec_rx/rx32_fifo_drop_cnt[17]} {u_fec_rx/rx32_fifo_drop_cnt[18]} {u_fec_rx/rx32_fifo_drop_cnt[19]} {u_fec_rx/rx32_fifo_drop_cnt[20]} {u_fec_rx/rx32_fifo_drop_cnt[21]} {u_fec_rx/rx32_fifo_drop_cnt[22]} {u_fec_rx/rx32_fifo_drop_cnt[23]} {u_fec_rx/rx32_fifo_drop_cnt[24]} {u_fec_rx/rx32_fifo_drop_cnt[25]} {u_fec_rx/rx32_fifo_drop_cnt[26]} {u_fec_rx/rx32_fifo_drop_cnt[27]} {u_fec_rx/rx32_fifo_drop_cnt[28]} {u_fec_rx/rx32_fifo_drop_cnt[29]} {u_fec_rx/rx32_fifo_drop_cnt[30]} {u_fec_rx/rx32_fifo_drop_cnt[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe1]
set_property port_width 1 [get_debug_ports u_ila_1/probe1]
connect_debug_port u_ila_1/probe1 [get_nets [list u_fec_rx/rx32_fifo_full]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets core_clk]
