----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.05.2023 02:50:57
-- Design Name: 
-- Module Name: executare_program - Behavioral
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

--VINATORU DAIANA--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity executare_program is
    Port ( CLK : in STD_LOGIC;
           START : in STD_LOGIC;
           RESET : in STD_LOGIC;
           SETARE_FUNC : in STD_LOGIC_VECTOR (1 DOWNTO 0);   --- (0)- prespalare ; (1)- clatire_suplimenatara
           TIMP_SPALARE : in std_logic_VECTOR (9 DOWNTO 0);
           TERMINARE_PROGRAM : out std_logic := '0';
           PROGRAM : out STD_LOGIC_VECTOR (5 downto 0));
end executare_program;

architecture Behavioral of executare_program is
type etape is (idle, inmuiere_vase, spalare_principala, evac_apa, clatire_apa,clatire_suplimentara,uscare_vase, stop);
signal stare_act, stare_urmatoare: etape := idle;

signal program_stare: std_logic_vector(5 downto 0);
signal timp: std_logic_vector(9 downto 0);
signal terminare_prog: std_logic:='0';
signal c: std_logic_VECTOR(0 TO 5):="000000";
begin
    process(clk, reset) 
    begin
       if(RESET = '1') then 
            stare_act <= idle;
       else 
            stare_act <= stare_urmatoare;
       end if;
    end process;
    
    process(stare_act, c)
    begin
        if(RESET = '1') then
            terminare_prog <= '0';
        else
            case stare_act is
                    when idle => terminare_prog <= '0';
                                 if(START ='1') then 
                                    stare_urmatoare <= inmuiere_vase;
                                 else 
                                    stare_urmatoare <= idle;
                                 end if;
                   -------------------------------INMUIERE VASE----------------------------                            
                    when inmuiere_vase => if(c(0) ='1' and START ='1') then 
                                            Stare_urmatoare <= spalare_principala;
                                         else 
                                            stare_urmatoare <= inmuiere_vase; 
                                           end if;   
                    -------------------------------SPALARE PRINCIPALA----------------------------                            
                    when spalare_principala =>if(c(1) ='1' and START ='1') then 
                                                   stare_urmatoare <= evac_apa;
                                              else 
                                                   stare_urmatoare <= spalare_principala; 
                                              end if; 
                   -------------------------------EVACUARE VASE----------------------------                            
                    when evac_apa =>if(c(2) ='1' and START ='1') then 
                                        stare_urmatoare <= clatire_apa;
                                    else 
                                        stare_urmatoare <= evac_apa; 
                                   end if;  
                   -------------------------------CLATIRE----------------------------                                                    
                     when clatire_apa =>if(c(3) ='1' and START ='1') then 
                                            if(SETARE_FUNC(1) ='1') then
                                                stare_urmatoare <= clatire_suplimentara;
                                            else
                                                stare_urmatoare <= uscare_vase;
                                            end if;
                                         else 
                                            stare_urmatoare <= clatire_apa; 
                                         end if;  
                   -------------------------------CLATIRE SUPLIMENTARA----------------------------                                                                                          
                    when clatire_suplimentara => if(c(4) ='1' and START ='1') then 
                                                    stare_urmatoare <= uscare_vase;
                                                 else 
                                                    stare_urmatoare <= clatire_suplimentara; 
                                                 end if; 
                   -------------------------------USCARE----------------------------                                                                                    
                    when uscare_vase => if(c(5) = '1' and START = '1') then  
                                            terminare_prog <= '1';
                                        end if;
                                       stare_urmatoare <= uscare_vase;
                                        
                    when others => stare_urmatoare <= idle;  
                end case;   
            end if;                             
    end process;
terminare_program <= terminare_prog;
num_inmuiere     :entity work.COUNTER_HM port map (HOUR => timp(9 downto 8), D1_MIN=> timp (7 downto 4), D0_MIN=> timp (3 downto 0),DOOR => START ,CLK=>CLK, RESET=>RESET, ENABLE=>program_stare(0), done=> c(0));
num_spalare_prin :entity work.COUNTER_HM port map (HOUR => timp(9 downto 8), D1_MIN=> timp (7 downto 4), D0_MIN=> timp (3 downto 0),DOOR => START ,CLK=>CLK, RESET=>RESET, ENABLE=>program_stare(1), done=> c(1));
num_evacuare     :entity work.COUNTER_HM port map (HOUR => timp(9 downto 8), D1_MIN=> timp (7 downto 4), D0_MIN=> timp (3 downto 0),DOOR => START ,CLK=>CLK, RESET=>RESET, ENABLE=>program_stare(2), done=> c(2));
num_clatire      :entity work.COUNTER_HM port map (HOUR => timp(9 downto 8), D1_MIN=> timp (7 downto 4), D0_MIN=> timp (3 downto 0),DOOR => START ,CLK=>CLK, RESET=>RESET, ENABLE=>program_stare(3), done=> c(3));
num_clatire_sup  :entity work.COUNTER_HM port map (HOUR => timp(9 downto 8), D1_MIN=> timp (7 downto 4), D0_MIN=> timp (3 downto 0),DOOR => START ,CLK=>CLK, RESET=>RESET, ENABLE=>program_stare(4), done=> c(4));
num_uscare       :entity work.COUNTER_HM port map (HOUR => timp(9 downto 8), D1_MIN=> timp (7 downto 4), D0_MIN=> timp (3 downto 0),DOOR => START ,CLK=>CLK, RESET=>RESET, ENABLE=>program_stare(5), done=> c(5));

 
---------------------------------for outputs AND TIME----------------------
process (reset)
    begin
        if(RESET ='1') THEN
            program_stare<= "000000";
            timp<= "0000000000";
        else
            case stare_act is
                when idle =>program_stare <="000000"; 
                when inmuiere_vase => program_stare <="000001"; 
                                     if(SETARE_FUNC(0) = '1') then 
                                            timp <="0000010101";
                                      else
                                            timp <="0000000101";
                                      end if;
                when spalare_principala => program_stare <="000010";  timp <=TIMP_SPALARE;
                when evac_apa => program_stare <="000100"; timp <= "0000000001"; 
                when clatire_apa => program_stare <="001000"; timp <="0000000101";  
                when clatire_suplimentara => program_stare <="010000"; timp <="0000000101"; 
                when uscare_vase => program_stare <="100000"; timp <="0000110000";
                when others => program_stare <="000000";
            end case;
        end if;
end process;
    program <= program_stare;
end Behavioral;
