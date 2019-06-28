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
        -- R2: cte
        -- R3: acumulador
        -- R4: endereço de memória a gravar / ler
        -- R5: reg que mostra valor dos primos
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
        22=> "010111110110000000", -- PC <= PC-5 se cc_UC (p/ loop elimina primos)
        -- fim loop elimina primos
        23=> "110100010010000111", -- PC <= 9 se cc_UC (p/ loop elimina primos)
        -- fim loop contador
        24=> "000001000000000111", -- R2 <= 0
        25=> "000100100000001111", -- R1 <= 1
        26=> "000110000100000111", -- R4 <= 32
        -- loop grava primos
        27=> "000100100000001000", -- R1 <= R1+1
        28=> "000011100100000111", -- R7 <= R1
        29=> "000111100100000001", -- R7 <= R7-32
        30=> "110101001000001111", -- PC < 36 (fim loop grava primos) se cc_Z
        31=> "001001000100000111", -- R2 <= [R1]
        32=> "110100110110001111", -- PC <= loop grava primos se cc_Z
        33=> "001100110000000100", -- [R4] <= R1
        34=> "000110000000001000", -- R4 <= R4+1
        35=> "110100110110000111", -- PC <= 27 (loop grava primos) se cc_UC
        -- fim loop grava primos
        36=> "000111111111111111", -- R7 <= -1
        37=> "001111110000000100", -- [R4] <= R7
        38=> "000110101111111111", -- R5 <= 63
        --39=> "000110101111111000", -- R5 <= R5+63
        --40=> "000110100000001000", -- R5 <= R5+1
        -- loop infinito primos
        41=> "000110000100000111", -- R4 <= 32
        -- loop percorre primos
        42=> "001011110000000111", -- R7 <= [R4]
        43=> "110101010010011111", -- PC <= 41 (loop infinito primos) se cc_N
        44=> "001111110100000100", -- [R5] <= R7
        45=> "000110000000001000", -- R4 <= R4+1
        46=> "110101010100000111", -- PC <= 42 (loop percorre primos) se cc_UC
        47=> "010100000000000000", -- PC <= PC se cc_UC (não sai daqui)
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
