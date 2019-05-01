library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_bank_tb is
end entity;

architecture a_reg_bank_tb of reg_bank_tb is
	component reg_bank is
		port(
			clk : in std_logic;
			rst : in std_logic;
			wr_en : in std_logic;
			mux_wr : in unsigned(2 downto 0);
			mux_rd0 : in unsigned(2 downto 0);
			mux_rd1 : in unsigned(2 downto 0);
			data_out0 : out unsigned(15 downto 0);
			data_out1 : out unsigned(15 downto 0);
			data_write : in unsigned(15 downto 0)
		);
	end component;
	
	signal clk, rst, wr_en: std_logic;
	signal mux_wr, mux_rd0, mux_rd1: unsigned(2 downto 0);
	signal data_write, data_out0, data_out1: unsigned(15 downto 0);
	
	begin
		uut: reg_bank port map (clk=>clk,
							   rst=>rst,
							   wr_en=>wr_en,
							   mux_wr=>mux_wr,
							   mux_rd0=>mux_rd0,
							   mux_rd1=>mux_rd1,
							   data_write=>data_write,
							   data_out0=>data_out0,
							   data_out1=>data_out1
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
		
		process -- sinais dos casos de teste
			begin
				wait for 100 ns; -- teste wr_en
				wr_en <= '0';
				mux_wr <= "001";
				mux_rd0 <= "001";
				mux_rd1 <= "001";
				data_write <= "1111111111111111";
				
				wait for 100 ns; -- tenta escrever em reg0
				wr_en <= '1';
				mux_wr <= "000";
				mux_rd0 <= "000";
				mux_rd1 <= "000";
				data_write <= "0111111111111111";
				
				wait for 100 ns; -- wr: reg1, rd0: reg1, rd1: reg0
				wr_en <= '1';
				mux_wr <= "001";
				mux_rd0 <= "001";
				mux_rd1 <= "000";
				data_write <= "0011111111111111";
				
				wait for 100 ns; -- wr: reg2, rd0: reg1, rd1: reg2
				wr_en <= '1';
				mux_wr <= "010";
				mux_rd0 <= "001";
				mux_rd1 <= "010";
				data_write <= "0001111111111111";
				
				wait for 100 ns; -- wr: reg7, rd0: reg6, rd1: reg7
				wr_en <= '1';
				mux_wr <= "111";
				mux_rd0 <= "110";
				mux_rd1 <= "111";
				data_write <= "0000111111111111";
				
				wait for 100 ns; -- wr: reg7, rd0: reg6, rd1: reg7
				wr_en <= '1';
				mux_wr <= "110";
				mux_rd0 <= "110";
				mux_rd1 <= "111";
				data_write <= "0000011111111111";
				
		end process;
end architecture;