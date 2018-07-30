library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;
entity top is
    Port ( 
           CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           
           Ld_or_str : in std_logic;  --1 for load and 0 
           Add_in    : in std_logic_vector(15 downto 0); 
           Data_in   : in std_logic_vector(31 downto 0); 
           Size_in   : in std_logic_vector(2 downto 0);  
           DR_Out    : out std_logic_vector(31 downto 0);
           
           Switch    : in std_logic_vector(15 downto 0);
           LEDs      : out std_logic_vector(15 downto 0);
           
           anode      : out   std_logic_vector (3 downto 0); 
           cathode    : out   std_logic_vector (6 downto 0)
           
           );
end top;

architecture Behavioral of top is


signal  RDATA_to_master : std_logic_vector(31 downto 0);
signal  ready_to_master : std_logic; 
signal  add_to_decoder  : std_logic_vector(15 downto 0);
signal  hwrite      : std_logic;
signal  hsize       : std_logic_vector(2 downto 0);
signal  htrans      : std_logic_vector(1 downto 0);
signal  hwdata      : std_logic_vector(31 downto 0);
signal  hselx_mem   : std_logic;
signal  RO_0        : std_logic;
signal  RO_1        : std_logic;
signal  RO_2        : std_logic;
signal  RO_3        : std_logic;
signal  RO_4        : std_logic;
signal  select_signal : std_logic_vector(3 downto 0);
signal  read_data0  : std_logic_vector(31 downto 0);
signal  read_data1  : std_logic_vector(31 downto 0);
signal  read_data2  : std_logic_vector(31 downto 0);
signal  read_data3  : std_logic_vector(31 downto 0);
signal  read_data4  : std_logic_vector(31 downto 0);
signal  IOselected  : std_logic;

signal  Add_to_mem :  std_logic_vector(15 downto 0); 
signal  Mem_out   :  std_logic_vector(31 downto 0); 
signal  Mem_in    :  std_logic_vector(31 downto 0);
signal  Wrt_enb   :  std_logic_vector(3 downto 0);
signal  SSD_disp  :  std_logic_vector(15 downto 0);
signal  temp      :  std_logic;
signal  sel       :  std_logic_vector(1 downto 0);

component memory is
Port(
    address     : in  STD_LOGIC_VECTOR(7 downto 0);  -- 1 inputs 32-bit
    write_data  : in std_logic_vector(31 downto 0);
    memory_write_enable  : in std_logic_vector(3 downto 0);
    read_data     : out STD_LOGIC_VECTOR(31 downto 0); --  output 31-bit 
    clock         : in std_logic;
    reset         : in std_logic
    );
end component;


component digit_display
port (
      b          : in    std_logic_vector (15 downto 0); 
      clk        : in    std_logic; 
      anode      : out   std_logic_vector (3 downto 0); 
      cathode    : out   std_logic_vector (6 downto 0)
      );
end component;

component master is
Port( 
      ld_or_str : in std_logic;  --1 for load and 0 for str
      add_in    : in std_logic_vector(15 downto 0);
      data_in   : in std_logic_vector(31 downto 0);
      size_in   : in std_logic_vector(2 downto 0);      --"000" for byte , "001" for hW ; "010" for Word
      DR_out    : out std_logic_vector(31 downto 0);
      HRESET    : in std_logic;
	  HCLK      : in std_logic;
	  HRDATA    : in std_logic_vector(31 downto 0);
	  HREADY    : in std_logic;
	  HADDR     : out std_logic_vector(15 downto 0);
	  HWRITE    : out std_logic;
	  HSIZE     : out std_logic_vector(2 downto 0);
	  HTRANS    : out std_logic_vector(1 downto 0);
	  HWDATA    : out std_logic_vector(31 downto 0)
	  );
end component;

component slave_mem is
Port ( 
      addr_out : out std_logic_vector(15 downto 0);
      mem_out : in std_logic_vector(31 downto 0);
      mem_in  : out std_logic_vector(31 downto 0);
      hselx : in std_logic;
      wrt_enb : out std_logic_vector(3 downto 0); 
      
      HRESET : in STD_LOGIC;
      HCLK : in STD_LOGIC;
      HWDATA : in STD_LOGIC_VECTOR (31 downto 0);
      HADDR : in STD_LOGIC_VECTOR (15 downto 0);
      HWRITE : in STD_LOGIC;
      HSIZE : in STD_LOGIC_VECTOR (2 downto 0);
      HTRANS : in STD_LOGIC_VECTOR (1 downto 0);
      HREADYOUT : out STD_LOGIC;
      HRDATA : out STD_LOGIC_VECTOR (31 downto 0)
      );
end component;

