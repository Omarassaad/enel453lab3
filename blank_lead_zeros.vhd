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

Signal or2_out, or3_out, or4_out : std_logic;
Signal mux_out : std_logic_vector (0 downto 0);

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
	
	begin
	
	MUX4TO1_inst: MUX4TO1
	PORT MAP(
      in1     => "1", 
		in2	  => "0",
		in3	  => "1",
		in4     => "0",
      s => state_switches,
      mux_out => mux_out
      );
		
		or4_out <= mux_out(0) or SSD4_in(3) or SSD4_in(2)  or SSD4_in(1)  or SSD4_in(0);
		or3_out <= or4_out or SSD3_in(3) or SSD3_in(2)  or SSD3_in(1)  or SSD3_in(0);
		or2_out <= or3_out or SSD2_in(3) or SSD2_in(2)  or SSD2_in(1)  or SSD2_in(0);
		blank_out <= "11" & (not or4_out) & (not or3_out) & (not or2_out) & '0';
		
end BEHAVIOR; -- can also be written as "end;"