-- UTFPR - DAELN
-- Professor Rafael E. de Góes
-- Disciplina de Arquitetura e Organização de Computadores
-- Arquivo TopLevel do Microprocessador para substituir o test_bech
-- versão 1.0 - 2018-10-15

library ieee ;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all;

ENTITY MikroP IS
PORT (   
		-- sinais que sao usados no toplevel (substituem o que vinha do testbench)
		RST   : in std_logic;  -- KEY0 R22
        CLK_H : in std_logic;  -- L1 (50 MHz)
		
		-- sinais que são a interface de teste no HW físico
		HALT_KEY : in std_logic; 	-- SW9: L2
		TURBO_EN : in std_logic; 	-- SW8: M1
		LED		: out unsigned (9 downto 4);  -- LED9..LED6
		HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- (max 99)
		HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- sempre apagados
		HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)  -- sempre apagados
	 );
END MikroP;


ARCHITECTURE LogicFunction OF MikroP IS
	
	COMPONENT disp is
	PORT ( 	
				clk : in std_logic;
				dado_in : in unsigned(15 downto 0);
				HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
				HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); --(max 99)
				HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
				HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
				rst    : in std_logic;
				clk_h  : in std_logic;
				turbo  : in std_logic;
				halt   : in std_logic;
				clk_div: out std_logic
			);
	END COMPONENT disp;
	
	component uctrl_regbk is
	    port(clk   : in std_logic;
         rst   : in std_logic;
         end_mem : out unsigned(6 downto 0);
         instr : out unsigned(17 downto 0);
         estado: out std_logic;
         data_reg0 : out signed (15 downto 0);
         data_reg1 : out signed (15 downto 0);
         saida_ula : out signed (15 downto 0);
         flags : out unsigned (2 downto 0);
         wr_en_flags : out unsigned (2 downto 0);         
         saida_display : out unsigned(15 downto 0)
    );
	end component;
    
    signal estado : std_logic;
    signal flags, wr_en_flags : unsigned (2 downto 0);
    signal end_mem : unsigned(6 downto 0);
    signal instr : unsigned(17 downto 0);
    signal data_reg0, data_reg1, saida_ula : signed(15 downto 0);
    signal saida_display : unsigned(15 downto 0);

	Signal CONT: unsigned (3 downto 0);
	signal clk_div: std_logic;  -- esse é o clock divido de maneira variável pelas teclas TURBO e HALT
	
BEGIN
	disp_top: disp
	PORT MAP (	
					clk=>clk_h,
					dado_in=> saida_display,
					
					rst    => RST,
					clk_h  => CLK_H,  
					turbo => TURBO_EN,
					halt => HALT_KEY,
					clk_div => clk_div,
					
					HEX0=>HEX0, 
					HEX1=>HEX1, 
					HEX2=>HEX2, 
					HEX3=>HEX3
				);
    ctrb : uctrl_regbk port map(
                    clk => clk_div,
                    rst => rst,
                    end_mem => end_mem,
                    instr => instr,
                    estado => estado,
                    data_reg0 => data_reg0,
                    data_reg1 => data_reg1,
                    saida_ula => saida_ula,
                    flags => flags,
                    wr_en_flags => wr_en_flags,
                    saida_display => saida_display
                    );	
-- 	Parte combincional assíncrona
	
	LED(9) <= saida_display(5);   -- LED9  pino R17 
	LED(8) <= saida_display(4);   -- LED8  pino R18
	LED(7) <= saida_display(3);	-- LED7  pino U18
	LED(6) <= saida_display(2);	-- LED6  pino Y18
	LED(5) <= saida_display(1);	-- LED6  pino ?
	LED(4) <= saida_display(0);	-- LED6  pino ?
	

END LogicFunction ;


