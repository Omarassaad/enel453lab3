library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_blank_lead_zeros is
end entity;

architecture behaviour of tb_blank_lead_zeros is

constant time_delay : time := 200 ns; 

Signal state_switches : std_logic_vector (1 downto 0);
Signal SSD2_in, SSD3_in, SSD4_in : std_logic_vector (3 downto 0);
Signal blank_out : std_logic_vector (5 downto 0); 


Component blank_lead_zeros is
port ( 
	   state_switches     		  : in std_logic_vector (1 downto 0);
		SSD2_in, SSD3_in, SSD4_in : in std_logic_vector (3 downto 0);
		blank_out 					  : out std_logic_vector (5 downto 0)
      );
		
end Component;

begin 

UUT: blank_lead_zeros

port map (

		state_switches => state_switches,
		SSD2_in => SSD2_in,
		SSD3_in => SSD3_in,
		SSD4_in => SSD4_in,
		blank_out => blank_out
	);
	
	stim_process: process
	begin
	
		SSD2_in <= "0000";
		SSD3_in <= "0100"; 
		SSD4_in <= "0000";
		state_switches <= "00";
		
	wait for time_delay;
		SSD2_in <= "1001";
		SSD3_in <= "1111"; 
		SSD4_in <= "0000";
		state_switches <= "01";
		
	wait for time_delay;
		SSD2_in <= "1111";
		SSD3_in <= "0110"; 
		SSD4_in <= "0000";
		state_switches <= "10";
	
	wait for time_delay;
		SSD2_in <= "1111";
		SSD3_in <= "0110"; 
		SSD4_in <= "0000";
		state_switches <= "11";
		
	wait for time_delay;
		
		
	wait;
	end process;
	
end behaviour;