rm -f *.obj

ghdl -a reg16b.vhd
ghdl -a reg_bank.vhd
ghdl -a reg_bank_tb.vhd

ghdl -r reg_bank_tb --stop-time=1000ns --wave=reg_bank_tb.ghw