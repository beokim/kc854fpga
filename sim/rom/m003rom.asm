start:
    ld  bc, 0880h
    ld  a,  01h    
    out (c), a      ; modul einschalten
    
; ctc channel 0
    ld  a, 47h      ; counter + tc follows + reset
    out (0ch), a   
;    ld  a, 5bh     ; tc
    ld  a, 01h      ; tc
    out (0ch), a 
    
; sio 1 cmd
    ld  a, 04h      ; x1 clock mode + + 1 stop bit + no parity
    out (0ah), a 
    ld  a, 03h      ; write reg 3
    out (0ah), a 
    ld  a, 20h      ; 5 bit + auto enables 
    out (0ah), a 
    ld  a, 05h      ; write reg 5
    out (0ah), a 
    ld  a, 0ah      ; TX en + RTS en
    out (0ah), a 
        
; ctc channel 2
    ld  a, 47h      ; counter + tc follows + reset
    out (0dh), a 
;    ld  a, 2eh      ; tc
    ld  a, 01h      ; tc
    out (0dh), a 
    
; sio 2 cmd
    ld  a, 18h      ; cmd: channel reset
    out (0bh), a 
    ld  a, 02h      ; write reg 2
    out (0bh), a 
    ld  a, 0e2h     ; int vector
    out (0bh), a 
    ld  a, 14h      ; reset ext/channel int + write reg 4
    out (0bh), a 
    ld  a, 44h      ; 16x clock mode + 1 stop bit + no parity
    out (0bh), a 
    ld  a, 03h      ; write reg 3
    out (0bh), a 
    ld  a, 0e1h     ; 8 bit + auto enables + rx enable
    out (0bh), a 
    ld  a, 05h      ; write reg 5
    out (0bh), a 
    ld  a, 0eah     ; DTR en + external sync mode + Tx en + RTS
    out (0bh), a 
    ld  a, 11h      ; cmd: reset ext/channel int + write reg 1
    out (0bh), a 
    ld  a, 18h      ; INT on All Rx Characters (Parity Does Not Affect Vector) + status affects vector off + tx int off
    out (0bh), a 

; txtest
    ld  a, 01h
    out (09h), a    ; sio 2 data    -> tx
    
txloop1:
    in  a, (0bh)    ; sio 2 cmd -> rr0 (status) lesen
    bit 2, a        ; Transmit Buffer Empty?
    jr  z, txloop1

    ld  a, 80h
    out (09h), a    ; sio 2 data    -> tx
    
    ld  c, 0a0h
        
txtest:
txloop:
    in  a, (0bh)    ; sio 2 cmd -> rr0 (status) lesen
    bit 2, a        ; Transmit Buffer Empty?
    jr  z, txloop

    ld  a, c
    out (09h), a    ; sio 2 data    -> tx
    
rxloop:
    in  a, (0bh)    ; sio 2 cmd -> rr0 (status) lesen
    bit 0, a        ; Receive Character Available?
    jr  z, rxloop
    
    in  a, (09h)    ; sio 2 data    -> rx
    ld  c, a
    inc c
    
    jr  txtest
    