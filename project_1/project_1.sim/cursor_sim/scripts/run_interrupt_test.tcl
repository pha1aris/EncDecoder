######################################################################
# run_interrupt_test.tcl
# 数据完全中断恢复测试
# 测试同步系统在数据完全中断后能否重新锁定
######################################################################

# 设置项目根目录
set PROJECT_ROOT [file normalize [file join [pwd] .. .. ..]]
set CURSOR_SIM_DIR [file normalize [file join [pwd] ..]]

# 设置工作目录
set WORK_DIR [file join $CURSOR_SIM_DIR work]
file mkdir $WORK_DIR
cd $WORK_DIR

puts "=========================================="
puts "Data Interrupt Recovery Test"
puts "=========================================="
puts "Project root: $PROJECT_ROOT"
puts "Working directory: [pwd]"
puts ""

# 创建库
vlib work
vmap work work

# 设置包含路径
set INC_OPTS "+incdir+$PROJECT_ROOT/project_1.srcs/sources_1/new"
append INC_OPTS " +incdir+$PROJECT_ROOT/project_1.srcs/sim_1/new"

# 编译顺序
puts "Compiling files..."

# 1. 编译改进版本的实现模块
puts "  Compiling improved implementation modules..."
vlog -work work $INC_OPTS +define+SIM \
    [file join $CURSOR_SIM_DIR src fso_deframer_improved.v] \
    [file join $CURSOR_SIM_DIR src bit_aligner_ind_improved.v]

# 2. 编译 wrapper 模块
puts "  Compiling wrapper modules..."
vlog -work work $INC_OPTS +define+SIM \
    [file join $CURSOR_SIM_DIR src bit_aligner_ind_wrapper.v] \
    [file join $CURSOR_SIM_DIR src fso_deframer_wrapper.v]

# 3. 编译基础模块
puts "  Compiling base modules..."
vlog -work work $INC_OPTS +define+SIM \
    [file join $PROJECT_ROOT project_1.srcs sim_1 new AdditiveScrambler.v] \
    [file join $PROJECT_ROOT project_1.srcs sources_1 new crc32.v]

# 4. 编译测试平台
puts "  Compiling testbench..."
vlog -work work $INC_OPTS +define+SIM \
    [file join $CURSOR_SIM_DIR tb tb_data_interrupt_recovery.v]

puts ""
puts "Compilation complete!"
puts ""

# 启动仿真
puts "=========================================="
puts "Starting simulation..."
puts "=========================================="

vsim -voptargs="+acc" -t ps work.tb_data_interrupt_recovery

# 添加波形
add wave -divider "Clock and Reset"
add wave /tb_data_interrupt_recovery/line_clk
add wave /tb_data_interrupt_recovery/core_clk
add wave /tb_data_interrupt_recovery/rst_n

add wave -divider "Interrupt Control"
add wave /tb_data_interrupt_recovery/data_interrupt
add wave /tb_data_interrupt_recovery/link_down
add wave /tb_data_interrupt_recovery/cdr_unstable

add wave -divider "Bit Alignment"
add wave /tb_data_interrupt_recovery/bit_locked
add wave /tb_data_interrupt_recovery/aligned_valid
add wave /tb_data_interrupt_recovery/aligned_data

add wave -divider "Frame Synchronization"
add wave /tb_data_interrupt_recovery/frame_locked
add wave /tb_data_interrupt_recovery/payload_valid
add wave /tb_data_interrupt_recovery/rx_block_id
add wave /tb_data_interrupt_recovery/rx_frame_in_block

add wave -divider "Recovery Status"
add wave /tb_data_interrupt_recovery/bit_lock_acquired
add wave /tb_data_interrupt_recovery/bit_lock_lost
add wave /tb_data_interrupt_recovery/bit_lock_recovered
add wave /tb_data_interrupt_recovery/frame_lock_acquired
add wave /tb_data_interrupt_recovery/frame_lock_lost
add wave /tb_data_interrupt_recovery/frame_lock_recovered

add wave -divider "Statistics"
add wave -radix unsigned /tb_data_interrupt_recovery/total_frames
add wave -radix unsigned /tb_data_interrupt_recovery/crc_error_frames
add wave -radix unsigned /tb_data_interrupt_recovery/fer_q32

# 运行仿真
run 50us

puts ""
puts "=========================================="
puts "Simulation complete!"
puts "=========================================="
puts ""
puts "Check the waveform and console output for results."
puts "Expected behavior:"
puts "  1. Initial lock acquisition (bit_locked and frame_locked go high)"
puts "  2. Lock loss during interruption"
puts "  3. Lock recovery after data restoration"
puts ""
