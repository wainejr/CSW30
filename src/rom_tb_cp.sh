rm -f *.obj

ghdl -a rom.vhd
ghdl -a rom_tb.vhd

ghdl -r rom_tb --stop-time=3000ns --wave=ula_tb.ghw

