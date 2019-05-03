library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_ctrl is
    port(clk : in std_logic;
		 rst : in std_logic;
		 end_mem : out signed(15 downto 0);
		 instr : in unsigned(17 downto 0)
		);
end entity;

architecture a_un_ctrl of un_ctrl is
	component reg16b
		port(clk : in std_logic;
			 rst : in std_logic;
			 wr_en : in std_logic;
			 data_in : in signed(15 downto 0);
			 data_out : out signed(15 downto 0)
    );
	end component;
	signal wr_en : std_logic;
	signal data_in, data_out : signed(15 downto 0); -- PC
	signal opcode : unsigned(6 downto 0); -- tamanho do opcode
	
	begin
		PC : reg16b port map(clk=>clk,
							 rst=>rst,
							 wr_en=>wr_en,
							 data_in=>data_in,
							 data_out=>data_out
		);
		
		end_mem <= data_out;
		data_in <= data_out+1;
		
		opcode <= instr(17 downto 11); -- exemplo
		
		wr_en <= '1'; -- por enquanto só 1
		
end architecture;