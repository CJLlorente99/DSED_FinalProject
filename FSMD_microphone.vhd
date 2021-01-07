----------------------------------------------------------------------------------
-- Company: Grupo 9
-- Engineer: CJLL & ITI
-- 
-- Create Date: 09.11.2020 11:03:24
-- Design Name: -
-- Module Name: FSMD_microphone - Behavioral
-- Project Name: Sistema de grabación, tratamiento y reproducción de audio
-- Target Devices: 
-- Tool Versions: 
-- Description: This component receives data from the microphone and translates it to STD_LOGIC_VECTOR. 
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

entity FSMD_microphone is
    Port ( clk_12megas : in STD_LOGIC; -- System clk
           reset : in STD_LOGIC; -- Asynchronous reset
           enable_4_cycles : in STD_LOGIC; -- Input signal in order to make this component work at 3MHz (comes from an AND gate of enable_4_cycles and record_enable)
           micro_data : in STD_LOGIC; -- Incoming data from microphone
           sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0); -- Sampled microphone data
           sample_out_ready : out STD_LOGIC -- Indicates sample_out is ready to be taken
           );
end FSMD_microphone;

architecture Behavioral of FSMD_microphone is
    -- FSM state type declaration
        type state_type is (idle, track, show_data1, show_data2);
    
    -- Signal declaration
        -- Registers
        signal count, next_count : integer;
        signal data1, next_data1, data2, next_data2, sample_out_unsig, next_sample_out_unsig : unsigned (sample_size-1 downto 0);
        signal first_cycle, next_first_cycle, next_sout_ready, sout_ready : STD_LOGIC;
        
        -- FSM state declaration
        signal state, next_state : state_type;

begin

    -- Register
    -- Upload new register values at a 3 MHz rate
        process (clk_12megas, reset)
        begin
            if reset = '1' then
                count <= 0;
                data1 <= (others => '0');
                data2 <= (others => '0');
                first_cycle <= '0';
                
                sample_out_unsig <= (others => '0');
                sout_ready <= '0';
                
                state <= idle;
                
            elsif rising_edge(clk_12megas) then
                if enable_4_cycles = '1' then -- IMPORTANT this if clause also contains record_enable condition
                    state <= next_state;
                    count <= next_count;
                    data1 <= next_data1;
                    data2 <= next_data2;
                    first_cycle <= next_first_cycle;
                    sout_ready <= next_sout_ready;
                    sample_out_unsig <= next_sample_out_unsig;
                end if;
            end if;
        end process;
    
    -- FSMD
        process (state, reset, micro_data, count, next_count, first_cycle, enable_4_cycles, data1, data2, sample_out_unsig, next_data1, next_data2)
        begin
            -- Default treatment
            next_count <= count;
            next_data1 <= data1;
            next_data2 <= data2;
            next_first_cycle <= first_cycle;
            next_sample_out_unsig <= sample_out_unsig;
            next_sout_ready <= '0';
            
            case (state) is
                
                -- Idle state reset every register and output value
                when idle =>
                    next_state <= track;
                
                -- Track state registers if micro data is 1 and adds it to each counter
                when track =>
                    next_count <= count + 1;
                    
                    if micro_data = '1' then
                        next_data1 <= data1 + 1;
                        next_data2 <= data2 + 1;
                    end if;
                    
                    if ((0 <= next_count and next_count <= 105) or (150 <= next_count and next_count <= 255)) then
                        next_state <= track;
                    else
                        if (106 <= next_count and next_count <= 149) then
                            next_state <= show_data2;
                            if first_cycle = '1' then
                                next_sample_out_unsig <= next_data2;
                                next_sout_ready <= '1';
                            end if;
                        else
                            next_state <= show_data1;
                            next_sample_out_unsig <= next_data1;
                            next_sout_ready <= '1';
                        end if;
                    end if;
                
                -- Show_data1 state stops micro data counting for counter 1 and uploads sample_out with counter 1 value
                when show_data1 =>
                    if count = 299 then
                        next_count <= 0;
                        next_first_cycle <= '1';
                    else
                        next_count <= count + 1;
                    end if;
                    
                    if micro_data = '1' then
                        next_data2 <= data2 + 1;
                    end if;
                    
                    if count = 256 then
                        next_sample_out_unsig <= data1;
                        next_sout_ready <= '0';
                    end if;
                    
                    if (256 <= next_count and next_count <= 299) then
                        next_state <= show_data1;
                    else
                        next_state <= track;
                        next_data1 <= (others => '0');
                    end if;
                
                -- Show_data1 state stops micro data counting for counter 2 and uploads sample_out with counter 2 value
                when show_data2 =>
                    next_count <= count + 1;
                    
                    if micro_data = '1' then
                        next_data1 <= data1 + 1;
                    end if;
                    
                    if first_cycle = '1' and count = 106 then
                        next_sample_out_unsig <= data2;
                        next_sout_ready <= '0';
                    end if;
                    
                    if (106 <= next_count and next_count <= 149) then
                        next_state <= show_data2;
                    else
                        next_state <= track;
                        next_data2 <= (others => '0');
                    end if;
                    
                when others =>
                    next_state <= idle;
                    
            end case;
        end process;
    
    -- Output logic
        sample_out <= std_logic_vector(sample_out_unsig);
        sample_out_ready <= sout_ready and enable_4_cycles;                 

end Behavioral;
