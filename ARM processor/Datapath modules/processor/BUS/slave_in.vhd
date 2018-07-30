library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity slave_in is
    Port ( 
           switches : in std_logic_vector(15 downto 0);
           hselx : in std_logic;
           HRESET : in STD_LOGIC;
           HCLK : in STD_LOGIC;
           HWDATA : in STD_LOGIC_VECTOR (31 downto 0);
           HADDR : in STD_LOGIC_VECTOR (15 downto 0);
           HWRITE : in STD_LOGIC;
           HSIZE : in STD_LOGIC_VECTOR (2 downto 0);
           HTRANS : in STD_LOGIC_VECTOR (1 downto 0);
           HREADYOUT : out STD_LOGIC;
           HRDATA : out STD_LOGIC_VECTOR (31 downto 0));
end slave_in;

architecture Behaioral of slave_in is
signal state : std_logic;

begin
process(HCLK)
begin
if (HCLK ='1' and HCLK' event) then
if (HRESET='1') then 
   state <= '0';
   
elsif state = '0' then 
  if HTRANS = "00" then state <= '0';HREADYOUT <= '0';
  elsif HTRANS="10" then 
      if hselx = '0' then state <= '0';
      elsif hselx = '1' then 
          if HWRITE ='1' then state <= '0';
          elsif HWRITE ='0' then state <= '1';
          end if;
      end if;
  end if;

elsif state = '1' then 
  HRDATA <= "0000000000000000"& switches ;state <='0';HREADYOUT <= '1';

end if;
end if;
end process;

end architecture ; -- Behaioral