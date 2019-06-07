library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maq_est is
    port( clk : in std_logic;
          rst : in std_logic;
          estado : out std_logic
    );
end entity;

architecture a_maq_est of maq_est is   
    signal est_atual : std_logic;
    begin
        process(clk,rst) -- acionado se houver mudança em clk ou rst
        begin
            if rst='1' then
                est_atual <= '0';
            elsif rising_edge(clk) then
                est_atual <= not est_atual;
            end if;
        end process;
        
        estado <= est_atual;
end architecture;
