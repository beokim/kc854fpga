onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fifo_tb/clk
add wave -noupdate /fifo_tb/res_n
add wave -noupdate -radix hexadecimal /fifo_tb/dataIn
add wave -noupdate -radix hexadecimal /fifo_tb/testVect
add wave -noupdate /fifo_tb/testVectIdx
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -divider FiFo1
add wave -noupdate /fifo_tb/fifo1/clk
add wave -noupdate /fifo_tb/fifo1/res_n
add wave -noupdate -radix hexadecimal /fifo_tb/fifo1/dataIn
add wave -noupdate -radix hexadecimal /fifo_tb/fifo1/dataOut
add wave -noupdate /fifo_tb/fifo1/rd
add wave -noupdate /fifo_tb/fifo1/wr
add wave -noupdate /fifo_tb/fifo1/fifoEmpty
add wave -noupdate /fifo_tb/fifo1/fifoFull
add wave -noupdate /fifo_tb/fifo1/fifoOver
add wave -noupdate -radix hexadecimal /fifo_tb/fifo1/data
add wave -noupdate /fifo_tb/fifo1/readPtr
add wave -noupdate /fifo_tb/fifo1/writePtr
add wave -noupdate /fifo_tb/fifo1/nextReadPtr
add wave -noupdate /fifo_tb/fifo1/nextWritePtr
add wave -noupdate /fifo_tb/fifo1/intFifoFull
add wave -noupdate -label /fifo_tb/fifo1/intFifoLast /fifo_tb/fifo1/intFifoLast
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -divider FiFo2
add wave -noupdate /fifo_tb/fifo2/clk
add wave -noupdate /fifo_tb/fifo2/res_n
add wave -noupdate -radix hexadecimal /fifo_tb/fifo2/dataIn
add wave -noupdate -radix hexadecimal /fifo_tb/fifo2/dataOut
add wave -noupdate /fifo_tb/fifo2/rd
add wave -noupdate /fifo_tb/fifo2/wr
add wave -noupdate /fifo_tb/fifo2/fifoEmpty
add wave -noupdate /fifo_tb/fifo2/fifoFull
add wave -noupdate /fifo_tb/fifo2/fifoOver
add wave -noupdate -radix hexadecimal /fifo_tb/fifo2/data
add wave -noupdate /fifo_tb/fifo2/writePtr
add wave -noupdate /fifo_tb/fifo2/readPtr
add wave -noupdate /fifo_tb/fifo2/nextWritePtr
add wave -noupdate /fifo_tb/fifo2/nextReadPtr
add wave -noupdate /fifo_tb/fifo2/intFifoFull
add wave -noupdate /fifo_tb/fifo2/intFifoEmpty
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {474223 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 199
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
WaveRestoreZoom {49594305 ps} {50021352 ps}
