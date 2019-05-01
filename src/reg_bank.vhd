library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_bank is 
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
end entity;

architecture a_reg_bank of reg_bank is
	component reg16b is
		port( clk : in std_logic;
			rst : in std_logic;
			wr_en : in std_logic;
			data_in : in unsigned(15 downto 0);
			data_out : out unsigned(15 downto 0)
		);
	end component;
	signal reg_out0, reg_out1, reg_out2, reg_out3, 
		reg_out4, reg_out5, reg_out6, reg_out7: unsigned(15 downto 0);
	signal const0: unsigned(15 downto 0);
	signal wr_en0, wr_en1, wr_en2, wr_en3, wr_en4, 
		wr_en5, wr_en6, wr_en7: std_logic; 
	begin
	reg0: reg16b port map(clk=>clk, rst=>rst, wr_en=>wr_en0, 
		data_in=>const0, data_out=>reg_out0); -- reg0 always 0
	reg1: reg16b port map(clk=>clk, rst=>rst, wr_en=>wr_en1, 
		data_in=>data_write, data_out=>reg_out1);
	reg2: reg16b port map(clk=>clk, rst=>rst, wr_en=>wr_en2, 
		data_in=>data_write, data_out=>reg_out2);
	reg3: reg16b port map(clk=>clk, rst=>rst, wr_en=>wr_en3, 
		data_in=>data_write, data_out=>reg_out3);
	reg4: reg16b port map(clk=>clk, rst=>rst, wr_en=>wr_en4, 
		data_in=>data_write, data_out=>reg_out4);
	reg5: reg16b port map(clk=>clk, rst=>rst, wr_en=>wr_en5, 
		data_in=>data_write, data_out=>reg_out5);
	reg6: reg16b port map(clk=>clk, rst=>rst, wr_en=>wr_en6, 
		data_in=>data_write, data_out=>reg_out6);
	reg7: reg16b port map(clk=>clk, rst=>rst, wr_en=>wr_en7, 
		data_in=>data_write, data_out=>reg_out7);
	
	wr_en0 <= '1';
	const0 <= "0000000000000000";
	
	wr_en1 <= '1' when wr_en='1' and mux_wr = "001" else
			  '0';
	wr_en2 <= '1' when wr_en='1' and mux_wr = "010" else
			  '0';
	wr_en3 <= '1' when wr_en='1' and mux_wr = "011" else
			  '0';
	wr_en4 <= '1' when wr_en='1' and mux_wr = "100" else
			  '0';
	wr_en5 <= '1' when wr_en='1' and mux_wr = "101" else
			  '0';
	wr_en6 <= '1' when wr_en='1' and mux_wr = "110" else
			  '0';
	wr_en7 <= '1' when wr_en='1' and mux_wr = "111" else
			  '0';  
	
	data_out0 <= reg_out0 when mux_rd0 = "000" else
				 reg_out1 when mux_rd0 = "001" else
				 reg_out2 when mux_rd0 = "010" else
				 reg_out3 when mux_rd0 = "011" else
				 reg_out4 when mux_rd0 = "100" else
				 reg_out5 when mux_rd0 = "101" else
				 reg_out6 when mux_rd0 = "110" else
				 reg_out7 when mux_rd0 = "111" else
				 "1111111111111111";
	
	data_out1 <= reg_out0 when mux_rd1 = "000" else
				 reg_out1 when mux_rd1 = "001" else
				 reg_out2 when mux_rd1 = "010" else
				 reg_out3 when mux_rd1 = "011" else
				 reg_out4 when mux_rd1 = "100" else
				 reg_out5 when mux_rd1 = "101" else
				 reg_out6 when mux_rd1 = "110" else
				 reg_out7 when mux_rd1 = "111" else
				 "1111111111111111";
end architecture;