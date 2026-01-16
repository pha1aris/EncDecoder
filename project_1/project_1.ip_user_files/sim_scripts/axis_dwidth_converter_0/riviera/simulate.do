transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+axis_dwidth_converter_0  -L xil_defaultlib -L xilinx_vip -L xpm -L axis_infrastructure_v1_1_1 -L axis_register_slice_v1_1_33 -L axis_dwidth_converter_v1_1_32 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.axis_dwidth_converter_0 xil_defaultlib.glbl

do {axis_dwidth_converter_0.udo}

run 1000ns

endsim

quit -force
