transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+rasterizer_ee712  -L xilinx_vip -L xpm -L axi_infrastructure_v1_1_0 -L axi_vip_v1_1_15 -L processing_system7_vip_v1_0_17 -L xil_defaultlib -L lib_cdc_v1_0_2 -L proc_sys_reset_v5_0_14 -L xlconstant_v1_1_8 -L smartconnect_v1_0 -L axi_register_slice_v2_1_29 -L axi_lite_ipif_v3_0_4 -L interrupt_control_v3_1_5 -L axi_gpio_v2_0_31 -L v_tc_v6_2_7 -L v_tc_v6_1_13 -L v_vid_in_axi4s_v4_0_11 -L v_axi4s_vid_out_v4_0_17 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.rasterizer_ee712 xil_defaultlib.glbl

do {rasterizer_ee712.udo}

run 1000ns

endsim

quit -force
