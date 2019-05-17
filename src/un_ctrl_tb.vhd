library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_ctrl_tb is
end entity;

architecture a_un_ctrl_tb of un_ctrl_tb is
    component un_ctrl
		port(clk : in std_logic;
			 rst : in std_logic;
			 end_mem : out unsigned(6 downto 0);
			 instr : out unsigned(17 downto 0);
			 estado: out std_logic;
			 opcode : out unsigned(3 downto 0) -- tamanho do opcode
			);
    end component;

    signal clk,rst: std_logic;
    signal end_mem: unsigned (6 downto 0);
    signal instr: unsigned(17 downto 0);
	
	begin
        uctr: un_ctrl port map (clk=>clk,
                               rst=>rst,
                               end_mem=>end_mem,
                               instr=>instr
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
                wait for 75 ns;
                rst <= '0';
                wait;
        end process;
        
		process -- teste (apenas contando)
            begin
				wait for 3000 ns;
		end process;
end architecture;