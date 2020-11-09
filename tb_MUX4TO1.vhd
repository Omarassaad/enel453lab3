library ieee;
use ieee.std_logic_1164.all;

entity tb_MUX4TO1 is
end tb_MUX4TO1;

architecture tb of tb_MUX4TO1 is

--Comoponent declaration for the MUX4TO1
    component MUX4TO1
        port (in1     : in std_logic_vector (15 downto 0); --S
              in2     : in std_logic_vector (15 downto 0);
              in3     : in std_logic_vector (15 downto 0);
              in4     : in std_logic_vector (15 downto 0);
              s       : in std_logic_vector (1 downto 0);
              mux_out : out std_logic_vector (15 downto 0));
    end component;

    signal in1     : std_logic_vector (15 downto 0);
    signal in2     : std_logic_vector (15 downto 0);
    signal in3     : std_logic_vector (15 downto 0);
    signal in4     : std_logic_vector (15 downto 0);
    signal s       : std_logic_vector (1 downto 0);
    signal mux_out : std_logic_vector (15 downto 0);

    constant time_delay : time := 20 ns;
	
	

begin
--Instantiation of UUT (MUX4TO1)

    uut : MUX4TO1
    port map (
		in1     => in1,
		in2     => in2,
        in3     => in3,
        in4     => in4,
        s       => s,
        mux_out => mux_out);

    stimuli : process
    begin
	
		assert false report "MUX4TO1 testbench started";
		
		wait for 100*time_delay;
        in1 <=  X"0000";
        in2 <=  X"0000";
        in3 <=  X"0000";
        in4 <=  X"5A5A";
        s 	<=  "00";  --We expect Mux to output 0000_0000_0000_0000
		
        wait for 100*time_delay;
		in1 <=  X"5A5A";
        in2 <=  X"5A5A";
        in3 <=  X"5A5A";
        in4 <=  X"5A5A";
        s 	<=  "11"; --We expect Mux to output 0101_1010_0101_1010
		
		wait for 100*time_delay;
		in1 <=  X"0000";
        in2 <=  X"FFFF";
        in3 <=  X"921A";
        in4 <=  X"5A5A";
        s 	<=  "10"; --We expect Mux to output 1111_1111_1111_1111
		
		wait for 100*time_delay;
		in1 <=  X"AAAA";
        in2 <=  X"FFFF";
        in3 <=  X"921A";
        in4 <=  X"5A5A";
        s 	<=  "00"; --We expect Mux to output 1010_1010_1010_1010
		
		wait for 100*time_delay;
		in1 <=  X"AAAA";
        in2 <=  X"FFFF";
        in3 <=  X"921A";
        in4 <=  X"5A5A";
        s 	<=  "01"; --We expect Mux to output 1001_0010_0001_1011
		
		wait for 100*time_delay;
		assert false report "MUX4TO1 testbench ended";
        wait;
    end process;

end tb;