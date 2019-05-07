rm -f *.obj

ghdl -a maq_est.vhd
ghdl -a prog_count.vhd
ghdl -a rom.vhd
ghdl -a un_ctrl.vhd
ghdl -a un_ctrl_tb.vhd
ghdl -e un_ctrl_tb

ghdl -r un_ctrl_tb --stop-time=3000ns --wave=un_ctrl_tb.ghw

