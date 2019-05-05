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
        0 => "111111000000000011", -- pula para o 3 
        1 => "000000000000000010",
        2 => "000000000000000100",
        3 => "000000000000001000",
        4 => "000000000000010000",
        5 => "000000000000100000",
        6 => "000000000001000000",
        7 => "111111000000001010", -- pula para o 10
        8 => "000000000100000000",
        9 => "000000001000000000",
        10 =>"111111000000001100", -- pula para o 12
		11 =>"000000100000000000",
        12 =>"000001000000000000",
        13 =>"111111000000001111", -- pula para o 15
        14 =>"000100000000000000",
        15 =>"000000000000000111",  
		16 =>"010000000000001111",
		17 =>"111111000000001110", -- pula para o 14 (loop)
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
