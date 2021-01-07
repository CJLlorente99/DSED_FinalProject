----------------------------------------------------------------------------------
-- Company: Grupo 9
-- Engineer: CJLL & ITI
-- 
-- Create Date: 14.11.2020 11:56:40
-- Design Name: -
-- Module Name: pwm - Behavioral
-- Project Name: Sistema de grabación, tratamiento y reproducción de audio
-- Target Devices: 
-- Tool Versions: 
-- Description: This component received STD_L0OGIC_VECTOR data and translates it to PWM data (which can be played by speakers).
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
use work.package_dsed.all;
use IEEE.NUMERIC_STD.ALL;

entity pwm is
    Port ( clk_12megas : in STD_LOGIC; -- System clock
           reset : in STD_LOGIC; -- Asynchronous reset
           en_2_cycles : in STD_LOGIC; -- Input signal in order to work at a 6MHz rate
           sample_in : in STD_LOGIC_VECTOR(sample_size - 1 downto 0); -- Sample to be translated to PWM
           sample_request : out STD_LOGIC; -- Indicator that shows when translation has been completed and new sample_in is to be taken
           pwm_pulse : out STD_LOGIC -- PWM data
           );
end pwm;

architecture Behavioral of pwm is
    -- Signal declaration
        -- Registers
        signal next_count, count : unsigned(8 downto 0) := (others => '0');
        signal sample, next_sample : STD_LOGIC_VECTOR(sample_size - 1 downto 0) := (others => '0');
        
        -- Auxiliar signals
        signal toggle, next_toggle : STD_LOGIC := '0';

begin

    -- Register
        process (clk_12megas, reset) 
        begin
            if reset = '1' then
                count <= (others => '0');
                toggle <= '0';
                sample <= (others => '0');
            elsif rising_edge(clk_12megas) then
            
                toggle <= next_toggle;
                sample <= next_sample;
            
                if en_2_cycles = '1' then
                    count <= next_count;
                end if;
            end if;
        end process;
    
    -- Next state logic
        next_count <= count + 1 when count < 299 else (others => '0');
        next_sample <= sample_in when (count = 299) else
                       sample;
        next_toggle <= not toggle;
    
    --Output logic
        pwm_pulse <= '1' when (unsigned(sample) > count) else '0';
        sample_request <= '1' when (count = 299) and (toggle = '1') else '0';

end Behavioral;
