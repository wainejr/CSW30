rm -f *.obj

ghdl -a reg16b.vhd
ghdl -a reg16b_tb.vhd

ghdl -r reg16b_tb --stop-time=1000ns --wave=reg16b_tb.ghw
