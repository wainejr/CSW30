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
		-- Crivo de eratostenes: 1 indica primo, 0 não primo
		-- R1: contador memória / numero atual
		-- R2: cte (1 e dps 0)
		-- R3: acumulador
		-- R7: auxiliar checagem (flags)
        0 => "000000100000000111", -- R1 <= 0
        1 => "000101000000001111", -- R2 <= 1
		-- loop inicializante
        2 => "001101000100000100", -- [R1] <= R2
        3 => "000100100000001000", -- R1 <= R1+1
        4 => "000011100100000111", -- R7 <= R1
        5 => "000111100100001001", -- R7 <= R7-33 (32 é até onde ir)
		6 => "010111111000010000", -- PC <= PC-4 se cc_NZ (p/ loop inicializante)
		-- fim loop inicializante
		7 => "000001000000000111", -- R2 <= 0
        8 => "000100100000001111", -- R1 <= 1
		-- loop contador
		9 => "000100100000001000", -- R1 <= R1+1
		10=> "000011100100000111", -- R7 <= R1
		11=> "000111100100000001", -- R7 <= R7-32
		12=> "110100110000001111", -- PC <= 24 se cc_Z (p/ fim do loop elimina primos)
        13=> "000001100100000111", -- R3 <= R1
		14=> "001011101100000111", -- R7 <= [R3]
		15=> "000011111100000111", -- R7 <= R7 (setar flag)
		16=> "110100010010001111", -- PC <= 9 se cc_Z (p/ loop contador)
		-- loop elimina primos
        17=> "000001100100000000", -- R3 <= R3+R1
		18=> "000011101100000111", -- R7 <= R3
		19=> "000111100100001001", -- R7 <= R7-33
		20=> "110100010010100111", -- PC <= 9 se CC_NN (p/ loop contador)
		21=> "001101001100000100", -- [R3] <= R2
        22=> "010111110110011000", -- PC <= PC-5 se cc_N (p/ loop elimina primos)
        -- fim loop elimina primos
		23=> "110100010010000111", -- PC <= 9 se cc_UC (p/ loop elimina primos)
		-- fim loop contador
		24=> "110100110000000111", -- PC <= 24 se cc_UC (nao sai daqui)
        -- abaixo: casos omissos => (um em todos os bits)
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
