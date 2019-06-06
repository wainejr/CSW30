library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_ctrl is
    port(clk : in std_logic;
         rst : in std_logic;
         wr_end_mem : in std_logic; -- escrever endereço absoluto de memória
         end_mem_in : in unsigned(6 downto 0);

         end_mem : out unsigned(6 downto 0);
		 instr : out unsigned(17 downto 0);
		 estado: out std_logic;
		 opcode : out unsigned(3 downto 0) -- tamanho do opcode
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
	signal end_mem_s : unsigned(6 downto 0);
	signal instr_s : unsigned(17 downto 0);
	signal opcode_s : unsigned(3 downto 0); -- tamanho do opcode
	signal estado_s : std_logic;
	signal jump_abs_en, jump_rel_en : std_logic; -- jump absoluto e relativo
	
	begin
		PC : prog_count port map(clk=>clk,
							 rst=>rst,
							 wr_en=>wr_en,
							 data_in=>data_in,
							 data_out=>data_out
		);
		
		mem_rom : rom port map(	clk=>clk,
								endereco=>end_mem_s,
								dado=>instr_s
		);
		mq_est : maq_est port map(	clk => clk,
									rst => rst,
									estado => estado_s
		);
		
		end_mem <= end_mem_s;
		instr <= instr_s;
		estado <= estado_s;
		opcode <= opcode_s;

        end_mem_s <= data_out;
		opcode_s <= instr_s(17 downto 14); -- opcode nos 4 MSB
		
		jump_abs_en <= '1' when opcode_s = "1111" else
					   '0';
		
        data_in <= data_out+1 when wr_end_mem = '0' else
                   end_mem_in; 
		
        wr_en <= '1' when estado_s = '1' else
				 '0' when estado_s = '0' else
                 '0'; -- 0->fetch, 1->decode/execute

end architecture;