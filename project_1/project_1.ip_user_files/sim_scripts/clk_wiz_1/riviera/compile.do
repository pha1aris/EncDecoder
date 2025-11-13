transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xilinx_vip
vlib riviera/xpm
vlib riviera/xil_defaultlib

vmap xilinx_vip riviera/xilinx_vip
vmap xpm riviera/xpm
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xilinx_vip  -l axi_vip_v1_1_19 -l smartconnect_v1_0 -l zynq_ultra_ps_e_vip_v1_0_19 "+incdir+D:/2024_2/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -l axi_vip_v1_1_19 -l smartconnect_v1_0 -l zynq_ultra_ps_e_vip_v1_0_19 "+incdir+../../../ipstatic" "+incdir+D:/2024_2/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib \
"D:/2024_2/Vivado/2024.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93  \
"D:/2024_2/Vivado/2024.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic" "+incdir+D:/2024_2/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib \
"../../../../project_1.gen/sources_1/ip/clk_wiz_1/clk_wiz_1_clk_wiz.v" \
"../../../../project_1.gen/sources_1/ip/clk_wiz_1/clk_wiz_1.v" \

vlog -work xil_defaultlib \
"glbl.v"

