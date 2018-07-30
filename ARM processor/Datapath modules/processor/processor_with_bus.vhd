--force reset=1 for 1 cycle without clock;force clock for 1 cycle; force reset=0 & remove force on clock;continue operatiing clock

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity processor is
port(
	  clk                : in std_logic;
	  reset                : in std_logic;
	  
	  show_add             : in std_logic_vector(3 downto 0);
      show_data            : out std_logic_vector(15 downto 0);
      
      
      Anode                : out   std_logic_vector (3 downto 0); 
      Cathode              : out   std_logic_vector (6 downto 0)
	);
end processor;

architecture Behavioral of processor is

signal instruction     : std_logic_vector(31 downto 0);  	     					
signal flag            : std_logic_vector(3 downto 0);--cnzv    
signal I_or_D          : std_logic;   
signal PCinc_OR_b      : std_logic;   
signal Rn_OR_Rd        : std_logic;   
signal Rs_OR_Rm        : std_logic;   
signal sft_OR_mul      : std_logic;   
signal s               : std_logic;   
signal Rd_OR_Rn_OR_lr  : std_logic_vector(1 downto 0);	
signal reg_wr_enbl     : std_logic;
signal IR_enb          : std_logic;
signal DR_enb          : std_logic;
signal A_enb           : std_logic;
signal B_enb           : std_logic;
signal Rd_enb          : std_logic;
signal shiftamt_enb         : std_logic;
signal sft_or_mul_res_enb   : std_logic;
signal res_enb              : std_logic;
signal PC_enb               : std_logic;
signal Imm                  : std_logic;
signal predicate            : std_logic;
signal Reg_wrtselect        : std_logic_vector(1 downto 0);
signal instr                : std_logic_vector(2 downto 0);
signal alu_sel              : std_logic_vector(3 downto 0);
signal Memory_master_enable : std_logic;
signal Alu_or_B             : std_logic;
signal Res_or_A             : std_logic;
signal Invert               : std_logic;
signal sftamt_reg_or_imm    : std_logic;
signal show                 : std_logic_vector(31 downto 0);
signal not_implemented      : std_logic;
signal stop                 : std_logic;
signal ld_or_str            : std_logic;
signal switches             : std_logic_vector(15 downto 0);
signal LED                  : std_logic_vector(15 downto 0);




component datapath 
port(
      instruction          : out std_logic_vector(31 downto 0);
      flag                 : out std_logic_vector(3 downto 0);--cnzv
      clock                : in std_logic;
      reset                : in std_logic;
      I_or_D               : in std_logic;
      PCinc_OR_b           : in std_logic;
      Rn_OR_Rd             : in std_logic;
      Rs_OR_Rm             : in std_logic;
      sft_OR_mul           : in std_logic;
      s                    : in std_logic;
      Rd_OR_Rn_OR_lr       : in std_logic_vector(1 downto 0);
      reg_wr_enbl          : in std_logic;
      IR_enb               : in std_logic;
      DR_enb               : in std_logic;
      A_enb                : in std_logic;
      B_enb                : in std_logic;
      Rd_enb               : in std_logic;
      shiftamt_enb         : in std_logic;
      sft_or_mul_res_enb   : in std_logic;
      res_enb              : in std_logic;
      PC_enb               : in std_logic;
      Imm                  : in std_logic;
      predicate            : in std_logic;
      Reg_wrtselect        : in std_logic_vector(1 downto 0);
      instr                : in std_logic_vector(2 downto 0);
      alu_sel              : in std_logic_vector(3 downto 0);
      Memory_master_enable : in std_logic; 
      Alu_or_B             : in std_logic;    
      Res_or_A             : in std_logic;
      Invert               : in std_logic;
      sftamt_reg_or_imm    : in std_logic;
      show_add             : in std_logic_vector(3 downto 0);
      show_data            : out std_logic_vector(31 downto 0);
      stop                 : out std_logic;
      switches             : in std_logic_vector(15 downto 0);
      LED                  : out std_logic_vector(15 downto 0);
      Anode                : out   std_logic_vector (3 downto 0); 
      Cathode              : out   std_logic_vector (6 downto 0);
      ld_or_str            : in std_logic
      );
end component; 

component controller 
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
      Alu_or_B             : out std_logic;
      Res_or_A             : out std_logic;
      Invert               : out std_logic;
      sftamt_reg_or_imm    : out std_logic;
      not_implemented      : out std_logic;
      stop                 : in std_logic;
      ld_or_str            : out std_logic      
      );
end component; 

begin

show_data <= show(15 downto 0);

dp   : datapath port map(instruction,flag,clk,reset,I_or_D,PCinc_OR_b,Rn_OR_Rd,Rs_OR_Rm,sft_OR_mul,s,Rd_OR_Rn_OR_lr,reg_wr_enbl,IR_enb,DR_enb,A_enb,B_enb,Rd_enb,shiftamt_enb,
sft_or_mul_res_enb,res_enb,PC_enb,Imm,predicate,Reg_wrtselect,instr,alu_sel,Memory_master_enable,Alu_or_B,Res_or_A,Invert,sftamt_reg_or_imm,show_add,show,stop,switches,LED,Anode,Cathode,ld_or_str);

ctrl : controller port map(instruction,flag,clk,reset,I_or_D,PCinc_OR_b,Rn_OR_Rd,Rs_OR_Rm,sft_OR_mul,s,Rd_OR_Rn_OR_lr,reg_wr_enbl,IR_enb,DR_enb,A_enb,B_enb,Rd_enb,shiftamt_enb,
sft_or_mul_res_enb,res_enb,PC_enb,Imm,predicate,Reg_wrtselect,instr,alu_sel,Memory_master_enable,Alu_or_B,Res_or_A,Invert,sftamt_reg_or_imm,not_implemented,stop,ld_or_str);

end Behavioral ;