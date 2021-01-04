----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.12.2020 12:19:26
-- Design Name: 
-- Module Name: fir_filter_3_tb - Behavioral
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
use STD.TEXTIO.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fir_filter_3_tb is
--  Port ( );
end fir_filter_3_tb;

architecture Behavioral of fir_filter_3_tb is

    component fir_filter is
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
               sample_in_enable : in STD_LOGIC;
               filter_select : in STD_LOGIC;
--               adder_res : out STD_LOGIC_VECTOR(sample_size*2 - 1 downto 0);
--               hm_res : out STD_LOGIC_VECTOR (((sample_size*2)-2) downto 0);
               sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
--               ctrl : out STD_LOGIC_VECTOR (2 downto 0);
--               x00 : out STD_LOGIC_VECTOR(sample_size-1 downto 0);
--               x01 : out STD_LOGIC_VECTOR(sample_size-1 downto 0);
--               x02 : out STD_LOGIC_VECTOR(sample_size-1 downto 0);
--               x03 : out STD_LOGIC_VECTOR(sample_size-1 downto 0);
--               x04 : out STD_LOGIC_VECTOR(sample_size-1 downto 0);
               sample_out_ready : out STD_LOGIC);
    end component;
    
    signal clk, reset, sample_in_enable, filter_select, sample_out_ready : STD_LOGIC := '0';
    signal sample_in, sample_out : STD_LOGIC_VECTOR (sample_size-1 downto 0) := (others => '0');
    
    -- Debugging signals
        
    --    signal hm_res : STD_LOGIC_VECTOR (((sample_size*2)-2) downto 0);
    --    signal adder_res : STD_LOGIC_VECTOR (((sample_size*2)-1) downto 0);
    --    signal ctrl : STD_LOGIC_VECTOR (2 downto 0);
    --    signal x00, x01, x02, x03, x04 : STD_LOGIC_VECTOR (sample_size-1 downto 0);
        
    -- Timing constants
    constant PERIOD : time := 10 ns;
    
    -- Open File Period
    signal clk_open : STD_LOGIC := '0';
    
    constant NUM_COL                : integer := 3;   -- number of column of file
    type t_integer_array       is array(integer range <> )  of integer;
    
    
    signal filter_select_aux : STD_LOGIC_VECTOR(7 downto 0); 
    signal reset_aux : STD_LOGIC_VECTOR(7 downto 0); 

begin

    U0 : fir_filter port map(
        clk => clk,
        reset => reset,
        sample_in => sample_in,
        sample_in_enable => sample_in_enable,
        filter_select => filter_select,
--        adder_res => adder_res,
--        hm_res => hm_res,
        sample_out => sample_out,
--        ctrl => ctrl,
--        x00 => x00,
--        x01 => x01,
--        x02 => x02,
--        x03 => x03,
--        x04 => x04,
        sample_out_ready => sample_out_ready
    );
    
    
    TIMING : process begin
        clk <= '0';
        wait for PERIOD/2;
        clk <= '1';
        wait for PERIOD/2;
    end process;
    
    TIMING_OPEN : process begin
        clk_open <= '0';
        wait for PERIOD * 10;
        clk_open <= '1';
        wait for PERIOD * 10;
    end process;
    
    SAMPLES_ENABLING : process begin
        sample_in_enable <= '0';
        wait for 19*PERIOD;
        sample_in_enable <= '1';
        wait for PERIOD;
    end process;
    
    
    READ_VALUES : process(clk_open) 
        FILE in_file : text OPEN read_mode IS "D:\Vivado\Laboratorios\final_project\DSEDFinalProject\input_data\sample_in_haha_LP.dat";
        variable in_line : line;
        variable in_read_ok : BOOLEAN;
        variable v_data_read            : t_integer_array(1 to NUM_COL);
    begin
        if rising_edge(clk_open) then
            if not endfile(in_file) then
                ReadLine(in_file, in_line);
                
                for item in 1 to NUM_COL loop 
                    Read(in_line, v_data_read(item), in_read_ok);
                end loop;
                
                reset_aux <= std_logic_vector(to_signed(v_data_read(1), 8));
                filter_select_aux <= std_logic_vector(to_signed(v_data_read(2), 8));
                sample_in <= std_logic_vector(to_signed(v_data_read(3), 8));
                
                if reset_aux = "00000000" then
                    reset <= '0';
                else 
                    reset <= '1';
                end if;
                
                if filter_select_aux = "00000000" then
                    filter_select <= '0';
                else 
                    filter_select <= '1';
                end if;
            else
                assert false report "Simulation Finished" severity failure;
            end if;
        end if;
    end process;
    
    WRITE_VALUES : process(clk)
        FILE out_file : text OPEN write_mode IS "D:\Vivado\Laboratorios\final_project\DSEDFinalProject\output_data\sample_out_haha_LP.dat";
        variable out_line : line;
    begin
        if rising_edge(clk) then
            if sample_out_ready = '1' then
                Write(out_line, to_integer(signed(sample_out)));
                WriteLine(out_file, out_line);
            end if;
        end if;
    end process;
    
    
    
    

end Behavioral;
