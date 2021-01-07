----------------------------------------------------------------------------------
-- Company: Grupo 9
-- Engineer: CJLL & ITI
-- 
-- Create Date: 09.11.2020 16:50:05
-- Design Name: -
-- Module Name: enable_generator - Behavioral
-- Project Name: Sistema de grabación, tratamiento y reproducción de audio
-- Target Devices: 
-- Tool Versions: 
-- Description: This component creates various pulses at different rates, needed in several components belonging to audio_interface
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

entity enable_generator is
    Port ( clk_12megas : in STD_LOGIC; -- System clock
           reset : in STD_LOGIC; -- Asynchronous reset
           clk_3megas : out STD_LOGIC;
           en_2_cycles : out STD_LOGIC;
           en_4_cycles : out STD_LOGIC
           );
end enable_generator;

architecture Behavioral of enable_generator is
    -- Signal declaration
        -- Registers
        signal count, next_count : unsigned(1 downto 0);
    
begin

    -- Register
        process (clk_12megas, reset)
        begin
            if reset = '1' then
                count <= "00";
            elsif rising_edge(clk_12megas) then
                count <= next_count;
            end if;
        end process;
    
    -- Next-state logic
        next_count <= count + 1;
    
    -- Output logic
        clk_3megas <= '1' when (count = 2 or count = 3) else
                      '0';
                      
        en_2_cycles <= '1' when (count = 1 or count = 3) else
                       '0';
                       
        en_4_cycles <= '1' when count = 2 else
                       '0';
    
end Behavioral;
