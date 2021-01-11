----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.01.2021 11:41:38
-- Design Name: 
-- Module Name: dsed_audio_2_tb - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dsed_audio_2_tb is
--  Port ( );
end dsed_audio_2_tb;

architecture Behavioral of dsed_audio_2_tb is
    -- Component declaration
component dsed_audio is
        Port ( clk_100Mhz : in STD_LOGIC;
               reset : in STD_LOGIC;
               -- Control ports
               recording : in STD_LOGIC; -- Record
               clearing : in STD_LOGIC; -- Reset ram
               playing : in STD_LOGIC; -- Sound on
               SW0 : in STD_LOGIC; 
               SW1 : in STD_LOGIC;
               -- To/From the microphone
               micro_clk : out STD_LOGIC;
               micro_data : in STD_LOGIC;
               micro_LR : out STD_LOGIC;
               -- To/From the mini_jack
               jack_sd : out STD_LOGIC;
               jack_pwm : out STD_LOGIC;
               LED : out STD_LOGIC_VECTOR(7 downto 0);
               -- Volume control
                volume_up : in STD_LOGIC;
                volume_down : in STD_LOGIC;
                -- Seven segments
                an : out STD_LOGIC_VECTOR (7 downto 0);
                seven_seg : out STD_LOGIC_VECTOR (6 downto 0)
               );
    end component;
    
    -- Inputs
    signal clk_100Mhz, reset, recording, clearing, playing, SW0, SW1, micro_data, volume_up, volume_down : STD_LOGIC := '0';
    
    -- Outputs
    signal micro_clk, micro_LR, jack_sd, jack_pwm : STD_LOGIC := '0';
    
    signal an : STD_LOGIC_VECTOR (7 downto 0);
    signal seven_seg : STD_LOGIC_VECTOR (6 downto 0);
    
    signal a, b, c : std_logic := '0';
    
    -- Timing signals
    constant PERIOD : time := 10ps;
    
begin
    -- DUT instantiation
    DUT: dsed_audio port map(
        clk_100Mhz => clk_100Mhz,
        reset => reset,
        -- Control ports
        recording => recording, -- Record
        clearing => clearing, -- Reset ram
        playing => playing, -- Sound on
        SW0 => SW0, 
        SW1 => SW1,
        -- To/From the microphone
        micro_clk => micro_clk,
        micro_data => micro_data,
        micro_LR => micro_LR,
        -- To/From the mini_jack
        jack_sd => jack_sd,
        jack_pwm => jack_pwm,
        LED => open, 
        
        volume_up => volume_up,
        volume_down => volume_down,
        an => open,
        seven_seg => open
        );
        
    -- CLK process
    CLK : process
    begin
        clk_100Mhz <= '0';
        wait for PERIOD/2;
        clk_100Mhz <= '1';
        wait for PERIOD/2;
    end process;
    
    -- Assign values
    reset <= '1',
             '0' after 10ns;
    -- First record some samples
    
    a <= not a after 130 ns;
    b <= not b after 210 ns;
    c <= not c after 370 ns;
    micro_data <= a xor b xor c;
    
    recording <= '1',
            '0' after 2us;
            
    -- Sound on and try all functionalities
    playing <= '0',
            '1' after 2us;
            
    SW0 <= '0';
           
    SW1 <= '0';
    
    volume_up <= '0',
                 '1' after 2us;
                 
    volume_down <= '0',
                   '1' after 3us;
end Behavioral;
