----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.05.2023 23:10:31
-- Design Name: 
-- Module Name: SETARE_PROGRAM - Behavioral
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
--PETRENCIUC AMELIA--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SETARE_PROGRAM is
    Port (
           DOOR : in STD_LOGIC;
           CLK : in STD_LOGIC;
           MODE : in STD_LOGIC;
           RESET : in STD_LOGIC;
           BTN_SETARE_PROG : in STD_LOGIC;
           BTN_STARE_URM : in STD_LOGIC;
           TEMPERATURA : in STD_LOGIC_VECTOR (1 downto 0);
           SETARE_FUNC : in STD_LOGIC_VECTOR (1 downto 0);
           terminare_program : out std_logic;
           PROGRAM_OUT : out std_logic_VECTOR(5 DOWNTO 0);
           SET : out std_logic_VECTOR(4 DOWNTO 0);
           AN : out STD_LOGIC_VECTOR (3 downto 0);
           CAT : out STD_LOGIC_VECTOR (6 downto 0)
           );
end SETARE_PROGRAM;

architecture Behavioral of SETARE_PROGRAM is
signal TIMP, TIMP_RAMAS : STD_LOGIC_VECTOR (11 downto 0) := x"000";
signal timp_spalare: std_logic_vector(9 downto 0);
signal enable_prog, enable_start, incepere_program, enable_stare_urmatoare: std_logic := '0';
signal functii: std_logic_vector(1 downto 0);
signal alg_prog: std_logic_vector(2 downto 0); 
signal prog_int: integer := 0;
signal program_automat: std_logic_vector(13 downto 0);
type setari is (SETARE_MODE,SETARE_PROG_AUT,SETARE_TIMP, SETARE_TEMP, SETARE_FUNCTII, SFARSIT_SETARI);
signal stare_act, stare_urmatoare : setari := SETARE_MODE;
signal DIVCLOCK, terminare_program_sig, DONE: std_logic :='0';
signal count:integer:=0;
begin
debouncer:  entity work.debouncer port map ( CLK=>CLK, BTN=> BTN_SETARE_PROG, ENABLE=>ENABLE_PROG);
alegere_program: entity work.counter_3_bits port map ( CLK=>CLK, en=>ENABLE_PROG, output=> alg_prog);
prog_int <= conv_integer(unsigned(alg_prog));
prog_automat : entity work.MEMORIE_PROGRAME port map (ADD => prog_int, cs=>mode, clk=>clk, data_out=>program_automat);


process(clk)
begin
    if(rising_edge(clk))then
        stare_act <= stare_urmatoare;
    end if;
end process;

process(stare_act,BTN_STARE_URM) 
begin
    if(RESET = '1') then
        enable_stare_urmatoare <= '0';
        stare_urmatoare <= SETARE_MODE;
        SET <= "00000";
    else
        if(BTN_STARE_URM = '1') then
            enable_stare_urmatoare <= '1';
        end if;
        case stare_act is
            when SETARE_MODE => SET <= "00001";
                                if( enable_stare_urmatoare ='1') then 
                                    enable_stare_urmatoare <= '0';
                                    stare_urmatoare <= SETARE_TIMP;
                                else 
                                    stare_urmatoare <= SETARE_MODE;
                                end if;
            when SETARE_PROG_AUT => SET <= "00010";
                                    if(MODE = '0' ) then 
                                        stare_urmatoare <= SETARE_TIMP;        
                                     else 
                                          if( enable_stare_urmatoare ='1') then 
                                                enable_stare_urmatoare <= '0';
                                                stare_urmatoare <= SETARE_TIMP;
                                                
                                          else 
                                                stare_urmatoare <= SETARE_PROG_AUT;
                                          end if; 
                                     end if;         
            when SETARE_TIMP => SET <= "00100";
                                if(MODE = '0') then 
                                    case setare_func is
                                        when "00" => timp <= x"041";-- am dat direct timp, standard, fara pre, fara cl
                                        when "01" => timp <= x"051"; --cu pre
                                        when "10" => timp <= x"046";--cu cl
                                        when "11" => timp <= x"056";-- amandoua
                                        when others => timp <= x"000";
                                        timp_spalare <= x"000";
                                    end case;
                                elsif (MODE = '1') then 
                                    case prog_int is
                                        when 1 => timp <= x"030"; 
                                        when 2 => timp <= x"330";
                                        when 3 => timp <= x"230";
                                        when 4 => timp <= x"255";
                                        when 5 => timp <= x"015";
                                        when others => timp <= x"000";
                                    end case;
                                    timp_spalare <= program_automat(11 downto 2);
                                end if;
                                if( enable_stare_urmatoare ='1') then 
                                    if(MODE ='0' or prog_int = 3) then
                                       enable_stare_urmatoare <= '0'; 
                                       stare_urmatoare <= SETARE_TEMP;
                                       
                                    else
                                        enable_stare_urmatoare <= '0';
                                        stare_urmatoare <= SFARSIT_SETARI;
                                        
                                    end if;
                                else 
                                    stare_urmatoare <= SETARE_TIMP;
                                end if;
             when SETARE_TEMP => SET <= "01000";
                                if(temperatura = "00") then 
                                    timp_spalare(3 downto 0) <=timp_spalare(3 downto 0)+1;    ---> 50 C
                                elsif(temperatura = "01") then 
                                    timp_spalare(3 downto 0) <=timp_spalare(3 downto 0)+2;    ---> 60 C
                                else
                                    timp_spalare(3 downto 0) <=timp_spalare(3 downto 0)+3;    ---> 75 C
                                end if;
                                if (enable_stare_urmatoare = '1') then
                                    enable_stare_urmatoare <= '0';
                                    stare_urmatoare <= SFARSIT_SETARI;
                                    
                                else
                                    stare_urmatoare <= SETARE_TEMP;
                                end if;
              when  SFARSIT_SETARI => SET <= "10000";   enable_start <= '1';
              when others => stare_urmatoare <= SETARE_MODE;
        end case;
    
    end if;
end process;

incepere_program <= enable_start and DOOR; -- instructiune pe biti
functii(1) <= SETARE_FUNC(1) WHEN MODE='1' ELSE program_automat(1);
functii(0) <= SETARE_FUNC(0) WHEN MODE='0' ELSE program_automat(0);

---NUMARATOR INVERS AFISAJ
Timp_num: entity work.COUNTER_DOWN_TIMP 
    port map(HOUR=> timp(9 downto 8), 
             D1_MIN=> timp(7 downto 4),
             D0_MIN=> timp(3 downto 0), 
             DOOR=> incepere_program,
             CLK =>CLK, 
             RESET=>RESET,  
             DONE => DONE,
             TIMP_RAMAS =>TIMP_RAMAS); 
--- AFISARE PE SSD
AFIS_TIMP: entity work.SSD port map (CLK=>CLK, d0 => timp_RAMAS(3 downto 0), d1 => timp_RAMAS(7 downto 4), d2 => timp_RAMAS(11 downto 8), d3 => "0000", an=>an, cat=>cat);

PROG_EXEC: entity work.executare_program  
        port map ( CLK =>CLK,
                   START => INCEPERE_PROGRAM,
                   RESET => RESET,
                   SETARE_FUNC => FUNCTII,   --- (0)- prespalare ; (1)- clatire_suplimenatara
                   TIMP_SPALARE => TIMP_SPALARE,
                   TERMINARE_PROGRAM =>TERMINARE_PROGRAM_SIG,
                   PROGRAM => PROGRAM_OUT);
TERMINARE_PROGRAM <= terminare_program_sig and DONE;
end Behavioral;
