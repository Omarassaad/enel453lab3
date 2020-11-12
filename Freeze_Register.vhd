library ieee; 
USE ieee.std_logic_1164.all;


entity Freeze_Register IS
generic(
	bits: integer := 15
	);

port(
	disable_n: in std_logic;
	clk : in std_logic; 
	d : in std_logic_vector (bits downto 0); 
	q : out std_logic_vector (bits downto 0); 
	reset_n : in std_logic
	);
end Freeze_Register;

architecture reglogic of Freeze_Register is 
signal zeros : std_logic_vector (bits downto 0); 

begin

	process (clk, reset_n)
		begin
			if reset_n = '0' then 
				q <= zeros; 
			elsif rising_edge(clk) then
				if disable_n = '1' then
					q <= d; 
				end if;
			end if; 
	end process; 
	
end reglogic;