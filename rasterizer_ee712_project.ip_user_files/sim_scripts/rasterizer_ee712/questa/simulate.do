onbreak {quit -f}
onerror {quit -f}

vsim  -lib xil_defaultlib rasterizer_ee712_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {rasterizer_ee712.udo}

run 1000ns

quit -force
