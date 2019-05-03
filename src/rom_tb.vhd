library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_tb is
end entity;

architecture a_rom_tb of rom_tb is
    component rom
        port(clk : in std_logic;
             endereco : in unsigned(6 downto 0);
             dado : out unsigned(17 downto 0) -- 17 pela especificação do uproc
        );
    end component;
    signal clk: std_logic;
    signal endereco : unsigned(6 downto 0);
    signal dado: unsigned(17 downto 0);
    
    begin
        romt: rom port map(clk=>clk,
                           endereco=>endereco,
                           dado=>dado
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
                wait for 100 ns;
                endereco <= "0000000"; -- 0
                wait for 100 ns;
                endereco <= "0000001"; -- 1
                wait for 100 ns;
                endereco <= "0000010"; -- 2
                wait for 100 ns;
                endereco <= "0000011"; -- 3
                wait for 100 ns;
                endereco <= "0000100"; -- 4
                wait for 100 ns;
                endereco <= "0000101"; -- 5
                wait for 100 ns;
                endereco <= "0000110"; -- 6
                wait for 100 ns;
                endereco <= "0000111"; -- 7
                wait for 100 ns;
                endereco <= "0001000"; -- 8
                wait for 100 ns;
                endereco <= "0001001"; -- 9
                wait for 100 ns;
                endereco <= "0001010"; -- 10
                wait for 100 ns;
                endereco <= "0001011"; -- 11
                wait for 100 ns;
                endereco <= "0001100"; -- 12
                wait for 100 ns;
        end process;

end architecture;