;    Filename:   test.asm
;    Authour:    John Lienau (yourmom@ctemplar.com)
;    Titel:      Erstes Assembler Programm.


GLOBAL _start   ;Startpunkt des Programmes festlegen
SECTION .text   ;in der sektion text steht der Programmcode

_start:
    mov rbx, 0
    mov rcx, 5      ;Anzahl schleifendurchläufe für loop

weiter:         ;das ist ein label, das zb für sprungziele benutzt werden kann
    add rbx, rcx

loop weiter

    mov rax, 60     ;funktionsnummer: programm beenden
    mov rdi, rbx      ;returncode 0 (rbx = 17)
syscall

;    Übersetzen:     nasm -f elf64 -g -F dwarf test.asm 
;    Linken:         asdf