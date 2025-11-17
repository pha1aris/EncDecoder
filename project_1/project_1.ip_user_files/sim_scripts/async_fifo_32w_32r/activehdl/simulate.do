transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+async_fifo_32w_32r  -L xil_defaultlib -L xilinx_vip -L xpm -L fifo_generator_v13_2_11 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.async_fifo_32w_32r xil_defaultlib.glbl

do {async_fifo_32w_32r.udo}

run 1000ns

endsim

quit -force
