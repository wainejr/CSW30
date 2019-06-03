library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regbk_ula_tb is 
end entity;

architecture a_regbk_ula_tb of regbk_ula_tb is
    component regbk_ula is 
        port(
            clk : in std_logic;
            rst : in std_logic;
            wr_en : in std_logic;
            mux_wr : in unsigned(2 downto 0);
            sel_op : in unsigned(2 downto 0);
            mux_rd0 : in unsigned(2 downto 0);
            mux_rd1 : in unsigned(2 downto 0);
            PC_in: in unsigned(6 downto 0);
            mux_PC: in std_logic;
            data_in: in signed (15 downto 0);
            mux_const: in std_logic;
            -- saidas ULA
            saidapin : out signed (15 downto 0);
            saida_flags : out unsigned (2 downto 0);
            -- valores em reg0 e reg1
            data_reg0 : out signed (15 downto 0);
            data_reg1 : out signed (15 downto 0)
        );
    end component;
    
    signal clk, rst, wr_en: std_logic;
    signal mux_wr, mux_rd0, mux_rd1, sel_op, saida_flags: unsigned(2 downto 0);
    signal data_in: signed(15 downto 0);
    signal saidapin: signed(15 downto 0);
    signal PC_in: unsigned(6 downto 0);
    signal mux_const, mux_PC : std_logic;
    
    begin
        uut: regbk_ula port map (clk=>clk,
                                rst=>rst,
                                wr_en=>wr_en,
                                mux_wr=>mux_wr,
                                sel_op=>sel_op,
                                mux_rd0=>mux_rd0,
                                mux_rd1=>mux_rd1,
                                PC_in=>PC_in,
                                mux_PC=>mux_PC,
                                data_in=>data_in,
                                mux_const=>mux_const,
                                saidapin=>saidapin,
                                saida_flags=>saida_flags
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
                wait for 100 ns; -- em reset ainda
                wr_en <= '0';
                mux_wr <= "000";
                sel_op <= "000";
                mux_rd0 <= "000";
                mux_rd1 <= "000";
                data_in <= "0000000000000000";
                PC_in <= "0000000";
                mux_const <= '0';
                mux_PC <= '0';
                
                wait for 100 ns; -- soma 1 com reg0 e coloca em reg1 (1)
                wr_en <= '1';
                mux_wr <= "001";
                sel_op <= "000";
                mux_rd0 <= "000";
                mux_rd1 <= "010";
                data_in <= "0000000000000001";
                PC_in <= "0000000";
                mux_const <= '1';
                mux_PC <= '0';

                wait for 100 ns; -- soma 4 com reg0 e coloca em reg2 (4)
                wr_en <= '1';
                mux_wr <= "010";
                sel_op <= "000";
                mux_rd0 <= "000";
                mux_rd1 <= "000";
                data_in <= "0000000000000100";
                PC_in <= "0000000";
                mux_const <= '1';
                mux_PC <= '0';
                
                wait for 100 ns; -- soma reg1 e reg2 e coloca em reg3 (5)
                wr_en <= '1';
                mux_wr <= "011";
                sel_op <= "000";
                mux_rd0 <= "010";
                mux_rd1 <= "001";
                data_in <= "0000000000000010";
                PC_in <= "0000000";
                mux_const <= '0';
                mux_PC <= '0';
                
                wait for 100 ns; -- soma reg3 e reg2 e coloca em reg3 (9)
                wr_en <= '1';
                mux_wr <= "011";
                sel_op <= "000";
                mux_rd0 <= "010";
                mux_rd1 <= "011";
                data_in <= "0000000000000010";
                PC_in <= "0000000";
                mux_const <= '0';
                mux_PC <= '0';
                
                wait for 100 ns; -- soma 19 (PC) com reg3 (9) e coloca em reg4
                wr_en <= '1';
                mux_wr <= "100";
                sel_op <= "000";
                mux_rd0 <= "000";
                mux_rd1 <= "011";
                data_in <= "0000000000000000";
                PC_in <= "0010011";
                mux_const <= '0';
                mux_PC <= '1';
                
                wait for 100 ns; -- soma 65 (PC) com -10 (data) e coloca em reg5
                wr_en <= '1';
                mux_wr <= "101";
                sel_op <= "000";
                mux_rd0 <= "000";
                mux_rd1 <= "000";
                data_in <= "1111111111110110";
                PC_in <= "1000001";
                mux_const <= '1';
                mux_PC <= '1';

                wait for 100 ns; -- soma 105 (PC) com 20 (data) e coloca em reg6
                wr_en <= '1';
                mux_wr <= "110";
                sel_op <= "000";
                mux_rd0 <= "000";
                mux_rd1 <= "000";
                data_in <= "0000000000010100";
                PC_in <= "1101001";
                mux_const <= '1';
                mux_PC <= '1';

        end process;
end architecture;


