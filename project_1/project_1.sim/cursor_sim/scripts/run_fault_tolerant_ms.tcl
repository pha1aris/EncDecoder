######################################################################
# run_fault_tolerant_ms.tcl
# 容错同步系统验证测试（几毫秒级衰落）
# 线速率：500Mbps
######################################################################

# 设置项目根目录
set PROJECT_ROOT [file normalize [file join [pwd] .. .. ..]]
set CURSOR_SIM_DIR [file normalize [file join [pwd] ..]]

# 设置工作目录
set WORK_DIR [file join $CURSOR_SIM_DIR work]
file mkdir $WORK_DIR
cd $WORK_DIR

puts "=========================================="
puts "Fault-Tolerant Sync Validation Test"
puts "Line Rate: 500Mbps"
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

# 1. 编译容错位对齐模块
puts "  Compiling fault-tolerant bit aligner..."
vlog -work work $INC_OPTS +define+SIM \
    [file join $CURSOR_SIM_DIR src bit_aligner_ind_fault_tolerant_ms.v]

# 2. 编译测试平台
puts "  Compiling testbench..."
vlog -work work $INC_OPTS +define+SIM \
    [file join $CURSOR_SIM_DIR tb tb_fault_tolerant_ms_validation.v]

puts ""
puts "Compilation complete!"
puts ""

# 启动仿真
puts "=========================================="
puts "Starting simulation..."
puts "=========================================="

vsim -voptargs="+acc" -t ps work.tb_fault_tolerant_ms_validation

# 添加波形
add wave -divider "Clock and Reset"
add wave /tb_fault_tolerant_ms_validation/line_clk
add wave /tb_fault_tolerant_ms_validation/core_clk
add wave /tb_fault_tolerant_ms_validation/rst_n

add wave -divider "Interrupt Control"
add wave /tb_fault_tolerant_ms_validation/data_interrupt
add wave /tb_fault_tolerant_ms_validation/link_down
add wave /tb_fault_tolerant_ms_validation/cdr_unstable
add wave /tb_fault_tolerant_ms_validation/test_case

add wave -divider "Bit Alignment - Lock Status"
add wave /tb_fault_tolerant_ms_validation/bit_locked
add wave /tb_fault_tolerant_ms_validation/bit_locked_soft
add wave /tb_fault_tolerant_ms_validation/data_valid
add wave /tb_fault_tolerant_ms_validation/aligned_valid
add wave /tb_fault_tolerant_ms_validation/aligned_data

add wave -divider "Bit Alignment - Internal State"
add wave /tb_fault_tolerant_ms_validation/u_bit_aligner_ft/lock_state
add wave -radix unsigned /tb_fault_tolerant_ms_validation/u_bit_aligner_ft/soft_loss_cnt
add wave -radix unsigned /tb_fault_tolerant_ms_validation/u_bit_aligner_ft/hard_loss_cnt

add wave -divider "Statistics"
add wave -radix unsigned /tb_fault_tolerant_ms_validation/soft_loss_count
add wave -radix unsigned /tb_fault_tolerant_ms_validation/hard_loss_count
add wave /tb_fault_tolerant_ms_validation/bit_lock_acquired
add wave /tb_fault_tolerant_ms_validation/bit_lock_lost
add wave /tb_fault_tolerant_ms_validation/bit_lock_recovered
add wave /tb_fault_tolerant_ms_validation/bit_lock_hard_lost
add wave -radix unsigned /tb_fault_tolerant_ms_validation/total_interrupt_time_ns

# 运行仿真
# 总时间计算：
# - 初始锁定：~1ms
# - 测试1：0.5ms衰落 + 1.28ms观察 = ~2ms
# - 测试2：3ms衰落 + 1.28ms观察 = ~5ms
# - 测试3：8ms衰落 + 3.2ms观察 = ~12ms
# - 测试4：15ms衰落 + 6.4ms观察 = ~22ms
# 总计：~42ms，加上间隔和结果检查，需要至少 60ms
run 60ms

puts ""
puts "=========================================="
puts "Simulation complete!"
puts "=========================================="
puts ""
puts "Check the waveform and console output for results."
puts ""
puts "Expected behavior:"
puts "  Test 1 (0.5ms): Should stay in soft loss, quick recovery"
puts "  Test 2 (3ms): Should stay in soft loss, quick recovery"
puts "  Test 3 (8ms): May enter hard loss, but should recover"
puts "  Test 4 (15ms): Should enter hard loss, need re-lock"
puts ""

# 退出仿真（批处理模式）
quit -sim
quit
