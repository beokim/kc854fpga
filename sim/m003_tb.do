onerror {resume}
quietly virtual function -install /m003_tb -env /m003_tb { (0)} virtual_000001
quietly virtual function -install /m003_tb -env /m003_tb { (0)} virtual_000002
quietly virtual function -install /m003_tb -env /m003_tb { (0)} virtual_000003
quietly virtual function -install /m003_tb -env /m003_tb { (0)} virtual_000004
quietly WaveActivateNextPane {} 0
add wave -noupdate /m003_tb/clk
add wave -noupdate /m003_tb/sysclk
add wave -noupdate /m003_tb/reset_n
add wave -noupdate -radix hexadecimal /m003_tb/testVect
add wave -noupdate /m003_tb/testVectIdx
add wave -noupdate /m003_tb/iorq_n
add wave -noupdate /m003_tb/rd_n
add wave -noupdate /m003_tb/testRd
add wave -noupdate /m003_tb/m1_n
add wave -noupdate /m003_tb/mreq_n
add wave -noupdate -radix hexadecimal /m003_tb/intPeriph
add wave -noupdate -radix hexadecimal /m003_tb/intAckPeriph
add wave -noupdate -radix hexadecimal /m003_tb/m003DataOut
add wave -noupdate /m003_tb/m003Sel
add wave -noupdate /m003_tb/m003Ena
add wave -noupdate /m003_tb/UART_RXD
add wave -noupdate /m003_tb/UART_TXD
add wave -noupdate -radix hexadecimal /m003_tb/testAddr
add wave -noupdate -radix hexadecimal /m003_tb/testData
add wave -noupdate /m003_tb/finished
add wave -noupdate -divider SIO
add wave -noupdate /m003_tb/m003/sio/clk
add wave -noupdate /m003_tb/m003/sio/res_n
add wave -noupdate /m003_tb/m003/sio/cs_n
add wave -noupdate -radix hexadecimal /m003_tb/m003/sio/dIn
add wave -noupdate -radix hexadecimal /m003_tb/m003/sio/dOut
add wave -noupdate /m003_tb/m003/sio/rd_n
add wave -noupdate /m003_tb/m003/sio/iorq_n
add wave -noupdate /m003_tb/m003/sio/m1_n
add wave -noupdate /m003_tb/m003/sio/baSel
add wave -noupdate /m003_tb/m003/sio/cdSel
add wave -noupdate /m003_tb/m003/sio/int
add wave -noupdate /m003_tb/m003/sio/intAck
add wave -noupdate /m003_tb/m003/sio/aRxd
add wave -noupdate /m003_tb/m003/sio/aTxd
add wave -noupdate /m003_tb/m003/sio/aRxTxClk
add wave -noupdate /m003_tb/m003/sio/bRxd
add wave -noupdate /m003_tb/m003/sio/bTxd
add wave -noupdate /m003_tb/m003/sio/bRxTxClk
add wave -noupdate -radix hexadecimal /m003_tb/m003/sio/sioDataOut
add wave -noupdate -radix hexadecimal /m003_tb/m003/sio/sioIntVect
add wave -noupdate /m003_tb/m003/sio/sioIntVectStatus
add wave -noupdate /m003_tb/m003/sio/sioEn
add wave -noupdate /m003_tb/m003/sio/sioRxd
add wave -noupdate /m003_tb/m003/sio/sioTxd
add wave -noupdate /m003_tb/m003/sio/sioRxTxClk
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate /m003_tb/m003/ctc/channels(2)/channel/clk
add wave -noupdate /m003_tb/m003/ctc/channels(2)/channel/res_n
add wave -noupdate /m003_tb/m003/ctc/channels(2)/channel/en
add wave -noupdate -radix hexadecimal /m003_tb/m003/ctc/channels(2)/channel/dIn
add wave -noupdate -radix hexadecimal /m003_tb/m003/ctc/channels(2)/channel/dOut
add wave -noupdate /m003_tb/m003/ctc/channels(2)/channel/rd_n
add wave -noupdate /m003_tb/m003/ctc/channels(2)/channel/int
add wave -noupdate /m003_tb/m003/ctc/channels(2)/channel/setTC
add wave -noupdate /m003_tb/m003/ctc/channels(2)/channel/ctcClkEn
add wave -noupdate /m003_tb/m003/ctc/channels(2)/channel/clk_trg
add wave -noupdate /m003_tb/m003/ctc/channels(2)/channel/zc_to
add wave -noupdate /m003_tb/m003/ctc/channels(2)/channel/state
add wave -noupdate /m003_tb/m003/ctc/channels(2)/channel/nextState
add wave -noupdate /m003_tb/m003/ctc/channels(2)/channel/control
add wave -noupdate /m003_tb/m003/ctc/channels(2)/channel/preDivider
add wave -noupdate /m003_tb/m003/ctc/channels(2)/channel/preDivVect
add wave -noupdate /m003_tb/m003/ctc/channels(2)/channel/edgeDet
add wave -noupdate -radix hexadecimal /m003_tb/m003/ctc/channels(2)/channel/dCounter
add wave -noupdate -radix hexadecimal /m003_tb/m003/ctc/channels(2)/channel/timeConstant
add wave -noupdate /m003_tb/m003/ctc/channels(2)/channel/counter/cntrEvent
add wave -noupdate -radix hexadecimal /m003_tb/m003/ctc/channels(2)/channel/cpu/tcData
add wave -noupdate /m003_tb/m003/ctc/channels(2)/channel/triggerIrq
add wave -noupdate /m003_tb/m003/ctc/channels(2)/channel/running
add wave -noupdate /m003_tb/m003/ctc/channels(2)/channel/startUp
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/clk
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/res_n
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/en
add wave -noupdate -radix hexadecimal /m003_tb/m003/sio/channels(1)/sioChannel/dIn
add wave -noupdate -radix hexadecimal /m003_tb/m003/sio/channels(1)/sioChannel/dOut
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/rd_n
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/cdSel
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/int
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/intAck
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/rxd
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/txd
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/rxTxClk
add wave -noupdate -radix hexadecimal /m003_tb/m003/sio/channels(1)/sioChannel/regs
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/preDiv
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/rxTxClkDelay
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/rxClkEn
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/txPreDiv
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/txStart
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/txCnt
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/txReg
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/txShift
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/rxPreDiv
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/rxInShift
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/rxRcv
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/rxShift
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/rxFifoWr
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/nextReg
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/currReg
add wave -noupdate -divider FiFo
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/rxFifo/clk
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/rxFifo/res_n
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/rxFifo/dataIn
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/rxFifo/dataOut
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/rxFifo/rd
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/rxFifo/wr
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/rxFifo/fifoEmpty
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/rxFifo/fifoFull
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/rxFifo/fifoOver
add wave -noupdate -radix hexadecimal /m003_tb/m003/sio/channels(1)/sioChannel/rxFifo/data
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/rxFifo/writePtr
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/rxFifo/readPtr
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/rxFifo/nextWritePtr
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/rxFifo/nextReadPtr
add wave -noupdate /m003_tb/m003/sio/channels(1)/sioChannel/rxFifo/intFifoFull
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {295972 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 370
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
WaveRestoreZoom {0 ps} {2254369 ps}
