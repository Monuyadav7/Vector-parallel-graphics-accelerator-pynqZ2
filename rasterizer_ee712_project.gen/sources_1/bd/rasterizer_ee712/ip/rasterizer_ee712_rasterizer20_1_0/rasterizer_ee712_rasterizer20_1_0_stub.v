// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Thu May  1 14:37:47 2025
// Host        : aicaslab10 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/root/Downloads/rasterizer_ee712_project/rasterizer_ee712_project.gen/sources_1/bd/rasterizer_ee712/ip/rasterizer_ee712_rasterizer20_1_0/rasterizer_ee712_rasterizer20_1_0_stub.v
// Design      : rasterizer_ee712_rasterizer20_1_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "rasterizer20,Vivado 2023.2" *)
module rasterizer_ee712_rasterizer20_1_0(S_AXI_ACLK, S_AXI_ARESETN, S_AXI_AWADDR, 
  S_AXI_AWVALID, S_AXI_AWREADY, S_AXI_WDATA, S_AXI_WVALID, S_AXI_WREADY, S_AXI_BRESP, 
  S_AXI_BVALID, S_AXI_BREADY, S_AXI_ARADDR, S_AXI_ARVALID, S_AXI_ARREADY, S_AXI_RDATA, 
  S_AXI_RRESP, S_AXI_RVALID, S_AXI_RREADY, m_axis_tdata, m_axis_tvalid, m_axis_tready, 
  m_axis_tlast, m_axis_tuser)
/* synthesis syn_black_box black_box_pad_pin="S_AXI_ARESETN,S_AXI_AWADDR[7:0],S_AXI_AWVALID,S_AXI_AWREADY,S_AXI_WDATA[31:0],S_AXI_WVALID,S_AXI_WREADY,S_AXI_BRESP[1:0],S_AXI_BVALID,S_AXI_BREADY,S_AXI_ARADDR[7:0],S_AXI_ARVALID,S_AXI_ARREADY,S_AXI_RDATA[31:0],S_AXI_RRESP[1:0],S_AXI_RVALID,S_AXI_RREADY,m_axis_tdata[23:0],m_axis_tvalid,m_axis_tready,m_axis_tlast,m_axis_tuser" */
/* synthesis syn_force_seq_prim="S_AXI_ACLK" */;
  input S_AXI_ACLK /* synthesis syn_isclock = 1 */;
  input S_AXI_ARESETN;
  input [7:0]S_AXI_AWADDR;
  input S_AXI_AWVALID;
  output S_AXI_AWREADY;
  input [31:0]S_AXI_WDATA;
  input S_AXI_WVALID;
  output S_AXI_WREADY;
  output [1:0]S_AXI_BRESP;
  output S_AXI_BVALID;
  input S_AXI_BREADY;
  input [7:0]S_AXI_ARADDR;
  input S_AXI_ARVALID;
  output S_AXI_ARREADY;
  output [31:0]S_AXI_RDATA;
  output [1:0]S_AXI_RRESP;
  output S_AXI_RVALID;
  input S_AXI_RREADY;
  output [23:0]m_axis_tdata;
  output m_axis_tvalid;
  input m_axis_tready;
  output m_axis_tlast;
  output m_axis_tuser;
endmodule
