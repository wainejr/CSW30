library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg16b_tb is
end entity;

architecture a_reg16b_tb of reg16b_tb is
    component reg16b
        port( clk : in std_logic;
               rst : in std_logic;
               wr_en : in std_logic;
               data_in : in signed(15 downto 0);
               data_out : out signed(15 downto 0)
        );
    end component;
    signal clk,rst,wr_en: std_logic;
    signal data_in,data_out: signed (15 downto 0);
    begin
        uut: reg16b port map (clk=>clk,
                               rst=>rst,
                               wr_en=>wr_en,
                               data_in=>data_in,
                               data_out=>data_out
                               );
        process -- sinal de clock
            begin
                clk <= '0';
                wait for 50 ns;
                clk <= '1';
                wait for 50 ns;
        end process;

        process -- sinal de reset
            begin
                rst <= '1';
                wait for 100 ns;
                rst <= '0';
                wait;
        end process;
        process -- sinais dos casos de teste
            begin
                wait for 100 ns;
                wr_en <= '0';
                data_in <= "1111111111111111";
                wait for 100 ns;
                data_in <= "0000000010001101";
                wait for 100 ns;
                wr_en <= '1';
                data_in <= "0000000010001101";
                wait for 100 ns;
                data_in <= "1111111110001101";
                wait for 100 ns;
                data_in <= "1111100000001101";
                wait for 100 ns;
                wr_en <= '0';
                data_in <= "1111100000001101";
        end process;
end architecture;