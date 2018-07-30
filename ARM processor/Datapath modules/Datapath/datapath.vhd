library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;


entity datapath is
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
      stop                 : out std_logic
      );
end datapath;
 

architecture Behavioral of datapath is
signal IR                   : std_logic_vector(31 downto 0);     
signal DR                   : std_logic_vector(31 downto 0);     
signal A                    : std_logic_vector(31 downto 0);    
signal B                    : std_logic_vector(31 downto 0); 
signal Rd                   : std_logic_vector(31 downto 0);     
signal sft_or_mul_res       : std_logic_vector(31 downto 0);                 
signal res                  : std_logic_vector(31 downto 0);       
signal PC                   : std_logic_vector(31 downto 0);     
signal shiftamt             : std_logic_vector(31 downto 0);           
signal sft_or_mul0          : std_logic_vector(31 downto 0);               
signal sft_or_mul1          : std_logic_vector(31 downto 0);               
signal memory_in            : std_logic_vector(31 downto 0);             
signal processor_out        : std_logic_vector(31 downto 0);                 
signal memory_out           : std_logic_vector(31 downto 0);             
signal rd_add1              : std_logic_vector(3 downto 0);           
signal rd_add2              : std_logic_vector(3 downto 0);           
signal wrt_add              : std_logic_vector(3 downto 0);           
signal mem_add              : std_logic_vector(31 downto 0);           
signal Imm_extended         : std_logic_vector(31 downto 0);               
signal Imm_or_not           : std_logic_vector(31 downto 0); 
signal IR_temp              : std_logic_vector(31 downto 0);           
signal DR_temp              : std_logic_vector(31 downto 0);           
signal A_temp               : std_logic_vector(31 downto 0);         
signal B_temp               : std_logic_vector(31 downto 0);         
signal Rd_temp              : std_logic_vector(31 downto 0);           
signal sft_or_mul_res_temp  : std_logic_vector(31 downto 0);                       
signal res_temp             : std_logic_vector(31 downto 0);           
signal shiftamt_temp        : std_logic_vector(31 downto 0);                 
signal PC_temp              : std_logic_vector(31 downto 0);           
signal PC_inc1              : std_logic_vector(31 downto 0);           
signal PC_inc2              : std_logic_vector(31 downto 0);           
signal bl_offset            : std_logic_vector(31 downto 0);             
signal memory_write_enable  : std_logic_vector(3 downto 0);
signal flag_temp            : std_logic_vector (3 downto 0);
signal sftcary              : std_logic;
signal zero                 : std_logic_vector(31 downto 0):="00000000000000000000000000000000";
signal zero_4               : std_logic_vector(3 downto 0):="0000";
signal four                 : std_logic_vector(31 downto 0):="00000000000000000000000000000100";
signal junk                 : std_logic_vector(3 downto 0);
signal Invert_res           : std_logic_vector(31 downto 0);
signal res1                 : std_logic_vector(31 downto 0);
signal rd_data2             : std_logic_vector(31 downto 0);
signal final_result         : std_logic_vector(31 downto 0);
signal flag_1               : std_logic_vector(3 downto 0);
signal ina                  : std_logic_vector(31 downto 0);  
signal cons                 : std_logic_vector(1 downto 0);
signal neg_PC_enb           : std_logic;

component ALU 
Port (
    A, B     : in  STD_LOGIC_VECTOR(31 downto 0);  -- 2 inputs 32-bit
    carry    : in std_logic;
    ALU_Sel  : in  STD_LOGIC_VECTOR(3 downto 0);  -- input 4-bit for selecting function
    ALU_out  : out  STD_LOGIC_VECTOR(31 downto 0); --  output 31-bit 
    flag     : out std_logic_vector(3 downto 0)        -- CNZV flags
    );
end component;


