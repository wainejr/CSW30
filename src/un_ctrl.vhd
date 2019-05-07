library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_ctrl is
    port(clk : in std_logic;
		 rst : in std_logic;
		 end_mem : out unsigned(6 downto 0);
		 instr : out unsigned(17 downto 0)
		);
end entity;

architecture a_un_ctrl of un_ctrl is
	
	component prog_count
		port(clk : in std_logic;
			 rst : in std_logic;
			 wr_en : in std_logic;
			 data_in : in unsigned(6 downto 0);
			 data_out : out unsigned(6 downto 0)
    );
	end component;
	
	component rom
		port(clk : in std_logic;
			 endereco : in unsigned(6 downto 0);
			 dado : out unsigned(17 downto 0)
	);
	end component;
	
	component maq_est
	    port( clk : in std_logic;
		  rst : in std_logic;
		  estado : out std_logic
	);
	end component;
	
	signal wr_en : std_logic;
	signal data_in, data_out : unsigned(6 downto 0); -- PC
	signal opcode : unsigned(5 downto 0); -- tamanho do opcode
	signal end_rom : unsigned(6 downto 0);
	signal instr_sig : unsigned(17 downto 0);
	signal estado : std_logic;
	signal jump_abs_en, jump_rel_en : std_logic; -- jump absoluto e relativo
	
	begin
		PC : prog_count port map(clk=>clk,
							 rst=>rst,
							 wr_en=>wr_en,
							 data_in=>data_in,
							 data_out=>data_out
		);
		
		mem_rom : rom port map(	clk=>clk,
								endereco=>end_rom,
								dado=>instr_sig
		);
		mq_est : maq_est port map(	clk => clk,
									rst => rst,
									estado => estado
		);
		
		end_mem <= end_rom; -- debug
		instr <= instr_sig; -- debug
		
		end_rom <= data_out;
		opcode <= instr_sig(17 downto 12); -- opcode nos 6 MSB
		 
		
		jump_abs_en <= '1' when opcode = "111111" else
					   '0';
		
		
		data_in <= data_out+1 when jump_abs_en='0' else
				   instr_sig(6 downto 0) when jump_abs_en='1' else -- endere?o absoluto nos 7 LSB
				   "0000000"; 
		
		
		wr_en <= '1' when estado = '1' else
				 '0' when estado = '0' else
				 '0'; -- 0->fetch, 1->decode/execute
		
end architecture;