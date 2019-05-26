rm -f *.obj

ghdl -a prog_count.vhd
ghdl -a prog_count_tb.vhd

ghdl -r prog_count_tb --stop-time=3000ns --wave=prog_count_tb.ghw
