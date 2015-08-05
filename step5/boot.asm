[ORG 0x7c00]
    jmp start

    %include "print.inc"

start:
    xor ax, ax      ; make AX zero
    mov ds, ax      ; set Data Segment to zero
    mov ss, ax      ; stack starts at zero
    mov sp, 0x9c00  ; 0x200 past code start

    mov ax, 0xb800  ; text video memory
    mov es, ax

    cli             ; disable interrupts
    mov bx, 0x09    ; hardware interrupt #
    shl bx, 2       ; multiply by 4 to get entry in IVT
    xor ax, ax
    mov gs, ax      ; start of memory
    mov [gs:bx], word keyhandler    ; put address of keyhandler function
                                    ; into IVT so it gets called whenever
                                    ; CPU is interrupted by a keypress
    mov [gs:bx+2], ds
    sti             ; enable interrupts

    jmp $           ; hang

keyhandler:
    in al, 0x60     ; get key data directly from hardware port
    mov bl, al      ; save it
    mov byte [port60], al

    in al, 0x61     ; keyboard control
    mov ah, al
    or al, 0x80     ; disable bit 7
    out 0x61, al    ; send it back
    xchg ah, al    ; get original
    out 0x61, al    ; send that back

    mov al, 0x20    ; end of interrupt
    out 0x20, al

    and bl, 0x80    ; key released?
    jnz done        ; don't repeat

    mov ax, [port60]
    mov word [reg16], ax
    call printreg16

done:
    iret

port60 dw 0

times 510-($-$$) db 0
dw 0xaa55

