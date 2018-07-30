----------------------------------------------------------------Memory-------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity memory is
    Port(
    address     : in  STD_LOGIC_VECTOR(7 downto 0);  -- 1 inputs 32-bit
    write_data  : in std_logic_vector(31 downto 0);
    memory_write_enable  : in std_logic_vector(3 downto 0);
    read_data     : out STD_LOGIC_VECTOR(31 downto 0); --  output 31-bit 
    clock         : in std_logic;
    reset         : in std_logic
    );
end memory; 

architecture Behavioral of memory is
type regstr is array (0 to 255) of std_logic_vector(31 downto 0); 
signal mem : regstr;
signal add : integer range 0 to 255;
signal rd_enb : std_logic;

begin
add <= to_integer(unsigned(address));
rd_enb <= not(memory_write_enable(0) or memory_write_enable(1) or memory_write_enable(2) or memory_write_enable(3));

with rd_enb select
read_data <= mem(to_integer(unsigned(address))) when '1',
             "00000000000000000000000000000000" when others;

process(clock)
  begin
  if (clock = '1' and clock'event) then
    if reset='1' then
        mem(0) <= X"00000000";
        mem(1) <= X"00000001";
        mem(2) <= X"00000002";
        mem(3) <= X"00000003";
        mem(4) <= X"00000004";
        mem(5) <= X"00000005";
        mem(6) <= X"00000006";
        mem(7) <= X"00000007";
        mem(8) <= X"00000008";
        mem(9) <= X"00000009";
        mem(10) <= X"0000000A";
        mem(11) <= X"0000000B";
        mem(12) <= X"0000000C";
        mem(13) <= X"0000000D";
        mem(14) <= X"0000000E";
        mem(15) <= X"0000000F";      
    end if;
    
    if memory_write_enable(0) = '1' then
      mem(to_integer(unsigned(address)))(7 downto 0) <= write_data(7 downto 0);
    end if;
    if memory_write_enable(1) = '1' then
      mem(to_integer(unsigned(address)))(15 downto 8) <= write_data(15 downto 8);
    end if;
    if memory_write_enable(2) = '1' then
      mem(to_integer(unsigned(address)))(23 downto 16) <= write_data(23 downto 16);
    end if;
    if memory_write_enable(3) = '1' then
      mem(to_integer(unsigned(address)))(31   downto 24) <= write_data(31   downto 24);
    end if;

  end if ;
end process;

end Behavioral;