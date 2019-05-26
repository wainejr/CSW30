library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uctrl_regbk is
	port(clk : in std_logic;
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
         saida_ula_bool : out std_logic;
		 -- variáveis de resultado
		 has_carry : out std_logic; -- resultado da ULA teve carry?
		 last_bool : out std_logic -- ultimo resultado 'valido' da saida booleana
	);
end entity;

architecture a_uctrl_regbk of uctrl_regbk is
    component un_ctrl
		port(clk : in std_logic;
			 rst : in std_logic;
			 end_mem : out unsigned(6 downto 0);
			 instr : out unsigned(17 downto 0);
			 estado: out std_logic;
			 opcode : out unsigned(3 downto 0) -- tamanho do opcode
			);
    end component;
	
	component regbk_ula is 
        port(
            clk : in std_logic;
            rst : in std_logic;
            wr_en : in std_logic;
            mux_wr : in unsigned(2 downto 0);
            sel_op : in unsigned(2 downto 0);
            mux_rd0 : in unsigned(2 downto 0);
            mux_rd1 : in unsigned(2 downto 0);
            data_in: in signed (15 downto 0);
            mux_const: in std_logic;
            PC_in: in unsigned(6 downto 0);
            mux_PC: in std_logic;
            -- saidas ULA
            saidapin : out signed (15 downto 0);
            saida_bool : out std_logic;
            -- valores em reg0 e reg1
            data_reg0 : out signed (15 downto 0);
            data_reg1 : out signed (15 downto 0)
        );
    end component;
	
	signal opcode : unsigned(3 downto 0);
	signal wr_en : std_logic;
	signal sel_op : unsigned(2 downto 0);
	signal mux_rd0, mux_rd1 : unsigned(2 downto 0);
    signal data_in : signed (15 downto 0);
    signal mux_const, mux_PC : std_logic;
     
    signal end_mem_s : unsigned(6 downto 0);
	signal instr_s : unsigned(17 downto 0);
    signal estado_s : std_logic;
    
    signal saida_ula_s : signed (15 downto 0);
    signal saida_bool_s : std_logic;

	begin 
		ctrl: un_ctrl port map(
						clk => clk,
						rst => rst,
						end_mem => end_mem_s,
						instr => instr_s,
						estado => estado_s,
						opcode => opcode
		);
		
		rg_ula: regbk_ula port map(
						clk => clk,
						rst => rst,
						wr_en => wr_en,
						mux_wr => mux_rd0, -- mux_wr é o mux_rd0
						sel_op => sel_op,
						mux_rd0 => mux_rd0, 
						mux_rd1 => mux_rd1,
						data_in => data_in,
                        mux_const => mux_const,
                        PC_in => end_mem_s,
                        mux_PC => mux_PC,
						saidapin => saida_ula_s,
						saida_bool => saida_bool_s,
						data_reg0 => data_reg0,
						data_reg1 => data_reg1
        );

        end_mem <= end_mem_s;
        instr <= instr_s;
        estado <= estado_s;
        
        saida_ula <= saida_ula_s;
        saida_ula_bool <= saida_bool_s;
		
		wr_en <= '0' when estado_s = '0' else -- não escreve no estado 0
				 '1' when opcode = "0000" else -- provisório (escreve apenas nas operações de 2 reg)
				 '0';

		mux_rd0 <= instr_s(13 downto 11);
		mux_rd1 <= instr_s(10 downto 8);
		sel_op <= instr_s(2 downto 0);
		
		mux_const <= '0' when opcode = "0000" else -- instruçoes com 2 regs tem opcode 0000
                     '1';
        mux_PC <= '0'; -- temporario, atualizar dps de definir os OPCODES
        
        data_in <= resize(signed(instr_s(10 downto 3)), 16); -- constante em [10-3]

        has_carry <= saida_ula when (sel_op = "000" or
                        sel_op = "001" or sel_op = "101" or
                        sel_op = "110") and opcode = "0000" else
                    '0' when rst ='1' else 
                    has_carry;
        last_bool <= saida_ula when (sel_op = "010" or sel_op = "011"
                            or sel_op = "100") and 
                            opcode = "0000" else -- temporário, adicionar opcodes ao defini-los
                        '0' when rst = '1' else
                        last_bool;

        );
end architecture;