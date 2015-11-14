onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /memcontrol_cpu_tb/memcontrol/clk
add wave -noupdate /memcontrol_cpu_tb/memcontrol/reset_n
add wave -noupdate -radix hexadecimal /memcontrol_cpu_tb/memcontrol/sramAddr
add wave -noupdate -radix hexadecimal /memcontrol_cpu_tb/memcontrol/sramDataOut
add wave -noupdate -radix hexadecimal /memcontrol_cpu_tb/memcontrol/sramDataIn
add wave -noupdate /memcontrol_cpu_tb/memcontrol/sramOE_n
add wave -noupdate /memcontrol_cpu_tb/memcontrol/sramCE_n
add wave -noupdate /memcontrol_cpu_tb/memcontrol/sramWE_n
add wave -noupdate /memcontrol_cpu_tb/memcontrol/sramLB_n
add wave -noupdate /memcontrol_cpu_tb/memcontrol/sramUB_n
add wave -noupdate -radix hexadecimal /memcontrol_cpu_tb/memcontrol/cpuAddr
add wave -noupdate -radix hexadecimal /memcontrol_cpu_tb/memcontrol/cpuDOut
add wave -noupdate -radix hexadecimal /memcontrol_cpu_tb/memcontrol/cpuDIn
add wave -noupdate /memcontrol_cpu_tb/memcontrol/cpuWR_n
add wave -noupdate /memcontrol_cpu_tb/memcontrol/cpuRD_n
add wave -noupdate /memcontrol_cpu_tb/memcontrol/cpuM1_n
add wave -noupdate /memcontrol_cpu_tb/memcontrol/cpuMREQ_n
add wave -noupdate /memcontrol_cpu_tb/memcontrol/cpuIORQ_n
add wave -noupdate /memcontrol_cpu_tb/memcontrol/cpuEn
add wave -noupdate /memcontrol_cpu_tb/memcontrol/cpuWait
add wave -noupdate /memcontrol_cpu_tb/memcontrol/cpuTick
add wave -noupdate /memcontrol_cpu_tb/memcontrol/pioPortA
add wave -noupdate /memcontrol_cpu_tb/memcontrol/pioPortB
add wave -noupdate -radix hexadecimal /memcontrol_cpu_tb/memcontrol/vidAddr
add wave -noupdate -radix hexadecimal /memcontrol_cpu_tb/memcontrol/vidData
add wave -noupdate /memcontrol_cpu_tb/memcontrol/vidRead
add wave -noupdate /memcontrol_cpu_tb/memcontrol/vidBusy
add wave -noupdate /memcontrol_cpu_tb/memcontrol/vidHires
add wave -noupdate /memcontrol_cpu_tb/memcontrol/state
add wave -noupdate -radix hexadecimal /memcontrol_cpu_tb/memcontrol/cpuAddrInt
add wave -noupdate -radix hexadecimal /memcontrol_cpu_tb/memcontrol/vidAddrInt
add wave -noupdate /memcontrol_cpu_tb/memcontrol/port84
add wave -noupdate /memcontrol_cpu_tb/memcontrol/port86
add wave -noupdate /memcontrol_cpu_tb/memcontrol/bankWe
add wave -noupdate /memcontrol_cpu_tb/memcontrol/bankEn
add wave -noupdate /memcontrol_cpu_tb/memcontrol/bankLByte
add wave -noupdate /memcontrol_cpu_tb/memcontrol/bankAddr
add wave -noupdate -radix hexadecimal /memcontrol_cpu_tb/memcontrol/romData
add wave -noupdate /memcontrol_cpu_tb/memcontrol/selectVid
add wave -noupdate /memcontrol_cpu_tb/memcontrol/cpuCycle
add wave -noupdate /memcontrol_cpu_tb/pio/aOut
add wave -noupdate /memcontrol_cpu_tb/pio/bOut
add wave -noupdate /memcontrol_cpu_tb/memcontrol/bankWe
add wave -noupdate /memcontrol_cpu_tb/memcontrol/bankEn
add wave -noupdate /memcontrol_cpu_tb/memcontrol/bankLByte
add wave -noupdate /memcontrol_cpu_tb/memcontrol/bankAddr
add wave -noupdate /memcontrol_cpu_tb/memcontrol/bankswitching/ram0en
add wave -noupdate /memcontrol_cpu_tb/memcontrol/bankswitching/ram0we
add wave -noupdate /memcontrol_cpu_tb/memcontrol/bankswitching/ram4en
add wave -noupdate /memcontrol_cpu_tb/memcontrol/bankswitching/ram4we
add wave -noupdate /memcontrol_cpu_tb/memcontrol/bankswitching/ram8en
add wave -noupdate /memcontrol_cpu_tb/memcontrol/bankswitching/ram8we
add wave -noupdate /memcontrol_cpu_tb/memcontrol/bankswitching/ram8raf
add wave -noupdate /memcontrol_cpu_tb/memcontrol/bankswitching/irmEn
add wave -noupdate /memcontrol_cpu_tb/memcontrol/bankswitching/irmBLA
add wave -noupdate /memcontrol_cpu_tb/memcontrol/bankswitching/romCaosC
add wave -noupdate /memcontrol_cpu_tb/memcontrol/bankswitching/romCaosE
add wave -noupdate /memcontrol_cpu_tb/memcontrol/bankswitching/romBasic
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {118310000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 356
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
WaveRestoreZoom {118008266 ps} {118611735 ps}
