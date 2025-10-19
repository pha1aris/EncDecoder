# =====================================================
# 1. 强制映射所有需要的Xilinx库 (!!! 最关键的一步 !!!)
# =====================================================
# 定义您已编译好的库的主路径
set PRECOMPILED_LIB_PATH "D:/2024_2/Vivado/2024.2/modelsim_lib_usplus"

# 告诉Modelsim库的具体位置
puts "Mapping pre-compiled Xilinx libraries from: ${PRECOMPILED_LIB_PATH}"

# <<< 关键补充：强制映射 fifo_generator 库 >>>
vmap fifo_generator_v13_2_11 ${PRECOMPILED_LIB_PATH}/fifo_generator_v13_2_11

# 其他通用库
vmap xpm                      ${PRECOMPILED_LIB_PATH}/xpm
vmap unisim                   ${PRECOMPILED_LIB_PATH}/unisim
vmap secureip                 ${PRECOMPILED_LIB_PATH}/secureip
# =====================================================
# 2. 建库 & 清理
# =====================================================
vlib work
vdel -all
vlib work
vmap work work
# =====================================================
# 3. 编译你的设计文件
# =====================================================
puts "Compiling user RTL, IP, and Testbench..."
vlog ../src/crc.v
vlog ../src/frame_generator.v
vlog C:/Users/PC/Desktop/fps/EnDec/project_1/project_1.gen/sources_1/ip/sync_gen_fifo/sim/sync_gen_fifo.v
vlog ../src/frame_synchronizer.v
vlog -sv ../sim/tb_frame_end2end.v
# =====================================================
# 4. 仿真 (!!! vsim 命令已更新 !!!)
# =====================================================
# <<< 关键补充：在 -L 参数中加入 fifo_generator 库 >>>
puts "Starting simulation..."
vsim -L fifo_generator_v13_2_11 -L xpm -L unisim -L secureip -gui -voptargs="+acc" work.tb_frame_end2end

# =====================================================
# 5. 配置波形 & 运行
# =====================================================
configure wave -signalnamewidth 1
add wave -r sim:/tb_frame_end2end/u_frame_sync/*
run 1us