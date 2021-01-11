----------------------------------------------------------------------------------
-- Company: Grupo 9
-- Engineer: CJLL & ITI
-- 
-- Create Date: 11.01.2021 15:47:59
-- Design Name: 
-- Module Name: sec_left - Behavioral
-- Project Name: Sistema de grabación, tratamiento y reproducción de audio
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
use IEEE.NUMERIC_STD.ALL;
use work.package_dsed.ALL;

entity sec_left is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           is_recording : in STD_LOGIC;
           sample_req : in STD_LOGIC;
           addr_now : in STD_LOGIC_VECTOR (18 downto 0);
           addr_max : in STD_LOGIC_VECTOR (18 downto 0);
           data_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           data_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
           play_en_in : in STD_LOGIC;
           play_en_out : out STD_LOGIC;
           to_seven_seg_recording : out STD_LOGIC_VECTOR (4 downto 0);
           to_seven_seg_playing : out STD_LOGIC_VECTOR (4 downto 0)
       );
end sec_left;

architecture Behavioral of sec_left is
    -- Signal definition
        -- Registers
        signal seconds_left_recording, next_seconds_left_recording : UNSIGNED (4 downto 0); -- max seconds that can be stored/reproduced is 26s
        signal seconds_left_playing, next_seconds_left_playing : UNSIGNED (4 downto 0); -- max seconds that can be stored/reproduced is 26s
        signal sample, next_sample : STD_LOGIC_VECTOR(sample_size-1 downto 0);
        signal count, next_count : UNSIGNED (13 downto 0);
        
        -- Aux signal
        signal seconds_recorded : UNSIGNED(40 downto 0); -- format (20.21)
        signal seconds_played : UNSIGNED(40 downto 0); -- format (20.21)
        
begin
    -- Register
        process(clk, reset)
        begin
            if reset = '1' then
                seconds_left_recording <= to_unsigned(26, 5);
                seconds_left_playing <= (others => '0');
                sample <= (others => '0');
                count <= (others => '0');
            elsif rising_edge(clk) then
                seconds_left_recording <= next_seconds_left_recording;
                seconds_left_playing <= next_seconds_left_playing;
                sample <= next_sample;
                count <= next_count;
            end if;
        end process;
        
    -- Next-state logic
        seconds_recorded <= unsigned(addr_max)*sampling_rate;
        seconds_played <= (unsigned(addr_max)-unsigned(addr_now))*sampling_rate;
        
        next_seconds_left_recording <= 26 - seconds_recorded(25 downto 21);
        next_seconds_left_playing <= seconds_played(25 downto 21);
                                      
        next_sample <= not sample when sample_req = '1' and count < 5000 else
                       (others => '0') when is_recording = '1' and count >= 5000 else
                       sample;
                       
        next_count <= count + 1 when sample_req = '1' and seconds_left_recording = 3 and count < 5000 else
                      count when seconds_left_recording = 3 and count < 5000 else
                      (others => '0') when (seconds_left_recording = 4 and next_seconds_left_recording = 3) or (is_recording = '1' and unsigned(addr_max) = MAX_ADDRESS) else
                      to_unsigned(5001,14); 
        
    -- Output logic
        to_seven_seg_recording <= std_logic_vector(seconds_left_recording);
        to_seven_seg_playing <= std_logic_vector(seconds_left_playing);
        
    -- Pitido
        data_out <= sample when is_recording = '1' else
                    data_in;
        
        play_en_out <= '1' when count < 5000 else
                       play_en_in;

end Behavioral;
