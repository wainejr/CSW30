library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity prog_count_tb is
end entity;

architecture a_prog_count_tb of prog_count_tb is
    component prog_count
        port( clk : in std_logic;
               rst : in std_logic;
               wr_en : in std_logic;
               data_in : in unsigned(6 downto 0);
               data_out : out unsigned(6 downto 0)
        );
    end component;
    signal clk,rst,wr_en: std_logic;
    signal data_in,data_out: unsigned (6 downto 0);
    begin
        uut: prog_count port map (clk=>clk,
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
                data_in <= "1111111";
                wait for 100 ns;
                data_in <= "1111110";
                wait for 100 ns;
                wr_en <= '1';
                data_in <= "1111100";
                wait for 100 ns;
                data_in <= "1111000";
                wait for 100 ns;
                data_in <= "1110000";
                wait for 100 ns;
                wr_en <= '0';
                data_in <= "1100000";
        end process;
end architecture;