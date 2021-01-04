----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.12.2020 11:32:50
-- Design Name: 
-- Module Name: dsed_audio_1_tb - Behavioral
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

-- This testbench just checks system accepts new data coming from micro and transitionates to other states
-- The correctness of the output data will be tested in other tb
entity dsed_audio_1_tb is
end dsed_audio_1_tb;

architecture Behavioral of dsed_audio_1_tb is
    -- Component declaration
component dsed_audio is
        Port ( clk_100Mhz : in STD_LOGIC;
               reset : in STD_LOGIC;
               -- Control ports
               BTNL : in STD_LOGIC; -- Record
               BTNC : in STD_LOGIC; -- Reset ram
               BTNR : in STD_LOGIC; -- Sound on
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
               
               -- Debugging signals
               dina_a : out STD_LOGIC_VECTOR(7 downto 0);
               wea_a : out STD_LOGIC_VECTOR(0 downto 0);
               ena_a : out STD_LOGIC;
               addra_a : out STD_LOGIC_VECTOR(18 downto 0);
               douta_a : out STD_LOGIC_VECTOR(7 downto 0);
               
               rec_enable : out STD_LOGIC;
               reco_ready : out STD_LOGIC;
               state_aux : out STD_LOGIC_VECTOR(2 downto 0);
               
               sample_request_aux : out std_logic
               );
    end component;
    
    -- Inputs
    signal clk_100Mhz, reset, BTNL, BTNC, BTNR, SW0, SW1, micro_data : STD_LOGIC := '0';
    
    -- Outputs
    signal micro_clk, micro_LR, jack_sd, jack_pwm : STD_LOGIC := '0';
    
    signal ena_a : STD_LOGIC := '1';
    signal dina_a, douta_a : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal wea_a : STD_LOGIC_VECTOR(0 downto 0) := (others => '0');
    signal addra_a : STD_LOGIC_VECTOR(18 downto 0) := (others => '0');
    
    signal rec_enable, reco_ready : STD_LOGIC := '1';
    
    signal state_aux : std_logic_vector(2 downto 0) := "000";
    
    signal a, b, c, sample_request_aux : std_logic := '0';
    
    -- Timing signals
    constant PERIOD : time := 10ps;
    
begin
    -- DUT instantiation
    DUT: dsed_audio port map(
        clk_100Mhz => clk_100Mhz,
        reset => reset,
        -- Control ports
        BTNL => BTNL, -- Record
        BTNC => BTNC, -- Reset ram
        BTNR => BTNR, -- Sound on
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
        
        ena_a => ena_a,
        dina_a => dina_a,
        douta_a => douta_a,
        wea_a => wea_a,
        addra_a => addra_a,
        
        rec_enable => rec_enable,
        reco_ready => reco_ready,
        state_aux => state_aux,
        
        sample_request_aux => sample_request_aux
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
    
    BTNL <= '1',
            '0' after 2us;
            
    -- Sound on and try all functionalities
    BTNR <= '0',
            '1' after 2us;
            
    SW0 <= '0', -- Play forward
           --'1' after 6us, -- Play reverse
           '0' after 4us, -- Filter LP
           '1' after 6us; -- Filter HP
           
    SW1 <= '0', -- Play forward
           --'0' after 6us, -- Play reverse
           '1' after 4us, -- Filter LP
           '1' after 6us; -- Filter HP

end Behavioral;
