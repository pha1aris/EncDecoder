# =================================================================
# 1. 清理 & 建库 (Clean & Create Library)
# =================================================================
if {[file isdirectory work]} {
    vdel -all
}
vlib work
vmap work work

# --- 映射部分：只保留你设计中实际用到的库 ---
vmap rs_decoder_v9_0_23 D:/2024_2/Vivado/2024.2/modelsim_lib_usplus/rs_decoder_v9_0_23
vmap rs_encoder_v9_0_22 D:/2024_2/Vivado/2024.2/modelsim_lib_usplus/rs_encoder_v9_0_22
vmap axi_utils_v2_0_10  D:/2024_2/Vivado/2024.2/modelsim_lib_usplus/axi_utils_v2_0_10
vmap xbip_pipe_v3_0_10  D:/2024_2/Vivado/2024.2/modelsim_lib_usplus/xbip_pipe_v3_0_10
vmap xbip_utils_v3_0_14 D:/2024_2/Vivado/2024.2/modelsim_lib_usplus/xbip_utils_v3_0_14
vmap rs_toolbox_v9_0_14 D:/2024_2/Vivado/2024.2/modelsim_lib_usplus/rs_toolbox_v9_0_14
# --- 映射部分结束 ---

# =====================================================
# 2. 编译源文件 (RTL 在 src，TB 在 sim)
# =====================================================
# 我将编译命令合并以提高效率
vlog ../src/*.v
vlog ../ip/*.v
vcom ../ip/rs_decoder_0.vhd
vcom ../ip/rs_encoder_0.vhd
vlog ../sim/loopback_tb.v

# =====================================================
# 3. 仿真启动 (最终干净版)
# =====================================================
# 使用 -novopt 解决版本兼容问题，并只链接需要的库
vsim -novopt -gui work.loopback_tb \
     -L unisim \
     -L fifo_generator_v13_2_11 \
     -L xpm \
     -L rs_decoder_v9_0_23 \
     -L rs_encoder_v9_0_22 \
     -L axi_utils_v2_0_10 \
     -L xbip_pipe_v3_0_10 \
     -L xbip_utils_v3_0_14 \
     -L rs_toolbox_v9_0_14
# =====================================================
# 4. 配置波形显示
# =====================================================
configure wave -signalnamewidth 1
add wave -r sim:/loopback_tb/*

# =====================================================
# 5. 运行仿真
# =====================================================
run 10us