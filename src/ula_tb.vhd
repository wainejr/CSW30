library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is
end;

architecture ula_tb of ula_tb is
	component ula
		port (	entr0,entr1  : in signed (15 downto 0);
				sel_op : in unsigned (2 downto 0);
				saida : out signed (15 downto 0);
				saida_bool : out std_logic
		);
	end component;
	signal entr0, entr1, saida: signed(15 downto 0);
	signal sel_op : unsigned (2 downto 0);
	signal saida_bool : std_logic;

begin
	uut: ula port map(entr0 => entr0,
					  entr1 => entr1,
					  saida => saida,
					  sel_op => sel_op,
					  saida_bool => saida_bool
	);
	process
	begin
		sel_op <= "000"; --soma
		entr0 <= "0000011110000111";
		entr1 <= "0000011110000111";
		wait for 50 ns;
		sel_op <= "001"; --subtração
		entr0 <= "0000011110000111";
		entr1 <= "0000011110000111";
		wait for 50 ns;
		sel_op <= "010"; --maior=true
		entr0 <= "0000011110001111";
		entr1 <= "0000011110000111";
		wait for 50 ns;
		sel_op <= "010"; --maior=false
		entr0 <= "0000011110000111";
		entr1 <= "0000011110010111";
		wait for 50 ns;
		sel_op <= "011"; --igual=true
		entr0 <= "0000011110000111";
		entr1 <= "0000011110000111";
		wait for 50 ns;
		sel_op <= "011"; --igual=false
		entr0 <= "0000011110000111";
		entr1 <= "0000011110010111";
		wait for 50 ns;
		sel_op <= "100"; --maior/igual=true
		entr0 <= "0000011110000111";
		entr1 <= "0000011110000111";
		wait for 50 ns;
		sel_op <= "100"; --maior/igual==false
		entr0 <= "0000011110000111";
		entr1 <= "0000011111000111";
		wait for 50 ns;
		sel_op <= "101"; --shLeft
		entr0 <= "0000011110000111";
		wait for 50 ns;
		sel_op <= "110"; --shRight
		entr0 <= "0000011110000111";
		wait for 50 ns;
		wait;
	end process;
end architecture;