component slave_out is
Port ( 
      out_val : out std_logic_vector(15 downto 0);
      hselx : in std_logic;
      HRESET : in STD_LOGIC;
      HCLK : in STD_LOGIC;
      HWDATA : in STD_LOGIC_VECTOR (31 downto 0);
      HADDR : in STD_LOGIC_VECTOR (15 downto 0);
      HWRITE : in STD_LOGIC;
      HSIZE : in STD_LOGIC_VECTOR (2 downto 0);
      HTRANS : in STD_LOGIC_VECTOR (1 downto 0);
      HREADYOUT : out STD_LOGIC;
      HRDATA : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component slave_in is
Port ( 
      switches : in std_logic_vector(15 downto 0);
      hselx : in std_logic;
      HRESET : in STD_LOGIC;
      HCLK : in STD_LOGIC;
      HWDATA : in STD_LOGIC_VECTOR (31 downto 0);
      HADDR : in STD_LOGIC_VECTOR (15 downto 0);
      HWRITE : in STD_LOGIC;
      HSIZE : in STD_LOGIC_VECTOR (2 downto 0);
      HTRANS : in STD_LOGIC_VECTOR (1 downto 0);
      HREADYOUT : out STD_LOGIC;
      HRDATA : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component dcdr is
Port ( 
      add : in STD_LOGIC_VECTOR (15 downto 0);
      memselect : out STD_LOGIC;
      IOselect : out STD_LOGIC;
      Portselect : out STD_LOGIC_VECTOR(3 downto 0)
      );  
end component;

component multiplex is
Port (
      Portselect : in STD_LOGIC_VECTOR(4 downto 0);
      HRDATA0    : in std_logic_vector(31 downto 0);
      HRDATA1    : in std_logic_vector(31 downto 0);
      HRDATA2    : in std_logic_vector(31 downto 0);
      HRDATA3    : in std_logic_vector(31 downto 0);
      HRDATA4    : in std_logic_vector(31 downto 0);
      HRDATA_OUT : out std_logic_vector(31 downto 0);
      HRESP_ot0    : in std_logic;
      HRESP_ot1    : in std_logic;
      HRESP_ot2    : in std_logic;
      HRESP_ot3    : in std_logic;
      HRESP_ot4    : in std_logic;
      HRESP_ot_OUT : out std_logic
 );
end component;

begin

SSD  : entity Work.digit_display
port map (
      b          => SSD_disp,
      clk        => CLK,
      anode      => anode,
      cathode    => cathode
      );

DT_mem : entity Work.memory
Port map(
    address     => Add_to_mem(7 downto 0),
    write_data  => mem_in,
    memory_write_enable  => Wrt_enb,
    read_data     => mem_out,
    clock         => CLK,
    reset         => RESET
    );

Mastr : entity Work.master
Port map( 
      ld_or_str => Ld_or_str,  --1 for load and 0 for str
      add_in    => Add_in ,
      data_in   => Data_in,
      size_in   => Size_in,
      DR_out    => DR_Out,
      HRESET    => RESET ,
	  HCLK      => CLK ,
	  HRDATA    => RDATA_to_master,
	  HREADY    => ready_to_master,
	  HADDR     => add_to_decoder,
	  HWRITE    => hwrite,
	  HSIZE     => hsize,
	  HTRANS    => htrans,
	  HWDATA    => hwdata
      );

sel(0) <= Ld_or_str;
sel(1) <= hselx_mem;
with sel select
temp <=  '1' when "10" | "11",
         '0' when others;

Slave_memory : entity Work.slave_mem
Port map ( 
      addr_out => Add_to_mem,
      mem_out => Mem_out,
      mem_in  => Mem_in,
      hselx => temp,
      wrt_enb => Wrt_enb,
      HRESET => RESET ,
      HCLK => CLK,
      HWDATA =>  hwdata,
      HADDR => add_to_decoder,
      HWRITE => hwrite,
      HSIZE => hsize,
      HTRANS => htrans,
      HREADYOUT => RO_0,
      HRDATA => read_data0 
      );

Slave_output1 : entity Work.slave_out
Port map( 
      out_val => LEDs,
      hselx => select_signal(0),
      HRESET => RESET,
      HCLK => CLK,
      HWDATA => hwdata,
      HADDR => add_to_decoder,
      HWRITE =>hwrite,
      HSIZE =>hsize,
      HTRANS =>htrans,
      HREADYOUT => RO_1,
      HRDATA => read_data1
      );

Slave_output2 : entity Work.slave_out
Port map( 
      out_val => SSD_disp,
      hselx => select_signal(1),
      HRESET => RESET,
      HCLK => CLK,
      HWDATA =>  hwdata,
      HADDR => add_to_decoder,
      HWRITE =>hwrite,
      HSIZE =>hsize,
      HTRANS =>htrans,
      HREADYOUT => RO_2,
      HRDATA => read_data2
      );

Slave_input3 : entity Work.slave_in
Port map( 
      switches => switch,
      hselx  => select_signal(2),
      HRESET  => RESET,
      HCLK  => CLK,
      HWDATA  =>  hwdata,
      HADDR  => add_to_decoder,
      HWRITE  => hwrite,
      HSIZE  => hsize,
      HTRANS  => htrans,
      HREADYOUT  => RO_3,
      HRDATA  => read_data3
      );

Slave_input4 : entity Work.slave_in 
Port map( 
      switches => switch,
      hselx  => select_signal(3),
      HRESET  => RESET,
      HCLK  => CLK,
      HWDATA  =>  hwdata,
      HADDR  => add_to_decoder,
      HWRITE  => hwrite,
      HSIZE  =>hsize ,
      HTRANS  =>htrans ,
      HREADYOUT  => RO_4,
      HRDATA  => read_data4 
      );

Mux : entity Work.multiplex
Port map (
      Portselect => select_signal ,
      HRDATA0    => read_data0,
      HRDATA1    => read_data1,
      HRDATA2    => read_data2,
      HRDATA3    => read_data3,
      HRDATA4    => read_data4,
      HRDATA_OUT => RDATA_to_master,
      HRESP_ot0  => RO_0,
      HRESP_ot1  => RO_1,
      HRESP_ot2  => RO_2,
      HRESP_ot3  => RO_3,
      HRESP_ot4  => RO_4,
      HRESP_ot_OUT => ready_to_master
 );

Decode : entity Work.dcdr
Port map( 
      add => add_to_decoder,
      memselect => hselx_mem,
      IOselect => IOselected,
      Portselect => select_signal 
); 

end Behavioral;
