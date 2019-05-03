rm -f *.obj

ghdl -a reg16b.vhd
ghdl -a reg_bank.vhd
ghdl -a ula.vhd
ghdl -a regbk_ula.vhd
ghdl -a regbk_ula_tb.vhd

ghdl -r regbk_ula_tb --stop-time=1000ns --wave=regbk_ula_tb.ghw

