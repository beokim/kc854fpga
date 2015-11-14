onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /blink_tb/kc854/CLOCK_50
add wave -noupdate /blink_tb/kc854/CLOCK_24
add wave -noupdate /blink_tb/kc854/VGA_R
add wave -noupdate /blink_tb/kc854/VGA_G
add wave -noupdate /blink_tb/kc854/VGA_B
add wave -noupdate /blink_tb/kc854/VGA_HS
add wave -noupdate /blink_tb/kc854/VGA_VS
add wave -noupdate /blink_tb/kc854/SRAM_ADDR
add wave -noupdate /blink_tb/kc854/SRAM_DQ
add wave -noupdate /blink_tb/kc854/SRAM_OE_N
add wave -noupdate /blink_tb/kc854/SRAM_CE_N
add wave -noupdate /blink_tb/kc854/SRAM_WE_N
add wave -noupdate /blink_tb/kc854/SRAM_LB_N
add wave -noupdate /blink_tb/kc854/SRAM_UB_N
add wave -noupdate /blink_tb/kc854/PS2_CLK
add wave -noupdate /blink_tb/kc854/PS2_DAT
add wave -noupdate /blink_tb/kc854/UART_TXD
add wave -noupdate /blink_tb/kc854/UART_RXD
add wave -noupdate /blink_tb/kc854/KEY
add wave -noupdate /blink_tb/kc854/SW
add wave -noupdate /blink_tb/kc854/LEDR
add wave -noupdate /blink_tb/kc854/LEDG
add wave -noupdate /blink_tb/kc854/HEX0
add wave -noupdate /blink_tb/kc854/HEX1
add wave -noupdate /blink_tb/kc854/HEX2
add wave -noupdate /blink_tb/kc854/HEX3
add wave -noupdate /blink_tb/kc854/GPIO_1
add wave -noupdate /blink_tb/kc854/cpuclk
add wave -noupdate /blink_tb/kc854/vgaclk
add wave -noupdate /blink_tb/kc854/clkLocked
add wave -noupdate /blink_tb/kc854/blink2div
add wave -noupdate /blink_tb/kc854/blink2div2
add wave -noupdate /blink_tb/kc854/blink2div3
add wave -noupdate /blink_tb/kc854/ctcDiv
add wave -noupdate /blink_tb/kc854/blinkTest
add wave -noupdate /blink_tb/kc854/vidLine
add wave -noupdate /blink_tb/kc854/cpuTick
add wave -noupdate /blink_tb/kc854/ctcH4Clk
add wave -noupdate /blink_tb/kc854/vidH5ClkEn
add wave -noupdate /blink_tb/kc854/ctcBIClk
add wave -noupdate /blink_tb/kc854/vDisplay
add wave -noupdate /blink_tb/kc854/testDiv
add wave -noupdate /blink_tb/kc854/kcVidLine
add wave -noupdate /blink_tb/kc854/vgaVidLine
add wave -noupdate /blink_tb/kc854/kcVidLineSLV
add wave -noupdate /blink_tb/kc854/vidBlink
add wave -noupdate /blink_tb/kc854/vgaDiv
add wave -noupdate /blink_tb/kc854/vgaData
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate /blink_tb/kc854/vidgen/vidclk
add wave -noupdate /blink_tb/kc854/vidgen/vgaRed
add wave -noupdate /blink_tb/kc854/vidgen/vgaGreen
add wave -noupdate /blink_tb/kc854/vidgen/vgaBlue
add wave -noupdate /blink_tb/kc854/vidgen/vgaHSync
add wave -noupdate /blink_tb/kc854/vidgen/vgaVSync
add wave -noupdate -radix decimal /blink_tb/kc854/vidgen/vgaAddr
add wave -noupdate -radix hexadecimal /blink_tb/kc854/vidgen/vgaData
add wave -noupdate /blink_tb/kc854/vidgen/vidHires
add wave -noupdate /blink_tb/kc854/vidgen/vidBlink
add wave -noupdate /blink_tb/kc854/vidgen/vidBlinkEn
add wave -noupdate /blink_tb/kc854/vidgen/vidSlowBlink
add wave -noupdate /blink_tb/kc854/vidgen/vidSlowBlinkEn
add wave -noupdate /blink_tb/kc854/vidgen/vidScanline
add wave -noupdate /blink_tb/kc854/vidgen/vidNextLine
add wave -noupdate /blink_tb/kc854/vidgen/vidLine
add wave -noupdate /blink_tb/kc854/vidgen/test
add wave -noupdate /blink_tb/kc854/vidgen/countH
add wave -noupdate /blink_tb/kc854/vidgen/countV
add wave -noupdate /blink_tb/kc854/vidgen/syncDelayH
add wave -noupdate /blink_tb/kc854/vidgen/syncDelayV
add wave -noupdate /blink_tb/kc854/vidgen/pixelData
add wave -noupdate /blink_tb/kc854/vidgen/colorData
add wave -noupdate /blink_tb/kc854/vidgen/pixelX
add wave -noupdate /blink_tb/kc854/vidgen/pixelXshift
add wave -noupdate /blink_tb/kc854/vidgen/pixelY
add wave -noupdate /blink_tb/kc854/vidgen/displayPixel
add wave -noupdate /blink_tb/kc854/vidgen/lineAddr
add wave -noupdate /blink_tb/kc854/vidgen/ditherFlag
add wave -noupdate /blink_tb/kc854/vidgen/vidLineInt
add wave -noupdate /blink_tb/kc854/vidgen/blinkDiv
add wave -noupdate /blink_tb/kc854/vidgen/vidBlinkInt
add wave -noupdate /blink_tb/kc854/vidgen/cntVidLine
add wave -noupdate /blink_tb/kc854/vidgen/cntrReset
add wave -noupdate /blink_tb/kc854/vidgen/cntBlink
add wave -noupdate /blink_tb/kc854/vidgen/blinkCntr
add wave -noupdate /blink_tb/kc854/vidgen/blinkLineCntr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {49999271 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 267
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
WaveRestoreZoom {0 ps} {894579 ps}
