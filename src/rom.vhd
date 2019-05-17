library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port(clk : in std_logic;
         endereco : in unsigned(6 downto 0);
         dado : out unsigned(17 downto 0) -- 17 pela especificação do uproc
);
end entity;

-- opcode p/ jump: 111111 (MSB)
-- end. do jump abs: 7 LSB

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(17 downto 0);
    constant conteudo_rom : mem := (
        -- caso endereco => conteudo
        0 => "000101100000101000", -- Carrega R3 (o registrador 3) com o valor 5
        1 => "000110000001000000", -- Carrega R4 com 8
        2 => "000010100000000111", -- Copia R0 para R5 (zera R5)
        3 => "000010101100000000", -- Soma R5 com R3 e guarda em R5
        4 => "000010110000000000", -- Soma R5 com R4 e guarda em R5
        5 => "000110100000001001", -- Subtrai um de R5 e guarda em R5
        6 => "111100000000010100", -- Salta para endereço 20
        7 => "000000000000000000",
        8 => "000000000000000000",
        9 => "000000000000000000",
        10 =>"000000000000000000",
		11 =>"000000000000000000",
        12 =>"000000000000000000",
        13 =>"000000000000000000",
        14 =>"000000000000000000",
        15 =>"000000000000000000",  
		16 =>"000000000000000000",
		17 =>"000000000000000000", 
		18 =>"000000000000000000",
        19 =>"000000000000000000",
        20 =>"000001110100000111", -- Copia R5 para R3
		21 =>"111100000000000010", -- Salta para a terceira instrução desta lista (R5 <= R3+R4)
		
		-- abaixo: casos omissos => (zero em todos os bits)
        others => (others=>'0')
    );
    
    begin 
    process(clk)
        begin
        if(rising_edge(clk)) then
            dado <= conteudo_rom(to_integer(endereco));
        end if;
    end process;
end architecture;
