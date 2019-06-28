-- UTFPR - DAELN
-- Professor Rafael E. de Góes
-- Disciplina de Arquitetura e Organização de Computadores
-- Arquivo que implementa a RAM com diplasy de 7 segmentos mapeado no endereço 127
-- inclui o divisor de clock de 50 MHz para 10Hz e 200 Hz (turbo)
-- versão 1.0 - 2018-10-15

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------------------
entity disp is
    port(
        clk : in std_logic;        
        dado_in : in signed(15 downto 0);
        --- sinais que saem da RAM para o circuito físico
        HEX0   : out STD_LOGIC_VECTOR(6 DOWNTO 0);
        HEX1   : out STD_LOGIC_VECTOR(6 DOWNTO 0); --(max 99)
        HEX2   : out STD_LOGIC_VECTOR(6 DOWNTO 0);
        HEX3   : out STD_LOGIC_VECTOR(6 DOWNTO 0);
                        --- sinais de teste de chaves, novas funções, divisor de clock para SW08 e SW09
                        --- clock 1 = 55-> 1MHz , clock 2 (3 ciclos para escrever, aproximar 500 ms por digito: 10 Hz)
        halt   : in std_logic;
        turbo  : in std_logic;
        clk_h  : in std_logic;
        clk_div: out std_logic;
        rst    : in std_logic
    );
end entity;
------------------------------------------------------------------------
architecture a_disp of disp is
    
    COMPONENT char_7seg
    PORT (     C : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
                Display : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
            );
    END COMPONENT;
    
    SIGNAL D0: STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL D1: STD_LOGIC_VECTOR(3 DOWNTO 0); 
    SIGNAL BCD: STD_LOGIC_VECTOR(7 DOWNTO 0);
    
    SIGNAL conteudo_reg: unsigned (15 DOWNTO 0);

    type NumBCD is array (0 to 99) of STD_LOGIC_VECTOR(7 DOWNTO 0);
    constant conteudo_BCD : NumBCD := (
         0 => "00000000", 1 => "00000001", 2 => "00000010", 3 => "00000011", 4 => "00000100", 5 => "00000101",
         6 => "00000110", 7 => "00000111", 8 => "00001000", 9 => "00001001",10 => "00010000",11 => "00010001",
        12 => "00010010",13 => "00010011",14 => "00010100",15 => "00010101",16 => "00010110",17 => "00010111",
        18 => "00011000",19 => "00011001",20 => "00100000",21 => "00100001",22 => "00100010",23 => "00100011",
        24 => "00100100",25 => "00100101",26 => "00100110",27 => "00100111",28 => "00101000",29 => "00101001",
        30 => "00110000",31 => "00110001",32 => "00110010",33 => "00110011",34 => "00110100",35 => "00110101",
        36 => "00110110",37 => "00110111",38 => "00111000",39 => "00111001",40 => "01000000",41 => "01000001",
        42 => "01000010",43 => "01000011",44 => "01000100",45 => "01000101",46 => "01000110",47 => "01000111",
        48 => "01001000",49 => "01001001",50 => "01010000",51 => "01010001",52 => "01010010",53 => "01010011",
        54 => "01010100",55 => "01010101",56 => "01010110",57 => "01010111",58 => "01010100",59 => "01011001",
        60 => "01100000",61 => "01100001",62 => "01100010",63 => "01100011",64 => "01100100",65 => "01100101",
        
        66 => "01000010",67 => "01000011",68 => "01000100",69 => "01000101",70 => "01000110",71 => "01000111",
        72 => "01000010",73 => "01000011",74 => "01000100",75 => "01000101",76 => "01000110",77 => "01000111",
        78 => "01000010",79 => "01000011",80 => "01000100",81 => "01000101",82 => "01000110",83 => "01000111",
        84 => "01000010",85 => "01000011",86 => "01000100",87 => "01000101",88 => "01000110",89 => "01000111",
        90 => "01000010",91 => "01000011",92 => "01000100",93 => "01000101",94 => "01000110",95 => "01000111",
        96 => "01000010",97 => "01000011",98 => "01000100",99 => "01000101",    others => (others=>'1')
    );

    signal contador: integer range 0 to 5000000; -- conta até 5M, gera 10 Hz 
    begin
        
---------------- processo de divisão do clock (com HALT e TURBO)    
    process (clk_h, rst)
    begin 
        if rst = '0' then 
            clk_div <= '0';
            contador <= 0;
            
        elsif clk_h = '1' and clk_h'event then 
            if halt = '0' then 
                if contador >= 5000000 then 
                    clk_div <= '1';
                    contador <= 0;
                else
                    if turbo = '1' then 
                        contador <= contador + 20;
                        clk_div <= '0';
                    else
                        contador <= contador + 1;
                        clk_div <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;
    
-- DISPLAY    
    H0: char_7seg PORT MAP (C=>D0, Display=>HEX0);
    H1: char_7seg PORT MAP (C=>D1, Display=>HEX1);
    
    BCD <= conteudo_BCD (to_integer (unsigned(dado_in)));
                     
    D0 <= BCD (3 downto 0);
    D1 <= BCD (7 downto 4);
    HEX2 <= "1111111";      -- pendente de implementação
    HEX3 <= "1111111";        -- pendente de implementação

    
    
end architecture;
