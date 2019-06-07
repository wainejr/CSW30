rm -f *.obj

ghdl -a reg16b.vhd
ghdl -a reg_bank.vhd
ghdl -a ula.vhd
ghdl -a ram.vhd
ghdl -a regbk_ula.vhd
ghdl -a regbk_ula_tb.vhd

ghdl -r regbk_ula_tb --stop-time=3000ns --wave=regbk_ula_tb.ghw

