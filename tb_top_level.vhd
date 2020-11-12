-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 22.10.2020 00:03:26 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_top_level is
end tb_top_level;

architecture tb of tb_top_level is

    component top_level
        port (clk         : in std_logic;
              reset_n     : in std_logic;
              freeze_button : in std_logic;
              SW          : in std_logic_vector (9 downto 0);
              LEDR        : out std_logic_vector (9 downto 0);
              HEX0        : out std_logic_vector (7 downto 0);
              HEX1        : out std_logic_vector (7 downto 0);
              HEX2        : out std_logic_vector (7 downto 0);
              HEX3        : out std_logic_vector (7 downto 0);
              HEX4        : out std_logic_vector (7 downto 0);
              HEX5        : out std_logic_vector (7 downto 0));
    end component;

    signal clk         : std_logic;
    signal reset_n     : std_logic;
    signal freeze_button : std_logic;
    signal SW          : std_logic_vector (9 downto 0);
    signal LEDR        : std_logic_vector (9 downto 0);
    signal HEX0        : std_logic_vector (7 downto 0);
    signal HEX1        : std_logic_vector (7 downto 0);
    signal HEX2        : std_logic_vector (7 downto 0);
    signal HEX3        : std_logic_vector (7 downto 0);
    signal HEX4        : std_logic_vector (7 downto 0);
    signal HEX5        : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 20 ns; -- EDIT Put right period here
    constant delay : time := 200 us;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    UUT : top_level
    port map (clk         => clk,
              reset_n     => reset_n,
              freeze_button => freeze_button,
              SW          => SW,
              LEDR        => LEDR,
              HEX0        => HEX0,
              HEX1        => HEX1,
              HEX2        => HEX2,
              HEX3        => HEX3,
              HEX4        => HEX4,
              HEX5        => HEX5
			  );

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
 -- EDIT Adapt initialization as needed
        SW <= (others => '0');
		
		

        -- Reset generation
        -- EDIT: Check that reset_n is really your reset signal
        reset_n <= '0';
        wait for 100 ns;
        reset_n <= '1';
        wait for 100 ns;
		freeze_button <= '1';
		wait for 30 ms; 
		

		-- the delay between switch inputs was increased to 5 ms for visibility purposes - you will see in modelsim
		-- Test Cases: Operating modes, Freeze_Button, Reset_n
		
		-- Operation Mode 1 Switch Inputs to Hexadecimal
		SW <= "0011111111"; wait for delay; -- displaying FF in Hexadecimal
		-- Operation Mode 2: ADC_value
		SW <= "10--------"; wait for delay; -- display ADC_value in Hexadecimal on SSD
		-- Operation Mode 3: Voltage
		SW <= "01--------"; wait for delay; -- display VAO in volts on SSD to the 3rd decimal place
		-- Operation Mode 4: distance
		SW <= "11--------"; wait for delay; -- display distance in cm on SSD to the 2nd decimal place
		-- Testing Freeze button
		SW <= "0011111111" ; wait for 2*TbPeriod;
		freeze_button <= '0'; wait for 30 ms; 
		SW <= "01--------"; wait for delay;
		SW <= "10--------"; wait for delay; 
		SW <= "11--------"; wait for delay; 
		freeze_button <= '1'; wait for 30 ms;
		-- Testing reset_n
		SW <= "0011111111" ; wait for delay;
		reset_n <= '0'; wait for delay;
		SW <= "01--------"; wait for delay;
		SW <= "10--------"; wait for delay;
		SW <= "11--------"; wait for delay; 
		reset_n <= '1'; wait for delay;
		
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_top_level of tb_top_level is
    for tb
    end for;
end cfg_tb_top_level;
