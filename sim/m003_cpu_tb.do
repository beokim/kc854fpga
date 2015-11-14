onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /m003_cpu_tb/cpuReset_n
add wave -noupdate /m003_cpu_tb/cpuclk
add wave -noupdate /m003_cpu_tb/sysclk
add wave -noupdate -radix hexadecimal /m003_cpu_tb/cpuAddr
add wave -noupdate -radix hexadecimal /m003_cpu_tb/cpuDataIn
add wave -noupdate -radix hexadecimal /m003_cpu_tb/cpu/u0/DI_Reg
add wave -noupdate -radix hexadecimal /m003_cpu_tb/cpuDataOut
add wave -noupdate /m003_cpu_tb/cpuEn
add wave -noupdate /m003_cpu_tb/cpuWait
add wave -noupdate /m003_cpu_tb/cpuInt_n
add wave -noupdate /m003_cpu_tb/cpuM1_n
add wave -noupdate /m003_cpu_tb/cpuMReq_n
add wave -noupdate /m003_cpu_tb/cpuRfsh_n
add wave -noupdate /m003_cpu_tb/cpuIorq_n
add wave -noupdate /m003_cpu_tb/cpuRD_n
add wave -noupdate /m003_cpu_tb/cpuWR_n
add wave -noupdate /m003_cpu_tb/cpuRETI
add wave -noupdate -radix hexadecimal /m003_cpu_tb/romData
add wave -noupdate -radix hexadecimal /m003_cpu_tb/m003DataOut
add wave -noupdate /m003_cpu_tb/m003Sel
add wave -noupdate /m003_cpu_tb/intPeriph
add wave -noupdate /m003_cpu_tb/intAckPeriph
add wave -noupdate /m003_cpu_tb/LEDR
add wave -noupdate /m003_cpu_tb/UART_RXD
add wave -noupdate /m003_cpu_tb/UART_TXD
add wave -noupdate /m003_cpu_tb/m003/clk
add wave -noupdate /m003_cpu_tb/m003/sysClkEn
add wave -noupdate /m003_cpu_tb/m003/res_n
add wave -noupdate -radix hexadecimal /m003_cpu_tb/m003/addr
add wave -noupdate -radix hexadecimal /m003_cpu_tb/m003/dIn
add wave -noupdate -radix hexadecimal /m003_cpu_tb/m003/dOut
add wave -noupdate /m003_cpu_tb/m003/modSel
add wave -noupdate /m003_cpu_tb/m003/modEna
add wave -noupdate /m003_cpu_tb/m003/m1_n
add wave -noupdate /m003_cpu_tb/m003/mreq_n
add wave -noupdate /m003_cpu_tb/m003/iorq_n
add wave -noupdate /m003_cpu_tb/m003/rd_n
add wave -noupdate /m003_cpu_tb/m003/int
add wave -noupdate /m003_cpu_tb/m003/intAck
add wave -noupdate /m003_cpu_tb/m003/test
add wave -noupdate /m003_cpu_tb/m003/aRxd
add wave -noupdate /m003_cpu_tb/m003/aTxd
add wave -noupdate /m003_cpu_tb/m003/bRxd
add wave -noupdate /m003_cpu_tb/m003/bTxd
add wave -noupdate /m003_cpu_tb/m003/ioSel
add wave -noupdate /m003_cpu_tb/m003/controlWordSel
add wave -noupdate /m003_cpu_tb/m003/sioCS_n
add wave -noupdate /m003_cpu_tb/m003/ctcCS_n
add wave -noupdate /m003_cpu_tb/m003/enabled
add wave -noupdate /m003_cpu_tb/m003/controlWord
add wave -noupdate /m003_cpu_tb/m003/ctcClkTrg
add wave -noupdate /m003_cpu_tb/m003/ctcZcTo
add wave -noupdate -radix hexadecimal /m003_cpu_tb/m003/ctcDataOut
add wave -noupdate -radix hexadecimal /m003_cpu_tb/m003/sioDataOut
add wave -noupdate /m003_cpu_tb/m003/sio/clk
add wave -noupdate /m003_cpu_tb/m003/sio/res_n
add wave -noupdate /m003_cpu_tb/m003/sio/cs_n
add wave -noupdate -radix hexadecimal /m003_cpu_tb/m003/sio/dIn
add wave -noupdate -radix hexadecimal /m003_cpu_tb/m003/sio/dOut
add wave -noupdate /m003_cpu_tb/m003/sio/rd_n
add wave -noupdate /m003_cpu_tb/m003/sio/iorq_n
add wave -noupdate /m003_cpu_tb/m003/sio/m1_n
add wave -noupdate /m003_cpu_tb/m003/sio/baSel
add wave -noupdate /m003_cpu_tb/m003/sio/cdSel
add wave -noupdate /m003_cpu_tb/m003/sio/int
add wave -noupdate /m003_cpu_tb/m003/sio/intAck
add wave -noupdate /m003_cpu_tb/m003/sio/aRxd
add wave -noupdate /m003_cpu_tb/m003/sio/aTxd
add wave -noupdate /m003_cpu_tb/m003/sio/aRxTxClk
add wave -noupdate /m003_cpu_tb/m003/sio/bRxd
add wave -noupdate /m003_cpu_tb/m003/sio/bTxd
add wave -noupdate /m003_cpu_tb/m003/sio/bRxTxClk
add wave -noupdate -radix hexadecimal /m003_cpu_tb/m003/sio/sioDataOut
add wave -noupdate -radix hexadecimal /m003_cpu_tb/m003/sio/sioIntVect
add wave -noupdate /m003_cpu_tb/m003/sio/sioIntVectStatus
add wave -noupdate /m003_cpu_tb/m003/sio/sioEn
add wave -noupdate /m003_cpu_tb/m003/sio/sioRxd
add wave -noupdate /m003_cpu_tb/m003/sio/sioTxd
add wave -noupdate /m003_cpu_tb/m003/sio/sioRxTxClk
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/clk
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/res_n
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/en
add wave -noupdate -radix hexadecimal /m003_cpu_tb/m003/sio/channels(1)/sioChannel/dIn
add wave -noupdate -radix hexadecimal /m003_cpu_tb/m003/sio/channels(1)/sioChannel/dOut
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rd_n
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/cdSel
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/int
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/intAck
add wave -noupdate -radix hexadecimal /m003_cpu_tb/m003/sio/channels(1)/sioChannel/intVect
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/intVectStatus
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rxd
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/txd
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rxTxClk
add wave -noupdate -radix hexadecimal /m003_cpu_tb/m003/sio/channels(1)/sioChannel/regs
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/preDiv
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rxTxClkDelay
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/txPreDiv
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/txStart
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/txCnt
add wave -noupdate -radix hexadecimal /m003_cpu_tb/m003/sio/channels(1)/sioChannel/txReg
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/txShift
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/txDone
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rxClkEn
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rxPreDiv
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rxInShift
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rxRcv
add wave -noupdate -radix hexadecimal /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rxShift
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rxFifoWr
add wave -noupdate -radix hexadecimal /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rxFifoDataOut
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rxFifoRd
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rxFifoEmpty
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/nextReg
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/currReg
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/dataRead
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rxFifo/clk
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rxFifo/res_n
add wave -noupdate -radix hexadecimal /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rxFifo/dataIn
add wave -noupdate -radix hexadecimal /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rxFifo/dataOut
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rxFifo/rd
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rxFifo/wr
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rxFifo/fifoEmpty
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rxFifo/fifoFull
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rxFifo/fifoOver
add wave -noupdate -radix hexadecimal /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rxFifo/data
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rxFifo/writePtr
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rxFifo/readPtr
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rxFifo/nextWritePtr
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rxFifo/nextReadPtr
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rxFifo/intFifoFull
add wave -noupdate /m003_cpu_tb/m003/sio/channels(1)/sioChannel/rxFifo/intFifoLast
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {37751874 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 361
configure wave -valuecolwidth 187
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
WaveRestoreZoom {1133941 ps} {112567338 ps}
