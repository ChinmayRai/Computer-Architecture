library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity digit_display is
   port ( b          : in    std_logic_vector (15 downto 0); 
          clk        : in    std_logic; 
          anode      : out   std_logic_vector (3 downto 0); 
          cathode    : out   std_logic_vector (6 downto 0)
         );
end entity digit_display;


architecture ssd of digit_display is

signal clock : std_logic;
signal flag  : integer range 1 to 4;
signal cathode1, cathode2, cathode3, cathode4, cath : std_logic_vector (6 downto 0);
signal counter : integer range 0 to 1000000;

begin

with b(15 downto 12) select 
cathode1<= "0111111" when "0000",
		   "0000110" when "0001",
		   "1011011" when "0010",
		   "1001111" when "0011",
		   "1100110" when "0100",
		   "1101101" when "0101",
		   "1111101" when "0110",
		   "0000111" when "0111",
		   "1111111" when "1000",
		   "1101111" when "1001",
	   	   "1000000" when others;
with b(11 downto 8) select
cathode2 <= "0111111" when "0000",
		   "0000110" when "0001",
		   "1011011" when "0010",
		   "1001111" when "0011",
		   "1100110" when "0100",
		   "1101101" when "0101",
		   "1111101" when "0110",
		   "0000111" when "0111",
		   "1111111" when "1000",
		   "1101111" when "1001",
	   	   "1000000" when others;
with b(7 downto 4) select 
cathode3<= "0111111" when "0000",
		   "0000110" when "0001",
		   "1011011" when "0010",
		   "1001111" when "0011",
		   "1100110" when "0100",
		   "1101101" when "0101",
		   "1111101" when "0110",
		   "0000111" when "0111",
		   "1111111" when "1000",
		   "1101111" when "1001",
	   	   "1000000" when others;
with b(3 downto 0) select
cathode4 <= "0111111" when "0000",
		   "0000110" when "0001",
		   "1011011" when "0010",
		   "1001111" when "0011",
		   "1100110" when "0100",
		   "1101101" when "0101",
		   "1111101" when "0110",
		   "0000111" when "0111",
		   "1111111" when "1000",
		   "1101111" when "1001",
	   	   "1000000" when others;
process(clk)
    --variable counter : integer range 0 to 10000;
    begin
        if ((clk'event) and (clk='1')) then
            if(counter >= 100000) then
                counter <= 0;
                if(clock = '0') then
                    clock <= '1';
                else
                    clock <= '0';
                end if;
            else
            	counter <= counter + 1;
            end if;
            
        end if;
    end process;		    

process(clock)
begin

if(clock='1' and clock'event) then
    if flag=4 then flag <=1; 
    else flag <= flag+1 ;
    end if;

    case flag is
    when 1 => 
    		anode <= "0111";
            cath <= cathode1;
    when 2 => 
    		anode <= "1011";
            cath <= cathode2;
    when 3 => 
    		anode <= "1101";
            cath <= cathode3;
    when 4 => 
    		anode <= "1110";
            cath <= cathode4;
    when others => 
    		anode <= "1111";
    		flag <= 1;
    end case; 
end if;                  
end process;

cathode <= not(cath);         
         
end architecture ;

