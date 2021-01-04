// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
// Date        : Wed Nov 18 11:39:42 2020
// Host        : LAPTOP-C5U9VH29 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top clk_wiz_12mhz -prefix
//               clk_wiz_12mhz_ clk_wiz_12mhz_stub.v
// Design      : clk_wiz_12mhz
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_12mhz(clk_12Mhz, reset, clk_100Mhz)
/* synthesis syn_black_box black_box_pad_pin="clk_12Mhz,reset,clk_100Mhz" */;
  output clk_12Mhz;
  input reset;
  input clk_100Mhz;
endmodule
