
# file: ibert_ultrascale_gth_0.xdc

############################################################


############################################################

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*REFCLKOUTMONITOR*} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD*.u_q/u_common/u_gthe*_common}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD*.u_q/u_common/U_COMMON_REGS/reg_*/I_EN_STAT_EQ1.U_STAT/xsdb_reg_reg[*]}]] 

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*RXUSRCLK*} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_STAT_EQ1.U_STAT/xsdb_reg_reg[*]}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_PATTERN_HANDLER/chk40.patchk40/link_reg}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[0].u_q/CH[0].u_ch/U_RXCDR_RESET/link_r_reg}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_PATTERN_HANDLER/chk40.patchk40/link_reg}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_STAT_EQ1.U_STAT/xsdb_reg_reg[*]}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_RESET_CONTROLLER/gtwiz_reset_inst/reset_synchronizer_rx_done_inst/rst_in_out_reg}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_STAT_EQ1.U_STAT/xsdb_reg_reg[*]}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_DF}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_STAT_EQ1.U_STAT/xsdb_reg_reg[*]}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_DFr}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_STAT_EQ1.U_STAT/xsdb_reg_reg[*]}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*TXUSRCLK*} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_STAT_EQ1.U_STAT/xsdb_reg_reg[*]}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_RESET_CONTROLLER/gtwiz_reset_inst/reset_synchronizer_tx_done_inst/rst_in_out_reg}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_STAT_EQ1.U_STAT/xsdb_reg_reg[*]}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*DMONITORCLK} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_STAT_EQ1.U_STAT/xsdb_reg_reg[*]}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_RXUSRCLK*_FREQ_COUNTER/state_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*CE} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_RXUSRCLK*_FREQ_COUNTER/testclk_cnt_reg[*]}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_PATTERN_HANDLER/chk40.patchk40/bit_error_o_reg}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_RESET_CONTROLLER/gtwiz_reset_inst/gtrxreset_out_reg}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_PATTERN_HANDLER/rx_cnt_rst_dly1_reg}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_RESET_CONTROLLER/gtwiz_reset_inst/gtrxreset_out_reg}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*R} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_PATTERN_HANDLER/rx_cnt_rst_dly1_reg}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_RESET_CONTROLLER/gtwiz_reset_inst/gtrxreset_out_reg}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_PATTERN_HANDLER/rx_cnt_rst_reg}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_RESET_CONTROLLER/gtwiz_reset_inst/gtrxreset_out_reg}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*S} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_PATTERN_HANDLER/rx_cnt_rst_reg}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_RESET_CONTROLLER/mgt_errcnt_reset_o_reg}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*S} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_DFr}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_PATTERN_HANDLER/chk40.patchk40/patgen_rx/pat_id_r1_reg[*]}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_TXUSRCLK*_FREQ_COUNTER/state_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*CE} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_TXUSRCLK*_FREQ_COUNTER/testclk_cnt_reg[*]}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_RESET_CONTROLLER/gtwiz_reset_inst/gttxreset_out_reg}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_PATTERN_HANDLER/gen40.patgen40/init_r1_reg}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_RESET_CONTROLLER/gtwiz_reset_inst/gttxreset_out_reg}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_PATTERN_HANDLER/tei_dly1_reg}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_PATTERN_HANDLER/tei_dly1_reg}]]


create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_PATTERN_HANDLER/tx_data_o_reg[*]}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_PATTERN_HANDLER/chk40.patchk40/link_reg}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_RXCDR_RESET/link_r_reg}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*RXUSRCLK*} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_RESET_CONTROLLER/gtwiz_reset_inst/gtwiz_reset_rx_done_int_reg}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*RXUSRCLK*} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_RESET_CONTROLLER/gtwiz_reset_inst/sm_reset_rx_timer_clr_reg}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*RXUSRCLK*} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_RXCDR_RESET/rxresetdone_r_reg}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*RXUSRCLK*} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*CE} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_RESET_CONTROLLER/gtwiz_reset_inst/FSM_sequential_sm_reset_rx_reg[*]}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*TXUSRCLK*} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_RESET_CONTROLLER/gtwiz_reset_inst/gtwiz_reset_tx_done_int_reg}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*TXUSRCLK*} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_RESET_CONTROLLER/gtwiz_reset_inst/sm_reset_tx_timer_clr_reg}]]

create_waiver -internal -quiet -type CDC -id {CDC-1} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*TXUSRCLK*} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*CE} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_RESET_CONTROLLER/gtwiz_reset_inst/FSM_sequential_sm_reset_tx_reg[*]}]]











create_waiver -internal -quiet -type CDC -id {CDC-2} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-2 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_PATTERN_HANDLER/chk40.patchk40/errored_bits_o_reg[*]}]]

create_waiver -internal -quiet -type CDC -id {CDC-2} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_RESET_CONTROLLER/mgt_errcnt_reset_o_reg}]]












create_waiver -internal -quiet -type CDC -id {CDC-4} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-4 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_PATTERN_HANDLER/chk40.patchk40/patgen_rx/pat_id_r1_reg[*]}]]

create_waiver -internal -quiet -type CDC -id {CDC-4} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-4 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_PATTERN_HANDLER/gen40.patgen40/pat_id_r1_reg[*]}]]

















create_waiver -internal -quiet -type CDC -id {CDC-7} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-7 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_RESET_CONTROLLER/gtwiz_reset_inst/gtrxreset_out_reg}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*PRE} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_PATTERN_HANDLER/chk40.patchk40/link_down_reg}]]

