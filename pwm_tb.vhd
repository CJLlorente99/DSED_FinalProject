----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.11.2020 15:30:39
-- Design Name: 
-- Module Name: pwm_tb - Behavioral
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

entity pwm_tb is
--  Port ( );
end pwm_tb;

architecture Behavioral of pwm_tb is

    component pwm is
        Port ( clk_12megas : in STD_LOGIC;
               reset : in STD_LOGIC;
               en_2_cycles : in STD_LOGIC;
               sample_in : in STD_LOGIC_VECTOR(sample_size - 1 downto 0);
               sample_request : out STD_LOGIC;
               pwm_pulse : out STD_LOGIC);
    end component;
    
    signal clk_12megas, reset, en_2_cycles, sample_request, pwm_pulse : STD_LOGIC;
    signal sample_in : STD_LOGIC_VECTOR(sample_size - 1 downto 0);
    
    constant PERIOD : time := 10 ns;

begin

    U0 : pwm port map(
        clk_12megas => clk_12megas,
        reset => reset,
        en_2_cycles => en_2_cycles,
        sample_in => sample_in,
        sample_request => sample_request,
        pwm_pulse => pwm_pulse
    );
    
    CLOCKING : process begin
        clk_12megas <= '0';
        en_2_cycles <= '0';
        wait for PERIOD/2;
        clk_12megas <= '1';
        wait for PERIOD/2;
        clk_12megas <= '0';
        en_2_cycles <= '1';
        wait for PERIOD/2;
        clk_12megas <= '1';
        wait for PERIOD/2;
    end process;
    
    VALUES : process begin
        reset <= '1';
        sample_in <= "10101010";
        wait for 13 ns;
        reset <= '0';
        wait for 5000 ns;
        sample_in <= "00000000";
        wait for 6000 ns;
        sample_in <= "10000001";
        wait for 6000 ns;
        sample_in <= "10101011";
        wait for 6000 ns;
        sample_in <= "00011101";
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait;
    end process;


end Behavioral;
