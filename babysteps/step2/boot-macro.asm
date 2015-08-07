; boot.asm with use of a macro for BIOS printing

; It should be noted that this method (using a macro instead of a
; procedure with call & ret) can significantly increase the size
; of the assembled program because the assembler will copy the
; code from the macro into every location where the macro is called.
; E.g. `BiosPrint msg` will be replaced by the folloing code every
; time it is encountered by the assembler. As a result, trying to
; call the macro more than once also generates errors because symbols
; like `ch_loop:` get defined more than once. While macros can be
; useful, this is not a good way to use them.
%macro BiosPrint 1
    mov si, word %1 ; load SI with pointer to string to print
ch_loop:
    lodsb           ; put the byte pointed to by SI into AL then increment SI
    or al, al       ; fast way to compare to zero (finds null-terminator)
    jz done         ; leave loop when null terminator is encountered
    mov ah, 0x0e
    int 0x10
    jmp ch_loop
done:
%endmacro

[ORG 0x7c00]
    
    ; Set the Data Segment (DS * 16 gives offset to program data)
    xor ax, ax      ; zero-out the ax register
    mov ds, ax      ; since we have told the assembler that we are offset to 0x7c00,
                    ; we can set the Data Segment to 0.

    BiosPrint msg   ; Print the string pointed to by SI

hang:
    jmp hang        ; infinite loop

msg db 'Hello World', 13, 10, 0     ; The string plus a line feed, carriage return, and null terminator


times 510-($-$$) db 0       ; Pad with zeroes
dd 0xaa55                   ; magic boot sector number

