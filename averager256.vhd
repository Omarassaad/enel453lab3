library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity averager256 is
   generic( 
	     N    : INTEGER := 8; -- 8; -- log2(number of samples to average over), e.g. N=8 is 2**8 = 256 samples 
        X    : INTEGER := 4; -- X = log4(2**N), e.g. log4(2**8) = log4(4**4) = log4(256) = 4 (bit of resolution gained)
		  bits : INTEGER := 11 -- number of bits in the input data to be averaged
		  );    
   port (
        clk     : in  std_logic;
        EN      : in  std_logic; -- takes a new sample when high for each clock cycle
        reset_n : in  std_logic; -- active-low
        Din     : in  std_logic_vector(bits downto 0); -- input sample for moving average calculation
        Q       : out std_logic_vector(bits downto 0)  -- 12-bit moving average of 256 samples
        -- Q_high_res :  out std_logic_vector(X+bits downto 0) -- (4+11 downto 0) -- first add (i.e. X) must match X constant in ADC_Data  
        );                                                -- moving average of ADC with additional bits of resolution:
   end averager256;                                       -- 256 average can give an additional 4 bits of ADC resolution, depending on conditions
                                                          
architecture rtl of averager256 is

subtype REG is std_logic_vector(bits downto 0);

type Register_Array is array (natural range <>) of REG;

signal REG_ARRAY : Register_Array(2**N downto 1);

type temporary is array(integer range <>) of integer;
signal tmp : temporary((2**N)-1 downto 1);
Constant tmp_zeros : integer := 0;

signal tmplast : std_logic_vector(2**N-1 downto 0);
constant Zeros : STD_LOGIC_VECTOR(11 downto 0) := (others => '0');

begin

   shift_reg : process(clk, reset_n)
   begin
      if(reset_n = '0') then
      
         resetShiftReg: for i in 1 to 2**N loop
            REG_ARRAY(i) <= Zeros;
         end loop resetShiftreg;
		 
         Q          <= (others => '0');
        
		  resetPipeline1: for i in 1 to (2**N)/2 loop
			tmp(i) <= tmp_zeros;
		  end loop resetPipeline1;
		  
		  resetPipeline2: for i in (((2**N)/2)+1) to ((2**N)-1) loop
			tmp(i) <= tmp_zeros;
		  end loop resetPipeline2;
         
      elsif rising_edge(clk) then
	  
			firstAdd: for i in 1 to (2**N)/2 loop
			tmp(i) <= to_integer(unsigned(REG_ARRAY((2*i)-1)))  + to_integer(unsigned(REG_ARRAY(2*i)));
			end loop firstAdd;
			
			secondAdd: for i in ((2**N)/2)+1 to (2**N)-1 loop
			tmp(i) <= tmp(2*(i-(2**N)/2)-1) + tmp(2*(i-(2**N)/2));
			end loop secondAdd; 
	  
	  
		
         if EN = '1' then
 
            REG_ARRAY(1) <= Din;
            shiftReg: for i in 1 to 2**N-1 loop
               REG_ARRAY(i+1) <= REG_ARRAY(i);
            end loop shiftReg;
			
            Q          <= tmplast(N+bits downto N); --divide by 256 (2**8)
      
            
         end if;
      end if;
   end process shift_reg;

	   
   tmplast <= std_logic_vector(to_unsigned(tmp((2**N)-1), tmplast'length));
      
end rtl;
