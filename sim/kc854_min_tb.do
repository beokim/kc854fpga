onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /kc854_min_tb/cpuclk
add wave -noupdate -radix hexadecimal /kc854_min_tb/cpuAddr
add wave -noupdate -radix hexadecimal /kc854_min_tb/cpuDataIn
add wave -noupdate -radix hexadecimal /kc854_min_tb/cpuDataOut
add wave -noupdate /kc854_min_tb/cpuEn
add wave -noupdate /kc854_min_tb/cpuWait
add wave -noupdate /kc854_min_tb/cpuTick
add wave -noupdate /kc854_min_tb/cpuInt_n
add wave -noupdate /kc854_min_tb/cpuM1_n
add wave -noupdate /kc854_min_tb/cpuMReq_n
add wave -noupdate /kc854_min_tb/cpuRfsh_n
add wave -noupdate /kc854_min_tb/cpuIorq_n
add wave -noupdate /kc854_min_tb/cpuRD_n
add wave -noupdate /kc854_min_tb/cpuWR_n
add wave -noupdate /kc854_min_tb/cpuRETI
add wave -noupdate /kc854_min_tb/reset_n
add wave -noupdate /kc854_min_tb/cpu/RESET_n
add wave -noupdate /kc854_min_tb/cpu/CLK_n
add wave -noupdate /kc854_min_tb/cpu/CLKEN
add wave -noupdate /kc854_min_tb/cpu/WAIT_n
add wave -noupdate /kc854_min_tb/cpu/INT_n
add wave -noupdate /kc854_min_tb/cpu/NMI_n
add wave -noupdate /kc854_min_tb/cpu/BUSRQ_n
add wave -noupdate /kc854_min_tb/cpu/M1_n
add wave -noupdate /kc854_min_tb/cpu/MREQ_n
add wave -noupdate /kc854_min_tb/cpu/IORQ_n
add wave -noupdate /kc854_min_tb/cpu/RD_n
add wave -noupdate /kc854_min_tb/cpu/WR_n
add wave -noupdate /kc854_min_tb/cpu/RFSH_n
add wave -noupdate /kc854_min_tb/cpu/HALT_n
add wave -noupdate /kc854_min_tb/cpu/BUSAK_n
add wave -noupdate -radix hexadecimal /kc854_min_tb/cpu/A
add wave -noupdate -radix hexadecimal /kc854_min_tb/cpu/DI
add wave -noupdate -radix hexadecimal /kc854_min_tb/cpu/DO
add wave -noupdate /kc854_min_tb/cpu/IntE
add wave -noupdate /kc854_min_tb/cpu/RETI_n
add wave -noupdate /kc854_min_tb/cpu/IntCycle_n
add wave -noupdate /kc854_min_tb/cpu/NoRead
add wave -noupdate /kc854_min_tb/cpu/Write
add wave -noupdate /kc854_min_tb/cpu/IORQ
add wave -noupdate /kc854_min_tb/cpu/DI_Reg
add wave -noupdate /kc854_min_tb/cpu/MCycle
add wave -noupdate /kc854_min_tb/cpu/TState
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {173737463 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 230
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {173675556 ps} {175069708 ps}
