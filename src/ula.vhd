library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is 
    port (  entr0,entr1  : in signed (15 downto 0);
            sel_op : in unsigned (2 downto 0);
            saida : out signed (15 downto 0);
            saida_bool : out std_logic
    );
end entity;


-- 000 - soma ([0]+[1])
-- 001 - subtracao ([0]-[1])
-- 010 - maior ([0]>[1]? 1 : 0)
-- 011 - igual ([0]==[1]? 1 : 0)
-- 100 - maior/igual ([0]>=[1]? 1 : 0)
-- 101 - shift left ([0]<<1)
-- 110 - shift right ([0]>>1)
-- 111 - segunda entrada ([1]) (útil para cópia)
architecture a_ula of ula is
begin 
    saida <= entr0+entr1 when sel_op = "000" else
             entr0-entr1 when sel_op = "001" else
             SHIFT_LEFT(entr0,1) when sel_op = "101" else
             SHIFT_RIGHT(entr0,1) when sel_op = "110" else
			 entr1 when sel_op = "111" else
             "0000000000000000";
    saida_bool <= '1' when sel_op = "010" and entr0 > entr1 else
                  '0' when sel_op = "010" and entr0 <= entr1 else
                  '1' when sel_op = "011" and entr0 = entr1 else
                  '0' when sel_op = "011" and entr0 /= entr1 else
                  '1' when sel_op = "100" and entr0 >= entr1 else
                  '0' when sel_op = "100" and entr0 < entr1 else
                  '0';

            
                  
end architecture;

