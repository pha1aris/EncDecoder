onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -voptargs="+acc=npr" -L xil_defaultlib -L xbip_utils_v3_0_14 -L axi_utils_v2_0_10 -L xbip_pipe_v3_0_10 -L xbip_dsp48_wrapper_v3_0_6 -L mult_gen_v12_0_22 -L floating_point_v7_0_24 -L div_gen_v5_1_23 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -L xpm -lib xil_defaultlib xil_defaultlib.div_gen_0 xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

log -r /*

do {div_gen_0.udo}

# execute post tcl file
set rc [catch {
  puts "source wave nameformat short"
  source "wave nameformat short"
} result]
if {$rc} {
  puts "$result"
  puts "ERROR: \[exportsim-Tcl-1\] Script failed:wave nameformat short"
}

run 0

quit -force
