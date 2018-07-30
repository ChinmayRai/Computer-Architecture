----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.04.2018 16:28:18
-- Design Name: 
-- Module Name: multiplex - Behavioral
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
--use UNISIM.VComponents.all;-

entity multiplex is
Port (
        Portselect : in STD_LOGIC_VECTOR(3 downto 0);
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
end multiplex;

architecture Behavioral of multiplex is

begin
with Portselect select
HRDATA_OUT <= HRDATA1 when "0001",
              HRDATA2 when "0010",
              HRDATA3 when "0100",
              HRDATA4 when "1000",
              HRDATA0 when others;
              
with Portselect select
HRESP_ot_OUT <= HRESP_ot1 when "0001",
                HRESP_ot2 when "0010",
                HRESP_ot3 when "0100",
                HRESP_ot4 when "1000",
                HRESP_ot0 when others;
              
end Behavioral;
