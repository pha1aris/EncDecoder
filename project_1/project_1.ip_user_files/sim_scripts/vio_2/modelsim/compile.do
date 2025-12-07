vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/ip/vio_2/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/ip/vio_2/hdl" "+incdir+D:/2024_2/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/ip/vio_2/sim/vio_2.v" \


vlog -work xil_defaultlib \
"glbl.v"

