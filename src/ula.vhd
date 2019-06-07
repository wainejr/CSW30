library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is 
    port (  entr0,entr1  : in signed (15 downto 0);
            sel_op : in unsigned (2 downto 0);
            saida : out signed (15 downto 0);
            saida_flags : out unsigned (2 downto 0) -- Z (zero), N (negativo), C (carry)
    );
end entity;

-- codificacao - operacao (dados)
-- 000 - soma ([0]+[1])
-- 001 - subtracao ([0]-[1])
-- 100 - primeira entrada ([0])
-- 101 - shift left ([0]<<1)
-- 110 - shift right ([0]>>1)
-- 111 - segunda entrada ([1]) (útil para cópia)
-- Flags - Z: saida=0; N: MSB=1; C: carry

architecture a_ula of ula is
    signal in_0, in_1, res: unsigned(16 downto 0);
    signal saida_s: signed (15 downto 0);
begin
	in_0 <= '0' & unsigned(entr0);
	in_1 <= '0' & unsigned(entr1);
    saida <= saida_s;
    
	saida_s <= entr0+entr1 when sel_op = "000" else
             entr0-entr1 when sel_op = "001" else
             SHIFT_LEFT(entr0,1) when sel_op = "101" else
             SHIFT_RIGHT(entr0,1) when sel_op = "110" else
             entr1 when sel_op = "111" else
             entr0 when sel_op = "100" else
             "0000000000000000";
	
	res <= in_0+in_1 when sel_op = "000" else
           in_0-in_1 when sel_op = "001" else
           SHIFT_LEFT(in_0,1) when sel_op = "101" else
           SHIFT_RIGHT(in_0,1) when sel_op = "110" else
           "00000000000000000";
			 
	
    saida_flags(0) <= '1' when saida_s = "00000000000000000000" else
                      '0'; -- Z
    saida_flags(1) <= '1' when saida_s(15) = '1' else
                      '0'; -- N
    saida_flags(2) <= '1' when res(16) = '1' else
                      '0'; -- C
end architecture;

