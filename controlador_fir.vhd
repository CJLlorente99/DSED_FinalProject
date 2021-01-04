----------------------------------------------------------------------------------
-- Company: Grupo 9
-- Engineer: CJLL & ITI
-- 
-- Create Date: 02.12.2020 13:14:07
-- Design Name: 
-- Module Name: controlador_fir - Behavioral
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
use work.package_dsed.ALL;
use IEEE.NUMERIC_STD.ALL;

entity controlador_fir is
    Port ( 
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        clear : in STD_LOGIC;
        sample_in_enable : in STD_LOGIC;
        ctrl : out STD_LOGIC_VECTOR(2 downto 0);
        sample_out_ready :out STD_LOGIC
    );
end controlador_fir;

architecture Behavioral of controlador_fir is
    -- Signals
        -- State related signals
        signal state, next_state : STD_LOGIC_VECTOR(2 downto 0);
        
        -- Register signals
        signal next_sample_out_ready : STD_LOGIC := '0';
        
    -- Constants
        -- State values:
        constant idle : STD_LOGIC_VECTOR (2 downto 0) := "111";
        constant s0 : STD_LOGIC_VECTOR (2 downto 0) := "000";
        constant s1 : STD_LOGIC_VECTOR (2 downto 0) := "001";
        constant s2 : STD_LOGIC_VECTOR (2 downto 0) := "010";
        constant s3 : STD_LOGIC_VECTOR (2 downto 0) := "011";
        constant s4 : STD_LOGIC_VECTOR (2 downto 0) := "100";
        constant s5 : STD_LOGIC_VECTOR (2 downto 0) := "101";

begin

    -- Register
        process (clk, reset) begin
            if reset = '1' then
                state <= idle;
                sample_out_ready <= '0';
            elsif rising_edge(clk) then
                if clear = '1' then
                    state <= idle;
                    sample_out_ready <= '0';
                else
                    sample_out_ready <= next_sample_out_ready;
                    state <= next_state;
                end if;
            end if;
        end process;
    
    
    -- Next State Logic
        process (state, sample_in_enable) begin
            next_sample_out_ready <= '0';
            next_state <= state;
            case state is 
                when idle =>
                    if (sample_in_enable = '1') then
                        next_state <= s0;
                    end if;
                when s0 =>
                    next_state <= s1;
                when s1 =>
                    next_state <= s2;
                when s2 =>
                    next_state <= s3;
                when s3 =>
                    next_state <= s4;
                when s4 =>
                    next_state <= s5;
                when s5 =>
                    next_state <= idle;
                    next_sample_out_ready <= '1';
                when others =>
                    next_state <= idle;
            end case;
        end process;
    
    
    -- Output Logic
        ctrl <= state;

end Behavioral;
