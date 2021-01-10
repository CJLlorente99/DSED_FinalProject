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
           an : out STD_LOGIC_VECTOR (7 downto 0);
           seven_seg : out STD_LOGIC_VECTOR (6 downto 0));
end seven_segment_manager;

architecture Behavioral of seven_segment_manager is
    -- FSM state type declaration
        type state_type is (idle, volume1, volume2, volume3, volume4, volume5);
        
    -- Signal definition
        -- Register
        signal count, next_count : UNSIGNED (13 downto 0); -- CAREFULL, SHOULD BE CHANGED ACCORDING TO refresh_rate constant
        
        -- FSM state declaration
        signal state, next_state : state_type;
    
    -- Auxiliar signals
        signal info_to_be_shown : UNSIGNED (6 downto 0);

begin
    -- Register
        process (clk, reset)
        begin
            if reset = '1' then
                state <= idle;
                count <= (others => '0');
            elsif rising_edge(clk) then
                state <= next_state;
                count <= next_count;
            end if;
        end process;
        
    -- FSMD
        process (count, state, volume_info)
        begin
            -- Default treatment
                an <= (others => '1');
                info_to_be_shown <= (others => '0');
                next_state <= state;
                        
            case state is
                
                when idle =>
                    next_count <= (others => '0');
                    next_state <= volume1;
                                    
                when volume1 =>
                    an <= "10111111";
                    info_to_be_shown <= to_unsigned(10,7); -- tens
                    next_count <= count + 1;
                    
                    if count < refresh_rate then
                        next_state <= volume1;
                    elsif count >= refresh_rate then
                        next_state <= volume2;
                        next_count <= (others => '0');
                    end if;
                    
                when volume2 =>
                    an <= "11011111";
                    info_to_be_shown <= to_unsigned(11,7); -- units
                    next_count <= count + 1;
                    
                    if count < refresh_rate then
                        next_state <= volume2;
                    elsif count >= refresh_rate then
                        next_state <= volume3;
                        next_count <= (others => '0');
                    end if;
                    
                when volume3 =>
                    an <= "11101111";
                    info_to_be_shown <= to_unsigned(12,7); -- tens
                    next_count <= count + 1;
                    
                    if count < refresh_rate then
                        next_state <= volume3;
                    elsif count >= refresh_rate then
                        next_state <= volume4;
                        next_count <= (others => '0');
                    end if;
                    
                when volume4 =>
                    an <= "11111011";
                    info_to_be_shown <= unsigned(volume_info)/10; -- tens
                    next_count <= count + 1;
                    
                    if count < refresh_rate then
                        next_state <= volume4;
                    elsif count >= refresh_rate then
                        next_state <= volume5;
                        next_count <= (others => '0');
                    end if;
                    
                when volume5 =>
                    an <= "11111101";
                    info_to_be_shown <= unsigned(volume_info) mod 10; -- tens
                    next_count <= count + 1;
                    
                    if count < refresh_rate then
                        next_state <= volume5;
                    elsif count >= refresh_rate then
                        next_state <= volume1;
                        next_count <= (others => '0');
                    end if;
                
                when others =>
                    next_state <= idle;
            
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
                         V_7_seg when info_to_be_shown = 10 else
                         O_7_seg when info_to_be_shown = 11 else
                         L_7_seg when info_to_be_shown = 12 else
                         zero_7_seg;
                      
end Behavioral;
