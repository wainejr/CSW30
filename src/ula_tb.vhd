library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is
end;

architecture a_ula_tb of ula_tb is
    component ula
        port (  entr0,entr1  : in signed (15 downto 0);
                sel_op : in unsigned (2 downto 0);
                saida : out signed (15 downto 0);
                saida_flags : out unsigned (2 downto 0)
        );
    end component;
    signal entr0, entr1, saida: signed(15 downto 0);
    signal sel_op : unsigned (2 downto 0);
    signal saida_flags : unsigned (2 downto 0);

begin
    uut: ula port map(entr0 => entr0,
                      entr1 => entr1,
                      saida => saida,
                      sel_op => sel_op,
                      saida_flags => saida_flags
    );
    process
    begin
        sel_op <= "000"; -- soma
        entr0 <= "0000011110000111";
        entr1 <= "0000011110000111";
        wait for 50 ns;
        sel_op <= "001"; -- subtração (zero)
        entr0 <= "0000011110000111";
        entr1 <= "0000011110000111";
        wait for 50 ns;
        sel_op <= "000"; -- soma (tem carry)
        entr0 <= "1111111000111110";
        entr1 <= "1100011110000111";
        wait for 50 ns;
        sel_op <= "000"; -- subtração (tem carry)
        entr0 <= "1111111000111110";
        entr1 <= "0100011110000111";
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