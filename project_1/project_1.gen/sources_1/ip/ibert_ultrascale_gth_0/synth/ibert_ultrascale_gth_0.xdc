
# file: ibert_ultrascale_gth_0.xdc
####################################################################################

##**************************************************************************
set_property ES_EYE_SCAN_EN TRUE [get_cells QUAD[*].u_q/CH[*].u_ch/u_gthe4_channel]
##
## TX/RX out clock and DMONITOR clock constraints
##
# GT X1Y4
#create_clock -period 4.000 [get_pins {QUAD[0].u_q/CH[0].u_ch/u_gthe4_channel/DMONITOROUTCLK}]
#set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {QUAD[0].u_q/CH[0].u_ch/u_gthe4_channel/DMONITOROUTCLK}]]
# GT X1Y5
#create_clock -period 4.000 [get_pins {QUAD[0].u_q/CH[1].u_ch/u_gthe4_channel/DMONITOROUTCLK}]
#set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {QUAD[0].u_q/CH[1].u_ch/u_gthe4_channel/DMONITOROUTCLK}]]
# GT X1Y6
#create_clock -period 4.000 [get_pins {QUAD[0].u_q/CH[2].u_ch/u_gthe4_channel/DMONITOROUTCLK}]
#set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {QUAD[0].u_q/CH[2].u_ch/u_gthe4_channel/DMONITOROUTCLK}]]
# GT X1Y7
#create_clock -period 4.000 [get_pins {QUAD[0].u_q/CH[3].u_ch/u_gthe4_channel/DMONITOROUTCLK}]
#set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {QUAD[0].u_q/CH[3].u_ch/u_gthe4_channel/DMONITOROUTCLK}]]
##
## GTH Channel and Common Loc constraints
##
set_property LOC GTHE4_CHANNEL_X1Y4 [get_cells QUAD[0].u_q/CH[0].u_ch/u_gthe4_channel]
set_property LOC GTHE4_CHANNEL_X1Y5 [get_cells QUAD[0].u_q/CH[1].u_ch/u_gthe4_channel]
set_property LOC GTHE4_CHANNEL_X1Y6 [get_cells QUAD[0].u_q/CH[2].u_ch/u_gthe4_channel]
set_property LOC GTHE4_CHANNEL_X1Y7 [get_cells QUAD[0].u_q/CH[3].u_ch/u_gthe4_channel]
set_property LOC GTHE4_COMMON_X1Y1 [get_cells QUAD[0].u_q/u_common/u_gthe4_common]
##
## DMONITOR clock BUFFERS location constraints
##
## Set case analysis on clock selection
set_case_analysis 0 [get_pins QUAD[*].u_q/CH[*].u_ch/u_gthe4_channel/TXRATE[*]]
set_case_analysis 0 [get_pins QUAD[*].u_q/CH[*].u_ch/u_gthe4_channel/RXRATE[*]]
		
		

set_case_analysis 1 [get_pins QUAD[0].u_q/u_common/u_gthe4_common/QPLL0REFCLKSEL[0]]
set_case_analysis 0 [get_pins QUAD[0].u_q/u_common/u_gthe4_common/QPLL0REFCLKSEL[1]]
set_case_analysis 0 [get_pins QUAD[0].u_q/u_common/u_gthe4_common/QPLL0REFCLKSEL[2]]

set_case_analysis 0 [get_pins QUAD[0].u_q/u_common/u_gthe4_common/QPLL1REFCLKSEL[0]]
set_case_analysis 0 [get_pins QUAD[0].u_q/u_common/u_gthe4_common/QPLL1REFCLKSEL[1]]
set_case_analysis 0 [get_pins QUAD[0].u_q/u_common/u_gthe4_common/QPLL1REFCLKSEL[2]]

set_case_analysis 1 [get_pins QUAD[0].u_q/CH[*].u_ch/u_gthe4_channel/CPLLREFCLKSEL[0]]
set_case_analysis 0 [get_pins QUAD[0].u_q/CH[*].u_ch/u_gthe4_channel/CPLLREFCLKSEL[1]]
set_case_analysis 0 [get_pins QUAD[0].u_q/CH[*].u_ch/u_gthe4_channel/CPLLREFCLKSEL[2]]

	
set_case_analysis 1 [get_pins QUAD[0].u_q/CH[*].u_ch/u_gthe4_channel/TXPLLCLKSEL[0]]
set_case_analysis 1 [get_pins QUAD[0].u_q/CH[*].u_ch/u_gthe4_channel/TXPLLCLKSEL[1]]
		
	
set_case_analysis 1 [get_pins QUAD[0].u_q/CH[*].u_ch/u_gthe4_channel/RXPLLCLKSEL[0]]
set_case_analysis 1 [get_pins QUAD[0].u_q/CH[*].u_ch/u_gthe4_channel/RXPLLCLKSEL[1]]

set_case_analysis 0 [get_pins QUAD[*].u_q/CH[*].u_ch/u_gthe4_channel/TXOUTCLKSEL[2]]
set_case_analysis 1 [get_pins QUAD[*].u_q/CH[*].u_ch/u_gthe4_channel/TXOUTCLKSEL[1]]
set_case_analysis 0 [get_pins QUAD[*].u_q/CH[*].u_ch/u_gthe4_channel/TXOUTCLKSEL[0]]

set_case_analysis 0 [get_pins QUAD[*].u_q/CH[*].u_ch/u_gthe4_channel/RXOUTCLKSEL[2]]
set_case_analysis 1 [get_pins QUAD[*].u_q/CH[*].u_ch/u_gthe4_channel/RXOUTCLKSEL[1]]
set_case_analysis 0 [get_pins QUAD[*].u_q/CH[*].u_ch/u_gthe4_channel/RXOUTCLKSEL[0]]
