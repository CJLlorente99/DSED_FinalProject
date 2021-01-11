----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.01.2021 12:30:14
-- Design Name: 
-- Module Name: delay_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity delay_tb is
--  Port ( );
end delay_tb;

architecture Behavioral of delay_tb is

    component delay is
        Port (
               clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               enable : in STD_LOGIC;
               
               increase : in STD_LOGIC;
               decrease : in STD_LOGIC;
               original_sig : in STD_LOGIC_VECTOR(sample_size - 1 downto 0);
               original_sig_ready : in STD_LOGIC;
               delayed_sig : out STD_LOGIC_VECTOR(sample_size - 1 downto 0);
               actual_level : out STD_LOGIC_VECTOR(4 downto 0)
        );
    end component;
    
    signal clk, reset, enable, increase, decrease, original_sig_ready : STD_LOGIC := '0';
    signal original_sig, aux, next_aux : STD_LOGIC_VECTOR(sample_size - 1 downto 0) := "00000001";
    signal delayed_sig : STD_LOGIC_VECTOR(sample_size - 1 downto 0) := (others => '0');
    signal level : STD_LOGIC_VECTOR(4 downto 0) := "00000";
    signal add : STD_LOGIC_VECTOR(sample_size - 1 downto 0) := (others => '0');
    
    constant PERIOD : time := 10 ns;
    
begin
    
    U0 : delay port map(
        clk => clk,
        reset => reset,
        enable => enable,
        increase => increase,
        decrease => decrease,
        original_sig => original_sig,
        original_sig_ready => original_sig_ready,
        delayed_sig => delayed_sig,
        actual_level => level
    );
    
    TIMMING : process begin
        clk <= '0';
        wait for PERIOD/2;
        clk <= '1';
        wait for PERIOD/2;
    end process;
    
    enable <= '1';
    
    reset <= '1', '0' after PERIOD;
    
    SIGNAL_READY : process begin 
        original_sig_ready <= '0';
        wait for 7 * PERIOD;
        original_sig_ready <= '1';
        wait for PERIOD;
    end process;
    
    INPUT_SIG : process begin
        aux <= next_aux;
        wait for 8 * PERIOD;
    end process;
    
    next_aux <= aux(sample_size - 2 downto 0) & aux(sample_size - 1);
    
    original_sig <= aux;
    
    increase <= '1', 
                '0' after 8 * PERIOD, 
                '1' after 32 * PERIOD, 
                '0' after 40 * PERIOD;
                
    decrease <= '0', 
                '1' after 64 * PERIOD, 
                '0' after 72 * PERIOD, 
                '1' after 96 * PERIOD;


end Behavioral;
