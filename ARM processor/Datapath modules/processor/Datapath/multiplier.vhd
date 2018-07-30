library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
entity multiplier is
    Port (
    A       : in  STD_LOGIC_VECTOR(31 downto 0);  -- 2 inputs 32-bit
    B       : in  STD_LOGIC_VECTOR(31 downto 0);  -- 2 inputs 32-bit
    mul_out : out STD_LOGIC_VECTOR(31 downto 0) --  output 31-bit 
    );
end multiplier;  
architecture Behavioral of multiplier is
signal temp : STD_LOGIC_VECTOR(63 downto 0);
begin
temp <= A*B;
mul_out <= temp(31 downto 0);
end Behavioral;
