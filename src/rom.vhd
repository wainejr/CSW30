library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port(clk : in std_logic;
         endereco : in unsigned(6 downto 0);
         dado : out unsigned(17 downto 0) -- 17 pela especificação do uproc
);
end entity;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(17 downto 0);
    constant conteudo_rom : mem := (
        -- caso endereco => conteudo
        0 => "000000000010000000",
        1 => "000000000011000000",
        2 => "000000000011100000",
        3 => "000000000011110000",
        4 => "000000000011111000",
        5 => "000000000011111100",
        6 => "000000000011111110",
        7 => "000000000011111111",
        8 => "000000000111111111",
        9 => "000000001111111111",
        10 =>"000000011111111111",
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
