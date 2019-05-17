library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador_tb is
end entity;

architecture a_processador_tb of processador_tb is
	component uctrl_regbk is
		port(
			 clk : in std_logic;
			 rst : in std_logic;
			 -- sinais unidade de controle (ROM, PC e estado)
			 end_mem : out unsigned(6 downto 0);
			 instr : out unsigned(17 downto 0);
			 estado: out std_logic;
			 -- sinais banco de registradores
			 data_reg0 : out signed (15 downto 0);
			 data_reg1 : out signed (15 downto 0);
			 -- saidas ULA
			 saida_ula : out signed (15 downto 0);
			 saida_ula_bool : out std_logic
		);
	end component;
	
	signal clk, rst, estado, saida_ula_bool : std_logic;
	signal end_mem : unsigned(6 downto 0);
	signal instr : unsigned(17 downto 0);
	signal data_reg0, data_reg1, saida_ula : signed(15 downto 0);
	
	begin
		ctrb : uctrl_regbk port map(
							clk => clk,
							rst => rst,
							end_mem => end_mem,
							instr => instr,
							estado => estado,
							data_reg0 => data_reg0,
							data_reg1 => data_reg1,
							saida_ula => saida_ula,
							saida_ula_bool => saida_ula_bool
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
        
        
end architecture;