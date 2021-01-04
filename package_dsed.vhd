----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.11.2020 10:54:15
-- Design Name: 
-- Module Name: package_dsed
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package package_dsed is
    
    constant sample_size :integer := 8;
    
    -- Filter coefs:
        -- High pass
        constant c0_high : signed(sample_size-1 downto 0) := "11111111";
        constant c1_high : signed(sample_size-1 downto 0) := "11100110";
        constant c2_high : signed(sample_size-1 downto 0) := "01001101";
        constant c3_high : signed(sample_size-1 downto 0) := "11100110";
        constant c4_high : signed(sample_size-1 downto 0) := "11111111";
        constant c0_low : signed(sample_size-1 downto 0) := "00000101";
        constant c1_low : signed(sample_size-1 downto 0) := "00011111";
        constant c2_low : signed(sample_size-1 downto 0) := "00111001";
        constant c3_low : signed(sample_size-1 downto 0) := "00011111";
        constant c4_low : signed(sample_size-1 downto 0) := "00000101";
         
    
end package_dsed;