----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.04.2023 19:08:10
-- Design Name: 
-- Module Name: counter_4_bits - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter_3_bits is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (2 downto 0));
end counter_3_bits;

architecture Behavioral of counter_3_bits is
signal afis: std_logic_VECTOR(2 DOWNTO 0);
begin
    process(clk,afis)
    begin
    if (clk='1' and clk'event) then
         if(afis = "101") then
            afis<= "000";
         else
             afis<=afis+1;
         end if;
    end if;
    end process;
    
    output<=afis;
end Behavioral;
