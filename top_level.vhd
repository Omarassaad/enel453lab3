library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


 
entity top_level is
    Port ( clk                           : in  STD_LOGIC;
           reset_n                       : in  STD_LOGIC;
			  save_button						  : in  STD_LOGIC;
			  SW                            : in  STD_LOGIC_VECTOR (9 downto 0);
           LEDR                          : out STD_LOGIC_VECTOR (9 downto 0);
           HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : out STD_LOGIC_VECTOR (7 downto 0)
          );
           
end top_level;

architecture Behavioral of top_level is

Signal Num_Hex0, Num_Hex1, Num_Hex2, Num_Hex3, Num_Hex4, Num_Hex5 : STD_LOGIC_VECTOR (3 downto 0):= (others=>'0');   
Signal DP_in, Blank:  STD_LOGIC_VECTOR (5 downto 0);
Signal switch_inputs: STD_LOGIC_VECTOR (12 downto 0);
Signal bcd:           STD_LOGIC_VECTOR(15 DOWNTO 0);
Signal switch_to_mux: STD_LOGIC_VECTOR(15 downto 0);
Signal mux_to_ssd  : STD_LOGIC_VECTOR(15 downto 0);
Signal save_register_value: STD_LOGIC_VECTOR(15 downto 0); 
Signal sync_to_switch : STD_LOGIC_VECTOR (9 downto 0);
Signal save_register_enable: STD_LOGIC;



Component SevenSegment is
    Port( Num_Hex0,Num_Hex1,Num_Hex2,Num_Hex3,Num_Hex4,Num_Hex5 : in  STD_LOGIC_VECTOR (3 downto 0);
          Hex0,Hex1,Hex2,Hex3,Hex4,Hex5                         : out STD_LOGIC_VECTOR (7 downto 0);
          DP_in,Blank                                           : in  STD_LOGIC_VECTOR (5 downto 0)
			);
End Component ;

Component binary_bcd IS
   PORT(
      clk     : IN  STD_LOGIC;                      --system clock
      reset_n : IN  STD_LOGIC;                      --active low asynchronus reset_n
      binary  : IN  STD_LOGIC_VECTOR(12 DOWNTO 0);  --binary number to convert
      bcd     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)   --resulting BCD number
		);           
END Component;

Component Save_Register is
	port( 
		enable: in std_logic;
		clk : in std_logic; 
		d : in std_logic_vector (15 downto 0); 
		q : out std_logic_vector (15 downto 0); 
		reset_n : in std_logic
	);
END Component;

Component MUX4TO1 is 
	port( in1, in2, in3, in4     : in  std_logic_vector(15 downto 0);	
       s       : in  std_logic_vector(1 downto 0);
       mux_out : out std_logic_vector(15 downto 0) -- notice no semi-colon 
      );
END Component; 



Component synchronizer is 
port(
	  A : in std_logic_vector(9 downto 0); 
	  G : out std_logic_vector(9 downto 0);
	  clk: in std_logic
		);
end Component; 

Component debounce is
port(  clk     : IN  STD_LOGIC;  --input clock
    reset_n : IN  STD_LOGIC;  --asynchronous active low reset
    button  : IN  STD_LOGIC;  --input signal to be debounced
    result  : OUT STD_LOGIC); --debounced signal
end Component;
  
begin
	Num_Hex0 <= mux_to_ssd(3 downto 0);
	Num_Hex1 <= mux_to_ssd(7 downto 4);                         
	Num_Hex2 <= mux_to_ssd(11 downto 8);
	Num_Hex3 <= mux_to_ssd(15 downto 12);
   Num_Hex4 <= "0000";
   Num_Hex5 <= "0000";   
   DP_in    <= "000000"; -- position of the decimal point in the display (1=LED on,0=LED off)
   Blank    <= "110000"; -- blank the 2 MSB 7-segment displays (1=7-seg display off, 0=7-seg display on)
             
                
SevenSegment_ins: SevenSegment  

                  PORT MAP( Num_Hex0 => Num_Hex0,
                            Num_Hex1 => Num_Hex1,
                            Num_Hex2 => Num_Hex2,
                            Num_Hex3 => Num_Hex3,
                            Num_Hex4 => Num_Hex4,
                            Num_Hex5 => Num_Hex5,
                            Hex0     => Hex0,
                            Hex1     => Hex1,
                            Hex2     => Hex2,
                            Hex3     => Hex3,
                            Hex4     => Hex4,
                            Hex5     => Hex5,
                            DP_in    => DP_in,
									 Blank    => Blank
                          );
                                     
 
LEDR(9 downto 0) <= sync_to_switch; -- gives visual display of the switch inputs to the LEDs on board
switch_inputs <= "00000" & sync_to_switch(7 downto 0);
switch_to_mux <= X"00" & sync_to_switch(7 downto 0);
 
binary_bcd_ins: binary_bcd                               
   PORT MAP(
      clk      => clk,                          
      reset_n  => reset_n,                                 
      binary   => switch_inputs,    
      bcd      => bcd         
      );
		
Save_Reg_ins: Save_Register
	PORT MAP(
		reset_n => reset_n,
		clk => clk,
		enable => save_register_enable,
		q => save_register_value,
		d => mux_to_ssd
		);

		
MUX4TO1_ins_1: MUX4TO1
   PORT MAP(
      in1     => bcd(15 downto 0),                          
      in2 	  => switch_to_mux(15 downto 0),
		in3	  => save_register_value,
		in4	  => X"5A5A",
      s => sync_to_switch(9 downto 8),    
      mux_out => mux_to_ssd
      );
		
sync : synchronizer
	PORT MAP(
	A => sw(9 downto 0), 
	G => sync_to_switch, 
	clk => clk 
	);
	
Debounce_ins: debounce
	PORT MAP(
	clk  => clk,
	button => save_button,
	reset_n => reset_n,
	result => save_register_enable
	);


end Behavioral;

