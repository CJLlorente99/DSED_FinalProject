----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.12.2020 12:25:17
-- Design Name: 
-- Module Name: ram_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ram_tb is
--  Port ( );
end ram_tb;

architecture Behavioral of ram_tb is

    component blk_mem_gen_0 IS
        Port (
            clka : IN STD_LOGIC;
            ena : IN STD_LOGIC;
            wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
            dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    end component;
    
    -- Signals
        signal clka, ena : STD_LOGIC := '0';
        signal wea : STD_LOGIC_VECTOR(0 downto 0) := (others => '0');
        signal addra : STD_LOGIC_VECTOR(18 downto 0) := (others => '0');
        signal dina : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
        signal douta : STD_LOGIC_VECTOR(7 downto 0);
        
        constant PERIOD : time := 83 ns;

begin
 
    U0 : blk_mem_gen_0 port map(
        clka => clka,
        ena => ena,
        wea => wea,
        addra => addra,
        dina => dina,
        douta => douta
    );
    
    TIMMING : process begin
        clka <= '0';
        wait for PERIOD/2;
        clka <= '1';
        wait for PERIOD/2;
    end process;
    
    
    VALUES : process begin
        ena <= '1';
        wea <= "1";
        addra <= (0 => '1' ,others => '0');
        dina <= "10101010";
        wait for PERIOD;
        addra <= (1 => '1' ,others => '0');
        dina <= "00001111";
        wait for PERIOD;
        addra <= (2 => '1' ,others => '0');
        dina <= "11110000";
        wait for PERIOD;
        addra <= (3 => '1' ,others => '0');
        dina <= "11001100";
        wait for PERIOD;
        addra <= (4 => '1' ,others => '0');
        dina <= "11101110";
        wait for PERIOD;
        wea <= "0";
        addra <= (0 => '1' ,others => '0');
        wait for PERIOD;
        addra <= (1 => '1' ,others => '0');
        wait for PERIOD;
        addra <= (2 => '1' ,others => '0');
        wait for PERIOD;
        addra <= (3 => '1' ,others => '0');
        wait for PERIOD;
        addra <= (4 => '1' ,others => '0');
        wait for PERIOD;
        
        ena <= '0';
        wea <= "1";
        addra <= (10 => '1' ,others => '0');
        dina <= "10101010";
        wait for PERIOD;
        wea <= "0";
        addra <= (10 => '1' ,others => '0');
        wait for PERIOD;
        ena <= '1';
        wea <= "1";
        addra <= (15 => '1' ,others => '0');
        dina <= "00010001";
        wait for PERIOD;
        wea <= "0";
        addra <= (15 => '1' ,others => '0');
        wait;
        
    end process;
    
end Behavioral;
