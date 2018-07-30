library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity control_signal_generator is
port(
	I_or_D : out std_logic;
	PCinc_or_B : out std_logic;
	Rn_or_Rd  : out std_logic;
	Rs_or_rm : out std_logic;
	Reg_wrtselect : out std_logic_vector(1 downto 0);
	Sft_or_mul : out std_logic;
	S : out std_logic;
	Rd_or_rn_or_lr : out std_logic_vector(1 downto 0);
	Reg_wr_enable : out std_logic;
	IR_enable : out std_logic;
	DR_enable : out std_logic;
	A_enable : out std_logic;
	B_enable : out std_logic;
	Rd_enable : out std_logic;
	shiftamt_enable : out std_logic;
	sft_or_mul_res_enable : out std_logic;
	res_enable : out std_logic;
	PC_enable : out std_logic;
	instr : out std_logic_vector(2 downto 0);
	imm : out std_logic;
	Memory_master_enable : out std_logic;
	Res_or_A             : out std_logic;
	Alu_or_B : out std_logic;
	Invert : out std_logic;

	P : in std_logic;
	immediate_address : in std_logic;
	Accm : in std_logic; --Accumulate (for mul)
	flag_update : in std_logic; --input IR(20)
	b_bl : in std_logic; --For b/bl  0->B, 1-> bl
	ldr_or_str : in std_logic; --for ldr instructions it will be 0 while for str it'll be 1
	pre_or_post : in std_logic; -- 0->pre and 1->post
	pmp_in : in std_logic_vector(2 downto 0);

	state : in std_logic_vector(3 downto 0)
	);
end control_signal_generator;

--0000 -> Instruction fetch and pc increment                MEM READ
--0001 -> A,B Read

--0010 -> Second read for DP which specifies shift amount (second operator is in register)
--0011 -> Calculation for DP, when second operand is in register
--0100 -> Write Result into register
--0101 -> Calculation for DP when Second operand is immediate

--0110 -> Second Read for multiplication 
--0111 -> Calculation for Mul 
--1000 -> Write Multiply Answer

--1001 -> Branch 3 (Reads offset)
--1010 -> Branch 4 (For linking LR)

--1011 -> Reading Rd,Rs and shifting Rm for DT instructions
--1100 -> address addition([Rn+Rm]/[Rn+Imm]) and passing to memory depending on pre/post    
--1101 -> Data write/read from memory DT                    MEM READ/WRITE
--1110 -> write data into register in case of ldr
--1111 -> writeback calculated address to Rn in case of post and pre_! 

Architecture Behavioral of control_signal_generator is
Signal temp : std_logic_vector(27 downto 0);
Begin
	With state select
	temp <= "00-----0--010000000000001000" 								when "0000",
	        "--10---0--000110000100000000" 								when "0001",
	        "--01--10--000000100000000000" 								when "0010",
	        "------1"& flag_update &"--000000011000000000" 			    when "0011",
	        "----01-000"& P &"00000000000000000" 						when "0100",  
	        "-------" & flag_update &"--000000001000010000" 			when "0101",
	        "--01--00--000001100000000001" 								when "0110",
	        "------0"&flag_update&"--0000000110000000"& NOT(Accm)&Accm  when "0111",
	        "----01-001"& P &"00000000000000000" 						when "1000",
	        "-1--10--10"& b_bl &"00000000000000000" 					when "1001",
	        "----10--10"& P &"00000000"& P &"00000000" 					when "1010",
	        "--01--10--0000011100----0000" 								when "1011",
	        "-------0--0000000010---"&immediate_address&'0'&pre_or_post&"00" 		when "1100",
	        "1------0--0010000000"&pmp_in&"-1"&pre_or_post&"00" 	when "1101",
	        "----00-000"& P &"000000000"&pmp_in&"-0000" 				when "1110",
	        "----01-001"& P &"000000000----0000"						when "1111",
	        "0000000000000000000000000000" when others;



	I_or_D <= 				temp(27);
	PCinc_or_B <= 			temp(26);
	Rn_or_Rd  <= 			temp(25);
	Rs_or_rm <= 			temp(24);
	Reg_wrtselect <= 		temp(23 downto 22);
	Sft_or_mul <= 			temp(21);
	S <= 					temp(20);
	Rd_or_rn_or_lr <= 		temp(19 downto 18);
	
	Reg_wr_enable <= 		temp(17);
	IR_enable <= 			temp(16);
	DR_enable <= 			temp(15);
	A_enable <= 			temp(14);
	B_enable <= 			temp(13);
	Rd_enable <= 			temp(12);
	shiftamt_enable <= 		temp(11);
	sft_or_mul_res_enable<= temp(10);
	res_enable <= 			temp(9);
	PC_enable <= 			temp(8);
	
	instr <= 				temp(7 downto 5);
	imm <=					temp(4);
	Memory_master_enable <= temp(3);
	Res_or_A <=				temp(2);
	Alu_or_B <=				temp(1);
	Invert <=				temp(0);


end Behavioral;