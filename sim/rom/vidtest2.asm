    org $0000 
    
	;TESTBILD FUER KC 85/4
	;=====================
 
 
VTEST2:	LD	A,4FH ; Mode 1: Input
	OUT	(8AH),A
	LD	A,15H ;  
	OUT	(88H),A
	LD	A,0FH ; Mode 0: Output
	OUT	(8AH),A
	LD	A,03H
	OUT	(8AH),A
	LD	A,8	 ;PIXELSPEICHER1
	OUT	(84H),A

	LD	HL,8000H ;PIXEL-RAM loeschen
    LD	DE,8001H
	LD	BC,10240
	LD	(HL),0
	LDIR

    ld  sp,0c000H
    
    ld  hl,test_data
    ld  de,8000H
    call dzx7_standard
    
MFE:	LD	A,0AH	;FARBSPEICHER1
	OUT	(84H),A
	LD	HL,8000H    ;FARB-RAM LADEN
	LD	DE,8001H
	LD	BC,27FFH
	LD	(HL),39H	;WEISS AUF BLAU
	LDIR

MW:	JR	MW

include "dzx7_standard.asm"

test_data:
    incbin "screendump.img.zx7"
test_end:

 
 
 