transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+ila_fec_rx  -L xil_defaultlib -L xilinx_vip -L xpm -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.ila_fec_rx xil_defaultlib.glbl

do {ila_fec_rx.udo}

run 1000ns

endsim

quit -force
