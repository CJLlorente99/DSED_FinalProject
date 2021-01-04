----------------------------------------------------------------------------------
-- Company: Grupo 9
-- Engineer: CJLL & ITI
-- 
-- Create Date: 09.11.2020 10:48:09
-- Design Name: 
-- Module Name: dsed_audio - Behavioral
-- Project Name: Sistema de grabación, tratamiento y reproducción de audio
-- Target Devices: 
-- Tool Versions: 
-- Description: This module rules the behaviour of the complete system. Behaviout is implemented as a FSM
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dsed_audio is
    Port ( clk_100Mhz : in STD_LOGIC;
           reset : in STD_LOGIC;
           -- Control ports
           BTNL : in STD_LOGIC; -- Record
           BTNC : in STD_LOGIC; -- Reset ram
           BTNR : in STD_LOGIC; -- Sound on
           SW0 : in STD_LOGIC; -- SW0 = '0' => (play forward or LPF), SW1= '1' => (play reverse or HPF)
           SW1 : in STD_LOGIC; -- SW1 = '0' => (play_reverse or play_forward), SW = '1' => filter (HPF or LPF)
           -- To/From the microphone
           micro_clk : out STD_LOGIC;
           micro_data : in STD_LOGIC;
           micro_LR : out STD_LOGIC;
           -- To/From the mini_jack
           jack_sd : out STD_LOGIC;
           jack_pwm : out STD_LOGIC;
           LED : out STD_LOGIC_VECTOR(7 downto 0)
           );
end dsed_audio;

architecture Behavioral of dsed_audio is
    -- Component declaration
        -- Input/Output component declaration    
        component audio_interface is
            Port ( clk_12megas : in STD_LOGIC;
                   reset : in STD_LOGIC;
                   -- Recording ports
                   -- To/From the controller
                   record_enable : in STD_LOGIC;
                   sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
                   sample_out_ready : out STD_LOGIC;
                   -- To/From the microphone
                   micro_clk : out STD_LOGIC;
                   micro_data : in STD_LOGIC;
                   micro_LR : out STD_LOGIC;
                   -- Playing ports
                   -- To/From the controller
                   play_enable : in STD_LOGIC;
                   sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
                   sample_request : out STD_LOGIC;
                   -- To/From the mini-jack
                   jack_sd : out STD_LOGIC;
                   jack_pwm : out STD_LOGIC;
                   --LED ports
                   --To/From PowerDisplay
                   LED : out STD_LOGIC_VECTOR (7 downto 0)
                   );
        end component;
        
        -- clock wizard component declaration
        component clk_wiz_12mhz is
            Port ( clk_100Mhz : in STD_LOGIC;
                   reset : in STD_LOGIC;
                   clk_12Mhz : out STD_LOGIC
                   );
        end component;
        
        -- RAM wizard component declaration
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
        
        -- FIR filter declaration
        component fir_filter is
            Port ( clk : in STD_LOGIC;
                reset : in STD_LOGIC;
                sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
                sample_in_enable : in STD_LOGIC;
                filter_select : in STD_LOGIC;
                sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
                sample_out_ready : out STD_LOGIC
                );
        end component;
    
    --FSM state type declaration
    type state_type is (idle, filter1, filter2, record_sampling, record_save, reset_mem, play_forward, play_reverse);
    
    -- Signals declaration
        -- Audio Interface
        signal clk_12Mhz, rec_ready, sample_request : STD_LOGIC;
        signal data_audio : STD_LOGIC_VECTOR (sample_size -1 downto 0);
        signal record_en, play_en : STD_LOGIC;
        
        -- RAM
        signal clka, ena : STD_LOGIC := '0';
        signal wea : STD_LOGIC_VECTOR(0 downto 0) := (others => '0');
        signal dina : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
        signal data_ram : STD_LOGIC_VECTOR(7 downto 0);
        
        -- Filter
        signal sample_in_filter : STD_LOGIC_VECTOR(7 downto 0);
        signal filter_in_enable, next_filter_in_enable, middle_filter_in_enable, filter_select : STD_LOGIC := '0';
        signal data_filter : STD_LOGIC_VECTOR(7 downto 0);
        signal data_filter_ready : STD_LOGIC;
        
        -- Extra signals
        signal signal_speaker : STD_LOGIC_VECTOR (sample_size -1 downto 0);
        
        -- FSM state declaration
        signal state, next_state : state_type;
        
        -- FSMD register signal
        signal final_address, next_final_address : UNSIGNED (18 downto 0); -- for recording purposes
        signal act_address, next_act_address : UNSIGNED (18 downto 0); -- for playing purposes
        signal next_filter_select : STD_LOGIC;

