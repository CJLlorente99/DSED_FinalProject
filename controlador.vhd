----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.11.2020 11:05:36
-- Design Name: 
-- Module Name: controlador - Behavioral
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

entity controlador is
    Port ( clk_100Mhz : in STD_LOGIC;
           reset : in STD_LOGIC;
           -- To/From the microphone
           micro_clk : out STD_LOGIC;
           micro_data : in STD_LOGIC;
           micro_LR : out STD_LOGIC;
           -- To/From the mini-jack
           jack_sd : out STD_LOGIC;
           jack_pwm : out STD_LOGIC;
           -- To/From PowerDisplay
           LED : out STD_LOGIC_VECTOR (7 downto 0));
end controlador;

architecture Behavioral of controlador is
    -- component declaration
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
               jack_pwm : out STD_LOGIC;
              --LED ports
              --To/From PowerDisplay
              LED : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    -- clock wizard component declaration
    component clk_wiz_12mhz is
        Port ( clk_100Mhz : in STD_LOGIC;
               reset : in STD_LOGIC;
               clk_12Mhz : out STD_LOGIC);
    end component;  

    -- signals declaration
    signal clk_12Mhz, sample_out_ready, sample_request : STD_LOGIC;
    signal sample_out, sample_in, next_sample_in : STD_LOGIC_VECTOR (sample_size -1 downto 0);
    signal count, next_count : UNSIGNED(9 downto 0) := (others => '0');
    signal first_time, next_first_time : STD_LOGIC := '1';

begin
    -- clk wizard instantiation
    CLK_WIZ : clk_wiz_12mhz
        port map ( clk_100Mhz => clk_100Mhz,
                   reset => reset,
                   clk_12Mhz => clk_12Mhz);
                   
    -- audio interface instantiation
    AUDIO_INTER : audio_interface
        port map ( clk_12megas => clk_12Mhz,
                   reset => reset,
                   record_enable => '1',
                   sample_out => sample_out,
                   sample_out_ready => sample_out_ready,
                   micro_clk => micro_clk,
                   micro_data => micro_data,
                   micro_LR => micro_LR,
                   play_enable => '1',
                   sample_in => sample_in,
                   sample_request => sample_request,
                   jack_sd => jack_sd,
                   jack_pwm => jack_pwm,
                   LED => LED);
                   
    -- logic for sample_in and sample_out
    -- register
    
    process (clk_12Mhz, reset)
    begin
        if reset='1' then
            count <= (others => '0');
            sample_in <= (others => '0');
            first_time <= '1';
        elsif rising_edge(clk_12Mhz) then
            count <= next_count;
            sample_in <= next_sample_in;
            first_time <= next_first_time;
        end if; 
    end process;
    
    -- next_state logic
    next_count <= (others => '0') when (sample_out_ready='1' and count>=600) or (first_time='1' and sample_out_ready='1') else
                   count + 1;
    next_first_time <= '0' when (sample_out_ready='1') else
                       first_time;
    
    next_sample_in <= sample_out when (sample_out_ready='1' and count>=600) or (sample_out_ready='1' and first_time='1') else
                      sample_in;

end Behavioral;
