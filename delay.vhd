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
        
        signal reg : REGS(MAX_DELAY-1 downto 1);
        
    -- Constants
        constant max_level : unsigned(4 downto 0) := to_unsigned(20, 5);
        constant min_level : unsigned(4 downto 0) := (others => '0');
        constant SATURATION_VALUE : STD_LOGIC_VECTOR(sample_size - 1 downto 0) := (others => '1');

begin

    -- Register
        process (clk, reset)
        begin
            if reset = '1' then
                for i in 1 to (MAX_DELAY -1) loop
                    reg(i) <= (others => '0');
                end loop;
            elsif rising_edge(clk) then
                count <= next_count;
                level <= next_level;
--                auxiliar_sig <= next_auxiliar_sig;
                
                -- Memory refreshing
                if original_sig_ready = '1' then
                
                    additive <= next_additive;
                    reg(1) <= original_sig;
                    
                    for i in 2 to (MAX_DELAY-1) loop
                        reg(i) <= reg(i-1);
                    end loop;
                end if;  
            end if;
        end process;
        
    -- Next state logic
        next_count <= count + 1;
                      
        next_level <= level + 1 when increase = '1' and level /= max_level and count = 10 else -- It doesn't matter when the button is checked 
                      level - 1 when decrease = '1' and level /= min_level and count = 10 else -- as lolg as there is no conflict with "reset"
                      level;
                      
        next_additive <= reg(1) when level = 1 else
                         reg(3) when level = 2 else
                         reg(5) when level = 3 else
                         reg(7) when level = 4 else
                         reg(9) when level = 5 else
                         reg(11) when level = 6 else
                         reg(13) when level = 7 else
                         reg(15) when level = 8 else
                         reg(17) when level = 9 else
                         reg(19) when level = 10 else
                         reg(21) when level = 11 else
                         reg(23) when level = 12 else
                         reg(25) when level = 13 else
                         reg(27) when level = 14 else
                         reg(29) when level = 15 else
                         reg(31) when level = 16 else
                         reg(33) when level = 17 else
                         reg(35) when level = 18 else
                         reg(37) when level = 19 else
                         reg(39) when level = 20 else
        --                    original_sig;
                         (others => '0');
                                        
    -- Output logic
        auxiliar_sig <= std_logic_vector(unsigned('0' & original_sig) + ("000" & (unsigned(additive(sample_size - 1 downto 2)))));
                       
        delayed_sig <= auxiliar_sig(sample_size - 1 downto 0) when auxiliar_sig(sample_size) = '0' else
                       SATURATION_VALUE;
                       
        actual_level <= std_logic_vector(level);
        
end Behavioral;
