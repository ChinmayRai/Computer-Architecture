library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity decoder is
port(
	instr27_to_20 : in std_logic_vector(7 downto 0);
	instr11_to_4  : in std_logic_vector(7 downto 0);
	not_implemented : out std_logic;
	inst_type : out std_logic_vector(1 downto 0);
	immidiate : out std_logic;
	flag_set_OR_ldrstr  : out std_logic;
	MUL  : out std_logic;
	hwDT : out std_logic;
	pmp_in : out std_logic_vector(2 downto 0);
	writeback : out std_logic
	);
end entity;

architecture Behavioral of decoder is
signal not1,not2,not3,mul1,mul2,hwDT1,hwDT2,hwDT_sig : std_logic;

begin

with instr11_to_4(3 downto 0) select
mul1<= '1' when "1001",
	   '0' when "1011",
	   '0' when "1101",
	   '0' when "1111",
	   '-' when others;
with instr27_to_20(7 downto 2) select
mul2 <= '1' when "000000",
		'0' when others;

MUL <= mul1 and mul2 ; 

with instr27_to_20(7 downto 5) select
hwDT1 <= '1' when "000",
		 '0' when others;

with instr11_to_4 select
hwDT2<= '0' when "00001001",
		'1' when "00001011",
		'1' when "00001101",
		'1' when "00001111",
		'0' when others;
hwDT_sig <= hwDT1 and hwDT2;
hwDT <= hwDT_sig;

with instr27_to_20(7 downto 5) select
immidiate <= '0' when "000",
			 '1' when "001",
			 '1' when "101",
			 '0' when "011",
			 '1' when "010",
			 '-' when others;

flag_set_OR_ldrstr <= instr27_to_20(0);
 
inst_type <= instr27_to_20(7 downto 6);

with instr27_to_20(7 downto 5) & instr11_to_4(0) select 
not1 <= '1' when "1100",
        '1' when "1101",
        '1' when "1110",
        '1' when "1111",
		'1' when "1000",
		'1' when "1001",
		'1' when "0111",
		'0' when others;
with instr27_to_20(7 downto 3) & instr11_to_4 select
not2 <= '1' when "000--11110--0",
		'1' when "00001----1001",
		'1' when "0001-----1001",
		'0' when others;
with instr27_to_20(7 downto 2) & instr11_to_4(3 downto 0) select
not3 <= '1' when"0000011011",
        '1' when"0000111011",
        '1' when"0001011011",
        '1' when"0001111011",
		'1' when"0000011101",
		'1' when"0000111101",
		'1' when"0001011101",
		'1' when"0001111101",
		'1' when"0000011111",
		'1' when"0000111111",
		'1' when"0001011111",
		'1' when"0001111111",
		'0' when others;

not_implemented <= not1 or not2 or not3;

--000 : ldr
--001 : ldrh
--010 : ldrb
--011 : ldrsh
--100 : ldrsb
--101 : strb
--110 : strh
--111 : str

writeback <= instr27_to_20(1);

with instr27_to_20(7 downto 6) & hwDT_sig & instr27_to_20(0) & instr11_to_4(2 downto 1) & instr27_to_20(2) select
pmp_in <= "110" when "0010010",      -- strh
		"001" when "0011010",      -- ldrh
		"011" when "0011110",      -- ldrsh
		"100" when "0011100",      -- ldrsb
		
		"000" when "0101000",      -- ldr
		"000" when "0101010",      -- ldr
		"000" when "0101100",      -- ldr
		"000" when "0101110",      -- ldr
		
		"010" when "0101001",      -- ldrb
		"010" when "0101011",      -- ldrb
		"010" when "0101101",      -- ldrb
		"010" when "0101111",      -- ldrb
		
		"111" when "0100000",      -- str
		"111" when "0100010",      -- str
		"111" when "0100100",      -- str
		"111" when "0100110",      -- str
		
		"111" when "0100001",      -- strb
		"111" when "0100011",      -- strb
		"111" when "0100101",      -- strb
		"111" when "0100111",      -- strb
		
		"---" when others;



end Behavioral;