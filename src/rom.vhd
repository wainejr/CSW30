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
        0 => "000101100000000000", -- R3 <= 0
        1 => "000110000000000000", -- R4 <= 0
        2 => "000010001100000000", -- R4 <= R4+R3
        3 => "000101100000001000", -- R3 <= R3+1
        4 => "000000101100000111", -- R1 <= R3
        5 => "000100100011110001", -- R1 <= R1-30
        6 => "010111111000011000", -- Se cc_N (N=1), PC <= PC - 4 (p/ R4<=R4+R3)
        7 => "000010110000000111", -- R5 <= R4
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
        --20 =>"000001110100000111", -- Copia R5 para R3
		--21 =>"111100000000000010", -- Salta para a terceira instrução desta lista (R5 <= R3+R4)
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
