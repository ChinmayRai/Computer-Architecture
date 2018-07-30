library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity master is
Port( 
      ld_or_str : in std_logic;  --1 for load and 0 for str
      add_in    : in std_logic_vector(15 downto 0);
      data_in   : in std_logic_vector(31 downto 0);
      size_in   : in std_logic_vector(2 downto 0);      --"000" for byte , "001" for hw ; "010" for word
      DR_out    : out std_logic_vector(31 downto 0);       
      HRESET    : in std_logic;
	  HCLK      : in std_logic;
	  HRDATA    : in std_logic_vector(31 downto 0);
	  HREADY    : in std_logic;
	  HADDR     : out std_logic_vector(15 downto 0);
	  HWRITE    : out std_logic;
	  HSIZE     : out std_logic_vector(2 downto 0);
	  HTRANS    : out std_logic_vector(1 downto 0);
	  HWDATA    : out std_logic_vector(31 downto 0
	  )	
	 );
end master;

architecture Behavioral of master is
signal state : std_logic_vector(1 downto 0);
begin
HWRITE <= not(ld_or_str);
process(HCLK)
begin
if (HCLK ='1' and HCLK' event) then
if (HRESET='1') then 
   state <= "00";
 
elsif state="00" then 
    HADDR <= add_in;
    HTRANS <= "10";
    HSIZE <= size_in;

    if ld_or_str = '0' then state <= "10"; elsif ld_or_str = '1' then
        state <= "01";
    end if;
    
elsif state="01" then 
    HTRANS <= "00";DR_out <= HRDATA; 
    if (HREADY='1') then 
        if ld_or_str = '1' then state <= "00"; else state <= "10"; end if;
    else state <= "01"; end if;
  
elsif state="10" then 
   HADDR <= add_in;
   HTRANS <= "10";
   HWDATA <= data_in;
   HSIZE <= size_in;
   state <= "11";
elsif state="11" then 
    HTRANS <= "00";
    if (HREADY='1') then 
            if ld_or_str = '1' then state <= "00"; else state <= "10"; end if;
    else state <= "11"; end if;

end if; 
end if;
end process;

end Behavioral;