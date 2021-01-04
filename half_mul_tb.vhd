----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.11.2020 13:02:30
-- Design Name: 
-- Module Name: half_mul_tb - Behavioral
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
use work.package_dsed.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity half_mul_tb is
end half_mul_tb;

architecture Behavioral of half_mul_tb is

component half_mul is
    Port ( 
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        a : in STD_LOGIC_VECTOR ((sample_size-1) downto 0);
        b : in STD_LOGIC_VECTOR ((sample_size-1) downto 0);
        c : out STD_LOGIC_VECTOR (((sample_size*2)-2) downto 0));
    end component;

    constant PERIOD : time := 10 ns;
    
    -- Signals
    
        signal clk, reset : STD_LOGIC := '0';
        signal a, b : STD_LOGIC_VECTOR ((sample_size-1) downto 0) := (others => '0');
        signal c : STD_LOGIC_VECTOR (((sample_size*2)-2) downto 0);

begin

    U0 : half_mul port map(
        clk => clk,
        reset => reset,
        a => a,
        b => b,
        c => c
    );
    
    CLOCKING : process begin
        clk <= '0';
        wait for PERIOD/2;
        clk <= '1';
        wait for PERIOD/2;
    end process;
    
    VALUES  : process begin
        reset <= '1';
        wait for 13 ns;
        reset <= '0';
        a <= "00000000";
        b <= "11111111";
        wait for 10 ns;
--        a <= "11111111";
--        b <= "11111111";
        wait for 10 ns;
        a <= "01111111";
        b <= "01111111";
        wait for 10 ns;
        a <= "01010101";
        b <= "11111111";
        wait for 10 ns;
        a <= "01001100";
        b <= "01000110";
        wait;
        
    end process;


end Behavioral;
