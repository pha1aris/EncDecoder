vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xilinx_vip
vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/xbip_utils_v3_0_14
vlib modelsim_lib/msim/axi_utils_v2_0_10
vlib modelsim_lib/msim/c_reg_fd_v12_0_10
vlib modelsim_lib/msim/xbip_dsp48_wrapper_v3_0_6
vlib modelsim_lib/msim/xbip_pipe_v3_0_10
vlib modelsim_lib/msim/c_addsub_v12_0_19
vlib modelsim_lib/msim/c_compare_v12_0_10
vlib modelsim_lib/msim/c_counter_binary_v12_0_20
vlib modelsim_lib/msim/c_shift_ram_v12_0_18
vlib modelsim_lib/msim/mult_gen_v12_0_22
vlib modelsim_lib/msim/rs_toolbox_v9_0_14
vlib modelsim_lib/msim/sid_v8_0_22
vlib modelsim_lib/msim/xil_defaultlib

vmap xilinx_vip modelsim_lib/msim/xilinx_vip
vmap xpm modelsim_lib/msim/xpm
vmap xbip_utils_v3_0_14 modelsim_lib/msim/xbip_utils_v3_0_14
vmap axi_utils_v2_0_10 modelsim_lib/msim/axi_utils_v2_0_10
vmap c_reg_fd_v12_0_10 modelsim_lib/msim/c_reg_fd_v12_0_10
vmap xbip_dsp48_wrapper_v3_0_6 modelsim_lib/msim/xbip_dsp48_wrapper_v3_0_6
vmap xbip_pipe_v3_0_10 modelsim_lib/msim/xbip_pipe_v3_0_10
vmap c_addsub_v12_0_19 modelsim_lib/msim/c_addsub_v12_0_19
vmap c_compare_v12_0_10 modelsim_lib/msim/c_compare_v12_0_10
vmap c_counter_binary_v12_0_20 modelsim_lib/msim/c_counter_binary_v12_0_20
vmap c_shift_ram_v12_0_18 modelsim_lib/msim/c_shift_ram_v12_0_18
vmap mult_gen_v12_0_22 modelsim_lib/msim/mult_gen_v12_0_22
vmap rs_toolbox_v9_0_14 modelsim_lib/msim/rs_toolbox_v9_0_14
vmap sid_v8_0_22 modelsim_lib/msim/sid_v8_0_22
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xilinx_vip  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+D:/2024_2/Vivado/2024.2/data/xilinx_vip/include" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+D:/2024_2/Vivado/2024.2/data/xilinx_vip/include" \
"D:/2024_2/Vivado/2024.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/2024_2/Vivado/2024.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm  -93  \
"D:/2024_2/Vivado/2024.2/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xbip_utils_v3_0_14  -93  \
"../../../ipstatic/hdl/xbip_utils_v3_0_vh_rfs.vhd" \

vcom -work axi_utils_v2_0_10  -93  \
"../../../ipstatic/hdl/axi_utils_v2_0_vh_rfs.vhd" \

vcom -work c_reg_fd_v12_0_10  -93  \
"../../../ipstatic/hdl/c_reg_fd_v12_0_vh_rfs.vhd" \

vcom -work xbip_dsp48_wrapper_v3_0_6  -93  \
"../../../ipstatic/hdl/xbip_dsp48_wrapper_v3_0_vh_rfs.vhd" \

vcom -work xbip_pipe_v3_0_10  -93  \
"../../../ipstatic/hdl/xbip_pipe_v3_0_vh_rfs.vhd" \

vcom -work c_addsub_v12_0_19  -93  \
"../../../ipstatic/hdl/c_addsub_v12_0_vh_rfs.vhd" \

vcom -work c_compare_v12_0_10  -93  \
"../../../ipstatic/hdl/c_compare_v12_0_vh_rfs.vhd" \

vcom -work c_counter_binary_v12_0_20  -93  \
"../../../ipstatic/hdl/c_counter_binary_v12_0_vh_rfs.vhd" \

vcom -work c_shift_ram_v12_0_18  -93  \
"../../../ipstatic/hdl/c_shift_ram_v12_0_vh_rfs.vhd" \

vcom -work mult_gen_v12_0_22  -93  \
"../../../ipstatic/hdl/mult_gen_v12_0_vh_rfs.vhd" \

vcom -work rs_toolbox_v9_0_14  -93  \
"../../../ipstatic/hdl/rs_toolbox_v9_0_vh_rfs.vhd" \

vcom -work sid_v8_0_22  -93  \
"../../../ipstatic/hdl/sid_v8_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93  \
"../../../../project_1.gen/sources_1/ip/sid_0/sim/sid_0.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

