; ---------------
dochar:
    call cprint
sprint:
    lodsb       ; put byte pointed to by SI into AL then increment SI
    cmp al, 0
    jne dochar  ; else, we're done
    add byte [ypos], 1  ; move down one line
    mov byte [xpos], 0  ; start at beginning of line
    ret

cprint:
    mov ah, 0x0f            ; white on black (BIOS tty attribute)
    
    ; Calculate vertical offset
    mov cx, ax              ; save char+attrib
    movzx ax, byte [ypos]   ; copies ypos into AX then pads with zeroes up to MSB
    mov dx, 160             ; 2 bytes per char, 80 chars per row
    mul dx                  ; DX(bytes per row) * AX(row number). Result is stored
                            ; in AX with any overflow beyond 16 bits being stored in DX.
    
    ; Calculate horizontal offset
    movzx bx, byte [xpos]
    shl bx, 1               ; x2 because each char+attrib takes up 2 bytes

    mov di, 0               ; vid mem offset
    add di, ax              ; add vert offset
    add di, bx              ; add horiz offset

    mov ax, cx              ; restore char+attrib
    stosw                   ; stores value of AX at [ES:DI] then increments DI
                            ; by 2 (because 2 bytes)
    add byte [xpos], 1      ; update position tracker

    ret


printreg16:
    mov di, outstr16
    mov ax, [reg16]
    mov si, hexstr
    mov cx, 4
hexloop:
    rol ax, 4
    mov bx, ax
    and bx, 0x0f
    mov bl, [si + bx]
    mov [di], bl
    inc di
    dec cx
    jnz hexloop

    mov si, outstr16
    call sprint

    ret


xpos        db 0
ypos        db 0
hexstr      db '0123456789ABCDEF'
outstr16    db '0000', 0
reg16       dw 0
