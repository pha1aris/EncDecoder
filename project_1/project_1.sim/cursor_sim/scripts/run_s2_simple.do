######################################################################
# run_s2_simple.do
# 简化的 S2 仿真脚本，使用硬编码路径
# 在 ModelSim 中执行: do run_s2_simple.do
######################################################################

# 设置项目根目录（请根据实际情况修改）
set PROJECT_ROOT "C:/Users/PC/Desktop/fps/EnDec/project_1"
set CURSOR_SIM_DIR "$PROJECT_ROOT/project_1.sim/cursor_sim"
set WORK_DIR "$CURSOR_SIM_DIR/work_modelsim"

# 创建并切换到工作目录
file mkdir $WORK_DIR
cd $WORK_DIR

puts "Working directory: [pwd]"

# 创建库
vlib work
vmap work work

# 设置包含路径
set INC_OPTS "+incdir+$PROJECT_ROOT/project_1.srcs/sources_1/new"
append INC_OPTS " +incdir+$PROJECT_ROOT/project_1.srcs/sim_1/new"

# 编译顺序（简化版，只编译必要的文件）
puts "Compiling files..."

# 编译 PRBS 模块
vlog -work work $INC_OPTS "$PROJECT_ROOT/project_1.srcs/sources_1/imports/imports/gtwizard_ultrascale_0_prbs_any.v"

# 编译基础模块
vlog -work work $INC_OPTS +define+SIM "$PROJECT_ROOT/project_1.srcs/sources_1/new/crc32.v"
vlog -work work $INC_OPTS +define+SIM "$PROJECT_ROOT/project_1.srcs/sources_1/new/gearbox_32to8.v"
vlog -work work $INC_OPTS +define+SIM "$PROJECT_ROOT/project_1.srcs/sources_1/new/gearbox_8to32_bs.v"
vlog -work work $INC_OPTS +define+SIM "$PROJECT_ROOT/project_1.srcs/sources_1/new/axis_fifo_sync.v"

# 编译同步模块
vlog -work work $INC_OPTS +define+SIM "$PROJECT_ROOT/project_1.srcs/sources_1/new/bit_aligner_ind.v"
vlog -work work $INC_OPTS +define+SIM "$PROJECT_ROOT/project_1.srcs/sources_1/new/fso_framer.v"
vlog -work work $INC_OPTS +define+SIM "$PROJECT_ROOT/project_1.srcs/sources_1/new/fso_deframer.v"

# 编译 GTH 相关（需要 IP 文件，这里简化处理）
# 注意：实际使用时需要编译所有 GTH IP 文件

# 编译 S2 顶层
vlog -work work $INC_OPTS +define+SIM "$PROJECT_ROOT/project_1.srcs/sources_1/new/fec_gth_loopback_top_s2.v"

# 编译 testbench
vlog -work work $INC_OPTS +define+SIM "$CURSOR_SIM_DIR/tb/tb_fec_gth_loopback_top_s2.v"

# 编译 glbl
set GBL_FILE "$PROJECT_ROOT/project_1.sim/sim_1/behav/xsim/glbl.v"
if {[file exists $GBL_FILE]} {
    vlog -work work $GBL_FILE
}

# 启动仿真
puts "Starting simulation..."
vsim -voptargs="+acc" -t ps work.tb_fec_gth_loopback_top_s2 work.glbl

puts "\n=========================================="
puts "ModelSim simulation loaded successfully!"
puts "Test: S2 (fec_gth_loopback_top_s2)"
puts "=========================================="
puts "\nYou can now control the simulation:"
puts "  - add wave *       : Add all signals to waveform"
puts "  - view wave        : Open waveform window"
puts "  - run 1ms          : Run simulation for 1ms"
puts "  - run -all         : Run until \$finish"
puts "\nSuggested commands:"
puts "  add wave /tb_fec_gth_loopback_top_s2/dut_s2/bit_locked_core"
puts "  add wave /tb_fec_gth_loopback_top_s2/dut_s2/frame_locked_core"
puts "  add wave /tb_fec_gth_loopback_top_s2/dut_s2/prbs_meas_ok"
puts "  add wave /tb_fec_gth_loopback_top_s2/dut_s2/prbs_meas_start"
puts "  add wave /tb_fec_gth_loopback_top_s2/dut_s2/prbs_err_vec"
puts "  add wave /tb_fec_gth_loopback_top_s2/dut_s2/prbs_match"
puts "  view wave"
puts "  run 1ms"
puts "\n=========================================="
