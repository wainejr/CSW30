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
         saida_ula_bool : out std_logic
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
            
            saidapin : out signed (15 downto 0);
            saida_bool : out std_logic;
			
			data_reg0 : out signed (15 downto 0);
			data_reg1 : out signed (15 downto 0)
        );
    end component;
	
	signal opcode : unsigned(3 downto 0);
	signal wr_en : std_logic;
	signal sel_op : unsigned(2 downto 0);
	signal mux_rd0, mux_rd1 : unsigned(2 downto 0);
	signal data_in : signed (15 downto 0);
	signal mux_const : std_logic;
	
	signal instr_s : unsigned(17 downto 0);
	begin 
		ctrl: un_ctrl port map(
						clk => clk,
						rst => rst,
						end_mem => end_mem,
						instr => instr_s,
						estado => estado,
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
						saidapin => saida_ula,
						saida_bool => saida_ula_bool,
						data_reg0 => data_reg0,
						data_reg1 => data_reg1
		);
		
		instr <= instr_s;
		
		wr_en <= '0' when opcode = "1111" else -- provisório (apenas p/ n escrever no jump)
				 '1';
		
		mux_rd0 <= instr_s(13 downto 11);
		mux_rd1 <= instr_s(10 downto 8);
		sel_op <= instr_s(2 downto 0);
		
		mux_const <= '0' when opcode = "0000" else -- instruçoes com 2 regs tem opcode 0000
					 '1';
					 
		data_in <= resize(signed(instr_s(10 downto 3)), 16);
end architecture;