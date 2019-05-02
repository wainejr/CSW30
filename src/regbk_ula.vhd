library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regbk_ula is 
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
end entity;

architecture a_regbk_ula of regbk_ula is
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
	
	component ula is 
	port (	entr0,entr1  : in signed (15 downto 0);
			sel_op : in unsigned (2 downto 0);
			saida : out signed (15 downto 0);
			saida_bool : out std_logic
	);
	end component;
	signal entr0, entr1: signed(15 downto 0);
	signal data_out0, data_out1, data_write: unsigned(15 downto 0);
	signal saida : signed(15 downto 0);
	
	begin
		regb: reg_bank port map (clk=>clk,
							   rst=>rst,
							   wr_en=>wr_en,
							   mux_wr=>mux_wr,
							   mux_rd0=>mux_rd0,
							   mux_rd1=>mux_rd1,
							   data_write=>data_write,
							   data_out0=>data_out0,
							   data_out1=>data_out1
							   );
		
		ulab: ula port map(entr0 => entr0,
						  entr1 => entr1,
						  saida => saida,
						  sel_op => sel_op,
						  saida_bool => saida_bool
						  );
						  
						  
		saidapin <= saida;					
		data_write <= unsigned(saida);
		data_out0 <= data_out0;
		data_out1 <= data_out1;	
		entr0 <= signed(data_out0);
		entr1 <= signed(data_out1) when mux_const = '0' else
				 signed(const)	   when mux_const = '1' else
				 "0000000000000000";

end architecture;
