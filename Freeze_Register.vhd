library ieee; 
USE ieee.std_logic_1164.all;


entity Freeze_Register IS

port(
	disable_n: in std_logic;
	clk : in std_logic; 
	d : in std_logic_vector (15 downto 0);
	sswitch_in : in std_logic_vector (1 downto 0); 
	q : out std_logic_vector (15 downto 0); 
	sswitch_out : out std_logic_vector (1 downto 0); 
	reset_n : in std_logic
	);
end Freeze_Register;

architecture reglogic of Freeze_Register is 

begin

	process (clk, reset_n)
		begin
			if reset_n = '0' then 
				q <= X"0000";
			elsif rising_edge(clk) then
				if disable_n = '1' then
					q <= d; 
				end if;
			end if; 
	end process; 
	
	process (clk)
		begin 
		
			if rising_edge(clk) then
				if disable_n = '1' then
					sswitch_out <= sswitch_in; 
				end if;
			end if; 
		end process;
end reglogic;