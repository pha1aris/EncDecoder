onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -voptargs="+acc=npr" -L xil_defaultlib -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -L xpm -lib xil_defaultlib xil_defaultlib.ila_fec_rx xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

log -r /*

do {ila_fec_rx.udo}

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
