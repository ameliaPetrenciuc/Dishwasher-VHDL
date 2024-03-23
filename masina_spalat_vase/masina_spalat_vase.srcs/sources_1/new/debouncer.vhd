----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.04.2023 18:10:57
-- Design Name: 
-- Module Name: debouncer - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debouncer is
    Port ( CLK : in STD_LOGIC;
           BTN : in STD_LOGIC;
           ENABLE : out STD_LOGIC);
end debouncer;

architecture Behavioral of debouncer is
    signal count: STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal q0,q1,q2,en: STD_LOGIC;
  
    
   component And2 is
     Port (
        a: in std_logic;
        b: in std_logic;
        output: out std_logic 
     );
    end component And2;
begin
    process(clk,count)
    begin
    --if rising_edge(clk) then
    if (clk='1' and clk'event) then count<=count+1;
    end if;
    end process;
    
    process(count,q0)
    begin
        if(count =x"ff") then
            q0<=Btn;
        end if;
    end process;
    
    process(q1,q2)
    begin
        q1<=q0;
        q2<=q1;
    end process; 

    enable <= q2 and q1;
end Behavioral;