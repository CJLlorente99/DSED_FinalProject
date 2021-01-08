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
    constant factor_size : integer := 11;
    
    -- 7 segments refresh rate
    constant refresh_rate : integer := 12000;
    
    -- 7 segments useful constant
    constant zero_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "1000000";
    constant one_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "1111001";
    constant two_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "0100100";
    constant three_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "0110000";
    constant four_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "0011001";
    constant five_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "0010010";
    constant six_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "0000010";
    constant seven_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "1111000";
    constant eight_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "0000000";
    constant nine_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "0010000";
    
    -- Filter coefs:
        -- High pass
        constant c0_high : signed(sample_size-1 downto 0) := "11111111";
        constant c1_high : signed(sample_size-1 downto 0) := "11100110";
        constant c2_high : signed(sample_size-1 downto 0) := "01001101";
        constant c3_high : signed(sample_size-1 downto 0) := "11100110";
        constant c4_high : signed(sample_size-1 downto 0) := "11111111";
        -- Low pass
        constant c0_low : signed(sample_size-1 downto 0) := "00000101";
        constant c1_low : signed(sample_size-1 downto 0) := "00011111";
        constant c2_low : signed(sample_size-1 downto 0) := "00111001";
        constant c3_low : signed(sample_size-1 downto 0) := "00011111";
        constant c4_low : signed(sample_size-1 downto 0) := "00000101";
        
    -- Volume coefs (format 4.7 if factor_size = 11)
        constant volume0 : unsigned(factor_size-1 downto 0) := "00000000000";
        constant volume1 : unsigned(factor_size-1 downto 0) := "00000000101";
        constant volume2 : unsigned(factor_size-1 downto 0) := "00000001010";
        constant volume3 : unsigned(factor_size-1 downto 0) := "00000010001";
        constant volume4 : unsigned(factor_size-1 downto 0) := "00000011001";
        constant volume5 : unsigned(factor_size-1 downto 0) := "00000100011";
        constant volume6 : unsigned(factor_size-1 downto 0) := "00000101111";
        constant volume7 : unsigned(factor_size-1 downto 0) := "00000111110";
        constant volume8 : unsigned(factor_size-1 downto 0) := "00001010000";
        constant volume9 : unsigned(factor_size-1 downto 0) := "00001100110";
        constant volume10 : unsigned(factor_size-1 downto 0) := "00010000000";
        constant volume11 : unsigned(factor_size-1 downto 0) := "00010100000";
        constant volume12 : unsigned(factor_size-1 downto 0) := "00011000111";
        constant volume13 : unsigned(factor_size-1 downto 0) := "00011110110";
        constant volume14 : unsigned(factor_size-1 downto 0) := "00100110000";
        constant volume15 : unsigned(factor_size-1 downto 0) := "00101110110";
        constant volume16 : unsigned(factor_size-1 downto 0) := "00111001011";
        constant volume17 : unsigned(factor_size-1 downto 0) := "01000110010";
        constant volume18 : unsigned(factor_size-1 downto 0) := "01010101111";
        constant volume19 : unsigned(factor_size-1 downto 0) := "01101000111";
        constant volume20 : unsigned(factor_size-1 downto 0) := "10000000000";
    
end package_dsed;