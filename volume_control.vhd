----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.01.2021 12:48:00
-- Design Name: 
-- Module Name: volume_control - Behavioral
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
use work.package_dsed.ALL;

entity volume_control is
    Port ( 
        clk : in STD_LOGIC;
        enable : in STD_LOGIC;
        reset : in STD_LOGIC;
        level_up : in STD_LOGIC;
        level_down : in STD_LOGIC;
        sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
        sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
        to_seven_seg : out STD_LOGIC_VECTOR (4 downto 0) -- Sent to the 7 segment manager
    );
end volume_control;

architecture Behavioral of volume_control is
    -- Signal declaration
        -- Registers
        signal level, next_level : UNSIGNED(4 downto 0);
        
        -- Unsigned to compute easily
        signal sample_out_unsig, sample_in_unsig : UNSIGNED(sample_size+factor_size-1 downto 0);
        signal factor : UNSIGNED(factor_size-1 downto 0);
        
        -- Auxiliar signal
        
        constant aux : STD_LOGIC_VECTOR(sample_size-1 downto 0) := (others => '0');
        constant sample_in_prepadding : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
        constant sample_in_postpadding : STD_LOGIC_VECTOR(6 downto 0) := (others => '0');

begin
    -- Register
        process(clk, reset)
        begin
            if reset = '1' then
                level <= "01010"; -- When reset -> factor = 1
            elsif rising_edge(clk) then
                level <= next_level;
            end if;
        end process;
        
    -- Next-state logic
        next_level <= level + 1 when (level_up = '1' and level < 20) else
                      level - 1 when (level_down = '1' and level > 0) else
                      level;
                      
    -- Output logic
        factor <= volume10 when enable = '0' else
                  volume0 when level = 0 else
                  volume1 when level = 1 else
                  volume2 when level = 2 else
                  volume3 when level = 3 else
                  volume4 when level = 4 else
                  volume5 when level = 5 else
                  volume6 when level = 6 else
                  volume7 when level = 7 else
                  volume8 when level = 8 else
                  volume9 when level = 9 else
                  volume10 when level = 10 else
                  volume11 when level = 11 else
                  volume12 when level = 12 else
                  volume13 when level = 13 else
                  volume14 when level = 14 else
                  volume15 when level = 15 else
                  volume16 when level = 16 else
                  volume17 when level = 17 else
                  volume18 when level = 18 else
                  volume19 when level = 19 else
                  volume20 when level = 20;
                  
        sample_out_unsig <= sample_in_unsig * unsigned(aux & std_logic_vector(factor));
    
    -- Assign inputs and deal with outputs and saturation
        sample_in_unsig <= unsigned(sample_in_prepadding & sample_in & sample_in_postpadding);
        
        sample_out <= (others => '1') when sample_out_unsig(sample_size+factor_size-1 downto sample_size+factor_size-1-3) /= 0 else -- POSITIVE SATURATION
                      std_logic_vector(sample_out_unsig(sample_size+factor_size-1-3 downto factor_size-1-3)); 
                      
        to_seven_seg <= "00" & std_logic_vector(level);
end Behavioral;
