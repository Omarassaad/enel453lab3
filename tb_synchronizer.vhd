library ieee; 
use ieee.std_logic_1164.all; 	

entity tb_synchronizer is 
end tb_synchronizer; 

architecture behaviour of tb_synchronizer is 

Component synchronizer is 
Generic(
	  bits : integer := 1 
	  );
port(
	  A : in std_logic_vector((bits-1) downto 0); 
	  G : out std_logic_vector((bits-1) downto 0);
	  clk: in std_logic 
		);
end component; 

signal A, G: std_logic_vector(47 downto 0); 
signal clk: std_logic;
constant clk_period: time:= 20 ns; 

begin 
	
	UUT:synchronizer
	generic map(
	bits => 48
	)
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
			A <= X"111111111111"; wait for 2*clk_period;
			A <= X"5A5A5A5A5A5A"; wait for 2*clk_period; 
			A <= X"000000000000"; wait for 4*clk_period; 
			wait;
	end process; 





end behaviour; 