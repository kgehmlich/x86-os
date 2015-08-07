; boot.asm with use of ORG for setting offset
[ORG 0x7c00]
    
    ; Set the Data Segment (DS * 16 gives offset to program data)
    xor ax, ax      ; zero-out the ax register
    mov ds, ax      ; since we have told the assembler that we are offset to 0x7c00,
                    ; we can set the Data Segment to 0.

    mov si, msg     ; Point the Source Index to the beginning of our string
ch_loop:
    lodsb           ; put the byte pointed to by SI into AL then increment SI
    
    or al, al       ; this is a fast way to compare to zero (has no actual effect on AL)
                    ; Since our string is null-terminated, if the byte is zero then we
                    ; have hit the end of the string.

    jz hang         ; leave loop
    mov ah, 0x0e    ; BIOS tty printing
    int 0x10        ; call interrupt to get BIOS to print to screen
    jmp ch_loop     ; continue to next character

hang:
    jmp hang        ; infinite loop

msg db 'Hello World', 13, 10, 0     ; The string plus a line feed, carriage return, and null terminator

times 510-($-$$) db 0       ; Pad with zeroes
dd 0xaa55                   ; magic boot sector number

