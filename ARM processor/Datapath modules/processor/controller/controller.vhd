------------------------------------------------------Controller---------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity controller is
      port(
      instruction          : in std_logic_vector(31 downto 0);
      flag                 : in std_logic_vector(3 downto 0);--cnzv
      clock                : in std_logic;
      reset                : in std_logic;
      I_or_D               : out std_logic;
      PCinc_OR_b           : out std_logic;
      Rn_OR_Rd             : out std_logic;
      Rs_OR_Rm             : out std_logic;
      sft_OR_mul           : out std_logic;
      s                    : out std_logic;
      Rd_OR_Rn_OR_lr       : out std_logic_vector(1 downto 0);
      reg_wr_enbl          : out std_logic;
      IR_enb               : out std_logic;
      DR_enb               : out std_logic;
      A_enb                : out std_logic;
      B_enb                : out std_logic;
      Rd_enb               : out std_logic;
      shiftamt_enb         : out std_logic;
      sft_or_mul_res_enb   : out std_logic;
      res_enb              : out std_logic;
      PC_enb               : out std_logic;
      Imm                  : out std_logic;
      predicate            : out std_logic;
      Reg_wrtselect        : out std_logic_vector(1 downto 0);
      instr                : out std_logic_vector(2 downto 0);
      alu_sel              : out std_logic_vector(3 downto 0);
      Memory_master_enable : out std_logic;
      sftamt_reg_or_imm    : out std_logic;
      Res_or_A             : out std_logic;
      Alu_or_B             : out std_logic;
      Invert               : out std_logic;
      not_implemented      : out std_logic;
      stop                 : in std_logic;
      ld_or_str            : out std_logic
      );
end controller;


architecture Behavioral of controller is
signal MUL  : std_logic;
signal hwDT : std_logic;
signal inst_type : std_logic_vector(1 downto 0);
signal immidiate : std_logic;
signal flag_set_OR_ldrstr : std_logic;
signal pmp_in : std_logic_vector(2 downto 0);
signal writeback : std_logic;
signal state : std_logic_vector(3 downto 0);
signal IR : std_logic_vector(31 downto 0);
signal p  : std_logic; 
signal and1 : std_logic;

component flag_check_unit
port(
      flags : in std_logic_vector(3 downto 0);
      cond  : in std_logic_vector(3 downto 0);
      p     : out std_logic
      );
end component;

component decoder 
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
end component;

component ALU_ctrl
port(
      inst_type : in std_logic_vector(1 downto 0);
      inst24_to_21 : in std_logic_vector(3 downto 0);
      MUL       : in std_logic;
      hwDT      : in std_logic;
      ALU_select : out std_logic_vector(3 downto 0)
      );
end component;

component controller_FSM
port( 
      inst_type         : in std_logic_vector(1 downto 0);
      immidiate         : in std_logic;
      ldr_or_str        : in std_logic;   --  0=str ;; 1=ldr    
      MUL               : in std_logic;
      hwDT              : in std_logic;
      pre_or_post       : in std_logic;   --0->pre and 1->post
      writeback         : in std_logic;  
      clock             : in std_logic;
      reset             : in std_logic;
      state             : inout std_logic_vector(3 downto 0);
      stop              : in std_logic
      );
end component;

component Control_signal_generator
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
end component;


begin
IR <= instruction;
predicate <= p;
and1 <= MUL and IR(21);
checking_condition: flag_check_unit port map(flag,IR(31 downto 28),p);

instr_decode      : decoder port map(IR(27 downto 20),IR(11 downto 4),not_implemented,inst_type,immidiate,flag_set_OR_ldrstr,MUL,hwDT,pmp_in,writeback);

ALU_control       : ALU_ctrl port map(inst_type,IR(24 downto 21),MUL,hwDT,alu_sel);

FSM               : controller_FSM port map(inst_type,immidiate,flag_set_OR_ldrstr,MUL,hwDT,IR(24),writeback,clock,reset,state,stop);

signal_generate   : Control_signal_generator port map(I_or_D,PCinc_OR_b,Rn_OR_Rd,Rs_OR_Rm,Reg_wrtselect,sft_OR_mul,s,Rd_OR_Rn_OR_lr,reg_wr_enbl,IR_enb,DR_enb,A_enb,B_enb,Rd_enb,shiftamt_enb,sft_or_mul_res_enb,res_enb,PC_enb,instr,Imm,Memory_master_enable,Res_or_A,Alu_or_B,Invert,p,immidiate,and1,flag_set_OR_ldrstr,IR(24),flag_set_OR_ldrstr,IR(24),pmp_in,state);

with flag_set_OR_ldrstr & inst_type select
ld_or_str <= '1' when "101",
             '0' when "001",
             'U' when others; 

with instruction(27 downto 26) & instruction(4) select
sftamt_reg_or_imm <= '0' when "001",
                     '1' when "000",
                     '1' when "010",
                     '-' when others;



end Behavioral;