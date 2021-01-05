----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.01.2021 14:24:43
-- Design Name: 
-- Module Name: seven_segment_manager - Behavioral
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

entity seven_segment_manager is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           volume_info : in STD_LOGIC_VECTOR (6 downto 0);
           en_volume : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (7 downto 0);
           seven_seg : out STD_LOGIC_VECTOR (6 downto 0));
end seven_segment_manager;

architecture Behavioral of seven_segment_manager is
    -- FSM state type declaration
        type state_type is (volume1, volume2);
        
    -- Signal definition
        -- Register
        signal count, next_count : UNSIGNED (7 downto 0);
        
        -- FSM state declaration
        signal state, next_state : state_type;
    
    -- Auxiliar signals
        signal info_to_be_shown : UNSIGNED (6 downto 0);

begin
    -- Register
        process (clk, reset)
        begin
            if reset = '1' then
                state <= volume1;
                count <= (others => '0');
            elsif rising_edge(clk) then
                state <= next_state;
                count <= next_count;
            end if;
        end process;
        
    -- FSMD
        process (count, state)
        begin
            case state is                    
                when volume1 =>
                    an <= "10000000";
                    info_to_be_shown <= unsigned(volume_info)/10; -- tens
                    next_count <= count + 1;
                    
                    if count < refresh_rate then
                        next_state <= volume1;
                    else
                        next_state <= volume2;
                        next_count <= (others => '0');
                    end if;
                    
                when volume2 =>
                    an <= "01000000";
                    info_to_be_shown <= unsigned(volume_info) mod 10; -- units
                    next_count <= count + 1;
                    
                    if count < refresh_rate then
                        next_state <= volume2;
                    else
                        next_state <= volume1;
                        next_count <= (others => '0');
                    end if;
                
                when others =>
                    next_state <= volume1;
            
            end case;
        end process;
        
        -- Output Logic
            seven_seg <= zero_7_seg when info_to_be_shown = 0 else
                         one_7_seg when info_to_be_shown = 1 else
                         two_7_seg when info_to_be_shown = 2 else
                         three_7_seg when info_to_be_shown = 3 else
                         four_7_seg when info_to_be_shown = 4 else
                         five_7_seg when info_to_be_shown = 5 else
                         six_7_seg when info_to_be_shown = 6 else
                         seven_7_seg when info_to_be_shown = 7 else
                         eight_7_seg when info_to_be_shown = 8 else
                         nine_7_seg when info_to_be_shown = 9 else
                         zero_7_seg;
                      
end Behavioral;
