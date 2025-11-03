
################======gth=======##################
# create_clock -name freerun_clk -period 32.000 [get_pins clk_wiz_0/clk_out1]
set_property package_pin L7 [get_ports mgtrefclk0_x1y1_n]
set_property package_pin L8 [get_ports mgtrefclk0_x1y1_p]
# ============Tx Disable Constraints==============
set_property PACKAGE_PIN G13     [get_ports tx_disable[0]]
set_property PACKAGE_PIN H12     [get_ports tx_disable[1]]
set_property IOSTANDARD LVCMOS33 [get_ports {tx_disable[*]}]
set_property SLEW       SLOW     [get_ports {tx_disable[*]}]

############### ====== sys ===== ###############
set_property PACKAGE_PIN AL8 [get_ports sys_clk_p]
set_property PACKAGE_PIN AL7 [get_ports sys_clk_n]
set_property IOSTANDARD DIFF_SSTL12 [get_ports {sys_clk_p sys_clk_n}]

set_property  PACKAGE_PIN AN12 [get_ports sys_rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports sys_rst_n]


#===========================================================
# 最稳妥：在综合后的网名上打标，-hier 允许跨层
# ======= Debug Mark for key signals =======
# set_property MARK_DEBUG true [get_nets -hier *userdata_tx_in*]
# set_property MARK_DEBUG true [get_nets -hier *userdata_rx_out*]
# set_property MARK_DEBUG true [get_nets -hier *pll_locked*]
# set_property MARK_DEBUG true [get_nets -hier *prbs_chk*]
# set_property MARK_DEBUG true [get_nets -hier *prbs_match*]

# # 防止综合优化掉信号
# set_property KEEP true [get_nets -hier *userdata_tx_in*]
# set_property KEEP true [get_nets -hier *userdata_rx_out*]
# set_property KEEP true [get_nets -hier *pll_locked*]
# set_property KEEP true [get_nets -hier *prbs_chk*]
# set_property KEEP true [get_nets -hier *prbs_match*]

