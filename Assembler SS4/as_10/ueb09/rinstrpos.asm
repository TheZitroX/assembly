;   file-name:      rinstrpos.asm
;   titel:          String searcher
;   author:         John Lienau
;					Tobias Pinnau
;   version:        v1.1
;   date:           31.05.2022
;   copyright:      Copyright (c) 2022

;   brief:          Checks a strings for a character with an index

Global rinstrpos, rinstr ;_start

;SECTION .stack
;SECTION  .bss
;SECTION .data
;	s1 db 5, 'Hallo',0
;	s2 db 'l',0
;	SECTION .text

;rdi - in: Startposition 
;rsi - in: zeiger auf den String
;rdx - in: zu suchendes Zeichen
; rax - out: gefundene position (0 = nicht gefunden)
rinstrpos:

;_start:

push rbp
mov rbp, rsp
push rcx
push rdi
push r14

;mov rdi ,5
;mov rsi, s1
;mov rdx, [s2]

mov rcx , rdi

xor rax, rax
weiterSuchen:
mov r14b, [rsi + rcx]
cmp r14, rdx
je gefunden
dec rcx
cmp rcx, 1
jl ende
jmp weiterSuchen

gefunden:
mov rax, rcx - 1

ende:


pop r14
pop rdi
pop rcx
mov rsp,rbp
pop rbp
ret


;rdi - in: Hauptsring
;rsi - in: zu suchendes Zeichen
; rax - out: gefundene position (0 = nicht gefunden)
rinstr:
;_start:
;mov rdi, s1
;xor rsi, rsi
;mov sil, [s2]
push rdx

mov rdx, rsi
mov rsi, rdi
xor rdi, rdi
mov dil, [rsi] ; rdi

call rinstrpos

pop rdx
ret

