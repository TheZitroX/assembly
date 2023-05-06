;   File-name:      ueb01-Pseudo-Zufallszahlen.asm
;   Titel:          First assembler programm
;   Author:         John Lienau (yourmom@ctemplar.com)
;   version:        v1.0
;   Date:           15.04.2022
;   Copyright:      Copyright (c) 2022

;   brief:          Gets a random integer from 8-bit value

global _start
section .text

_start:
    mov al, 4   ;start num
    mov rcx, 50  ;loop count

    onward:
        mov r8b, al
        mov r9b, al

        shr r8b, 1
        xor r8b, r9b

        shr r8b, 2
        xor r8b, r9b

        shr r8b, 2
        xor r8b, r9b

        ;bit the the end
        shr r8b, 2
        ;bit to carry-flag
        rcr r8b, 1
        ;shift carry-bit in the right-bit
        rcl al, 1

    loop onward

    ;end program
    mov rax, 60     ;functionNum: programm end
    mov rdi, 0      ;return 0
    syscall
