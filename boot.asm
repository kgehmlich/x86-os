; boot.asm
    cli     ; Clears interrupts flag, so the CPU will not react to interrupts (e.g. ctrl-alt-del)
hang:
    jmp hang

    times 510-($-$$) db 0
    dd 0xaa55

