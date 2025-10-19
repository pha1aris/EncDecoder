# =====================================================
# 1. 清理 & 建库
# =====================================================
vdel -all
vlib work
vmap work work

# =====================================================
# 2. 编译源文件 (RTL 在 src，TB 在 sim)
# =====================================================
# RTL 文件
vlog ../src/pre_interleaver.v
vlog ../src/de_interleaver.v
vlog ../src/pre_interleaver_v1.v
vlog ../src/de_interleaver_v1.v
vlog ../src/gtwizard_ultrascale_0_prbs_any.v
# Testbench 文件
vlog ../sim/per_interleaver_sim.v

# =====================================================
# 3. 仿真
# =====================================================
vsim -gui -voptargs="+acc" work.per_interleaver_sim

# =====================================================
# 4. 配置波形显示
# =====================================================
# 显示完整信号名
configure wave -signalnamewidth 1

# 添加模块信号到波形窗口
# 注意：实例名必须和 testbench 中的实例一致
add wave -r sim:/per_interleaver_sim/u_pre_interleaver/*
add wave -r sim:/per_interleaver_sim/u_de_interleaver/*
add wave -r sim:/per_interleaver_sim/u_pre_interleaver_v1/*
add wave -r sim:/per_interleaver_sim/u_de_interleaver_v1/*
add wave -r sim:/per_gtwizard_ultrascale_0_prbs_any.v/*
# =====================================================
# 5. 运行仿真
# =====================================================
run 10us
