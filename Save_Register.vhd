library ieee; 
USE ieee.std_logic_1164.all;


entity Save_Register IS

port(
	enable: in std_logic;
	clk : in std_logic; 
	d : in std_logic_vector (15 downto 0); 
	q : out std_logic_vector (15 downto 0); 
	reset_n : in std_logic
	);
end Save_Register;

architecture reglogic of Save_Register is 

begin

	process (clk, reset_n)
		begin
			if reset_n = '0' then 
				q <= X"0000"; 
			elsif rising_edge(clk) then
				if enable = '0' then
					q <= d; 
				end if;
			end if; 
	end process; 
	
end reglogic;