component shifter
 Port (
    A           : in  STD_LOGIC_VECTOR(31 downto 0);  -- 1 inputs 32-bit
    shift_type  : in std_logic_vector(1 downto 0);
    shiftamt    : in STD_LOGIC_VECTOR(4 downto 0);  -- input 5-bit for selecting function
    shift_out   : out STD_LOGIC_VECTOR(31 downto 0); --  output 31-bit 
    shift_carry : out std_logic --shifter carry
    );
end component;


component multiplier
Port (
    A       : in  STD_LOGIC_VECTOR(31 downto 0);  -- 2 inputs 32-bit
    B       : in  STD_LOGIC_VECTOR(31 downto 0);  -- 2 inputs 32-bit
    mul_out : out STD_LOGIC_VECTOR(31 downto 0) --  output 31-bit 
    );
end component;


component registr
Port(
    write_data : in std_logic_vector(31 downto 0); -- data to be written
    read_add1  : in std_logic_vector(3 downto 0); -- 4-bit read address for read ports
    read_add2  : in std_logic_vector(3 downto 0); -- 4-bit read address for read ports
    write_add  : in std_logic_vector(3 downto 0); -- 4-bit address for writing
    show_add   : in std_logic_vector(3 downto 0);
    show_data  : out std_logic_vector(31 downto 0);
    clock      : in std_logic;
    reset      : in std_logic;
    write_enable : in std_logic;
    read_data1  : out std_logic_vector(31 downto 0);
    read_data2  : out std_logic_vector(31 downto 0);
    PC : in std_logic_vector(31 downto 0)
  ); 
end component;


