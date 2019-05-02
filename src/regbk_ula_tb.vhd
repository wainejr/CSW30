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
			const: in unsigned (15 downto 0);
			mux_const: in std_logic;
			
			saidapin : out signed (15 downto 0);
			saida_bool : out std_logic
		);
	end component;
	
	signal clk, rst, wr_en, saida_bool: std_logic;
	signal mux_wr, mux_rd0, mux_rd1, sel_op: unsigned(2 downto 0);
	signal const: unsigned(15 downto 0);
	signal saidapin: signed(15 downto 0);
	signal mux_const : std_logic;
	
	begin
		uut: regbk_ula port map (clk=>clk,
								rst=>rst,
								wr_en=>wr_en,
								mux_wr=>mux_wr,
								sel_op=>sel_op,
								mux_rd0=>mux_rd0,
								mux_rd1=>mux_rd1,
								const=>const,
								mux_const=>mux_const,
								saidapin=>saidapin,
								saida_bool=>saida_bool
							   );
							   
		process -- sinal de clock
			begin
				clk <= '0';
				wait for 100 ns;
				clk <= '1';
				wait for 100 ns;
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
				wait for 50 ns; --em reset ainda
				wr_en <= '0';
				mux_wr <= "000";
				sel_op <= "000";
				mux_rd0 <= "000";
				mux_rd1 <= "000";
				const <= "0000000000000000";
				mux_const <= '0';
				
				wait for 100 ns; -- carrega um na entrada 01 da ula
				wr_en <= '0';
				mux_wr <= "000";
				sel_op <= "000";
				mux_rd0 <= "000";
				mux_rd1 <= "010";
				const <= "0000000000000001";
				mux_const <= '1';
				
				wait for 100 ns; -- carrega 0 na entrada 00 da ula
				wr_en <= '1';
				mux_wr <= "000";
				sel_op <= "000";
				mux_rd0 <= "000";
				mux_rd1 <= "001";
				const <= "0000000000000100";
				mux_const <= '1';
				
				wait for 100 ns; -- sem escrever nada
				wr_en <= '0';
				mux_wr <= "000";
				sel_op <= "000";
				mux_rd0 <= "000";
				mux_rd1 <= "000";
				const <= "0000000000000010";
				mux_const <= '0';
				
		end process;
end architecture;


