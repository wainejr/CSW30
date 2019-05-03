rm -f *.obj

ghdl -a maq_est.vhd
ghdl -a maq_est_tb.vhd

ghdl -r maq_est_tb --stop-time=3000ns --wave=maq_est_tb.ghw

