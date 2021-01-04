----------------------------------------------------------------------------------
-- Company: Grupo 9
-- Engineer: CJLL & ITI
-- 
-- Create Date: 09.11.2020 10:48:09
-- Design Name: 
-- Module Name: audio_interface - Behavioral
-- Project Name: Sistema de grabación, tratamiento y reproducción de audio
-- Target Devices: 
-- Tool Versions: 
-- Description:  This interface joins pwm, FSDM_microphone, enable_generator and average_power_display together
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 1.00 - File finished
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.package_dsed.ALL;
use IEEE.NUMERIC_STD.ALL;

entity audio_interface is
    Port ( clk_12megas : in STD_LOGIC; -- System clock
           reset : in STD_LOGIC; -- Asynchronous logic
           -- Recording ports
           -- To/From the controller
           record_enable : in STD_LOGIC; -- When activated, micro_data is sampled
           sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0); -- Sampled micro data
           sample_out_ready : out STD_LOGIC; -- Indicator that sample_out is currently valid
           -- To/From the microphone
           micro_clk : out STD_LOGIC; -- Clk sent to the microphone
           micro_data : in STD_LOGIC; -- Data coming from microphone
           micro_LR : out STD_LOGIC; -- Left/Right channel
           -- Playing ports
           -- To/From the controller
           play_enable : in STD_LOGIC; -- When activated, data in sample_in is played
           sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0); -- Data to be reproduced
           sample_request : out STD_LOGIC; -- Indicator that asks for the next sample to be reproduced
           -- To/From the mini-jack
           jack_sd : out STD_LOGIC; -- Mono audio stage control information
           jack_pwm : out STD_LOGIC; -- PWM signal that is to be reproduced
           --LED ports
           --To/From PowerDisplay
           LED : out STD_LOGIC_VECTOR (7 downto 0) -- Data showing current signal power
           );
end audio_interface;

architecture Behavioral of audio_interface is
    -- Component declaration
        component pwm is
            Port ( clk_12megas : in STD_LOGIC;
                   reset : in STD_LOGIC;
                   en_2_cycles : in STD_LOGIC;
                   sample_in : in STD_LOGIC_VECTOR(sample_size - 1 downto 0);
                   sample_request : out STD_LOGIC;
                   pwm_pulse : out STD_LOGIC
                   );
        end component;
        
        component FSMD_microphone is
            Port ( clk_12megas : in STD_LOGIC;
                   reset : in STD_LOGIC;
                   enable_4_cycles : in STD_LOGIC;
                   micro_data : in STD_LOGIC;
                   sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
                   sample_out_ready : out STD_LOGIC
                   );
        end component;
        
        component enable_generator is
            Port ( clk_12megas : in STD_LOGIC;
                   reset : in STD_LOGIC;
                   clk_3megas : out STD_LOGIC;
                   en_2_cycles : out STD_LOGIC;
                   en_4_cycles : out STD_LOGIC
                   );
        end component;
        
        component average_power_display is
            Port ( clk_12megas : in STD_LOGIC;
                   reset : in STD_LOGIC;
                   sample_in : in STD_LOGIC_VECTOR(sample_size - 1 downto 0);
                   sample_request : in STD_LOGIC;
                   LED : out STD_LOGIC_VECTOR (7 downto 0)
                   );
        end component; 
    
    -- pwm signals:
        signal en_2_cycles,pwm_pulse : STD_LOGIC;
        
    -- FSMD_microphone signals:
        signal enable_4_cycles, auxiliar_enable : STD_LOGIC;
        
    -- enable_generator signals:
        signal clk_3megas : STD_LOGIC;
        
    --sample request aux signal
        signal s_request : STD_LOGIC;
        
    --pwm output aux signal
        signal jack_pwm_auxiliar : STD_LOGIC;
        
begin

    -- Some signals have a constant value
        jack_sd <= '1';
        micro_LR <= '1';
    
    -- Signal assignation in order to record only when record_enable is activated
        auxiliar_enable <= (enable_4_cycles and record_enable);
    
    -- sample_request is used in variuos components. Thus, this assignation is necessary
        sample_request <= s_request;
    
    -- Signal assignation in order to play actual PWM data when play_enable is activated. If play_enable is deactivated, jack_pwm is set to all 0's
        jack_pwm <= play_enable and jack_pwm_auxiliar;

    -- Component instantiation
        PWM_CONVERTER : pwm port map(
            clk_12megas => clk_12megas,
            reset => reset,
            en_2_cycles => en_2_cycles,
            sample_in => sample_in,
            sample_request => s_request,
            pwm_pulse => jack_pwm_auxiliar
        );
        
        MICRO_SAMPLER : FSMD_microphone port map(
            clk_12megas => clk_12megas,
            reset => reset,
            enable_4_cycles => auxiliar_enable,
            micro_data => micro_data,
            sample_out => sample_out,
            sample_out_ready => sample_out_ready
        );
        
        EN_GENERATOR : enable_generator port map(
            clk_12megas => clk_12megas,
            reset => reset,
            clk_3megas => micro_clk,
            en_2_cycles => en_2_cycles,
            en_4_cycles => enable_4_cycles
        );
        
        POWER_LEDS : average_power_display port map(
            clk_12megas => clk_12megas,
           reset => reset,
           sample_in => sample_in,
           sample_request => s_request,
           LED => LED
        );

end Behavioral;
