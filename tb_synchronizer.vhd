library ieee; 
use ieee.std_logic_1164.all; 	

entity tb_synchronizer is 
end tb_synchronizer; 

architecture behaviour of tb_synchronizer is 

Component synchronizer is 
port(
	  A : in std_logic_vector(9 downto 0); 
	  G : out std_logic_vector(9 downto 0);
	  clk: in std_logic 
		);
end component; 

signal A, G: std_logic_vector(9 downto 0); 
signal clk: std_logic;
constant clk_period: time:= 20 ns; 

begin 
	
	UUT:synchronizer
	port map(
		A => A,
		G => G, 
		clk => clk 
	); 
	
	
	clk_process: process is 
		variable i : integer := 0;	
	begin 
		while i < 8 loop
			clk <= '0'; wait for clk_period/2; 
			clk <= '1'; wait for clk_period/2; 
			i:= i+1;
		end loop; 
		wait; 
	end process;
	
	switch_process: process 
		begin 
			A <= "1111111111"; wait for 2*clk_period;
			A <= "1010101010"; wait for 2*clk_period; 
			A <= "0000000000"; wait for 4*clk_period; 
			wait;
	end process; 





end behaviour; 