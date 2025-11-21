transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib activehdl/xilinx_vip
vlib activehdl/xpm
vlib activehdl/gtwizard_ultrascale_v1_7_19
vlib activehdl/xil_defaultlib

vmap xilinx_vip activehdl/xilinx_vip
vmap xpm activehdl/xpm
vmap gtwizard_ultrascale_v1_7_19 activehdl/gtwizard_ultrascale_v1_7_19
vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xilinx_vip  -sv2k12 "+incdir+D:/2024_2/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l gtwizard_ultrascale_v1_7_19 -l xil_defaultlib \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"D:/2024_2/Vivado/2024.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -sv2k12 "+incdir+D:/2024_2/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l gtwizard_ultrascale_v1_7_19 -l xil_defaultlib \
"D:/2024_2/Vivado/2024.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/2024_2/Vivado/2024.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93  \
"D:/2024_2/Vivado/2024.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work gtwizard_ultrascale_v1_7_19  -v2k5 "+incdir+D:/2024_2/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l gtwizard_ultrascale_v1_7_19 -l xil_defaultlib \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_bit_sync.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gte4_drp_arb.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gthe4_delay_powergood.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtye4_delay_powergood.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gthe3_cpll_cal.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gthe3_cal_freqcnt.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gthe4_cpll_cal.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gthe4_cpll_cal_rx.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gthe4_cpll_cal_tx.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gthe4_cal_freqcnt.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtye4_cpll_cal.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtye4_cpll_cal_rx.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtye4_cpll_cal_tx.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtye4_cal_freqcnt.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtwiz_buffbypass_rx.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtwiz_buffbypass_tx.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtwiz_reset.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtwiz_userclk_rx.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtwiz_userclk_tx.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtwiz_userdata_rx.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtwiz_userdata_tx.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_reset_sync.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_reset_inv_sync.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+D:/2024_2/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l gtwizard_ultrascale_v1_7_19 -l xil_defaultlib \
"../../../../project_1.gen/sources_1/ip/gtwizard_ultrascale_0/sim/gtwizard_ultrascale_v1_7_gthe4_channel.v" \
"../../../../project_1.gen/sources_1/ip/gtwizard_ultrascale_0/sim/gtwizard_ultrascale_0_gthe4_channel_wrapper.v" \
"../../../../project_1.gen/sources_1/ip/gtwizard_ultrascale_0/sim/gtwizard_ultrascale_v1_7_gthe4_common.v" \
"../../../../project_1.gen/sources_1/ip/gtwizard_ultrascale_0/sim/gtwizard_ultrascale_0_gthe4_common_wrapper.v" \
"../../../../project_1.gen/sources_1/ip/gtwizard_ultrascale_0/sim/gtwizard_ultrascale_0_gtwizard_gthe4.v" \
"../../../../project_1.gen/sources_1/ip/gtwizard_ultrascale_0/sim/gtwizard_ultrascale_0_gtwizard_top.v" \
"../../../../project_1.gen/sources_1/ip/gtwizard_ultrascale_0/sim/gtwizard_ultrascale_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

