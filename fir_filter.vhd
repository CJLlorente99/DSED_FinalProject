----------------------------------------------------------------------------------
-- Company: Grupo 9
-- Engineer: CJLL & ITI
-- 
-- Create Date: 04.12.2020 13:13:33
-- Design Name: 
-- Module Name: fir_filter - Behavioral
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

entity fir_filter is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_in_enable : in STD_LOGIC;
           filter_select : in STD_LOGIC;
           sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_out_ready : out STD_LOGIC);
end fir_filter;

architecture Behavioral of fir_filter is
    -- Component instantiation
        component fir_data_path is
            Port ( clk : in STD_LOGIC;
                   reset : in STD_LOGIC;
                   clear : in STD_LOGIC;
                   ctrl : in STD_LOGIC_VECTOR (2 downto 0);
                   filter_select : in STD_LOGIC; -- HIGH = 1   |  LOW = 0
                   sample_enable : in STD_LOGIC;
                   sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
                   s : out STD_LOGIC_VECTOR (sample_size-1 downto 0)
               );
        end component;
        
        component controlador_fir is
            Port ( 
                clk : in STD_LOGIC;
                reset : in STD_LOGIC;
                clear : in STD_LOGIC;
                sample_in_enable : in STD_LOGIC;
                ctrl : out STD_LOGIC_VECTOR(2 downto 0);
                sample_out_ready :out STD_LOGIC
            );
        end component;
    
    -- fir_data_path signals:
        signal ctrl : STD_LOGIC_VECTOR(2 downto 0);
        signal act_filter_select : STD_LOGIC;
    
    -- Auxiliar signal that clears FIR memory to prevent first samples from getting altered if filtering mode is changed.
        signal clear_aux : STD_LOGIC;

begin
    -- Module instantiation
        U0 : fir_data_path port map(
            clk => clk,
            reset => reset,
            clear => clear_aux,
            ctrl => ctrl,
            filter_select => filter_select,
            sample_enable => sample_in_enable,
            sample_in => sample_in,
            s => sample_out
        );
        
        U1 : controlador_fir port map(
            clk => clk,
            reset => reset,
            clear => clear_aux,
            sample_in_enable => sample_in_enable,
            ctrl => ctrl,
            sample_out_ready => sample_out_ready
        );
    
    -- Logic that activates clear when filter_select changes
    -- Register
        process(clk)
        begin
            if rising_edge(clk) then
                act_filter_select <= filter_select;
            end if;
        end process;
    
    -- Output logic
        clear_aux <= '1' when act_filter_select /= filter_select else
                     '0';       


end Behavioral;
