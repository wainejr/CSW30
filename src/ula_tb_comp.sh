rm -f *.obj

ghdl -a ula.vhd
ghdl -a ula_tb.vhd

ghdl -r ula_tb --wave=ula_tb.ghw

