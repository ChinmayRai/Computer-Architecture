library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity flag_check_unit is
port(
	flags : in std_logic_vector(3 downto 0);
	cond  : in std_logic_vector(3 downto 0);
	p     : out std_logic
	);
end flag_check_unit;

architecture behavioral of flag_check_unit is
signal in_val_temp : std_logic_vector(15 downto 0);
signal pred : std_logic;

component mux16
Port(
in_val  : in std_logic_vector(15 downto 0);
selec   : in std_logic_vector(3 downto 0);
enable  : in std_logic;
out_val :out std_logic
        );
end component;

begin

in_val_temp(0) <= flags(1);
in_val_temp(1) <= Not flags(1);
in_val_temp(2) <= flags(3);
in_val_temp(3) <= Not flags(3);
in_val_temp(4) <= flags(2);
in_val_temp(5) <= Not flags(2);
in_val_temp(6) <= flags(0);
in_val_temp(7) <= NOt flags(0);
in_val_temp(8) <= flags(3) and (Not flags(1));
in_val_temp(9) <= (Not flags(3)) and flags(1);
in_val_temp(10) <= Not (flags(2) xor flags(0));
in_val_temp(11) <= flags(2) xor flags(0);
in_val_temp(12) <= (Not (flags(2) xor flags(0))) and (Not flags(1));
in_val_temp(13) <= (flags(2) xor flags(0)) and flags(1);
in_val_temp(14) <= '1';

mux_16 : mux16 port map(in_val_temp,cond,'1',pred);

p<= pred;

end behavioral ;