----------------------------------------------------------------------------------
-- Company: Grupo 9
-- Engineer: CJLL & ITI
-- 
-- Create Date: 09.11.2020 10:54:15
-- Design Name: 
-- Module Name: package_dsed
-- Project Name: Sistema de grabación, tratamiento y reproducción de audio
-- Target Devices: 
-- Tool Versions: 
-- Description: Package containing usefull constants
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 1.00 - File finished
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package package_dsed is
    
        constant sample_size : integer := 8;
        constant factor_size : integer := 11;
        
    -- Sampling rate
        constant sampling_rate : UNSIGNED(21 downto 0) := "0000000000000001101001"; -- format (1.21)
    
    -- 7 segments refresh rate
        constant refresh_rate : integer := 12000;
        constant rotation_rate : integer := 50;
    
    -- type definition for 7 seg purposes  
        type seven_seg_info is array (natural range <>) of UNSIGNED(6 downto 0);
        
    -- info length
        constant info_length : integer := 44;
    
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
        constant blank_7_seg : STD_LOGIC_VECTOR (6 downto 0) := (others => '1');
        
        constant A_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "0001000";
        constant B_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "0000011";
        constant C_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "0100111";
        constant D_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "0100001";
        constant E_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "0000110";
        constant F_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "0001110";
        constant G_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "0000010";
        constant H_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "0001001";
        constant I_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "1101111";
        constant J_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "1100001";
        constant K_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "1111111";
        constant L_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "1000111";
        constant M_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "0101011";
        constant N_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "0101011";
        constant O_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "0100011";
        constant P_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "0001100";
        constant Q_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "0011000";
        constant R_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "0101111";
        constant S_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "0010010";
        constant T_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "1001110";
        constant U_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "1100011";
        constant V_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "1000001";
        constant W_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "1111111";
        constant X_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "1111111";
        constant Y_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "0001101";
        constant Z_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "0100100";
        
        constant barra_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "1001001";
        constant igual_7_seg : STD_LOGIC_VECTOR (6 downto 0) := "0110111";
        
        constant number_0 : integer := 0;
        constant number_1 : integer := 1;
        constant number_2 : integer := 2;
        constant number_3 : integer := 3;
        constant number_4 : integer := 4;
        constant number_5 : integer := 5;
        constant number_6 : integer := 6;
        constant number_7 : integer := 7;
        constant number_8 : integer := 8;
        constant number_9 : integer := 9;
        constant letter_A : integer := 10;
        constant letter_B : integer := 11;
        constant letter_C : integer := 12;
        constant letter_D : integer := 13;
        constant letter_E : integer := 14;
        constant letter_F : integer := 15;
        constant letter_G : integer := 16;
        constant letter_H : integer := 17;
        constant letter_I : integer := 18;
        constant letter_J : integer := 19;
        constant letter_K : integer := 20;
        constant letter_L : integer := 21;
        constant letter_M : integer := 22;
        constant letter_N : integer := 23;
        constant letter_O : integer := 24;
        constant letter_P : integer := 25;
        constant letter_Q : integer := 26;
        constant letter_R : integer := 27;
        constant letter_S : integer := 28;
        constant letter_T : integer := 29;
        constant letter_U : integer := 30;
        constant letter_V : integer := 31;
        constant letter_W : integer := 32;
        constant letter_X : integer := 33;
        constant letter_Y : integer := 34;
        constant letter_Z : integer := 35;
        
        constant symbol_igual : integer := 36;
        constant symbol_barras : integer := 37;  
    
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
        
    -- Max address possible in RAM
        constant MAX_ADDRESS : UNSIGNED(18 downto 0) := (others => '1');
        
end package_dsed;
        