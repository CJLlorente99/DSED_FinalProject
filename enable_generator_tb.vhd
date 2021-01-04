----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.11.2020 16:52:12
-- Design Name: 
-- Module Name: enable_generator_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity enable_generator_tb is
end enable_generator_tb;

architecture Behavioral of enable_generator_tb is
    -- Component declaration
    component enable_generator is
        Port ( clk_12megas : in STD_LOGIC;
               reset : in STD_LOGIC;
               clk_3megas : out STD_LOGIC;
               en_2_cycles : out STD_LOGIC;
               en_4_cycles : out STD_LOGIC;
               counter_out : out unsigned (2 downto 0));
    end component;
    
    -- Input signals
    signal clk_1Ghz, reset : STD_LOGIC;
    
    -- Output signals
    signal clk_250megas, en_2cycles, en_4cycles : STD_LOGIC;
    signal counter_out : unsigned(2 downto 0);
    
    -- Constants for periodic signals
    constant PERIOD_1Ghz : time := 1ns;
begin
    -- DUT instantiation
    DUT : enable_generator
        port map (clk_12megas => clk_1Ghz,
                  reset => reset,
                  clk_3megas => clk_250megas,
                  en_2_cycles => en_2cycles,
                  en_4_cycles => en_4cycles,
                  counter_out => counter_out);
                  
    -- Periodic signal creation
    clk1Ghz : process
    begin
        clk_1Ghz <= '0';
        wait for PERIOD_1Ghz/2;
        clk_1Ghz <= '1';
        wait for PERIOD_1Ghz/2;
    end process;
    
    -- Input signal asignation
    
   reset <= '1',
            '0' after 0.3ns;

end Behavioral;
