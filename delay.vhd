----------------------------------------------------------------------------------
-- Company: Grupo 9
-- Engineer: CJLL & ITI
-- 
-- Create Date: 08.01.2021 17:34:48
-- Design Name: 
-- Module Name: delay - Behavioral
-- Project Name: Sistema de grabación, tratamiento y reproducción de audio
-- Target Devices: 
-- Tool Versions: 
-- Description: This module introduces a variable delay
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
use work.package_dsed.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.NUMERIC_STD.ALL;

entity delay is
    Port (
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           increase : in STD_LOGIC;
           decrease : in STD_LOGIC;
           original_sig : in STD_LOGIC_VECTOR(sample_size - 1 downto 0);
           original_sig_ready : in STD_LOGIC;
           delayed_sig : out STD_LOGIC_VECTOR(sample_size - 1 downto 0);
           actual_level : out STD_LOGIC_VECTOR(4 downto 0)
    );
end delay;

architecture Behavioral of delay is

    -- Signals 
        signal next_count, count, max_count : unsigned(22 downto 0) := (others => '0');
        
        signal level, next_level : unsigned(4 downto 0) := (others => '0');
        
        signal next_additive, additive : STD_LOGIC_VECTOR(sample_size - 1 downto 0) := (others => '0');
        
        signal auxiliar_sig, next_auxiliar_sig : STD_LOGIC_VECTOR(sample_size downto 0) := (others => '0');
        
        
        signal reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10 : STD_LOGIC_VECTOR(sample_size - 1 downto 0) := (others => '0');
        signal reg11, reg12, reg13, reg14, reg15, reg16, reg17, reg18, reg19, reg20 : STD_LOGIC_VECTOR(sample_size - 1 downto 0) := (others => '0');
        signal reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, reg30 : STD_LOGIC_VECTOR(sample_size - 1 downto 0) := (others => '0');
        signal reg31, reg32, reg33, reg34, reg35, reg36, reg37, reg38, reg39 : STD_LOGIC_VECTOR(sample_size - 1 downto 0) := (others => '0');
        
    -- Constants
        constant max_level : unsigned(4 downto 0) := to_unsigned(20, 5);
        constant min_level : unsigned(4 downto 0) := (others => '0');
        constant SATURATION_VALUE : STD_LOGIC_VECTOR(sample_size - 1 downto 0) := (others => '1');

begin

    -- Register
        process (clk, reset)
        begin
            if reset = '1' then
                reg1 <= (others => '0');
                reg2 <= (others => '0');
                reg3 <= (others => '0');
                reg4 <= (others => '0');
                reg5 <= (others => '0');
                reg6 <= (others => '0');
                reg7 <= (others => '0');
                reg8 <= (others => '0');
                reg9 <= (others => '0');
                reg10 <= (others => '0');
                reg11 <= (others => '0');
                reg12 <= (others => '0');
                reg13 <= (others => '0');
                reg14 <= (others => '0');
                reg15 <= (others => '0');
                reg16 <= (others => '0');
                reg17 <= (others => '0');
                reg18 <= (others => '0');
                reg19 <= (others => '0');
                reg20 <= (others => '0');
                reg21 <= (others => '0');
                reg22 <= (others => '0');
                reg23 <= (others => '0');
                reg24 <= (others => '0');
                reg25 <= (others => '0');
                reg26 <= (others => '0');
                reg27 <= (others => '0');
                reg28 <= (others => '0');
                reg29 <= (others => '0');
                reg30 <= (others => '0');
                reg31 <= (others => '0');
                reg32 <= (others => '0');
                reg33 <= (others => '0');
                reg34 <= (others => '0');
                reg35 <= (others => '0');
                reg36 <= (others => '0');
                reg37 <= (others => '0');
                reg38 <= (others => '0');
                reg39 <= (others => '0');
            elsif rising_edge(clk) then
                count <= next_count;
                level <= next_level;
                
                -- Memory refreshing
                if original_sig_ready = '1' then
                
                    additive <= next_additive;
                
                    reg1 <= original_sig;
                    reg2 <= reg1;
                    reg3 <= reg2;
                    reg4 <= reg3;
                    reg5 <= reg4;
                    reg6 <= reg5;
                    reg7 <= reg6;
                    reg8 <= reg7;
                    reg9 <= reg8;
                    reg10 <= reg9;
                    reg11 <= reg10;
                    reg12 <= reg11;
                    reg13 <= reg12;
                    reg14 <= reg13;
                    reg15 <= reg14;
                    reg16 <= reg15;
                    reg17 <= reg16;
                    reg18 <= reg17;
                    reg19 <= reg18;
                    reg20 <= reg19;
                    reg21 <= reg20;
                    reg22 <= reg21;
                    reg23 <= reg22;
                    reg24 <= reg23;
                    reg25 <= reg24;
                    reg26 <= reg25;
                    reg27 <= reg26;
                    reg28 <= reg27;
                    reg29 <= reg28;
                    reg30 <= reg29;
                    reg31 <= reg30;
                    reg32 <= reg31;
                    reg33 <= reg32;
                    reg34 <= reg33;
                    reg35 <= reg34;
                    reg36 <= reg35;
                    reg37 <= reg36;
                    reg38 <= reg37;
                    reg39 <= reg38;
                end if;
                    
                
            end if;
        end process;
        
    -- Next state logic
        next_count <= count + 1;
                      
        next_level <= level + 1 when increase = '1' and level /= max_level and count = 10 else -- It doesn't matter when the button is checked 
                      level - 1 when decrease = '1' and level /= min_level and count = 10 else -- as lolg as there is no conflict with "reset"
                      level;
                      
        next_additive <= reg1 when level = 1 else
                         reg3 when level = 2 else
                         reg5 when level = 3 else
                         reg7 when level = 4 else
                         reg9 when level = 5 else
                         reg11 when level = 6 else
                         reg13 when level = 7 else
                         reg15 when level = 8 else
                         reg17 when level = 9 else
                         reg19 when level = 10 else
                         reg21 when level = 11 else
                         reg23 when level = 12 else
                         reg25 when level = 13 else
                         reg27 when level = 14 else
                         reg29 when level = 15 else
                         reg31 when level = 16 else
                         reg33 when level = 17 else
                         reg35 when level = 18 else
                         reg37 when level = 19 else
                         reg39 when level = 20 else
        --                    original_sig;
                         (others => '0');
                      
                      
    -- Output logic
        -- An auxiliar signal is used to check if the sum exceeds the maximum value that can be represented 
        auxiliar_sig <= std_logic_vector(unsigned('0' & original_sig) + ("000" & (unsigned(additive(sample_size - 1 downto 2)))));
                       
        delayed_sig <= auxiliar_sig(sample_size - 1 downto 0) when auxiliar_sig(sample_size) = '0' else
                       SATURATION_VALUE;
                       
        actual_level <= std_logic_vector(level);
        
end Behavioral;
