----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.11.2020 12:46:08
-- Design Name: 
-- Module Name: audio_interface_tb - Behavioral
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

entity audio_interface_tb is
--  Port ( );
end audio_interface_tb;

architecture Behavioral of audio_interface_tb is
    component audio_interface is
        Port ( clk_12megas : in STD_LOGIC;
               reset : in STD_LOGIC;
               -- Recording ports
               -- To/From the controller
               record_enable : in STD_LOGIC;
               sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
               sample_out_ready : out STD_LOGIC;
               -- To/From the microphone
               micro_clk : out STD_LOGIC;
               micro_data : in STD_LOGIC;
               micro_LR : out STD_LOGIC;
               -- Playing ports
               -- To/From the controller
               play_enable : in STD_LOGIC;
               sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
               sample_request : out STD_LOGIC;
               -- To/From the mini-jack
               jack_sd : out STD_LOGIC;
               jack_pwm : out STD_LOGIC);
    end component;
    
    -- Inputs:
        signal clk_12megas, reset, record_enable, micro_data, play_enable : STD_LOGIC := '0';
        signal sample_in : STD_LOGIC_VECTOR (sample_size-1 downto 0) := (others => '0');
    
    -- Outputs:
        signal  sample_out_ready, micro_clk, micro_LR, sample_request, jack_sd, jack_pwm : STD_LOGIC;
        signal sample_out : STD_LOGIC_VECTOR (sample_size-1 downto 0);
        
    -- Clock constant
        constant PERIOD : time := 83.3333 ns;
        
    -- Auxiliar signals:
        signal a, b, c : STD_LOGIC := '0';

begin
    U0 : audio_interface port map(
        clk_12megas => clk_12megas,
        reset => reset,
        record_enable => record_enable,
        sample_out => sample_out,
        sample_out_ready => sample_out_ready,
        micro_clk => micro_clk,
        micro_data => micro_data,
        micro_LR => micro_LR,
        play_enable => play_enable,
        sample_in => sample_in,
        sample_request => sample_request,
        jack_sd => jack_sd,
        jack_pwm => jack_pwm
    );
    
    TIMMING : process 
    begin
        clk_12megas <= '0';
        wait for PERIOD/2;
        clk_12megas <= '1';
        wait for PERIOD/2;
    end process;
    
    VALUES : process
    begin
        record_enable <= '1';
        play_enable <= '1';
        reset <= '1';
        wait for 100 us;
        reset <= '0';
        sample_in <= "00000000";
        wait for 50 us;
        sample_in <= "11111000";
        wait for 50 us;
        sample_in <= "01101100";
        wait for 50 us;
        sample_in <= "11111111";
        wait for 50 us;
        sample_in <= "01010101";
        wait for 50 us;
        sample_in <= "10000001";
        wait for 50 us;
        sample_in <= "01111110";
        wait for 50 us;
        sample_in <= "00110011";
        wait for 50 us;
        sample_in <= "00001111";
        wait;
    end process;
    
    a <= not a after 1300 ns;
    b <= not b after 2100 ns;
    c <= not c after 3700 ns;
    micro_data <= a xor b xor c;
    


end Behavioral;
