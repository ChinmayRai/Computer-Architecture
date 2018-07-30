----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.04.2018 14:10:12
-- Design Name: 
-- Module Name: slave - Behavioral
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

entity slave_mem is
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
           HRDATA : out STD_LOGIC_VECTOR (31 downto 0));
end slave_mem;

architecture Behavioral of slave_mem is
signal state: std_logic; 
signal W  : std_logic; 

begin
addr_out <= HADDR;
process(HCLK)
begin
if (HCLK ='1' and HCLK' event) then
if (HRESET='1') then 
   state <= '0';
   wrt_enb <="0000";
   
   
elsif state ='0' then 
    if HTRANS="00" then state<='0';
    elsif HTRANS="10" then
        if hselx ='0' then state <='0';
        elsif hselx ='1' then 
            W <= HWRITE;
            HREADYOUT <= '0';
            state <= '1';
        end if; 
    end if;
        
elsif state = '1' then
    HREADYOUT <= '1';
    if W='0' then HRDATA <= mem_out; state <='0';
    elsif W='1' then wrt_enb <="1111" ;mem_in <= HWDATA; state <= '0';  
    end if;  
    
end if;
end if;
end process;


end Behavioral;
