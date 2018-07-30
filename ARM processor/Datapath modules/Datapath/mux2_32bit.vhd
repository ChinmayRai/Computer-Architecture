library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity mux2_32bit is 
    port(
in0      : in std_logic_vector(31 downto 0);
in1      : in std_logic_vector(31 downto 0); 
selec    : in std_logic;
enable   : in std_logic;
out_val  : out std_logic_vector(31 downto 0)  
        );
end entity;
architecture Behavioral of mux2_32bit is
signal temp : std_logic_vector(31 downto 0);
signal temp2 : std_logic_vector(31 downto 0);
begin
with selec select
temp <= in0 when '0',
        in1 when others;
with enable select 
temp2 <= temp when '1',
         temp2 when others;
out_val <= temp2;
end Behavioral ; -- arch