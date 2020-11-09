library ieee; 
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity tb_Save_Register is
end tb_Save_Register;

architecture behaviour of tb_Save_Register is 

component Save_Register is 
port (
	enable: in std_logic;
	clk : in std_logic; 
	d : in std_logic_vector (15 downto 0); 
	q : out std_logic_vector (15 downto 0); 
	reset_n : in std_logic

);
end component;



signal clk, enable, reset: std_logic; 
signal d : std_logic_vector(15 downto 0);
signal q : std_logic_vector(15 downto 0);
constant clk_period : time := 20 ns; 


begin 

UUT : Save_Register
port map (
	clk =>clk, 
	enable => enable, 
	d => d, 
	q => q, 
	reset_n => reset

); 


clk_process: process is 
	variable i : integer := 0;
		
	begin 
	
	while i < 10 loop
		clk <= '0'; wait for clk_period/2; 
		clk <= '1'; wait for clk_period/2; 
		i:= i+1;
	end loop; 
	wait; 
	
	end process; 
	
input_process: process
	begin 
		d <= X"0000"; wait for 2*clk_period; 
		d <= X"00FF"; wait for 2*clk_period; 
		d <= X"005A"; wait for 2*clk_period; 
		d <= X"0012"; wait for 2*clk_period; 
		d <= X"0076"; wait for 2*clk_period;
		wait; 
	end process; 
	
save_process: process
	begin 
		enable <= '1'; wait for 4*clk_period; 
		enable <= '0'; wait for clk_period; 
		enable <= '1'; wait for 3*clk_period; 
		enable <= '0'; wait for clk_period; 
		enable <= '1'; wait for clk_period; 
		wait;
	end process; 

reset_process: process 
	begin 
		reset <= '0'; wait for clk_period;
		reset <= '1'; wait for 5*clk_period; 
		reset <= '0'; wait for clk_period; 
		reset <= '1'; wait for 3*clk_period; 
		wait; 
	end process;

end behaviour; 