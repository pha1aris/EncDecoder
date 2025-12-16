transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+vio_frame_cfg  -L xil_defaultlib -L xilinx_vip -L xpm -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.vio_frame_cfg xil_defaultlib.glbl

do {vio_frame_cfg.udo}

run 1000ns

endsim

quit -force
