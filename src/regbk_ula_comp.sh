rm -f *.obj

ghdl -a reg16b.vhd
ghdl -a reg_bank.vhd
ghdl -a ula.vhd
ghdl -a regbk_ula.vhd
