library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regbk_ula_tb is 
end entity;

architecture a_regbk_ula_tb of regbk_ula_tb is
	component regbk_ula is 
		port(
			clk : in std_logic;
			rst : in std_logic;
			wr_en : in std_logic;
			mux_wr : in unsigned(2 downto 0);
			sel_op : in unsigned(2 downto 0);
			mux_rd0 : in unsigned(2 downto 0);
			mux_rd1 : in unsigned(2 downto 0);
			data_write : in unsigned(15 downto 0);
			
			saida : out signed(15 downto 0);
			saida_bool : out std_logic
		);
	end component;
	
	signal clk, rst, wr_en, saida_bool: std_logic;
	signal mux_wr, mux_rd0, mux_rd1, sel_op: unsigned(2 downto 0);
	signal data_write: unsigned(15 downto 0);
	signal saida: signed(15 downto 0);
	
	begin
		uut: regbk_ula port map (clk=>clk,
								rst=>rst,
								wr_en=>wr_en,
								mux_wr=>mux_wr,
								sel_op=>sel_op,
								mux_rd0=>mux_rd0,
								mux_rd1=>mux_rd1,
								data_write=>data_write,
								saida=>saida,
								saida_bool=>saida_bool
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
				mux_wr <= "000";
				sel_op <= "000";
				mux_rd0 <= "000";
				mux_rd1 <= "000";
				data_write <= "0000000000000000";
				wait for 100 ns;
		end process;
end architecture;


