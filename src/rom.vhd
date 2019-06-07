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
        0 => "000100100000001111", -- R1 <= 1
        1 => "000101000000100111", -- R2 <= 4
        2 => "000101100001001111", -- R3 <= 9
        3 => "000110000011100111", -- R4 <= 28
        4 => "000110100110111111", -- R5 <= 55
        5 => "000111001111101111", -- R6 <= 125
        6 => "001111001100000100", -- [R3] <= R6
        7 => "001001101100000111", -- R3 <= [R3]
        8 => "001101000100000100", -- [R1] <= R2
        9 => "001011000100000111", -- R6 <= [R1]
        10 =>"001110110000000100", -- [R4] <= R5
        11 =>"001000110000000111", -- R1 <= [R4]
        -- R1 = 55
        -- R2 = 4
        -- R3 = 125 
        -- R4 = 28
        -- R5 = 55
        -- R6 = 4
        -- [9] = 125
        -- [1] = 4
        -- [28] = 55
        -- 12 =>"111111111111111111", 
        -- 13 =>"111111111111111111",
        -- 14 =>"111111111111111111",
        -- 15 =>"111111111111111111",  
        -- 16 =>"111111111111111111",
        -- 17 =>"111111111111111111", 
        -- 18 =>"111111111111111111",
        -- 19 =>"111111111111111111",
        --20 =>"000001110100000111", -- Copia R5 para R3
        --21 =>"111100000000000010", -- Salta para a terceira instrução desta lista (R5 <= R3+R4)
        -- abaixo: casos omissos => (zero em todos os bits)
        -- others => (others=>'0')
        others => "111111111111111111"
    );
    
    begin 
    process(clk)
        begin
        if(rising_edge(clk)) then
            dado <= conteudo_rom(to_integer(endereco));
        end if;
    end process;
end architecture;
