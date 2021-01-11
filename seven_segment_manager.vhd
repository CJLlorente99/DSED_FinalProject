----------------------------------------------------------------------------------
-- Company: Grupo 9
-- Engineer: CJLL & ITI
-- 
-- Create Date: 05.01.2021 14:24:43
-- Design Name: 
-- Module Name: seven_segment_manager - Behavioral
-- Project Name: Sistema de grabación, tratamiento y reproducción de audio
-- Target Devices: 
-- Tool Versions: 
-- Description: This module deals with the information that is to be shown in the seven segments display.
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

entity seven_segment_manager is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           volume_info : in STD_LOGIC_VECTOR (6 downto 0); -- info about volume level
           level : in STD_LOGIC_VECTOR (4 downto 0); -- info about current delay level
           secs_left : in STD_LOGIC_VECTOR (4 downto 0);
           secs_played : in STD_LOGIC_VECTOR (4 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           seven_seg : out STD_LOGIC_VECTOR (6 downto 0)
       );
end seven_segment_manager;

architecture Behavioral of seven_segment_manager is       
    -- FSM state type declaration
        type state_type is (idle, show);
        
    -- Signal definition
        -- Register
        signal count, next_count, rotating_count, next_rotating_count : UNSIGNED (13 downto 0); -- CAREFULL, SHOULD BE CHANGED ACCORDING TO refresh_rate/rotating_rate constant
        signal iterator, next_iterator : UNSIGNED (7 downto 0); -- signal rotated for output an assignation
        signal digit_shown, next_digit_shown : UNSIGNED(5 downto 0); -- info's index displayed 
        signal rotating_info, next_rotating_info : UNSIGNED(5 downto 0); -- in order to rotate info
        signal act_info : SEVEN_SEG_INFO (info_length-1 downto 0); -- rotated info's version
        
        -- FSM state declaration
        signal state, next_state : state_type;
    
    -- Auxiliar signals
        signal info : SEVEN_SEG_INFO (info_length-1 downto 0); 
        signal info_to_be_shown : UNSIGNED (6 downto 0); -- 7 segment shown

begin
    -- info association
