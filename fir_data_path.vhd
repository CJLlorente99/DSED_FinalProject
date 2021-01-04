----------------------------------------------------------------------------------
-- Company: Grupo 9
-- Engineer: CJLL & ITI
-- 
-- Create Date: 27.11.2020 13:37:21
-- Design Name: 
-- Module Name: fir_data_path - Behavioral
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

entity fir_data_path is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           clear : IN STD_LOGIC;
           ctrl : in STD_LOGIC_VECTOR (2 downto 0);
           filter_select : in STD_LOGIC; -- HIGH = 1   |  LOW = 0
           sample_enable : in STD_LOGIC;
           sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           s : out STD_LOGIC_VECTOR (sample_size-1 downto 0));
end fir_data_path;

architecture Behavioral of fir_data_path is
    -- Component instantiation
        component half_mul is
            Port ( 
                clk : in STD_LOGIC;
                reset : in STD_LOGIC;
                a : in STD_LOGIC_VECTOR ((sample_size-1) downto 0);
                b : in STD_LOGIC_VECTOR ((sample_size-1) downto 0);
                c : out STD_LOGIC_VECTOR (((sample_size*2)-2) downto 0));
        end component;    
    
    -- Signals
        -- Registers
        signal mul1, mul2 : signed (sample_size-1 downto 0) := (others => '0');
        signal sum1, sum2 : signed (sample_size*2 - 2 downto 0) := (others => '0');
        signal next_s :  STD_LOGIC_VECTOR (sample_size-1 downto 0) := (others => '0');
        signal half_mul_out : STD_LOGIC_VECTOR(sample_size*2 - 2 downto 0) := (others => '0');
        signal r1, next_r1, add : signed(sample_size*2 - 1 downto 0) := (others => '0');
        
        -- Filter coefs
        signal c0, c1, c2, c3, c4 : signed(sample_size-1 downto 0);
        
        -- Samples
        signal x0, x1, x2, x3, x4 : signed(sample_size-1 downto 0);
        
        -- Saturation values
        constant MAX_SAT : STD_LOGIC_VECTOR (sample_size - 1 downto 0) := (sample_size-1 => '0' , others => '1');
        constant MIN_SAT : STD_LOGIC_VECTOR (sample_size - 1 downto 0) := (sample_size-1 => '1' , others => '0');

begin
    -- Arithmetic units
    -- HalfMul
        U0 : half_mul port map(
            clk => clk,
            reset => reset,
            a => std_logic_vector(mul1),
            b => std_logic_vector(mul2),
            c => half_mul_out
        );
    -- Adder
        add <= resize(sum1, sample_size*2) + resize(sum2, sample_size*2);
    
    -- Coef selecction
        c0 <= c0_low when filter_select = '0' else c0_high;
        c1 <= c1_low when filter_select = '0' else c1_high;
        c2 <= c2_low when filter_select = '0' else c2_high;
        c3 <= c3_low when filter_select = '0' else c3_high;
        c4 <= c4_low when filter_select = '0' else c4_high;        
        
    -- Register
        process (clk, reset) begin
            if reset = '1' then
                r1 <= (others => '0');
                x0 <= (others => '0');
                x1 <= (others => '0');
                x2 <= (others => '0');
                x3 <= (others => '0');
                x4 <= (others => '0');
                
            elsif rising_edge(clk) then
                r1 <= next_r1;
                
                if clear = '1' then
                    x0 <= (others => '0');
                    x1 <= (others => '0');
                    x2 <= (others => '0');
                    x3 <= (others => '0');
                    x4 <= (others => '0');
                                
                elsif sample_enable = '1' then
                      x0 <= signed(sample_in);
                      x1 <= x0;
                      x2 <= x1;
                      x3 <= x2;
                      x4 <= x3;
                end if;
            end if;
        end process;
    
    -- HalfMul input routing
        process(ctrl, x0, x1, x2, x3, x4, c0, c1, c2, c3, c4)
        begin
            case ctrl is
                when "000" =>
                    mul1 <= c0;
                    mul2 <= x0;
                when "001" =>
                    mul1 <= c1;
                    mul2 <= x1;
                when "010" =>
                    mul1 <= c2;
                    mul2 <= x2;
                when "011" =>
                    mul1 <= c3;
                    mul2 <= x3;
                when "100" =>
                    mul1 <= c4;
                    mul2 <= x4;
                when others =>
                    mul1 <= c4;
                    mul2 <= x4;
                end case;
            end process;
            
        -- HalfMul output routing
            -- It could be simplifyed but it has been decided to follow the canonical strcuture presented during the course. 
            process(half_mul_out)
            begin
                sum1 <= signed(half_mul_out);
            end process;
            
        -- Adder input routing
            process(ctrl, r1)
            begin
                case ctrl is
                    when "000" =>
                        sum2 <= r1(sample_size * 2 - 2 downto 0);
                    when "001" =>
                        sum2 <= (others => '0');
                    when "010" =>
                        sum2 <= r1(sample_size * 2 - 2 downto 0);
                    when "011" =>
                        sum2 <= r1(sample_size * 2 - 2 downto 0);
                    when "100" =>
                        sum2 <= r1(sample_size * 2 - 2 downto 0);
                    when others =>
                        sum2 <= r1(sample_size * 2 - 2 downto 0);
                end case;
            end process;
            
        -- Adder output routing
            -- It could be simplifyed but it has been decided to follow the canonical strcuture presented during the course. 
            process (add)
            begin
                next_r1 <= add;
            end process;
    
        -- Output logic
        -- Considering worst case scenario, it has been determined necessary to set max and min output values.
            s <=  MAX_SAT when r1(sample_size*2 - 1 downto sample_size*2 - 2) = "01" else
                  MIN_SAT when r1(sample_size*2 - 1 downto sample_size*2 - 2) = "10" else
                  std_logic_vector(r1(sample_size*2-2 downto sample_size-1));

end Behavioral;
