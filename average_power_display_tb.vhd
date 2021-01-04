----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.11.2020 19:02:33
-- Design Name: 
-- Module Name: average_power_display - Behavioral
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
use work.package_dsed.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity average_power_display_tb is
end average_power_display_tb;

architecture Behavioral of average_power_display_tb is

    component average_power_display is
        Port ( clk_12megas : in STD_LOGIC;
               reset : in STD_LOGIC;
               sample_in : in STD_LOGIC_VECTOR(sample_size - 1 downto 0);
               sample_request : in STD_LOGIC;
               LED : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    signal clk_12megas, reset, sample_request : STD_LOGIC := '0';
    signal sample_in : STD_LOGIC_VECTOR(sample_size - 1 downto 0) := (others => '0');
    signal LED : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    
    constant PERIOD : time := 10 ns;
    
begin
    
    U0 : average_power_display port map(
        clk_12megas => clk_12megas,
        reset => reset,
        sample_in => sample_in,
        sample_request => sample_request,
        LED => LED
    );
    
    CLOCKING : process begin
        clk_12megas <= '0';
        sample_request <= '0';
        wait for PERIOD/2;
        clk_12megas <= '1';
        wait for PERIOD/2;
        clk_12megas <= '0';
        sample_request <= '1';
        wait for PERIOD/2;
        clk_12megas <= '1';
        wait for PERIOD/2;
    end process;
    
    
    VALUES : process begin
        reset <= '1';
        wait for 230 ns;
        reset <= '0';
        sample_in <= "00000000";
        wait for 10240 ns;
        sample_in <= "11111111";
        wait for 10240 ns;
        sample_in <= "01010101";
        wait for 10240 ns;
        sample_in <= "10111010";
        wait for 10240 ns;
        sample_in <= "00000000";
        wait for 10240 ns;
        sample_in <= "11111111";
        wait for 20480 ns;
        sample_in <= "11111111";
        wait;
    end process;



end Behavioral;
