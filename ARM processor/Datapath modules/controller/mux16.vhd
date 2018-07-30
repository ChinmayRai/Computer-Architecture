library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity mux16 is
Port(
in_val  : in std_logic_vector(15 downto 0);
selec   : in std_logic_vector(3 downto 0);
enable  : in std_logic;
out_val :out std_logic
        );
end mux16;

architecture Behavioral of mux16 is
signal out_temp : std_logic;
signal out_temp1 : std_logic;
begin
out_temp <= in_val(to_integer(unsigned(selec)));

with enable select 
out_temp1 <= out_temp when '1',
             out_temp1 when others;
             
out_val <= out_temp1;
end Behavioral; -- Behavioral