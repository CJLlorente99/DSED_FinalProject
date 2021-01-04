----------------------------------------------------------------------------------
-- Company: Grupo 9
-- Engineer: CJLL & ITI
-- 
-- Create Date: 09.11.2020 14:21:35
-- Design Name: 
-- Module Name: FSMD_microphone_SO_tb - Behavioral
-- Project Name: Sistema de grabación, tratamiento y reproducción de audio
-- Target Devices: 
-- Tool Versions: 
-- Description: testbench for proving sample_out works as expected
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

entity FSMD_microphone_SO_tb is
end FSMD_microphone_SO_tb;

architecture Behavioral of FSMD_microphone_SO_tb is
    component FSMD_microphone is
        Port ( clk_12megas : in STD_LOGIC;
               reset : in STD_LOGIC;
               enable_4_cycles : in STD_LOGIC;
               micro_data : in STD_LOGIC;
               sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
               sample_out_ready : out STD_LOGIC
               -- Debugging outputs
--               count : out integer;
--               state_num : out integer
               );
    end component;
    
    -- Signal declaration
    -- Input signals
    signal clk_10megas,reset, enable_4_cycles, micro_data : STD_LOGIC := '0';
    
    -- Output signals
    signal sample_out : STD_LOGIC_VECTOR (sample_size-1 downto 0) := (others => '0');
    signal sample_out_ready : STD_LOGIC := '0';
    
    -- Debugging output signals
--    signal count, state_num : integer;
    
    -- Constant declaration for periodic signals simulation purposes
    constant PERIOD_1Ghz : time := 1ns;
    constant EN_TIME_UP : time := 0.5ns;
    constant EN_TIME_DOWN : time := 3.5ns;
    
    -- Aux signals
    signal a,b,c : STD_LOGIC := '0';    
begin
    -- DUT instantiation
    DUT : FSMD_microphone
        port map ( clk_12megas => clk_10megas,
                   reset => reset,
                   enable_4_cycles => enable_4_cycles,
                   micro_data => micro_data,
                   sample_out => sample_out,
                   sample_out_ready => sample_out_ready
                   -- Debugging outputs
--                   count => count,
--                   state_num => state_num
                   );
                   
    -- Periodic signal creation
    CLK_10MHz : process
    begin
        clk_10megas <= '0';
        wait for PERIOD_1Ghz/2;
        clk_10megas <= '1';
        wait for PERIOD_1Ghz/2;
    end process;
    
    EN_4_CYC : process
    begin
        enable_4_cycles <= '0';
        wait for EN_TIME_DOWN;
        enable_4_cycles <= '1';
        wait for EN_TIME_UP;
    end process;
    
    -- Singnal assignation
    
    reset <= '1',
             '0' after PERIOD_1Ghz;
             
    a <= not a after 50ns;
    b <= not b after 80ns;
    c <= not c after 100ns;
    micro_data <= a xor b xor c;

end Behavioral;
