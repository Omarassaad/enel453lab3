library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


 
entity top_level is
    Port ( clk                           : in  STD_LOGIC;
           reset_n                       : in  STD_LOGIC;
			  freeze_button						  : in  STD_LOGIC;
			  SW                            : in  STD_LOGIC_VECTOR (9 downto 0);
           LEDR                          : out STD_LOGIC_VECTOR (9 downto 0);
           HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : out STD_LOGIC_VECTOR (7 downto 0)
          );
           
end top_level;

architecture Behavioral of top_level is

--SSD Module Signals
Signal Num_Hex0, Num_Hex1, Num_Hex2, Num_Hex3, Num_Hex4, Num_Hex5 : STD_LOGIC_VECTOR (3 downto 0):= (others=>'0');   
Signal DP_in, Blank:  STD_LOGIC_VECTOR (5 downto 0);

--ADC Module Signals
Signal voltage_ADC_out, distance_ADC_out: STD_LOGIC_VECTOR(15 downto 0);
Signal voltage_ADC, distance_ADC: STD_LOGIC_VECTOR(12 downto 0);  

--MUX4TO1 Module Signals
Signal mux_to_freeze, freeze_to_ssd, switch_to_mux  : STD_LOGIC_VECTOR(15 downto 0);
Signal freeze_register_disable: STD_LOGIC;
Signal moving_average_to_ADC_sync: STD_LOGIC_VECTOR (11 downto 0);

--Synchronizer Signals 
Signal sync_out: STD_LOGIC_VECTOR (47 downto 0);
Signal SW_sync_out : STD_LOGIC_VECTOR (9 downto 0);
Signal ADC_sync_out: STD_LOGIC_VECTOR(37 downto 0);


Component SevenSegment is
    Port( Num_Hex0,Num_Hex1,Num_Hex2,Num_Hex3,Num_Hex4,Num_Hex5 : in  STD_LOGIC_VECTOR (3 downto 0);
          Hex0,Hex1,Hex2,Hex3,Hex4,Hex5                         : out STD_LOGIC_VECTOR (7 downto 0);
          DP_in,Blank                                           : in  STD_LOGIC_VECTOR (5 downto 0)
			);
End Component ;

Component ADC_Data is
    Port( clk      : in STD_LOGIC;
	       reset_n  : in STD_LOGIC; -- active-low
			 voltage  : out STD_LOGIC_VECTOR (12 downto 0); -- Voltage in milli-volts
			 distance : out STD_LOGIC_VECTOR (12 downto 0); -- distance in 10^-4 m (e.g. if distance = 33 cm, then 3300 is the value)
			 ADC_raw  : out STD_LOGIC_VECTOR (11 downto 0); -- the latest 12-bit ADC value
          ADC_out  : out STD_LOGIC_VECTOR (11 downto 0)  -- moving average of ADC value, over 256 samples,
         );                                              -- number of samples defined by the averager module
End Component;

Component binary_bcd IS
   PORT(
      clk     : IN  STD_LOGIC;                      --system clock
      reset_n : IN  STD_LOGIC;                      --active low asynchronus reset_n
      binary  : IN  STD_LOGIC_VECTOR(12 DOWNTO 0);  --binary number to convert
      bcd     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)   --resulting BCD number
		);  		
END Component;

Component Freeze_Register is
	port( 
		disable_n: in std_logic;
		clk : in std_logic; 
		d : in std_logic_vector (15 downto 0); 
		q : out std_logic_vector (15 downto 0); 
		reset_n : in std_logic
	);
END Component;

Component MUX4TO1 is 
   Generic(
	  bitsperinput : integer := 1
	  );
	port( in1, in2, in3, in4     : in  std_logic_vector((bitsperinput-1) downto 0);	
       s       : in  std_logic_vector(1 downto 0);
       mux_out : out std_logic_vector((bitsperinput-1) downto 0) -- notice no semi-colon 
      );
END Component; 

Component synchronizer is 
Generic(
	  bits : integer := 1
	  );
port(
	  A : in std_logic_vector((bits-1) downto 0); 
	  G : out std_logic_vector((bits-1) downto 0);
	  clk: in std_logic
		);
end Component; 

Component debounce is

GENERIC(
    clk_freq    : INTEGER := 50_000_000;  --system clock frequency in Hz
    stable_time : INTEGER := 30);         --time button must remain stable in ms
	 
port(  

	 clk     : IN  STD_LOGIC;  --input clock
    reset_n : IN  STD_LOGIC;  --asynchronous active low reset
    button  : IN  STD_LOGIC;  --input signal to be debounced
    result  : OUT STD_LOGIC); --debounced signal
end Component;
  
begin
	Num_Hex0 <= freeze_to_ssd(3 downto 0);
	Num_Hex1 <= freeze_to_ssd(7 downto 4);                         
	Num_Hex2 <= freeze_to_ssd(11 downto 8);
	Num_Hex3 <= freeze_to_ssd(15 downto 12);
   Num_Hex4 <= "0000";
   Num_Hex5 <= "0000";   
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
                                     
 
LEDR(9 downto 0) <= SW_sync_out; -- gives visual display of the switch inputs to the LEDs on board
switch_to_mux <= X"00" & SW_sync_out(7 downto 0);


 
bcd_distance: binary_bcd                               
   PORT MAP(
      clk      => clk,                          
      reset_n  => reset_n,                                 
      binary   => ADC_sync_out(37 downto 25),    
      bcd      => distance_ADC_out         
      );
		
bcd_voltage: binary_bcd                               
   PORT MAP(
      clk      => clk,                          
      reset_n  => reset_n,                                 
      binary   => ADC_sync_out(24 downto 12),    
      bcd      => voltage_ADC_out         
      );
		
Freeze_Reg_ins: Freeze_Register
	PORT MAP(
		reset_n => reset_n,
		clk => clk,
		disable_n => freeze_register_disable,
		d => mux_to_freeze,
		q => freeze_to_ssd
		);

		
MUX4TO1_ins_1: MUX4TO1
   Generic map(
	  bitsperinput => 16
	  )
	  
	PORT MAP(
      in1     => switch_to_mux,  
		in2	  => X"0" & ADC_sync_out(11 downto 0),		
		in3	  => voltage_ADC_out,
		in4   => distance_ADC_out,
      s => SW_sync_out(9 downto 8),    
      mux_out => mux_to_freeze
      );
		
MUX4TO1_ins_2 : MUX4TO1
	Generic map(
	  bitsperinput => 6
	  )
	PORT MAP (
		in1     => "000000",  
		in2	  => "000000",		
		in3	  => "001000",
		in4   => "000100",
      s => SW_sync_out(9 downto 8),    
      mux_out => DP_in
		);
		
sync : synchronizer
	Generic map (
	bits => 48
	)
	
	PORT MAP(
	A => distance_ADC & voltage_ADC & moving_average_to_ADC_sync & sw, 
	G => sync_out, 
	clk => clk 
	);
	
ADC_sync_out <= sync_out(47 downto 10); 
SW_sync_out <= sync_out(9 downto 0);

	
Debounce_ins: debounce
	Generic map (
		stable_time => 30
	)
	PORT MAP(
	clk  => clk,
	button => freeze_button,
	reset_n => reset_n,
	result => freeze_register_disable
	);

ADC_Data_ins: ADC_Data
	PORT MAP(
	clk => clk,
	reset_n => reset_n,
	voltage => voltage_ADC,
	ADC_out => moving_average_to_ADC_sync,
	distance => distance_ADC

);	
	
end Behavioral;

