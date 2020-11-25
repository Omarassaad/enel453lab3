LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use work.LUT_pkg.all; 

ENTITY voltage2distance_array2 IS
   PORT(
      clk            :  IN    STD_LOGIC;                                
      reset_n        :  IN    STD_LOGIC;                                
      voltage        :  IN    STD_LOGIC_VECTOR(12 DOWNTO 0);                           
      distance       :  OUT   STD_LOGIC_VECTOR(12 DOWNTO 0));  
END voltage2distance_array2;

ARCHITECTURE behavior OF voltage2distance_array2 IS


begin

    	
   distance <= std_logic_vector(to_unsigned(v2d_LUT(to_integer(unsigned(voltage))),distance'length));

end behavior;
