----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.11.2020 12:51:48
-- Design Name: 
-- Module Name: controlador_tb - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controlador_tb is
end controlador_tb;

architecture Behavioral of controlador_tb is
    -- component declaration
    component controlador is
        Port ( clk_100Mhz : in STD_LOGIC;
               reset : in STD_LOGIC;
               -- To/From the microphone
               micro_clk : out STD_LOGIC;
               micro_data : in STD_LOGIC;
               micro_LR : out STD_LOGIC;
               -- To/From the mini-jack
               jack_sd : out STD_LOGIC;
               jack_pwm : out STD_LOGIC);
    end component;
    
    -- input signals declaration
    signal clk, reset, micro_data : STD_LOGIC;
    
    -- output signals declaration
    signal micro_clk, micro_LR, jack_sd, jack_pwm : STD_LOGIC;
    
    -- aux constants for clk   
    constant PERIOD : time := 10ns;
    
    -- aux signals  
    signal a,b,c : STD_LOGIC := '0';
    
begin
    -- DUT instantiation
    DUT : controlador
        Port map ( clk_100Mhz => clk,
                   reset => reset,
                   micro_clk => micro_clk,
                   micro_data => micro_data,
                   micro_LR => micro_LR,
                   jack_sd => jack_sd,
                   jack_pwm => jack_pwm);

    -- clk simulation process
    clk_process : process
    begin
        clk <= '0';
        wait for PERIOD/2;
        clk <= '1';
        wait for PERIOD/2;
    end process;
    
    reset <= '1',
             '0' after 40ns;
             
    a <= not a after 50ns;
    b <= not b after 80ns;
    c <= not c after 100ns;
    micro_data <= a xor b xor c;

end Behavioral;
