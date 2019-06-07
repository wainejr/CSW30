library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maq_est_tb is
end entity;

architecture a_maq_est_tb of maq_est_tb is
    component maq_est
            port(clk : in std_logic;
                rst : in std_logic;
                estado : out std_logic
                );
    end component;
    signal clk, rst, estado : std_logic;
    
    begin
        uut: maq_est port map (clk=>clk,
                               rst=>rst,
                               estado=>estado
                               );
        
        process
            begin
                clk <= '0';
                wait for 50 ns;
                clk <= '1';
                wait for 50 ns;
        end process;
        
        process
            begin
                rst <= '1';
                wait for 75 ns;
                rst <= '0';
                wait;
        end process;
        
        process
            begin
                wait for 1000 ns; -- clock for 1000 ns
        end process;
        
end architecture;