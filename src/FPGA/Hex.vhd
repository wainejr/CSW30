-- UTFPR - DAELN
-- Professor Rafael E. de Góes
-- Disciplina de Arquitetura e Organização de Computadores
-- Arquivo que encapsula a coversão de um digito em 7 segmentos
-- versão 1.0 - 2018-10-15

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY char_7seg IS
PORT ( 
	C : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	Display : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END char_7seg;

ARCHITECTURE Behavior OF char_7seg IS
BEGIN
-- considerando"gfedcba", 1 apaga
	DISPLAY <= 	"1000000" when C="0000" else 
					"1111001" when C="0001" else
					"0100100" when C="0010" else
					"0110000" when C="0011" else
					"0011001" when C="0100" else
					"0010010" when C="0101" else
					"0000010" when C="0110" else
					"1111000" when C="0111" else
					"0000000" when C="1000" else
					"0010000" when C="1001" else
				   "1111111";							--- tudo apagado
END Behavior;
