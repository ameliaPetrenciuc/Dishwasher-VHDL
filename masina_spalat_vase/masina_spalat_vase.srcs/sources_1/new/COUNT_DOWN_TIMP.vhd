----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.05.2023 02:54:38
-- Design Name: 
-- Module Name: COUNTER_HM - Behavioral
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
---PETRENCIUC AMELIA & VINATORU DAIANA ---

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

entity COUNTER_DOWN_TIMP is
    Port ( HOUR : in STD_LOGIC_VECTOR (1 downto 0);
           D1_MIN : in STD_LOGIC_VECTOR (3 downto 0);
           D0_MIN : in STD_LOGIC_VECTOR (3 downto 0);
           DOOR : in std_logic;
           CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           DONE : out STD_LOGIC;
           TIMP_RAMAS : out STD_LOGIC_VECTOR(11 downto 0)
          );
end COUNTER_DOWN_TIMP;

architecture Behavioral of COUNTER_DOWN_TIMP is
signal divclock : std_logic;
signal done_sig : std_logic := '0';
signal min_digit1: std_logic_vector(3 downto 0):= D1_MIN;
signal min_digit0: std_logic_vector(3 downto 0):= D0_MIN;
signal hour_digit: std_logic_vector(1 downto 0):= HOUR;
signal count:integer:=0;
begin
    ---DIVIZOR DE FRECVENTA
    process(clk, RESET)
    begin
        if(RESET ='1') then 
            count <= 0;
        elsif( rising_edge(clk) and door = '1') then
            if(count = 50000000) then 
                divclock <= not divclock;
                count<=0;
            else 
                count<= count +1;
            end if;
       end if;
    end process;
    process(DIVCLOCK) 
      begin
           if(RESET ='1') then 
                done_sig<= '0';
                min_digit0<=d0_min;
                min_digit1<=d1_min;
                hour_digit<= hour;
                DONE <= '0';
           else
            if(rising_edge(DIVCLOCK) and done_sig = '0') then 
                if(min_digit0 = "0001" and min_digit1 = "0000" and hour_digit = "0000") then
                    min_digit0 <="0000";
                    done_sig <='1';
                    DONE <= '1';
                elsif(min_digit0 = "0000" and min_digit1 = "0000") then 
                    hour_digit<=hour_digit-1;
                    min_digit1<= "0101";
                    min_digit0<="1001";
                    done_sig <='0';
                elsif(min_digit0 = "0000") then 
                    min_digit1<= min_digit1-1;
                    min_digit0<="1001";
                    done_sig <='0';
                else 
                    min_digit0<= min_digit0-1;
                    done_sig <='0';
                end if;
           end if;
           end if;
      end process; 
      timp_ramas <="00"&hour_digit&min_digit1&min_digit0;        
end Behavioral;
