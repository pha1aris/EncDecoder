# ===================================================================
# 最终版 run.do - 结合了专业脚本结构与预编译库流程
#
# 说明:
# 本脚本是你之前两个版本的最终整合。它假设你已经成功运行了
# compile_simlib，并将只编译你自己的设计文件。
# ===================================================================

# ##################################################################
# 阶段〇: 设置与清理
# ##################################################################
puts "INFO: --- STAGE 0: SETUP & CLEANUP ---"

# --- 脚本初始化：设置可移植的路径 ---
# 获取本脚本所在的目录，并切换过去，以确保所有相对路径都正确
set script_dir [file dirname [info script]]
cd $script_dir
puts "INFO: Changed current directory to '$script_dir'"

# --- 每次运行时清理旧的工作库 ---
if {[file isdirectory "work"]} {
    puts "INFO: Deleting previous 'work' library..."
    file delete -force "work"
}

# --- **关键步骤**: 指向你用 compile_simlib 生成的库目录 ---
set PRECOMPILED_LIB_DIR "D:/2024_2/Vivado/2024.2/modelsim_lib_usplus"

# ##################################################################
# 阶段一: 编译你自己的设计
# ##################################################################
puts "INFO: --- STAGE 1: COMPILING YOUR DESIGN ---"

# --- 创建并映射本地工作库 ---
vlib work
vmap work work

# --- 编译 Package 和 Interface (来自你的专业模板) ---
# ** 修正: 已删除对加密IP源文件(StateTableCore.sv, StateTable.sv等)的编译。**
# ** 这些IP已经存在于你用compile_simlib生成的预编译库中，无需再次编译。**
puts "INFO: Skipping compilation of pre-compiled packages (arch_package, StateTable, etc.)..."
# vlog -sv -work work +incdir+../sim "../sim/config_pkg.sv"
# vlog -sv -work work +incdir+../sim "../sim/arch_defines.v"
# vlog -sv -work work +incdir+../sim "../sim/arch_package.sv"
# vlog -sv -work work +incdir+../sim "../sim/proj_package.sv"
# vlog -sv -work work +incdir+../sim "../sim/interface.sv"
# vlog -sv -work work +incdir+../sim "../sim/StateTableCore.sv"
# vlog -sv -work work +incdir+../sim "../sim/StateTable.sv"

# --- 编译你的 RTL 设计文件 (来自你的专业模板) ---
puts "INFO: Compiling your RTL source files..."
vlog -sv -work work +incdir+../src \
    "../src/ddr4_controler_clean.v" \
    "../src/ddr4_controler_deintv.v" \
    "../src/ddr4_fifo_ctrl.v" \
    "../src/ddr4_rw.v" \
    "../src/ddr4_rw_deintv.v" \
    "../sim/gtwizard_ultrascale_0_prbs_any.v"

# --- 编译 glbl.v ---
# (请确保你已将 glbl.v 文件复制到 ../sim 目录下)
vlog -work work "../sim/glbl.v"

# --- 编译 Testbench (最后编译, 来自你的专业模板) ---
puts "INFO: Compiling the testbench..."
vlog -sv -work work +incdir+../sim "../sim/interleaver_self_check_sim.v"

puts "INFO: Your design compilation finished successfully."

# ##################################################################
# 阶段二: 仿真
# ##################################################################
puts "INFO: --- STAGE 2: SIMULATION ---"

# --- 启动仿真 ---
puts "INFO: Starting simulation..."
vsim -gui -voptargs="+acc" \
    -modelsimini "${PRECOMPILED_LIB_DIR}/modelsim.ini" \
    -L unisim \
    -L unimacro \
    -L secureip \
    -L xil_defaultlib \
    -L xpm \
    -L fifo_generator_v13_2_11 \
    -L ddr4_v2_2_24 \
    work.interleaver_self_check_sim work.glbl

# --- 添加波形并运行 (来自你的专业模板) ---
puts "INFO: Adding waves and running simulation..."
add wave -position insertpoint sim:/interleaver_self_check_sim/*
run 10us

puts "INFO: Simulation finished."

