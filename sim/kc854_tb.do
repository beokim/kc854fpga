onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /kc854_tb/kc854/CLOCK_50
add wave -noupdate /kc854_tb/kc854/CLOCK_24
add wave -noupdate /kc854_tb/kc854/cpuclk
add wave -noupdate /kc854_tb/kc854/vgaclk
add wave -noupdate /kc854_tb/kc854/VGA_R
add wave -noupdate /kc854_tb/kc854/VGA_G
add wave -noupdate /kc854_tb/kc854/VGA_B
add wave -noupdate /kc854_tb/kc854/VGA_HS
add wave -noupdate /kc854_tb/kc854/VGA_VS
add wave -noupdate -radix hexadecimal /kc854_tb/kc854/SRAM_ADDR
add wave -noupdate /kc854_tb/kc854/SRAM_DQ
add wave -noupdate /kc854_tb/kc854/SRAM_OE_N
add wave -noupdate /kc854_tb/kc854/SRAM_CE_N
add wave -noupdate /kc854_tb/kc854/SRAM_WE_N
add wave -noupdate /kc854_tb/kc854/SRAM_LB_N
add wave -noupdate /kc854_tb/kc854/SRAM_UB_N
add wave -noupdate /kc854_tb/kc854/PS2_CLK
add wave -noupdate /kc854_tb/kc854/PS2_DAT
add wave -noupdate /kc854_tb/kc854/UART_TXD
add wave -noupdate /kc854_tb/kc854/UART_RXD
add wave -noupdate /kc854_tb/kc854/KEY
add wave -noupdate /kc854_tb/kc854/SW
add wave -noupdate /kc854_tb/kc854/LEDR
add wave -noupdate /kc854_tb/kc854/LEDG
add wave -noupdate /kc854_tb/kc854/HEX0
add wave -noupdate /kc854_tb/kc854/HEX1
add wave -noupdate /kc854_tb/kc854/HEX2
add wave -noupdate /kc854_tb/kc854/HEX3
add wave -noupdate /kc854_tb/kc854/GPIO_1
add wave -noupdate /kc854_tb/kc854/reset_n
add wave -noupdate /kc854_tb/kc854/sramOE_n
add wave -noupdate -radix hexadecimal /kc854_tb/kc854/sramDataOut
add wave -noupdate -radix hexadecimal /kc854_tb/kc854/sramDataIn
add wave -noupdate -radix hexadecimal /kc854_tb/kc854/cpuAddr
add wave -noupdate -radix hexadecimal /kc854_tb/kc854/cpuDataIn
add wave -noupdate -radix hexadecimal /kc854_tb/kc854/cpuDataOut
add wave -noupdate /kc854_tb/kc854/cpuEn
add wave -noupdate /kc854_tb/kc854/cpuWait
add wave -noupdate /kc854_tb/kc854/cpuInt_n
add wave -noupdate /kc854_tb/kc854/cpuM1_n
add wave -noupdate /kc854_tb/kc854/cpuMReq_n
add wave -noupdate /kc854_tb/kc854/cpuRfsh_n
add wave -noupdate /kc854_tb/kc854/cpuIorq_n
add wave -noupdate /kc854_tb/kc854/cpuRD_n
add wave -noupdate /kc854_tb/kc854/cpuWR_n
add wave -noupdate -radix hexadecimal /kc854_tb/kc854/vidAddr
add wave -noupdate -radix hexadecimal /kc854_tb/kc854/vidData
add wave -noupdate /kc854_tb/kc854/vidBusy
add wave -noupdate /kc854_tb/kc854/vidRead
add wave -noupdate /kc854_tb/kc854/vidHires
add wave -noupdate /kc854_tb/kc854/ioSel
add wave -noupdate /kc854_tb/kc854/pioCS_n
add wave -noupdate /kc854_tb/kc854/ctcCS_n
add wave -noupdate /kc854_tb/kc854/pioAIn
add wave -noupdate /kc854_tb/kc854/pioAOut
add wave -noupdate /kc854_tb/kc854/pioARdy
add wave -noupdate /kc854_tb/kc854/pioAStb
add wave -noupdate /kc854_tb/kc854/pioBIn
add wave -noupdate /kc854_tb/kc854/pioBOut
add wave -noupdate /kc854_tb/kc854/pioBRdy
add wave -noupdate /kc854_tb/kc854/pioBStb
add wave -noupdate /kc854_tb/kc854/debugClock
add wave -noupdate -radix hexadecimal /kc854_tb/kc854/debugCpuAddr
add wave -noupdate /kc854_tb/kc854/debugRunCpu
add wave -noupdate /kc854_tb/kc854/intAckPeriph
add wave -noupdate /kc854_tb/kc854/intPeriph
add wave -noupdate -radix hexadecimal /kc854_tb/kc854/memDataOut
add wave -noupdate /kc854_tb/kc854/cpu/RESET_n
add wave -noupdate /kc854_tb/kc854/cpu/CLK_n
add wave -noupdate /kc854_tb/kc854/cpu/CLKEN
add wave -noupdate /kc854_tb/kc854/cpu/WAIT_n
add wave -noupdate /kc854_tb/kc854/cpu/INT_n
add wave -noupdate /kc854_tb/kc854/cpu/NMI_n
add wave -noupdate /kc854_tb/kc854/cpu/BUSRQ_n
add wave -noupdate /kc854_tb/kc854/cpu/M1_n
add wave -noupdate /kc854_tb/kc854/cpu/MREQ_n
add wave -noupdate /kc854_tb/kc854/cpu/IORQ_n
add wave -noupdate /kc854_tb/kc854/cpu/RD_n
add wave -noupdate /kc854_tb/kc854/cpu/WR_n
add wave -noupdate /kc854_tb/kc854/cpu/RFSH_n
add wave -noupdate /kc854_tb/kc854/cpu/HALT_n
add wave -noupdate /kc854_tb/kc854/cpu/BUSAK_n
add wave -noupdate -radix hexadecimal /kc854_tb/kc854/cpu/A
add wave -noupdate -radix hexadecimal /kc854_tb/kc854/cpu/DI
add wave -noupdate -radix hexadecimal /kc854_tb/kc854/cpu/DO
add wave -noupdate /kc854_tb/kc854/cpu/IntE
add wave -noupdate /kc854_tb/kc854/cpu/RETI_n
add wave -noupdate /kc854_tb/kc854/cpu/IntCycle_n
add wave -noupdate /kc854_tb/kc854/cpu/NoRead
add wave -noupdate /kc854_tb/kc854/cpu/Write
add wave -noupdate /kc854_tb/kc854/cpu/IORQ
add wave -noupdate -radix hexadecimal /kc854_tb/kc854/cpu/DI_Reg
add wave -noupdate /kc854_tb/kc854/cpu/MCycle
add wave -noupdate /kc854_tb/kc854/cpu/TState
add wave -noupdate /kc854_tb/kc854/memcontrol/clk
add wave -noupdate /kc854_tb/kc854/memcontrol/reset_n
add wave -noupdate -radix hexadecimal /kc854_tb/kc854/memcontrol/sramAddr
add wave -noupdate -radix hexadecimal /kc854_tb/kc854/memcontrol/sramDataOut
add wave -noupdate -radix hexadecimal /kc854_tb/kc854/memcontrol/sramDataIn
add wave -noupdate /kc854_tb/kc854/memcontrol/sramOE_n
add wave -noupdate /kc854_tb/kc854/memcontrol/sramCE_n
add wave -noupdate /kc854_tb/kc854/memcontrol/sramWE_n
add wave -noupdate /kc854_tb/kc854/memcontrol/sramLB_n
add wave -noupdate /kc854_tb/kc854/memcontrol/sramUB_n
add wave -noupdate -radix hexadecimal /kc854_tb/kc854/memcontrol/cpuAddr
add wave -noupdate -radix hexadecimal /kc854_tb/kc854/memcontrol/cpuDOut
add wave -noupdate -radix hexadecimal /kc854_tb/kc854/memcontrol/cpuDIn
add wave -noupdate /kc854_tb/kc854/memcontrol/cpuWR_n
add wave -noupdate /kc854_tb/kc854/memcontrol/cpuRD_n
add wave -noupdate /kc854_tb/kc854/memcontrol/cpuM1_n
add wave -noupdate /kc854_tb/kc854/memcontrol/cpuMREQ_n
add wave -noupdate /kc854_tb/kc854/memcontrol/cpuIORQ_n
add wave -noupdate /kc854_tb/kc854/memcontrol/cpuEn
add wave -noupdate /kc854_tb/kc854/memcontrol/cpuWait
add wave -noupdate /kc854_tb/kc854/memcontrol/cpuTick
add wave -noupdate /kc854_tb/kc854/memcontrol/pioPortA
add wave -noupdate /kc854_tb/kc854/memcontrol/pioPortB
add wave -noupdate -radix hexadecimal /kc854_tb/kc854/memcontrol/vidAddr
add wave -noupdate -radix hexadecimal /kc854_tb/kc854/memcontrol/vidData
add wave -noupdate /kc854_tb/kc854/memcontrol/vidRead
add wave -noupdate /kc854_tb/kc854/memcontrol/vidBusy
add wave -noupdate /kc854_tb/kc854/memcontrol/vidHires
add wave -noupdate /kc854_tb/kc854/memcontrol/state
add wave -noupdate -radix hexadecimal /kc854_tb/kc854/memcontrol/cpuAddrInt
add wave -noupdate -radix hexadecimal /kc854_tb/kc854/memcontrol/vidAddrInt
add wave -noupdate /kc854_tb/kc854/memcontrol/port84
add wave -noupdate /kc854_tb/kc854/memcontrol/port86
add wave -noupdate /kc854_tb/kc854/memcontrol/bankWe
add wave -noupdate /kc854_tb/kc854/memcontrol/bankEn
add wave -noupdate /kc854_tb/kc854/memcontrol/bankLByte
add wave -noupdate /kc854_tb/kc854/memcontrol/bankAddr
add wave -noupdate -radix hexadecimal /kc854_tb/kc854/memcontrol/romData
add wave -noupdate /kc854_tb/kc854/memcontrol/selectVid
add wave -noupdate /kc854_tb/kc854/memcontrol/cpuCycle
add wave -noupdate /kc854_tb/kc854/memcontrol/bankswitching/ram0en
add wave -noupdate /kc854_tb/kc854/memcontrol/bankswitching/ram0we
add wave -noupdate /kc854_tb/kc854/memcontrol/bankswitching/ram4en
add wave -noupdate /kc854_tb/kc854/memcontrol/bankswitching/ram4we
add wave -noupdate /kc854_tb/kc854/memcontrol/bankswitching/ram8en
add wave -noupdate /kc854_tb/kc854/memcontrol/bankswitching/ram8we
add wave -noupdate /kc854_tb/kc854/memcontrol/bankswitching/ram8raf
add wave -noupdate /kc854_tb/kc854/memcontrol/bankswitching/irmEn
add wave -noupdate /kc854_tb/kc854/memcontrol/bankswitching/irmBLA
add wave -noupdate /kc854_tb/kc854/memcontrol/bankswitching/romCaosC
add wave -noupdate /kc854_tb/kc854/memcontrol/bankswitching/romCaosE
add wave -noupdate /kc854_tb/kc854/memcontrol/bankswitching/romBasic
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 344
configure wave -valuecolwidth 141
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
WaveRestoreZoom {0 ps} {493939 ps}
