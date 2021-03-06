library ieee;
use ieee.std_logic_1164.all;

entity tb_top_level is
end tb_top_level;

architecture tb of tb_top_level is

    component top_level
        port (clk           : in std_logic;
              reset_n       : in std_logic;
              freeze_button : in std_logic;
              SW            : in std_logic_vector (9 downto 0);
              LEDR          : out std_logic_vector (9 downto 0);
              HEX0          : out std_logic_vector (7 downto 0);
              HEX1          : out std_logic_vector (7 downto 0);
              HEX2          : out std_logic_vector (7 downto 0);
              HEX3          : out std_logic_vector (7 downto 0);
              HEX4          : out std_logic_vector (7 downto 0);
              HEX5          : out std_logic_vector (7 downto 0));
    end component;

    signal clk           : std_logic;
    signal reset_n       : std_logic;
    signal freeze_button : std_logic;
    signal SW            : std_logic_vector (9 downto 0);
    signal LEDR          : std_logic_vector (9 downto 0);
    signal HEX0          : std_logic_vector (7 downto 0);
    signal HEX1          : std_logic_vector (7 downto 0);
    signal HEX2          : std_logic_vector (7 downto 0);
    signal HEX3          : std_logic_vector (7 downto 0);
    signal HEX4          : std_logic_vector (7 downto 0);
    signal HEX5          : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 20 ns; -- EDIT Put right period here
	constant delay : time:= TbPeriod*10000; 
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : top_level
    port map (clk           => clk,
              reset_n       => reset_n,
              freeze_button => freeze_button,
              SW            => SW,
              LEDR          => LEDR,
              HEX0          => HEX0,
              HEX1          => HEX1,
              HEX2          => HEX2,
              HEX3          => HEX3,
              HEX4          => HEX4,
              HEX5          => HEX5);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    stimuli : process
    begin
        
        SW <= (others => '0');

      
        reset_n <= '0';
		
        wait for 100 ns;
        reset_n <= '1';
        wait for 100 ns;
		freeze_button <= '1';
		wait for 1 ms; 
   
   
			SW <= "0011111111"; wait for delay; -- displaying FF in Hexadecimal
		-- Operation Mode 2: ADC_value
		SW <= "1000000000"; wait for delay; -- display ADC_value in Hexadecimal on SSD

		
		-- Operation Mode 3: Voltage
		SW <= "0100000000"; wait for delay; -- display VAO in volts on SSD to the 3rd decimal place
		-- Operation Mode 4: distance
		SW <= "1100000000"; wait for delay; -- display distance in cm on SSD to the 2nd decimal place
		-- Testing Freeze button
		SW <= "0011111111" ; wait for 2*TbPeriod;
		freeze_button <= '0'; wait for 1.2 ms; 
		SW <= "0100000000"; wait for delay;
		SW <= "1000000000"; wait for delay; 
		SW <= "1100000000"; wait for delay; 
		freeze_button <= '1'; wait for 1.2 ms;
	
		
		
		-- Testing reset_n
		SW <= "0011111111" ; wait for delay;
		reset_n <= '0'; wait for delay;
		SW <= "0100000000"; wait for delay;
		SW <= "1000000000"; wait for delay;
		SW <= "1100000000"; wait for delay; 
		reset_n <= '1'; wait for delay;
      
			-- Testing Freeze button
		SW <= "0111111111" ; wait for 2*TbPeriod;
		freeze_button <= '0'; wait for 1.2 ms; 
		SW <= "0100000000"; wait for delay;
		SW <= "1000000000"; wait for delay; 
		SW <= "1100000000"; wait for delay; 
		freeze_button <= '1'; wait for 1.2 ms;
	
		wait for 10000 * TbPeriod;
        TbSimEnded <= '1';
      
        assert false report "Simulation ended" severity failure; -- need this line to halt the testbench  
			
	
	  
    end process;

end tb;


configuration cfg_tb_top_level of tb_top_level is
    for tb
    end for;
end cfg_tb_top_level;