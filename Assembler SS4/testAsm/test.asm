;    Filename:   test.asm
;    Authour:    John Lienau (yourmom@ctemplar.com)
;    Titel:      Erstes Assembler Programm.


global _start   ;Startpunkt des Programmes festlegen

section .data
    string1 db "Hello World", 0
    string2 db "World", 0

section .text
global strcmp

strcmp(const char* a, const char* b):
    push rbp
    mov rbp, rsp
    xor eax, eax        ; Initialize return value to 0
    xor ebx, ebx        ; Initialize counter to 0
    mov rdi, rsi        ; Move b pointer to rdi for use with LODSB
    mov rcx, -1         ; Initialize comparison flag to -1 (b is greater)
    
    loop:
        lodsb               ; Load next byte from a into AL and advance pointer
        cmp al, [rdi+rbx]   ; Compare byte from a with byte from b
        je continue         ; If bytes match, continue with next byte
        mov rcx, rbx        ; Store position of mismatch in rcx
        jl done             ; If byte from b is greater, set flag to 1 (a is less)
        mov rcx, -1         ; Otherwise, set flag to -1 (b is greater)
        jmp done
        
    continue:
        inc ebx             ; Increment counter
        test al, al         ; Check for end of string (null terminator)
        jnz loop            ; If not end of string, continue with next byte
        
    done:
        mov rax, rcx        ; Move comparison flag to eax for return
        pop rbp
        ret


_start:
    push rbp
    mov rbp, rsp

    mov rdi, string1
    mov rsi, string2
    call strcmp(const char* a, const char* b)
    mov rbx, rax

    pop rbp
    mov rax, 60     ;funktionsnummer: programm beenden
    mov rdi, rbx      ;returncode 0 (rbx = 17)
    syscall

;    Übersetzen:     nasm -f elf64 -g -F dwarf test.asm 
;    Linken:         asdf