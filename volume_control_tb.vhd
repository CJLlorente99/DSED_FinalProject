----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.01.2021 10:55:12
-- Design Name: 
-- Module Name: volume_control_tb - Behavioral
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

entity volume_control_tb is
--  Port ( );
end volume_control_tb;

architecture Behavioral of volume_control_tb is
    -- Component declaration
        component volume_control is
            Port ( 
                clk : in STD_LOGIC;
                reset : in STD_LOGIC;
                level_up : in STD_LOGIC;
                level_down : in STD_LOGIC;
                sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
                sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
                to_seven_seg : out STD_LOGIC_VECTOR (6 downto 0) -- Sent to the 7 segment manager
            );
        end component;
        
    -- Signal declaration
        -- Inputs
        signal clk, reset, level_up, level_down : STD_LOGIC := '0';
        signal sample_in : STD_LOGIC_VECTOR (sample_size-1 downto 0) := (others => '0');
        
        -- Outputs
        signal sample_out : STD_LOGIC_VECTOR (sample_size-1 downto 0);
        signal to_seven_seg : STD_LOGIC_VECTOR (6 downto 0);
        
    -- timing constants
        constant period : time := 10ps;
begin
    -- DUT instantiation
    DUT : volume_control
        port map ( clk => clk,
                   reset => reset,
                   level_up => level_up,
                   level_down => level_down,
                   sample_in => sample_in,
                   sample_out => sample_out,
                   to_seven_seg => to_seven_seg
               );
               
    -- clk process
        process
        begin
            clk <= '0';
            wait for period/2;
            clk <= '1';
            wait for period/2;
        end process;
    
    -- Signals assignation
        reset <= '1',
                 '0' after 20 ns;
                 
        sample_in <= "00001111";
        
        level_up <= '1',
                    '0' after 1ms;
                    
        level_down <= '0',
                      '1' after 1ms;

end Behavioral;
