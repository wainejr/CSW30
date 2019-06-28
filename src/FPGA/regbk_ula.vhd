library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regbk_ula is 
    port(
        clk : in std_logic;
        rst : in std_logic;
        wr_en : in std_logic;
        wr_en_ram: in std_logic;
        mux_wr : in unsigned(2 downto 0);
        sel_op : in unsigned(2 downto 0);
        mux_rd0 : in unsigned(2 downto 0);
        mux_rd1 : in unsigned(2 downto 0);
        data_in: in signed (15 downto 0);
        mux_const: in unsigned(1 downto 0);
        PC_in: in unsigned(6 downto 0);
        mux_PC: in std_logic;
        -- saidas ULA
        saidapin : out signed (15 downto 0);
        saida_flags : out unsigned (2 downto 0);
        -- valores em reg0 e reg1
        data_reg0 : out signed (15 downto 0);
        data_reg1 : out signed (15 downto 0);
        -- saida display
        saida_display : out unsigned(15 downto 0)
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
            data_out0 : out signed(15 downto 0);
            data_out1 : out signed(15 downto 0);
            data_write : in signed(15 downto 0)
        );
    end component;
    
    component ula is 
    port (  
            entr0,entr1  : in signed (15 downto 0);
            sel_op : in unsigned (2 downto 0);
            saida : out signed (15 downto 0);
            saida_flags : out unsigned (2 downto 0)
    );
    end component;

    component ram is
    port(
            clk : in std_logic;
            endereco : in unsigned(6 downto 0);
            wr_en : in std_logic;
            dado_in : in signed(15 downto 0);
            dado_out : out signed(15 downto 0);
            saida_display : out unsigned(15 downto 0)
    );
    end component;

    signal entr0, entr1: signed(15 downto 0);
    signal data_out0, data_out1, data_write: signed(15 downto 0);
    signal saida : signed(15 downto 0);

    signal dado_in_ram, dado_out_ram : signed(15 downto 0);
    signal end_ram_s : unsigned(6 downto 0);


    begin
        regb: reg_bank port map (clk=>clk,
                               rst=>rst,
                               wr_en=>wr_en,
                               mux_wr=>mux_wr,
                               mux_rd0=>mux_rd0,
                               mux_rd1=>mux_rd1,
                               data_write=>saida,
                               data_out0=>data_out0,
                               data_out1=>data_out1
                               );
        
        ulab: ula port map(entr0 => entr0,
                          entr1 => entr1,
                          saida => saida,
                          sel_op => sel_op,
                          saida_flags => saida_flags
                          );
        
        ramb: ram port map( clk => clk,
                            endereco => end_ram_s,
                            wr_en => wr_en_ram,
                            dado_in => data_out0,
                            dado_out => dado_out_ram,
                            saida_display => saida_display
        );

        saidapin <= saida;
        
        end_ram_s <= resize(unsigned(data_out1), 7);

        entr0 <= data_out0 when mux_PC = '0' else
                 resize(signed(PC_in), 16) when mux_PC = '1' else
                 "0000000000000000";
        entr1 <= data_out1 when mux_const = "00" else
                 data_in   when mux_const = "01" else
                 dado_out_ram when mux_const = "10" else
                 "0000000000000000";

        data_reg0 <= data_out0;
        data_reg1 <= data_out1;

end architecture;
