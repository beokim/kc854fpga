; Bootloader fuer KC-Roms
; komprimiert mit ZX7
; passt gerade so in 16k
    org 0000h

    ld  sp,0c000H
    
    ld  a,1fh ; RAM0 + CHAOS E + IRM + ROM Basic aus
    out (88h),a
    ld  a,0fh ; Mode 0: Output
    out (8ah),a
    ld  a,08h ; pixelspeicher1
    out (84h),a
    ld  a,80h ; 1xxxxxxx CHAOS C an
    out (86h),a
    
    ld  hl,caos_c_data
    ld  de,0c000H
    call dzx7_standard
    
    ld  hl,caos_e_data
    ld  de,0e000H
    call dzx7_standard

    xor a,a ; 0xxxxxxx CHAOS C aus
    out (86h),a
    
    ld  a,9fh ; RAM0 + CHAOS E + IRM + ROM Basic an 
    out (88h),a
    
    ld  hl,basic_data
    ld  de,0c000H
    call dzx7_standard
boot: 
    jp 0f000h

include "asm\dzx7_standard.asm"

basic_data:
    incbin "packed\basic_c0.854.zx7"
caos_c_data:
    incbin "packed\caos__c0.854.zx7"
caos_e_data:
    incbin "packed\caos__e0.854.zx7"
caos_end: