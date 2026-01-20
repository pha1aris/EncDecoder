######################################################################
# run_validation_simple.tcl
# 简化的验证脚本 - 用于快速验证容错同步系统
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
if {[catch {vlog -work work $INC_OPTS +define+SIM \
    [file join $CURSOR_SIM_DIR src bit_aligner_ind_fault_tolerant_ms.v]} err]} {
    puts "ERROR: Failed to compile bit_aligner_ind_fault_tolerant_ms.v"
    puts "Error: $err"
    exit 1
}

# 2. 编译测试平台
puts "  Compiling testbench..."
if {[catch {vlog -work work $INC_OPTS +define+SIM \
    [file join $CURSOR_SIM_DIR tb tb_fault_tolerant_ms_validation.v]} err]} {
    puts "ERROR: Failed to compile tb_fault_tolerant_ms_validation.v"
    puts "Error: $err"
    exit 1
}

puts ""
puts "Compilation complete!"
puts ""

# 启动仿真
puts "=========================================="
puts "Starting simulation..."
puts "=========================================="

if {[catch {vsim -voptargs="+acc" -t ps work.tb_fault_tolerant_ms_validation} err]} {
    puts "ERROR: Failed to start simulation"
    puts "Error: $err"
    exit 1
}

# 运行仿真（批处理模式，自动运行到结束）
puts "Running simulation for 60ms..."
run 60ms

puts ""
puts "=========================================="
puts "Simulation complete!"
puts "=========================================="
puts ""
puts "Check console output above for test results."
puts ""

# 退出
quit -sim
quit
