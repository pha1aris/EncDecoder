
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