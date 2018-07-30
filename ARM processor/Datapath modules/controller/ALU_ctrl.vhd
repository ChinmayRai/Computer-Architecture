library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity ALU_ctrl is
port(
	inst_type : in std_logic_vector(1 downto 0);
	inst24_to_21 : in std_logic_vector(3 downto 0);
	MUL       : in std_logic;
	hwDT      : in std_logic;
	ALU_select : out std_logic_vector(3 downto 0)
	);
end entity;
architecture Behavioral of ALU_ctrl is
begin
Process(inst_type,inst24_to_21,MUL,hwDT)
begin
CASE inst_type is
    when "00" =>
        if(MUL='1' and hwDT='0') then
            if (inst24_to_21(0)='0') then
                ALU_select <= "1101";
            elsif (inst24_to_21(0)='1') then
                ALU_select <= "0100";
            end if; 
        elsif(MUL='0' and hwDT='1') then
            if (inst24_to_21(2) ='1') then 
                ALU_select <= "0100"; 
            elsif (inst24_to_21(2) ='0') then 
                ALU_select <= "0010";
            end if;
        elsif(MUL='0' and hwDT='0') then
            ALU_select <= inst24_to_21;
        end if; 
    when "01" =>
        if (inst24_to_21(2) ='1') then ALU_select <= "0100"; 
        elsif (inst24_to_21(2) ='0') then ALU_select <= "0010"; 
        else ALU_select <= "----"; 
        end if;
    when "10" =>
        ALU_select <= "0100";
    when others =>
        ALU_select <= "----";
end CASE;

end process;
end Behavioral;