begin
    -- clk wizard instantiation
    CLK_WIZ : clk_wiz_12mhz
        port map ( clk_100Mhz => clk_100Mhz,
                   reset => reset,
                   clk_12Mhz => clk_12Mhz
               );
                   
    -- audio interface instantiation
    AUDIO_INTER : audio_interface
        port map ( clk_12megas => clk_12Mhz, 
                   reset => reset, 
                   record_enable => record_en, 
                   sample_out => data_audio, 
                   sample_out_ready => rec_ready, 
                   micro_clk => micro_clk, 
                   micro_data => micro_data, 
                   micro_LR => micro_LR, 
                   play_enable => play_en,
                   sample_in => signal_speaker,
                   sample_request => sample_request,
                   jack_sd => jack_sd,
                   jack_pwm => jack_pwm,
                   LED => LED
                );
    
    -- ram instantation
    RAM : blk_mem_gen_0 
        port map ( clka => clk_12Mhz,
                   ena => ena,
                   wea => wea,
                   addra => std_logic_vector(act_address),
                   dina => data_audio,
                   douta => data_ram
               );
    
    -- filter instantation
    FILTER : fir_filter 
        port map ( clk => clk_12Mhz,
                   reset => reset,
                   sample_in => sample_in_filter,
                   sample_in_enable => filter_in_enable,
                   filter_select => filter_select,
                   sample_out => data_filter,
                   sample_out_ready => data_filter_ready
               );
               
   ena <= '1';
                        
    -- FSMD logic
        -- Register
            process(clk_12Mhz, reset)
            begin
                if reset = '1' then
                    state <= idle;
                    final_address <= (others => '0');
                    act_address <= (others => '0');
                elsif rising_edge(clk_12Mhz) then
                    state <= next_state;
                    final_address <= next_final_address;
                    act_address <= next_act_address;
                    filter_select <= next_filter_select;
                    filter_in_enable <= middle_filter_in_enable;
                    middle_filter_in_enable <= next_filter_in_enable; -- filter_in_enable is carried through a double register to deal with clear situations
                end if;     
            end process;
    
    -- FSMD states logic
        process(state, BTNC, BTNL, BTNR, SW0, SW1, rec_ready, sample_request, data_ram, filter_select, data_filter, data_filter_ready)
        begin
        -- Default treatment
            play_en <= '0';
            record_en <= '0';
            next_state <= state;
            next_final_address <= final_address;
            next_filter_select <= filter_select;
            next_act_address <= act_address;
            wea <= "0";
            next_filter_in_enable <= '0';
            
            
        -- Case structure for state and transition logic
        case (state) is
            -- Idle state just checks for next state
            when idle =>
            
                ---------------------------------------------
                --               CAJA VERDE:               --
                ---------------------------------------------
                if BTNC = '1' then      
                    next_state <= reset_mem;
                elsif BTNL = '1' then   
                    next_state <= record_sampling;
                elsif BTNR = '1' then   
                    if SW1 = '0' and sample_request = '1' then
                        if SW0 = '0' then   
                            next_act_address <= (others => '0');
                            next_state <= play_forward;
                        else                
                            next_act_address <= final_address - 1;
                            next_state <= play_reverse;
                        end if;
                    elsif SW1 = '1' then    
                        next_state <= filter1;
                        next_act_address <= (others => '0');
                        next_filter_in_enable <= '1';
                        next_filter_select <= SW0;
                    else                    
                        next_state <= idle;
                    end if;
                else
                    next_state <= idle;
                end if;
                ---------------------------------------------
                
            -- Record_sampling waits until microphone sample is ready to be saved
            -- Mic sample out is directly connected to ram
            when record_sampling =>
                record_en <= '1';
                if rec_ready = '1' then
                    next_state <= record_save;
                else
                    next_state <= record_sampling;
                end if;
            
            -- Record save activates write enable and increments by one last address written
            when record_save =>
                wea <= "1";
                next_final_address <= final_address + 1;
                next_act_address <= act_address + 1;
                
                ---------------------------------------------
                --               CAJA VERDE:               --
                ---------------------------------------------
                if BTNC = '1' then
                    next_state <= reset_mem;
                elsif BTNL = '1' then
                    next_state <= record_sampling;
                elsif BTNR = '1' then
                    if SW1 = '0' and sample_request = '1' then
                        if SW0 = '0' then
                            next_act_address <= (others => '0');
                            next_state <= play_forward;
                        else
                            next_act_address <= final_address - 1;
                            next_state <= play_reverse;
                        end if;
                    elsif SW1 = '1' then
                        next_state <= filter1;
                        next_act_address <= (others => '0');
                        next_filter_in_enable <= '1';
                        next_filter_select <= SW0;
                    else
                        next_state <= idle;
                    end if;
                else
                    next_state <= idle;
                end if;
                ---------------------------------------------
    
                
            -- Reset memory changes final address to 0, in order to overwrite previous info
            when reset_mem =>
                next_final_address <= (others => '0');
                next_act_address <= (others => '0');
                
                ---------------------------------------------
                --               CAJA VERDE:               --
                ---------------------------------------------
                if BTNC = '1' then
                    next_state <= reset_mem;
                elsif BTNL = '1' then
                    next_state <= record_sampling;
                elsif BTNR = '1' then
                    if SW1 = '0' and sample_request = '1' then
                        if SW0 = '0' then
                            next_act_address <= (others => '0');
                            next_state <= play_forward;
                        else
                            next_act_address <= final_address - 1;
                            next_state <= play_reverse;
                        end if;
                    elsif SW1 = '1' then
                        next_state <= filter1;
                        next_act_address <= (others => '0');
                        next_filter_in_enable <= '1';
                        next_filter_select <= SW0;
                    else
                        next_state <= idle;
                    end if;
                else
                    next_state <= idle;
                end if;
                ---------------------------------------------
                
            -- Play forward  
            when play_forward =>
                play_en <= '1';
            
                ---------------------------------------------
                --               CAJA VERDE:               --
                ---------------------------------------------
                if BTNC = '1' then
                    next_state <= reset_mem;
                elsif BTNL = '1' then
                    next_state <= record_sampling;
                elsif BTNR = '1' then
                    if SW1 = '0' then
                        if SW0 = '0' then
                            --------------------------------
                            next_state <= play_forward;
                            if sample_request = '1' then
                                if act_address = final_address - 1 then
                                    next_act_address <= (others => '0');
                                else
                                    next_act_address <= act_address + 1;
                                end if;                             
                            end if;
                            --------------------------------
                        elsif SW0 = '1' and sample_request = '1' then
                            next_act_address <= final_address - 1;
                            next_state <= play_reverse;
                        end if;
                    elsif SW1 = '1' then
                        next_state <= filter1;
                        next_act_address <= (others => '0');
                        next_filter_in_enable <= '1';
                        next_filter_select <= SW0;
                    else
                        next_state <= idle;
                    end if;
                else
                    next_state <= idle;
                end if;
                ---------------------------------------------
            
            -- Play reverse       
            when play_reverse =>
                play_en <= '1';
            
                ---------------------------------------------
                --               CAJA VERDE:               --
                ---------------------------------------------
                if BTNC = '1' then
                    next_state <= reset_mem;
                elsif BTNL = '1' then
                    next_state <= record_sampling;
                elsif BTNR = '1' then
                    if SW1 = '0' then
                        if SW0 = '1' then
                            --------------------------------
                            next_state <= play_reverse;
                            if sample_request = '1' then
                                if act_address = 0 then
                                    next_act_address <= final_address - 1;
                                else
                                    next_act_address <= act_address - 1;
                                end if;                             
                            end if;
                            --------------------------------                        
                        elsif SW0 = '0' and sample_request = '1' then
                            next_act_address <= (others => '0');
                            next_state <= play_forward;
                        end if;
                    elsif SW1 = '1' then
                        next_state <= filter1;
                        next_act_address <= (others => '0');
                        next_filter_in_enable <= '1';
                        next_filter_select <= SW0;
                    else
                        next_state <= idle;
                    end if;
                else
                    next_state <= idle;
                end if;
                ---------------------------------------------
                
            -- Filter, same states use for both inputs, what only changes is filter_select
            -- Filter1 is used to introduce new sample in the filter  
            when filter1 =>
                
                ---------------------------------------------
                --               CAJA VERDE:               --
                ---------------------------------------------
                if BTNC = '1' then
                    next_state <= reset_mem;
                elsif BTNL = '1' then
                    next_state <= record_sampling;
                elsif BTNR = '1' then
                    if SW1 = '0' and sample_request = '1' then
                        if SW0 = '0' then
                            next_act_address <= (others => '0');
                            next_state <= play_forward;
                        else
                            next_act_address <= final_address - 1;
                            next_state <= play_reverse;
                        end if;
                    elsif SW1 = '1' then                        
                        next_filter_select <= SW0;
                        
                        if filter_select = SW0 then
                            if data_filter_ready = '1' then
                                next_state <= filter2;
                            else
                                next_state <= filter1;
                            end if;
                        else
                            next_act_address <= (others => '0');
                            next_filter_in_enable <= '1';
                            next_state <= filter1;
                        end if;
                        ------------------------------------
                    else
                        next_state <= idle;
                    end if;
                else
                    next_state <= idle;
                end if;
                ---------------------------------------------
                
            when filter2 =>          
                play_en <= '1';
            
                ---------------------------------------------
                --               CAJA VERDE:               --
                ---------------------------------------------
                if BTNC = '1' then
                    next_state <= reset_mem;
                elsif BTNL = '1' then
                    next_state <= record_sampling;
                elsif BTNR = '1' then
                    if SW1 = '0' then
                        if SW0 = '1' then
                            next_state <= play_reverse;
                            if sample_request = '1' then
                                if act_address = 0 then
                                    next_act_address <= final_address - 1;
                                else
                                    next_act_address <= act_address - 1;
                                end if;                             
                            end if;
                        elsif SW0 = '0' and sample_request = '1' then
                            next_act_address <= (others => '0');
                            next_state <= play_forward;
                        end if;
                    elsif SW1 = '1' then
                        if sample_request = '1' then
                            next_state <= filter1;
                            next_filter_in_enable <= '1';
                            if act_address = final_address - 1 then
                                next_act_address <= (others => '0');
                                next_filter_in_enable <= '1';
                            else
                                next_act_address <= act_address + 1;
                                next_filter_in_enable <= '1';
                            end if;
                        else
                            next_state <= filter2;
                        end if;
                    else
                        next_state <= idle;
                    end if;
                else
                    next_state <= idle;
                end if;
                ---------------------------------------------
                
            when others =>
                next_state <= idle;
                
            end case;
        end process;
    
    -- Conversion from binary to CA2
    sample_in_filter <= not data_ram(sample_size-1) & data_ram(sample_size-2 downto 0);
    
    -- Output Logic
        signal_speaker <= data_ram when (state = play_forward or state = play_reverse) else
                          not data_filter(sample_size-1) & data_filter(sample_size-2 downto 0) when (state = filter1 or state = filter2) else
                          (others => '0');    
    
end Behavioral;