component BRAM_wrapper
port (
    BRAM_PORTA_0_addr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTA_0_clk : in STD_LOGIC;
    BRAM_PORTA_0_din : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTA_0_dout : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTA_0_en : in STD_LOGIC;
    BRAM_PORTA_0_we : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
end component;


component mux2_4bit
port(
in0      : in std_logic_vector(3 downto 0); 
in1      : in std_logic_vector(3 downto 0); 
selec    : in std_logic;
enable   : in std_logic;
out_val  : out std_logic_vector(3 downto 0)  
        );
end component;


component mux2_32bit
port(
in0      : in std_logic_vector(31 downto 0);
in1      : in std_logic_vector(31 downto 0); 
selec    : in std_logic;
enable   : in std_logic;
out_val  : out std_logic_vector(31 downto 0)  
        );
end component;


component mux4_32bit
port(
in0     : in std_logic_vector(31 downto 0); 
in1     : in std_logic_vector(31 downto 0); 
in2     : in std_logic_vector(31 downto 0); 
in3     : in std_logic_vector(31 downto 0); 
selec   : in std_logic_vector(1 downto 0);
enable  : in std_logic;
out_val : out std_logic_vector(31 downto 0)  
        );
end component;

component mux4_4bit
port(
in0     : in std_logic_vector(3 downto 0); 
in1     : in std_logic_vector(3 downto 0); 
in2     : in std_logic_vector(3 downto 0); 
in3     : in std_logic_vector(3 downto 0); 
selec   : in std_logic_vector(1 downto 0);
enable   : in std_logic;
out_val  : out std_logic_vector(3 downto 0)  
        );
end component;


component mp_path
Port(
    memory_in  : in std_logic_vector(31 downto 0);
    processor_in : in std_logic_vector(31 downto 0); 
    instr: in std_logic_vector(2 downto 0); 
    byte_offset : in std_logic_vector(1 downto 0);
    memory_write_enable : out std_logic_vector(3 downto 0);
    memory_out  :  out std_logic_vector(31 downto 0);
    processor_out : out std_logic_vector(31 downto 0)
  ); 
end component;


begin

main_ALU: ALU port map(Invert_res,Imm_or_not,'0',alu_sel,res1,flag_temp);

with res_enb select
res <= res_temp when '1',
       res when others;

ALU_or_B_sel : mux2_32bit port map (res1,sft_or_mul_res,Alu_or_B,'1',res_temp);
RES_or_A_sel : mux2_32bit port map (res,Invert_res,Res_or_A,'1',final_result);

with s select
flag_1 <= flag_temp when '1',
        flag_1 when others;
flag <= flag_1;

shift : shifter port map(B,IR(6 downto 5),shiftamt(4 downto 0),sft_or_mul1,sftcary);

multiply : multiplier port map(B,shiftamt,sft_or_mul0);

sftORmul : mux2_32bit port map(sft_or_mul0,sft_or_mul1,sft_OR_mul,'1',sft_or_mul_res_temp );

Imm_extended(31 downto 12) <= "00000000000000000000";
Imm_extended(11 downto 0)  <= IR(11 downto 0);

Immdiate  : mux2_32bit port map(sft_or_mul_res,Imm_extended,Imm,'1',Imm_or_not);

with sft_or_mul_res_enb select
sft_or_mul_res <= sft_or_mul_res_temp when '1',
                  sft_or_mul_res when others;

reg_rdadd_sel_1 : mux2_4bit port map(IR(15 downto 12),IR(19 downto 16),Rn_OR_Rd,'1',rd_add1);

reg_rdadd_sel_2 : mux2_4bit port map(IR(3 downto 0),IR(11 downto 8),Rs_OR_Rm,'1',rd_add2);

reg_wradd_sel   : mux4_4bit port map(IR(15 downto 12),IR(19 downto 16),"1110",zero_4,Rd_OR_Rn_OR_lr,'1',wrt_add);

reg_wr_sel : mux4_32bit port map(DR,final_result,PC,zero,Reg_wrtselect,'1',memory_in);

Rgstr : registr port map(processor_out,rd_add1,rd_add2,wrt_add,show_add,show_data,clock,reset,reg_wr_enbl,A_temp,B_temp,PC);

Rd_temp <= A_temp ;
rd_data2 <= B_temp ;

ina(31 downto 5) <= "000000000000000000000000000";
ina(4 downto 0)  <= IR(11 downto 7);

shiftamt_reg_or_imm : mux2_32bit port map(rd_data2,ina,sftamt_reg_or_imm,'1',shiftamt_temp);

with A_enb select
A <= A_temp when '1',
     A  when others;

with B_enb select
B <= B_temp when '1',
     B  when others;

invert_sel : mux2_32bit port map(A,Rd,Invert,'1',Invert_res);

with Rd_enb select
Rd <= Rd_temp when '1',
      Rd when others;

with shiftamt_enb select
shiftamt <= shiftamt_temp when '1',
            shiftamt when others;

Instruction_or_Data : mux2_32bit port map(PC,final_result,I_or_D,'1',mem_add);

mem : BRAM_wrapper port map(mem_add,clock,memory_out,IR_temp,Memory_master_enable,memory_write_enable);

Processor_Memory_path : mp_path port map(memory_in,Rd,instr,IR(1 downto 0),memory_write_enable,memory_out,processor_out);

DR_temp <= IR_temp;

with IR_enb select
IR <= IR_temp when '1',
      IR when others;
      
instruction <= IR;

with DR_enb select
DR <= DR_temp when '1',
      DR when others;

bl_offset <= four + ("000000" & IR(23 downto 0) & "00");

PC_inc : ALU port map(PC,four,'0',four(3 downto 0),PC_inc1,junk);

PC_inc_bl : ALU port map(PC,bl_offset,'0',four(3 downto 0),PC_inc2,junk);

PC_inc_sel : mux2_32bit port map(PC_inc1,PC_inc2,PCinc_OR_b,neg_PC_enb ,PC_temp);

neg_PC_enb <= not PC_enb;

cons(0) <= reset;
cons(1) <=  PC_enb;

with cons select
PC <= PC_temp when "10",
      "00000000000000000000000000000000" when "11",
      "00000000000000000000000000000000" when "01",
      PC when others; 
      
with PC select 
stop <= '1' when X"0000001c",
        '0' when others;

end Behavioral;

-----------------------------------------------------------------------------------------------------------------------------------

