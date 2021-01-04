----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2020 13:27:11
-- Design Name: 
-- Module Name: fir_filter_2_tb - Behavioral
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

entity fir_filter_2_tb is
--  Port ( );
end fir_filter_2_tb;

architecture Behavioral of fir_filter_2_tb is
    component fir_filter is
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
               sample_in_enable : in STD_LOGIC;
               filter_select : in STD_LOGIC;
--               adder_res : out STD_LOGIC_VECTOR(sample_size*2 - 1 downto 0);
--               hm_res : out STD_LOGIC_VECTOR (((sample_size*2)-2) downto 0);
               sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
--               ctrl : out STD_LOGIC_VECTOR (2 downto 0);
--               x00 : out STD_LOGIC_VECTOR(sample_size-1 downto 0);
--               x01 : out STD_LOGIC_VECTOR(sample_size-1 downto 0);
--               x02 : out STD_LOGIC_VECTOR(sample_size-1 downto 0);
--               x03 : out STD_LOGIC_VECTOR(sample_size-1 downto 0);
--               x04 : out STD_LOGIC_VECTOR(sample_size-1 downto 0);
               sample_out_ready : out STD_LOGIC);
    end component;
    
    signal clk, reset, sample_in_enable, filter_select, sample_out_ready : STD_LOGIC := '0';
    signal sample_in, sample_out : STD_LOGIC_VECTOR (sample_size-1 downto 0) := (others => '0');
    
    -- Debugging signals
    
--    signal hm_res : STD_LOGIC_VECTOR (((sample_size*2)-2) downto 0);
--    signal adder_res : STD_LOGIC_VECTOR (((sample_size*2)-1) downto 0);
--    signal ctrl : STD_LOGIC_VECTOR (2 downto 0);
--    signal x00, x01, x02, x03, x04 : STD_LOGIC_VECTOR (sample_size-1 downto 0);
    
    -- Timing constants
    constant PERIOD : time := 10 ns;

begin

    U0 : fir_filter port map(
        clk => clk,
        reset => reset,
        sample_in => sample_in,
        sample_in_enable => sample_in_enable,
        filter_select => filter_select,
--        adder_res => adder_res,
--        hm_res => hm_res,
        sample_out => sample_out,
--        ctrl => ctrl,
--        x00 => x00,
--        x01 => x01,
--        x02 => x02,
--        x03 => x03,
--        x04 => x04,
        sample_out_ready => sample_out_ready
    );
    
    
    TIMING : process begin
        clk <= '0';
        wait for PERIOD/2;
        clk <= '1';
        wait for PERIOD/2;
    end process;
    
    SAMPLES_ENABLING : process begin
        sample_in_enable <= '0';
        wait for 19*PERIOD;
        sample_in_enable <= '1';
        wait for PERIOD;
    end process;
    
    VALUES : process begin
        -- 0.5
        reset <= '1';
        filter_select <= '0'; --LOW PASS
        wait for 13 ns;
        reset <= '0';
        sample_in <= "00000000";
        wait for 20*PERIOD;
        sample_in <= "01000000";
        wait for 20*PERIOD;
        sample_in <= "00000000";
        wait for 20*PERIOD;
        sample_in <= "00000000";
        wait for 20*PERIOD;
        sample_in <= "00010000";
        wait for 20*PERIOD;
        sample_in <= "00000000";
        wait for 20*PERIOD;
        sample_in <= "00000000";
        wait for 20*PERIOD;
        sample_in <= "00000000";
        wait for 20*PERIOD;
        sample_in <= "00000000";
        wait for 20*PERIOD;
        
        sample_in <= "00000000";
        wait for 20*PERIOD;
        filter_select <= '1'; --HIGH PASS
        sample_in <= "00000000";
        wait for 20*PERIOD;
        sample_in <= "01000000";
        wait for 20*PERIOD;
        sample_in <= "00000000";
        wait for 20*PERIOD;
        sample_in <= "00000000";
        wait for 20*PERIOD;
        sample_in <= "00010000";
        wait for 20*PERIOD;
        sample_in <= "00000000";
        wait for 20*PERIOD;
        sample_in <= "00000000";
        wait for 20*PERIOD;
        sample_in <= "00000000";
        wait for 20*PERIOD;
        sample_in <= "00000000";
        wait for 20*PERIOD;
        
    end process;
    
end Behavioral;