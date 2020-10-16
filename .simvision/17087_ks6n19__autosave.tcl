
# NC-Sim Command File
# TOOL:	ncsim(64)	15.20-s058
#

set tcl_prompt1 {puts -nonewline "ncsim> "}
set tcl_prompt2 {puts -nonewline "> "}
set vlog_format %h
set vhdl_format %v
set real_precision 6
set display_unit auto
set time_unit module
set heap_garbage_size -200
set heap_garbage_time 0
set assert_report_level note
set assert_stop_level error
set autoscope yes
set assert_1164_warnings yes
set pack_assert_off {}
set severity_pack_assert_off {note warning}
set assert_output_stop_level failed
set tcl_debug_level 0
set relax_path_name 1
set vhdl_vcdmap XX01ZX01X
set intovf_severity_level ERROR
set probe_screen_format 0
set rangecnst_severity_level ERROR
set textio_severity_level ERROR
set vital_timing_checks_on 1
set vlog_code_show_force 0
set assert_count_attempts 1
set tcl_all64 false
set tcl_runerror_exit false
set assert_report_incompletes 0
set show_force 1
set force_reset_by_reinvoke 0
set tcl_relaxed_literal 0
set probe_exclude_patterns {}
set probe_packed_limit 4k
set probe_unpacked_limit 16k
set assert_internal_msg no
set svseed 1
set assert_reporting_mode 0
alias . run
alias iprof profile
alias quit exit
database -open -shm -into waves.shm waves
database -open -shm -into memory.shm memory -default
probe -create -database waves de1_soc_wrapper_stim.CLOCK_50 de1_soc_wrapper_stim.KEY de1_soc_wrapper_stim.SW de1_soc_wrapper_stim.LEDR de1_soc_wrapper_stim.HEX0 de1_soc_wrapper_stim.HEX1 de1_soc_wrapper_stim.HEX2 de1_soc_wrapper_stim.HEX3 de1_soc_wrapper_stim.VGA_R de1_soc_wrapper_stim.VGA_G de1_soc_wrapper_stim.VGA_B de1_soc_wrapper_stim.VGA_HS de1_soc_wrapper_stim.VGA_VS de1_soc_wrapper_stim.VGA_CLK de1_soc_wrapper_stim.VGA_BLANK_N de1_soc_wrapper_stim.dut.soc_inst.HADDR de1_soc_wrapper_stim.dut.soc_inst.HWRITE de1_soc_wrapper_stim.dut.soc_inst.HSEL_RAM de1_soc_wrapper_stim.dut.soc_inst.HSEL_SW de1_soc_wrapper_stim.dut.soc_inst.HSEL_DOUT
probe -create -database waves de1_soc_wrapper_stim.CLOCK_50 de1_soc_wrapper_stim.KEY de1_soc_wrapper_stim.SW de1_soc_wrapper_stim.LEDR de1_soc_wrapper_stim.HEX0 de1_soc_wrapper_stim.HEX1 de1_soc_wrapper_stim.HEX2 de1_soc_wrapper_stim.HEX3 de1_soc_wrapper_stim.VGA_R de1_soc_wrapper_stim.VGA_G de1_soc_wrapper_stim.VGA_B de1_soc_wrapper_stim.VGA_HS de1_soc_wrapper_stim.VGA_VS de1_soc_wrapper_stim.VGA_CLK de1_soc_wrapper_stim.VGA_BLANK_N de1_soc_wrapper_stim.dut.soc_inst.HADDR de1_soc_wrapper_stim.dut.soc_inst.HWRITE de1_soc_wrapper_stim.dut.soc_inst.HSEL_RAM de1_soc_wrapper_stim.dut.soc_inst.HSEL_SW de1_soc_wrapper_stim.dut.soc_inst.HSEL_DOUT
probe -create -database waves de1_soc_wrapper_stim.CLOCK_50 de1_soc_wrapper_stim.KEY de1_soc_wrapper_stim.SW de1_soc_wrapper_stim.LEDR de1_soc_wrapper_stim.HEX0 de1_soc_wrapper_stim.HEX1 de1_soc_wrapper_stim.HEX2 de1_soc_wrapper_stim.HEX3 de1_soc_wrapper_stim.VGA_R de1_soc_wrapper_stim.VGA_G de1_soc_wrapper_stim.VGA_B de1_soc_wrapper_stim.VGA_HS de1_soc_wrapper_stim.VGA_VS de1_soc_wrapper_stim.VGA_CLK de1_soc_wrapper_stim.VGA_BLANK_N de1_soc_wrapper_stim.dut.soc_inst.HADDR de1_soc_wrapper_stim.dut.soc_inst.HWRITE de1_soc_wrapper_stim.dut.soc_inst.HSEL_RAM de1_soc_wrapper_stim.dut.soc_inst.HSEL_SW de1_soc_wrapper_stim.dut.soc_inst.HSEL_DOUT
probe -create -database waves de1_soc_wrapper_stim.CLOCK_50 de1_soc_wrapper_stim.KEY de1_soc_wrapper_stim.SW de1_soc_wrapper_stim.LEDR de1_soc_wrapper_stim.HEX0 de1_soc_wrapper_stim.HEX1 de1_soc_wrapper_stim.HEX2 de1_soc_wrapper_stim.HEX3 de1_soc_wrapper_stim.VGA_R de1_soc_wrapper_stim.VGA_G de1_soc_wrapper_stim.VGA_B de1_soc_wrapper_stim.VGA_HS de1_soc_wrapper_stim.VGA_VS de1_soc_wrapper_stim.VGA_CLK de1_soc_wrapper_stim.VGA_BLANK_N de1_soc_wrapper_stim.dut.soc_inst.HADDR de1_soc_wrapper_stim.dut.soc_inst.HWRITE de1_soc_wrapper_stim.dut.soc_inst.HSEL_RAM de1_soc_wrapper_stim.dut.soc_inst.HSEL_SW de1_soc_wrapper_stim.dut.soc_inst.HSEL_DOUT
probe -create -database waves de1_soc_wrapper_stim.dut.soc_inst.pix1.pixel_address
probe -create -database memory de1_soc_wrapper_stim.dut.soc_inst.pix1.pixel
probe -create -database memory de1_soc_wrapper_stim.dut.soc_inst.pix1.pixel_x de1_soc_wrapper_stim.dut.soc_inst.pix1.pixel_y

simvision -input /home/ks6n19/Documents/project/.simvision/17087_ks6n19__autosave.tcl.svcf
