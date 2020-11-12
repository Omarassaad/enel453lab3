library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity blank_lead_zeros is

port ( 
	   state_switches     		  : in std_logic_vector (1 downto 0);
		SSD2_in, SSD3_in, SSD4_in : in std_logic_vector (3 downto 0);
		blank_out 					  : out std_logic_vector (5 downto 0)
      );
end blank_lead_zeros; 

architecture BEHAVIOR of blank_lead_zeros is

Signal   or4_out : std_logic;
Signal or3_out, or2_out, mux_out, mux_out1, mux_out2 : std_logic_vector (0 downto 0);

Component MUX4TO1 is

	generic(
		 bitsperinput : integer := 1
		 ); 
	port ( 
	   in1, in2, in3, in4     : in  std_logic_vector((bitsperinput-1) downto 0);	
       s       : in  std_logic_vector(1 downto 0);
       mux_out : out std_logic_vector((bitsperinput-1) downto 0) -- notice no semi-colon 
      );
end Component;

Component MUX2TO1 is
generic(
		bits : integer := 1
		); 
port ( in1     : in  std_logic_vector((bits-1) downto 0);
       in2     : in  std_logic_vector((bits-1) downto 0);
       s       : in  std_logic;
       mux_out : out std_logic_vector((bits-1) downto 0) -- notice no semi-colon 
      );
end Component; -- can also be written as "end entity;" or just "end;"
	
	begin
	
	MUX4TO1_inst: MUX4TO1
	PORT MAP(
        in1     => "1", -- hex
		in2	  => "0", -- moving average, 10 
		in3	  => "1", -- voltage, 01 
		in4     => "0", --decimal, 11
      s => state_switches,
      mux_out => mux_out
      );
	 MUX2TO1_inst1 : MUX2TO1
	 PORT MAP(
		in1   => or2_out, 
		in2	  => "1",
		s => state_switches(0), 
		mux_out => mux_out1
		); 
	MUX2TO1_inst2 : MUX2TO1
	 PORT MAP(
		in1   => or3_out, 
		in2	  => "1",
		s => state_switches(0), 
		mux_out => mux_out2
		); 
		
		
		or4_out <= mux_out(0) or SSD4_in(3) or SSD4_in(2)  or SSD4_in(1)  or SSD4_in(0);
		or3_out(0) <= or4_out or SSD3_in(3) or SSD3_in(2)  or SSD3_in(1)  or SSD3_in(0);
		or2_out(0) <= or3_out(0) or SSD2_in(3) or SSD2_in(2)  or SSD2_in(1)  or SSD2_in(0);
		blank_out <= "11" & (not or4_out) & (not mux_out2) & (not mux_out1) & '0';
		
end BEHAVIOR; -- can also be written as "end;"