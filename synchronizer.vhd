library ieee; 
USE ieee.std_logic_1164.all;

entity synchronizer is 
Generic(
	  bits : integer := 1 
	  ); 
port(
	  A : in std_logic_vector((bits-1) downto 0); 
	  G : out std_logic_vector((bits-1) downto 0);
	  clk: in std_logic 
	);
end synchronizer; 

architecture behaviour of synchronizer is

signal E: std_logic_vector((bits-1) downto 0); 


begin

	process(clk)
	begin
		if rising_edge(clk) then
			E <= A;
			G <= E; 
		end if; 
		
	end process; 
	
end behaviour; 

	  