create_waiver -internal -quiet -type CDC -id {CDC-7} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-7 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_RESET_CONTROLLER/gtwiz_reset_inst/gtrxreset_out_reg}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*CLR} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_PATTERN_HANDLER/chk40.patchk40/link_reg}]]

create_waiver -internal -quiet -type CDC -id {CDC-7} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-7 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_RESET_CONTROLLER/gtwiz_reset_inst/gtrxreset_out_reg}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*CLR} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_PATTERN_HANDLER/chk40.patchk40/err_cnt_reg[*]}]]

create_waiver -internal -quiet -type CDC -id {CDC-7} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-7 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_RESET_CONTROLLER/gtwiz_reset_inst/gtrxreset_out_reg}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*PRE} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_PATTERN_HANDLER/chk40.patchk40/err_cnt_reg[*]}]]


















create_waiver -internal -quiet -type CDC -id {CDC-10} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-10 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_PATTERN_HANDLER/chk40.patchk40/errored_bits_o_reg[*]}]]

create_waiver -internal -quiet -type CDC -id {CDC-10} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-10 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_PATTERN_HANDLER/forward_dly1_reg}]]

create_waiver -internal -quiet -type CDC -id {CDC-10} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-10 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_PATTERN_HANDLER/chk40.patchk40/bit_error_o_reg}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_PATTERN_HANDLER/forward_dly1_reg}]]

create_waiver -internal -quiet -type CDC -id {CDC-10} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-1 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_RESET_CONTROLLER/mgt_errcnt_reset_o_reg}]]






















create_waiver -internal -quiet -type CDC -id {CDC-13} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-13 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*RXCHBONDI[*]} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]

create_waiver -internal -quiet -type CDC -id {CDC-13} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-13 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*RX8B10BEN} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]

create_waiver -internal -quiet -type CDC -id {CDC-13} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-13 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*RXCHBONDEN} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]

create_waiver -internal -quiet -type CDC -id {CDC-13} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-13 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*RXCHBONDMASTER} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]

create_waiver -internal -quiet -type CDC -id {CDC-13} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-13 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*RXCHBONDSLAVE} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]

create_waiver -internal -quiet -type CDC -id {CDC-13} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-13 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*RXCOMMADETEN} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]

create_waiver -internal -quiet -type CDC -id {CDC-13} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-13 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*RXGEARBOXSLIP} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]

create_waiver -internal -quiet -type CDC -id {CDC-13} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-13 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*RXMCOMMAALIGNEN} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]

create_waiver -internal -quiet -type CDC -id {CDC-13} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-13 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*RXPCOMMAALIGNEN} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]

create_waiver -internal -quiet -type CDC -id {CDC-13} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-13 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*RXPOLARITY} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]

create_waiver -internal -quiet -type CDC -id {CDC-13} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-13 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*RXPRBSCNTRESET} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]

create_waiver -internal -quiet -type CDC -id {CDC-13} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-13 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*RXSLIDE} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]

create_waiver -internal -quiet -type CDC -id {CDC-13} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-13 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*RXSLIPPMA} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]

create_waiver -internal -quiet -type CDC -id {CDC-13} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-13 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*RXCHBONDLEVEL[*]} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]

create_waiver -internal -quiet -type CDC -id {CDC-13} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-13 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*RXPRBSSEL[*]} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]

create_waiver -internal -quiet -type CDC -id {CDC-13} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-13 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*TX8B10BEN} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]

create_waiver -internal -quiet -type CDC -id {CDC-13} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-13 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*TXCOMINIT} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]

create_waiver -internal -quiet -type CDC -id {CDC-13} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-13 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*TXCOMSAS} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]

create_waiver -internal -quiet -type CDC -id {CDC-13} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-13 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*TXCOMWAKE} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]

create_waiver -internal -quiet -type CDC -id {CDC-13} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-13 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*TXDETECTRX} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]

create_waiver -internal -quiet -type CDC -id {CDC-13} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-13 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*TXELECIDLE} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]

create_waiver -internal -quiet -type CDC -id {CDC-13} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-13 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*TXINHIBIT} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]

create_waiver -internal -quiet -type CDC -id {CDC-13} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-13 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*TXPOLARITY} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]

create_waiver -internal -quiet -type CDC -id {CDC-13} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-13 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*TXPD[*]} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]

create_waiver -internal -quiet -type CDC -id {CDC-13} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-13 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*TXPRBSFORCEERR} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]

create_waiver -internal -quiet -type CDC -id {CDC-13} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-13 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*TX8B10BBYPASS[*]} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]

create_waiver -internal -quiet -type CDC -id {CDC-13} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-13 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_DMON_LUTRAM_FIFO/dmon_fifo_push_dly_2_reg_srl2}]]















create_waiver -internal -quiet -type CDC -id {CDC-14} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-14 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*TXHEADER[*]} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]

create_waiver -internal -quiet -type CDC -id {CDC-14} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-14 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*TXPRBSSEL[*]} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]

create_waiver -internal -quiet -type CDC -id {CDC-14} -user ibert_ultrascale_gth -tags "1165855" -description "CDC-14 waiver for CPLL Calibration logic" \
                        -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*C} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/U_CHANNEL_REGS/reg_*/I_EN_CTL_EQ1.U_CTL/xsdb_reg_reg[*]}]] \
						       -to [get_pins -quiet -filter {REF_PIN_NAME=~*TXSEQUENCE[*]} -of_objects [get_cells -hierarchical -filter {NAME =~*QUAD[*].u_q/CH[*].u_ch/u_gthe*_channel}]]



