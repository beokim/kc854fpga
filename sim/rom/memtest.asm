    org 4000h
    
bootrom:
    jp  start
start:    
    ld  sp,0c000H
    
    ld  a,4fh  ; Mode 1: Input
    out (8ah),a
    ld  a,1fh ; RAM0 + CHAOS E + IRM + ROM Basic aus
    out (88h),a
    ld  a,0fh ; Mode 0: Output
    out (8ah),a
    ld  a,08h ; pixelspeicher1
    out (84h),a
    ld  a,80h ; 1xxxxxxx CHAOS C an
    out (86h),a

    ld  a, 1
    ld  hl,00000h
    ld  (hl),a
    ld  a,(hl)
    
    inc a ; 2
    ld  h,080h
    ld  (hl),a
    ld  a,(hl)
    
    inc a ; 3
    ld  h,0c0h
    ld  (hl),a
    ld  a,(hl)
    
    inc a ; 4
    ld  h,0e0h
    ld  (hl),a
    ld  a,(hl)
    
    ld  a,9fh ; RAM0 + CHAOS E + IRM + ROM Basic an (=> CHAOS C aus)
    out (88h),a
    
    inc a ; a0h
    ld  h,0c0h
    ld  (hl),a
    ld  a,(hl)
    
    inc a ; a1h
    ld  h,0e0h
    ld  (hl),a
    ld  a,(hl)
    
end:
    jr  end