--        info(70) <= (others => '1');
--        info(69) <= to_unsigned(letter_S, 7);
--        info(68) <= to_unsigned(letter_E, 7);
--        info(67) <= to_unsigned(letter_C, 7);
--        info(66) <= to_unsigned(letter_S, 7);
--        info(65) <= (others => '1');
--        info(64) <= to_unsigned(letter_L, 7);
--        info(63) <= to_unsigned(letter_E, 7);
--        info(62) <= to_unsigned(letter_F, 7);
--        info(61) <= to_unsigned(letter_T, 7);
--        info(60) <= (others => '1');
--        info(59) <= to_unsigned(letter_T, 7);
--        info(58) <= to_unsigned(letter_O, 7);
--        info(57) <= (others => '1');
--        info(56) <= to_unsigned(letter_B, 7);
--        info(55) <= to_unsigned(letter_E, 7);
--        info(54) <= (others => '1');
--        info(53) <= to_unsigned(letter_P, 7);
--        info(52) <= to_unsigned(letter_L, 7);
--        info(51) <= to_unsigned(letter_A, 7);
--        info(50) <= to_unsigned(letter_Y, 7);
--        info(49) <= to_unsigned(letter_E, 7);
--        info(48) <= to_unsigned(letter_D, 7);
--        info(47) <= (others => '1');
--        info(46) <= "000" & unsigned(secs_played)/10;
--        info(45) <= "000" & unsigned(secs_played) mod 10;
--        info(44) <= (others => '1');
--        info(43) <= to_unsigned(symbol_barras, 7);
    
        info(43) <= (others => '1');
        info(42) <= to_unsigned(letter_S, 7);
        info(41) <= to_unsigned(letter_E, 7);
        info(40) <= to_unsigned(letter_C, 7);
        info(39) <= to_unsigned(letter_S, 7);
        info(38) <= (others => '1');
        info(37) <= to_unsigned(letter_L, 7);
        info(36) <= to_unsigned(letter_E, 7);
        info(35) <= to_unsigned(letter_F, 7);
        info(34) <= to_unsigned(letter_T, 7);
        info(33) <= (others => '1');
        info(32) <= to_unsigned(letter_I, 7);
        info(31) <= to_unsigned(letter_N, 7);
        info(30) <= (others => '1');
        info(29) <= to_unsigned(letter_R, 7);
        info(28) <= to_unsigned(letter_A, 7);
        info(27) <= to_unsigned(letter_M, 7);
        info(26) <= (others => '1');
        info(25) <= "000" & unsigned(secs_left)/10;
        info(24) <= "000" & unsigned(secs_left) mod 10;
        info(23) <= (others => '1');
        info(22) <= to_unsigned(symbol_barras, 7);
        
        info(21) <= (others => '1');
        info(20) <= to_unsigned(letter_E, 7);
        info(19) <= to_unsigned(letter_C, 7);
        info(18) <= to_unsigned(letter_O, 7);
        info(17) <= (others => '1');
        info(16) <= to_unsigned(symbol_igual, 7);
        info(15) <= (others => '1');
        info(14) <= "000" & unsigned(level)/10;
        info(13) <= "000" & unsigned(level) mod 10;
        info(12) <= (others => '1');
        info(11) <= to_unsigned(symbol_barras, 7);
                
        info(10) <= (others => '1');
        info(9) <= to_unsigned(letter_V, 7);
        info(8) <= to_unsigned(letter_O, 7);
        info(7) <= to_unsigned(letter_L, 7);
        info(6) <= (others => '1');
        info(5) <= to_unsigned(symbol_igual, 7);
        info(4) <= (others => '1');
        info(3) <= unsigned(volume_info)/10;
        info(2) <= unsigned(volume_info) mod 10;
        info(1) <= (others => '1');
        info(0) <= to_unsigned(symbol_barras, 7);

    -- Register
        process (clk, reset)
        begin
            if reset = '1' then
                state <= idle;
                count <= (others => '0');
                rotating_count <= (others => '0');
                iterator <= "10000000";
                digit_shown <= to_unsigned(info'length,digit_shown'length) - 1;
                rotating_info <= (others => '0');
            elsif rising_edge(clk) then
                state <= next_state;
                count <= next_count;
                rotating_count <= next_rotating_count;
                iterator <= next_iterator;
                digit_shown <= next_digit_shown;
                rotating_info <= next_rotating_info;
            end if;
        end process;
        
    -- FSMD
        process (count, state, digit_shown, iterator, rotating_count, rotating_info)
        begin
            -- Default treatment
                next_iterator <= iterator;
                next_state <= state;
                next_count <= count;
                next_rotating_count <= rotating_count;
                next_digit_shown <= digit_shown;
                next_rotating_info <= rotating_info;
                        
            case state is
                
                -- idle state
                when idle =>
                    next_count <= (others => '0');
                    next_rotating_count <= (others => '0');
                    next_iterator <= "10000000";
                    next_digit_shown <= to_unsigned(info'length,digit_shown'length) - 1;
                    next_state <= show;
                    next_rotating_info <= (others => '0');
                
                -- main state with mealy transitions
                when show =>
                    next_count <= count + 1;                    
                    if count < refresh_rate then -- refresh rate makes sure every display is illuminated a certain amount of time
                        next_state <= show;
                    elsif count >= refresh_rate then
                        next_state <= show;
                        next_iterator <= rotate_right(iterator, 1); -- iterate through every display
                        next_count <= (others => '0');
                        
                        if digit_shown = info'length-8 then -- indicates 8 displays have been correctly illuminated
                            next_digit_shown <= to_unsigned(info'length, digit_shown'length) - 1;
                            if rotating_count < rotation_rate then -- rotation rate in order to show info at a sufficient pace
                                next_rotating_count <= rotating_count + 1;
                            else -- when sufficient time has been reached, rotate and show more info
                                if rotating_info = info'length-1 then
                                    next_rotating_info <= (others => '0');
                                else
                                    next_rotating_info <= rotating_info + 1;
                                end if;
                                next_rotating_count <= (others => '0');
                            end if;
                        else
                            next_digit_shown <= digit_shown - 1;
                        end if;
                    end if;
                
                when others =>
                    next_state <= idle;
            
            end case;
        end process;
        
        -- Output Logic
            -- rotation association (left-wise)
            act_info <= info(info'length-2 downto 0) & info(info'length-1 downto info'length-1) when rotating_info=1 else
                        info(info'length-3 downto 0) & info(info'length-1 downto info'length-2) when rotating_info=2 else
                        info(info'length-4 downto 0) & info(info'length-1 downto info'length-3) when rotating_info=3 else
                        info(info'length-5 downto 0) & info(info'length-1 downto info'length-4) when rotating_info=4 else
                        info(info'length-6 downto 0) & info(info'length-1 downto info'length-5) when rotating_info=5 else
                        info(info'length-7 downto 0) & info(info'length-1 downto info'length-6) when rotating_info=6 else
                        info(info'length-8 downto 0) & info(info'length-1 downto info'length-7) when rotating_info=7 else
                        info(info'length-9 downto 0) & info(info'length-1 downto info'length-8) when rotating_info=8 else
                        info(info'length-10 downto 0) & info(info'length-1 downto info'length-9) when rotating_info=9 else
                        info(info'length-11 downto 0) & info(info'length-1 downto info'length-10) when rotating_info=10 else
                        info(info'length-12 downto 0) & info(info'length-1 downto info'length-11) when rotating_info=11 else
                        info(info'length-13 downto 0) & info(info'length-1 downto info'length-12) when rotating_info=12 else
                        info(info'length-14 downto 0) & info(info'length-1 downto info'length-13) when rotating_info=13 else
                        info(info'length-15 downto 0) & info(info'length-1 downto info'length-14) when rotating_info=14 else
                        info(info'length-16 downto 0) & info(info'length-1 downto info'length-15) when rotating_info=15 else
                        info(info'length-17 downto 0) & info(info'length-1 downto info'length-16) when rotating_info=16 else
                        info(info'length-18 downto 0) & info(info'length-1 downto info'length-17) when rotating_info=17 else
                        info(info'length-19 downto 0) & info(info'length-1 downto info'length-18) when rotating_info=18 else
                        info(info'length-20 downto 0) & info(info'length-1 downto info'length-19) when rotating_info=19 else
                        info(info'length-21 downto 0) & info(info'length-1 downto info'length-20) when rotating_info=20 else
                        info(info'length-22 downto 0) & info(info'length-1 downto info'length-21) when rotating_info=21 else
                        info(info'length-23 downto 0) & info(info'length-1 downto info'length-22) when rotating_info=22 else
                        info(info'length-24 downto 0) & info(info'length-1 downto info'length-23) when rotating_info=23 else                                                                                                  
                        info(info'length-25 downto 0) & info(info'length-1 downto info'length-24) when rotating_info=24 else
                        info(info'length-26 downto 0) & info(info'length-1 downto info'length-25) when rotating_info=25 else
                        info(info'length-27 downto 0) & info(info'length-1 downto info'length-26) when rotating_info=26 else
                        info(info'length-28 downto 0) & info(info'length-1 downto info'length-27) when rotating_info=27 else
                        info(info'length-29 downto 0) & info(info'length-1 downto info'length-28) when rotating_info=28 else
                        info(info'length-30 downto 0) & info(info'length-1 downto info'length-29) when rotating_info=29 else
                        info(info'length-31 downto 0) & info(info'length-1 downto info'length-30) when rotating_info=30 else
                        info(info'length-32 downto 0) & info(info'length-1 downto info'length-31) when rotating_info=31 else
                        info(info'length-33 downto 0) & info(info'length-1 downto info'length-32) when rotating_info=32 else
                        info(info'length-34 downto 0) & info(info'length-1 downto info'length-33) when rotating_info=33 else
                        info(info'length-35 downto 0) & info(info'length-1 downto info'length-34) when rotating_info=34 else                                                                                                  
                        info(info'length-36 downto 0) & info(info'length-1 downto info'length-35) when rotating_info=35 else
                        info(info'length-37 downto 0) & info(info'length-1 downto info'length-36) when rotating_info=36 else
                        info(info'length-38 downto 0) & info(info'length-1 downto info'length-37) when rotating_info=37 else
                        info(info'length-39 downto 0) & info(info'length-1 downto info'length-38) when rotating_info=38 else
                        info(info'length-40 downto 0) & info(info'length-1 downto info'length-39) when rotating_info=39 else
                        info(info'length-41 downto 0) & info(info'length-1 downto info'length-40) when rotating_info=40 else
                        info(info'length-42 downto 0) & info(info'length-1 downto info'length-41) when rotating_info=41 else
                        info(info'length-43 downto 0) & info(info'length-1 downto info'length-42) when rotating_info=42 else
                        info(info'length-44 downto 0) & info(info'length-1 downto info'length-43) when rotating_info=43 else
--                        info(info'length-45 downto 0) & info(info'length-1 downto info'length-44) when rotating_info=44 else
--                        info(info'length-46 downto 0) & info(info'length-1 downto info'length-45) when rotating_info=45 else                                                                                                  
--                        info(info'length-47 downto 0) & info(info'length-1 downto info'length-46) when rotating_info=46 else
--                        info(info'length-48 downto 0) & info(info'length-1 downto info'length-47) when rotating_info=47 else
--                        info(info'length-49 downto 0) & info(info'length-1 downto info'length-48) when rotating_info=48 else
--                        info(info'length-50 downto 0) & info(info'length-1 downto info'length-49) when rotating_info=49 else
--                        info(info'length-51 downto 0) & info(info'length-1 downto info'length-50) when rotating_info=50 else
--                        info(info'length-52 downto 0) & info(info'length-1 downto info'length-51) when rotating_info=51 else
--                        info(info'length-53 downto 0) & info(info'length-1 downto info'length-52) when rotating_info=52 else
                        info;
            
            -- actual element in the array info to be shown
            info_to_be_shown <= act_info(to_integer(digit_shown));
            
            -- association between 7 segment std_logic_vector and info (unsigned)                            
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
                         A_7_seg when info_to_be_shown = 10 else
                         B_7_seg when info_to_be_shown = 11 else
                         C_7_seg when info_to_be_shown = 12 else
                         D_7_seg when info_to_be_shown = 13 else
                         E_7_seg when info_to_be_shown = 14 else
                         F_7_seg when info_to_be_shown = 15 else
                         G_7_seg when info_to_be_shown = 16 else
                         H_7_seg when info_to_be_shown = 17 else
                         I_7_seg when info_to_be_shown = 18 else
                         J_7_seg when info_to_be_shown = 19 else
                         K_7_seg when info_to_be_shown = 20 else
                         L_7_seg when info_to_be_shown = 21 else
                         M_7_seg when info_to_be_shown = 22 else
                         N_7_seg when info_to_be_shown = 23 else
                         O_7_seg when info_to_be_shown = 24 else                                       
                         P_7_seg when info_to_be_shown = 25 else
                         Q_7_seg when info_to_be_shown = 26 else
                         R_7_seg when info_to_be_shown = 27 else
                         S_7_seg when info_to_be_shown = 28 else
                         T_7_seg when info_to_be_shown = 29 else
                         U_7_seg when info_to_be_shown = 30 else
                         V_7_seg when info_to_be_shown = 31 else
                         W_7_seg when info_to_be_shown = 32 else                                       
                         X_7_seg when info_to_be_shown = 33 else
                         Y_7_seg when info_to_be_shown = 34 else
                         Z_7_seg when info_to_be_shown = 35 else
                         igual_7_seg when info_to_be_shown = 36 else 
                         barra_7_seg when info_to_be_shown = 37 else
                         blank_7_seg;
            
            -- simple relation between iterator and output an             
            an <= not std_logic_vector(iterator);
                      
end Behavioral;
