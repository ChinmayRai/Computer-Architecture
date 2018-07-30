----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.04.2018 16:15:14
-- Design Name: 
-- Module Name: decoder - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dcdr is
    Port ( 
           add : in STD_LOGIC_VECTOR (15 downto 0);
           memselect : out STD_LOGIC;
           IOselect : out STD_LOGIC;
           Portselect : out STD_LOGIC_VECTOR(3 downto 0)
         );  
end dcdr;

architecture Behavioral of dcdr is
signal temp : std_logic; 
begin

temp <= add(7) and add(6) and add(5) and add(4) and add(3) and add(2);
IOselect <= temp ;
memselect <= not(temp);

Portselect(0) <= '1' when (add(1 downto 0)="00" and temp='1') else '0';
Portselect(1) <= '1' when (add(1 downto 0)="01" and temp='1') else '0';
Portselect(2) <= '1' when (add(1 downto 0)="10" and temp='1') else '0';
Portselect(3) <= '1' when (add(1 downto 0)="11" and temp='1') else '0';

end Behavioral;


