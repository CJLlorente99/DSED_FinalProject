-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
-- Date        : Wed Nov 18 11:39:42 2020
-- Host        : LAPTOP-C5U9VH29 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top clk_wiz_12mhz -prefix
--               clk_wiz_12mhz_ clk_wiz_12mhz_stub.vhdl
-- Design      : clk_wiz_12mhz
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_wiz_12mhz is
  Port ( 
    clk_12Mhz : out STD_LOGIC;
    reset : in STD_LOGIC;
    clk_100Mhz : in STD_LOGIC
  );

end clk_wiz_12mhz;

architecture stub of clk_wiz_12mhz is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_12Mhz,reset,clk_100Mhz";
begin
end;
