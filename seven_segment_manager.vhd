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
        type state_type is (idle, show);
        
    -- Signal definition
        -- Register
        signal count, next_count, rotating_count, next_rotating_count : UNSIGNED (13 downto 0); -- CAREFULL, SHOULD BE CHANGED ACCORDING TO refresh_rate constant
        signal iterator, next_iterator : UNSIGNED (7 downto 0);
        signal digit_shown, next_digit_shown : UNSIGNED(3 downto 0);
        signal rotating_info, next_rotating_info : UNSIGNED(3 downto 0);
        signal act_info : SEVEN_SEG_INFO (8*num_info - 1 downto 0);
        
        -- FSM state declaration
        signal state, next_state : state_type;
    
    -- Auxiliar signals
        signal info : SEVEN_SEG_INFO (8*num_info - 1 downto 0); 
        signal info_to_be_shown : UNSIGNED (6 downto 0);

begin
    -- info association
        info(15) <= (others => '1');
        info(14) <= to_unsigned(letter_I, 7);
        info(13) <= to_unsigned(letter_N, 7);
        info(12) <= to_unsigned(letter_F, 7);
        info(11) <= (others => '1');
        info(10) <= to_unsigned(letter_A, 7);
        info(9) <= to_unsigned(letter_D, 7);
        info(8) <= to_unsigned(letter_D, 7);        
        info(7) <= (others => '1');
        info(6) <= to_unsigned(letter_V, 7);
        info(5) <= to_unsigned(letter_O, 7);
        info(4) <= to_unsigned(letter_L, 7);
        info(3) <= (others => '1');
        info(2) <= unsigned(volume_info)/10;
        info(1) <= unsigned(volume_info) mod 10;
        info(0) <= (others => '1');

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
        process (count, state, digit_shown, iterator, rotating_count)
        begin
            -- Default treatment
                next_iterator <= iterator;
                next_state <= state;
                next_count <= count;
                next_rotating_count <= rotating_count;
                next_digit_shown <= digit_shown;
                next_rotating_info <= rotating_info;
                        
            case state is
                
                when idle =>
                    next_count <= (others => '0');
                    next_rotating_count <= (others => '0');
                    next_iterator <= "10000000";
                    next_digit_shown <= to_unsigned(info'length,digit_shown'length) - 1;
                    next_state <= show;
                    next_rotating_info <= (others => '0');
                    
                when show =>
                    next_count <= count + 1;                    
                    if count < refresh_rate then
                        next_state <= show;
                    elsif count >= refresh_rate then
                        next_state <= show;
                        next_iterator <= rotate_right(iterator, 1);
                        next_count <= (others => '0');
                        
                        if digit_shown = info'length-8 then
                            next_digit_shown <= to_unsigned(info'length, digit_shown'length) - 1;
                            if rotating_count < rotation_rate then
                                next_rotating_count <= rotating_count + 1;
                            else
                                next_rotating_info <= rotating_info + 1;
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
            act_info <= info(0 downto 0) & info(8*num_info-1 downto 1) when rotating_info = 1 else
                        info(1 downto 0) & info(8*num_info-1 downto 2) when rotating_info = 2 else
                        info(2 downto 0) & info(8*num_info-1 downto 3) when rotating_info = 3 else
                        info(3 downto 0) & info(8*num_info-1 downto 4) when rotating_info = 4 else
                        info(4 downto 0) & info(8*num_info-1 downto 5) when rotating_info = 5 else
                        info(5 downto 0) & info(8*num_info-1 downto 6) when rotating_info = 6 else
                        info(6 downto 0) & info(8*num_info-1 downto 7) when rotating_info = 7 else
                        info(7 downto 0) & info(8*num_info-1 downto 8) when rotating_info = 8 else
                        info(8 downto 0) & info(8*num_info-1 downto 9) when rotating_info = 9 else
                        info(9 downto 0) & info(8*num_info-1 downto 10) when rotating_info = 10 else
                        info(10 downto 0) & info(8*num_info-1 downto 11) when rotating_info = 11 else
                        info(11 downto 0) & info(8*num_info-1 downto 12) when rotating_info = 12 else
                        info(12 downto 0) & info(8*num_info-1 downto 13) when rotating_info = 13 else
                        info(13 downto 0) & info(8*num_info-1 downto 14) when rotating_info = 14 else
                        info(14 downto 0) & info(8*num_info-1 downto 15) when rotating_info = 15 else
                        info;
        
            info_to_be_shown <= act_info(to_integer(digit_shown));
                                        
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
                         blank_7_seg;
                         
            an <= not std_logic_vector(iterator);
                      
end Behavioral;
