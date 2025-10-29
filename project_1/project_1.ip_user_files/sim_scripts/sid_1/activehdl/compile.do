transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib activehdl/xilinx_vip
vlib activehdl/xpm
vlib activehdl/xbip_utils_v3_0_14
vlib activehdl/axi_utils_v2_0_10
vlib activehdl/c_reg_fd_v12_0_10
vlib activehdl/xbip_dsp48_wrapper_v3_0_6
vlib activehdl/xbip_pipe_v3_0_10
vlib activehdl/c_addsub_v12_0_19
vlib activehdl/c_compare_v12_0_10
vlib activehdl/c_counter_binary_v12_0_20
vlib activehdl/c_shift_ram_v12_0_18
vlib activehdl/mult_gen_v12_0_22
vlib activehdl/rs_toolbox_v9_0_14
vlib activehdl/sid_v8_0_22
vlib activehdl/xil_defaultlib

vmap xilinx_vip activehdl/xilinx_vip
vmap xpm activehdl/xpm
vmap xbip_utils_v3_0_14 activehdl/xbip_utils_v3_0_14
vmap axi_utils_v2_0_10 activehdl/axi_utils_v2_0_10
vmap c_reg_fd_v12_0_10 activehdl/c_reg_fd_v12_0_10
vmap xbip_dsp48_wrapper_v3_0_6 activehdl/xbip_dsp48_wrapper_v3_0_6
vmap xbip_pipe_v3_0_10 activehdl/xbip_pipe_v3_0_10
vmap c_addsub_v12_0_19 activehdl/c_addsub_v12_0_19
vmap c_compare_v12_0_10 activehdl/c_compare_v12_0_10
vmap c_counter_binary_v12_0_20 activehdl/c_counter_binary_v12_0_20
vmap c_shift_ram_v12_0_18 activehdl/c_shift_ram_v12_0_18
vmap mult_gen_v12_0_22 activehdl/mult_gen_v12_0_22
vmap rs_toolbox_v9_0_14 activehdl/rs_toolbox_v9_0_14
vmap sid_v8_0_22 activehdl/sid_v8_0_22
vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xilinx_vip  -sv2k12 "+incdir+D:/2024_2/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xbip_utils_v3_0_14 -l axi_utils_v2_0_10 -l c_reg_fd_v12_0_10 -l xbip_dsp48_wrapper_v3_0_6 -l xbip_pipe_v3_0_10 -l c_addsub_v12_0_19 -l c_compare_v12_0_10 -l c_counter_binary_v12_0_20 -l c_shift_ram_v12_0_18 -l mult_gen_v12_0_22 -l rs_toolbox_v9_0_14 -l sid_v8_0_22 -l xil_defaultlib \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -sv2k12 "+incdir+D:/2024_2/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xbip_utils_v3_0_14 -l axi_utils_v2_0_10 -l c_reg_fd_v12_0_10 -l xbip_dsp48_wrapper_v3_0_6 -l xbip_pipe_v3_0_10 -l c_addsub_v12_0_19 -l c_compare_v12_0_10 -l c_counter_binary_v12_0_20 -l c_shift_ram_v12_0_18 -l mult_gen_v12_0_22 -l rs_toolbox_v9_0_14 -l sid_v8_0_22 -l xil_defaultlib \
"D:/2024_2/Vivado/2024.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/2024_2/Vivado/2024.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93  \
"D:/2024_2/Vivado/2024.2/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xbip_utils_v3_0_14 -93  \
"../../../ipstatic/hdl/xbip_utils_v3_0_vh_rfs.vhd" \

vcom -work axi_utils_v2_0_10 -93  \
"../../../ipstatic/hdl/axi_utils_v2_0_vh_rfs.vhd" \

vcom -work c_reg_fd_v12_0_10 -93  \
"../../../ipstatic/hdl/c_reg_fd_v12_0_vh_rfs.vhd" \

vcom -work xbip_dsp48_wrapper_v3_0_6 -93  \
"../../../ipstatic/hdl/xbip_dsp48_wrapper_v3_0_vh_rfs.vhd" \

vcom -work xbip_pipe_v3_0_10 -93  \
"../../../ipstatic/hdl/xbip_pipe_v3_0_vh_rfs.vhd" \

vcom -work c_addsub_v12_0_19 -93  \
"../../../ipstatic/hdl/c_addsub_v12_0_vh_rfs.vhd" \

vcom -work c_compare_v12_0_10 -93  \
"../../../ipstatic/hdl/c_compare_v12_0_vh_rfs.vhd" \

vcom -work c_counter_binary_v12_0_20 -93  \
"../../../ipstatic/hdl/c_counter_binary_v12_0_vh_rfs.vhd" \

vcom -work c_shift_ram_v12_0_18 -93  \
"../../../ipstatic/hdl/c_shift_ram_v12_0_vh_rfs.vhd" \

vcom -work mult_gen_v12_0_22 -93  \
"../../../ipstatic/hdl/mult_gen_v12_0_vh_rfs.vhd" \

vcom -work rs_toolbox_v9_0_14 -93  \
"../../../ipstatic/hdl/rs_toolbox_v9_0_vh_rfs.vhd" \

vcom -work sid_v8_0_22 -93  \
"../../../ipstatic/hdl/sid_v8_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  \
"../../../../project_1.gen/sources_1/ip/sid_1/sim/sid_1.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

