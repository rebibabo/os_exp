    org     07c00h
    mov     ax, cs
    mov     ds, ax
    mov     es, ax
    call    DispStr
    jmp     $
DispStr:
    mov     ax, BootMessage
    mov     bp, ax
    mov     cx, 16
    mov     ax, 01301h
    mov     bx, 000ch
    mov     dl, 0
    int     10h
    ret
BootMessage:        DB      "Hello, OS world!"
times   510-($-$$)  DB      0
DW      0xaa55