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
         flags : out unsigned (2 downto 0);
         wr_en_flags : out unsigned (2 downto 0)
    );
end entity;

architecture a_uctrl_regbk of uctrl_regbk is
    component un_ctrl
        port(clk : in std_logic;
             rst : in std_logic;
             wr_end_mem : in std_logic;
             end_mem_in : in unsigned(6 downto 0);
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
            saida_flags : out unsigned (2 downto 0);
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
     
    
    signal wr_end_mem_s : std_logic;
    signal end_mem_in_s : unsigned(6 downto 0);
    signal end_mem_s : unsigned(6 downto 0);
    signal instr_s : unsigned(17 downto 0);
    signal estado_s : std_logic;
    
    signal saida_ula_s : signed (15 downto 0);
    signal saida_flags_s : unsigned(2 downto 0);
    signal flags_s : unsigned(2 downto 0);
    signal wr_en_flags_s : unsigned(2 downto 0);
    signal rst_wr_en : std_logic; -- reset write enable das flags (p n dar bug)

    signal end_mem_wr : unsigned(6 downto 0);
    
    -- aux
    signal branch : std_logic;
    signal Z, N, C :  std_logic;
    signal cc : unsigned(3 downto 0);

    begin 
        ctrl: un_ctrl port map(
                        clk => clk,
                        rst => rst,
                        wr_end_mem => wr_end_mem_s,
                        end_mem_in => end_mem_in_s,
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
                        saida_flags => saida_flags_s,
                        data_reg0 => data_reg0,
                        data_reg1 => data_reg1
        );

        end_mem <= end_mem_s;
        instr <= instr_s;
        estado <= estado_s;
        saida_ula <= saida_ula_s;
        flags <= flags_s;
        wr_en_flags <= wr_en_flags_s;

        -- banco de registradores/ula
        wr_en <= '0' when estado_s = '0' else -- não escreve no estado 0
                 '1' when opcode = "0000" or opcode = "0001" else
                 '0';

        mux_rd0 <= instr_s(13 downto 11);
        mux_rd1 <= instr_s(10 downto 8);
        sel_op <= instr_s(2 downto 0);

        -- entrada de constante na ULA
        mux_const <= '1' when opcode = "0001" or opcode = "0101" or opcode = "1101"
                    else '0';
        data_in <=  resize(signed(instr_s(10 downto 3)), 16) 
                        when opcode = "0001" else
                    resize(signed(instr_s(13 downto 7)), 16) 
                        when opcode = "0101" or opcode = "1101"
                    else "0000000000000000"; 
        
        -- entrada do PC na ULA
        mux_PC <=   '1' when opcode = "0100" or opcode = "0101"
                    else '0';
        
        -- flags
        --process(estado_s, rst, clk)
        --begin
        --if rst='1' then
        --    rst_wr_en <= '1';
        -- wr_en das flags desativado assincronamente e seu rst só é desativado para estado_s=1
        --elsif falling_edge(clk) then
        --    rst_wr_en <= '1';
        --elsif rising_edge(estado_s) then 
        --    rst_wr_en <= '0';
        --end if;
        --end process;
        
        wr_en_flags_s(0) <= '0' when wr_en='1' else
                            '1' when opcode = "0000" or opcode = "0001" else
                            '0';
        wr_en_flags_s(1) <= '0' when wr_en='1' else
                            '1' when opcode = "0000" or opcode = "0001" else
                            '0';
        wr_en_flags_s(2) <= '0' when wr_en='1' else
                            '1' when opcode = "0000" or opcode = "0001" else
                            '0';
        flags_s(0) <= '0' when rst='1' else
                saida_flags_s(0) when wr_en_flags_s(0) = '1' else
                flags_s(0);  
        flags_s(1) <= '0' when rst='1' else
                saida_flags_s(1) when wr_en_flags_s(1) = '1' else
                flags_s(1);
        flags_s(2) <= '0' when rst='1' else
                saida_flags_s(2) when wr_en_flags_s(2) = '1' else
                flags_s(2);

        -- branches
        cc <= instr_s(6 downto 3);
        Z <= flags_s(0);
        N <= flags_s(1);
        C <= flags_s(2);
        branch <= '1' when cc="0000" -- cc_UC
                        or (cc="0001" and Z='1') --cc_Z
                        or (cc="0010" and Z='0') --cc_NZ
                        or (cc="0011" and N='1') --cc_N
                        or (cc="0100" and N='0') --cc_NN
                        or (cc="0101" and C='1') --cc_C
                        or (cc="0110" and C='0') --cc_NC
                        or (cc="0111" and Z='1') --cc_E
                        or (cc="1000" and Z='0') --cc_NE
                        or (cc="1001" and C='1') --cc_ULT
                        or (cc="1010" and (C='1' or Z='1')) --cc_ULE
                        or (cc="1011" and C='0') --cc_UGE
                        or (cc="1100" and (C='0' or Z='0')) --cc_UGT
                    else '0';
        wr_end_mem_s <= branch when
                            (opcode="1101" or opcode="1100" 
                            or opcode="0101" or opcode="0100") else
                        '0';
        end_mem_in_s <= resize(unsigned(saida_ula_s), 7);

end architecture;