library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity registr is
  Port(
    write_data : in std_logic_vector(31 downto 0); -- data to be written
    read_add1  : in std_logic_vector(3 downto 0); -- 4-bit read address for read ports
    read_add2  : in std_logic_vector(3 downto 0); -- 4-bit read address for read ports
    write_add  : in std_logic_vector(3 downto 0); -- 4-bit address for writing
    show_add   : in std_logic_vector(3 downto 0);
    show_data  : out std_logic_vector(31 downto 0);
    clock      : in std_logic;
    reset      : in std_logic;
    write_enable : in std_logic;
    read_data1  : out std_logic_vector(31 downto 0);
    read_data2  : out std_logic_vector(31 downto 0);
    PC : in std_logic_vector(31 downto 0)
  ); 
end entity ;

architecture Behavioral of registr is
type regstr is array (0 to 15) of std_logic_vector(31 downto 0); 
signal reg : regstr;
signal indexr1 : integer range 0 to 15;
signal indexr2 : integer range 0 to 15;
signal indexw : integer;
signal indexshow : integer range 0 to 15;

begin
indexr1 <= to_integer(unsigned(read_add1));
indexr2 <= to_integer(unsigned(read_add2));
indexw  <= to_integer(unsigned(write_add));
indexshow <= to_integer(unsigned(show_add));

read_data1 <= reg(to_integer(unsigned(read_add1)));
read_data2 <= reg(to_integer(unsigned(read_add2)));
show_data <= reg(to_integer(unsigned(show_add)));


process(clock)
begin

if (clock = '1' and clock'event) then   
    if write_enable = '1' then
        reg(indexw) <= write_data;
    end if;
end if ;
end process;

end Behavioral;