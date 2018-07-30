library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use UNISIM.Vcomponents.all;
use IEEE.STD_LOGIC_ARITH.CONV_STD_LOGIC_VECTOR;
use ieee.NUMERIC_STD.all;

entity shifter is
    Port (
    A           : in STD_LOGIC_VECTOR(31 downto 0);  -- 1 inputs 32-bit
    shift_type  : in std_logic_vector(1 downto 0);
    shiftamt    : in STD_LOGIC_VECTOR(4 downto 0);  -- input 5-bit for selecting function
    shift_out   : out STD_LOGIC_VECTOR(31 downto 0); --  output 31-bit 
    shift_carry : out std_logic --shifter carry
    );
end shifter; 

architecture Behavioral of shifter is
signal zero : std_logic:='0';
signal amt  : integer;
signal num : std_logic;

begin
amt <= to_integer(unsigned(shiftamt));
WITH shift_type SELECT
shift_out  <= STD_LOGIC_VECTOR(shift_left(unsigned(A),amt)) WHEN "00",
              STD_LOGIC_VECTOR(shift_right(unsigned(A),amt)) WHEN "01",
              STD_LOGIC_VECTOR(shift_right(signed(A), amt)) WHEN "10",
              STD_LOGIC_VECTOR(rotate_right(signed(A),amt)) WHEN OTHERS;
              
with shiftamt select
num <= '0' when "00000",
       '1' when others;

       
WITH shift_type & num SELECT           
shift_carry <= zero WHEN "000",
               zero WHEN "010",
               zero WHEN "100",
               zero WHEN "110",
               A(31 - amt) WHEN "001",
               A(amt -1) WHEN "011",
               A(amt -1) WHEN "101",
               A(amt -1) WHEN "111",
               zero WHEN OTHERS;
   
 
end Behavioral;