rm -f *.obj

ghdl -a reg16b.vhd
ghdl -a reg_bank.vhd
ghdl -a ula.vhd
ghdl -a regbk_ula.vhd
ghdl -a maq_est.vhd
ghdl -a prog_count.vhd
ghdl -a rom.vhd
ghdl -a un_ctrl.vhd

ghdl -a uctrl_regbk.vhd