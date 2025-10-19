# ===================================================================
# ModelSim Simulation Script for Scrambler/Descrambler Test
#
# 最终修正版 - 确保编译正确的设计文件
# ===================================================================
if {[file isdirectory work]} { vdel -all }
vlib work
vmap work work

# ===================================================================
# 2. 编译 Verilog 源文件
# ===================================================================
echo "==> Compiling RTL source files..."
# [修正] 确保编译的是我们功能正确的最终版本
vlog ../src/ScramblerDescrambler.v

echo "==> Compiling simulation source files..."
vlog ./tb_scrambler_descrambler.v

# ===================================================================
# 3. 启动仿真
# ===================================================================
echo "==> Starting simulation..."
vsim -gui -voptargs="+acc" work.tb_scrambler_descrambler

# ===================================================================
# 4. 配置波形显示
# ===================================================================
echo "==> Configuring waveform display..."
configure wave -signalnamewidth 1
add wave -divider "Testbench Top Level" -r /tb_scrambler_descrambler/*
add wave -divider "Descrambler Internals" -radix hex /tb_scrambler_descrambler/u_descrambler/lfsr_reg

# ===================================================================
# 5. 运行仿真
# ===================================================================
echo "==> Running simulation for 1us..."
run 1us

echo "==> Simulation finished."
