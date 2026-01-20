# =========================================================
# Stage1 waveform setup (Vivado + ModelSim/Questa)
# =========================================================
quietly WaveActivateNextPane {} 0
delete wave *

# --------- 常用显示设置（可选）---------
configure wave -namecolwidth 260
configure wave -valuecolwidth 120
configure wave -signalnamewidth 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -timelineunits ns

# =========================================================
# 0) 先定义一个层级前缀，避免每行都写很长
#    你需要把 tb / dut_s1 的名字改成你实际的
# =========================================================
set TB      sim:/tb_fec_gth_loopback_top
set DUT     $TB/dut_s1

# =========================================================
# 1) 时钟/复位层
# =========================================================
add wave -noupdate -divider {CLK / RESET}
add wave -noupdate $TB/sys_rst_n
add wave -noupdate $DUT/core_clk
add wave -noupdate $DUT/clk_locked
add wave -noupdate $DUT/logic_rst_n
add wave -noupdate $DUT/logic_rst

# =========================================================
# 2) 物理就绪/有效数据层（链路可用前提）
# =========================================================
add wave -noupdate -divider {LINE READY / RX VALID}
add wave -noupdate $DUT/rx_active_line
add wave -noupdate $DUT/cdr_stable_line
add wave -noupdate $DUT/have_light_line
add wave -noupdate $DUT/rx_word_valid_line

# =========================================================
# 3) 字对齐层
# =========================================================
add wave -noupdate -divider {BIT ALIGN}
add wave -noupdate $DUT/rx_slide_req
add wave -noupdate $DUT/bit_locked_core

# =========================================================
# 4) 帧对齐层
# =========================================================
add wave -noupdate -divider {FRAME LOCK}
add wave -noupdate $DUT/frame_locked_core

# 可选：你若有前导匹配/CRC窗口统计信号，放这
# add wave -noupdate $DUT/u_rx_stage1/preamble_found
# add wave -noupdate $DUT/u_rx_stage1/crc_ok
# add wave -noupdate $DUT/u_rx_stage1/crc_bad_cnt
#
# =========================================================
# 5) 端到端正确性（PRBS）
# =========================================================
add wave -noupdate -divider {PRBS / BER}
add wave -noupdate $DUT/prbs_match_raw
add wave -noupdate $DUT/prbs_err_vec
add wave -noupdate $DUT/total_err_cnt
add wave -noupdate $DUT/total_bits_cnt
add wave -noupdate $DUT/ber_out

# =========================================================
# 6) 可选：总线（不建议默认打开，太粗）
# =========================================================
# add wave -noupdate -divider {BUSES}
# add wave -noupdate -radix hex $DUT/tx_data_to_gth
# add wave -noupdate -radix hex $DUT/rx_data_from_gth

update
WaveRestoreZoom {0 ns} {2 us}
