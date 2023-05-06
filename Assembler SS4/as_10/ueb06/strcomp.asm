;   file-name:      strcomp.asm
;   titel:          String compare
;   author:         John Lienau
;					Tobias Pinnau
;   version:        v1.1
;   date:           31.05.2022
;   copyright:      Copyright (c) 2022

;   brief:          Checks two strings for being in enthalten

GLOBAL _start

SECTION .stack
SECTION .data
	s1 db 5, 'Hallo'
	s2 db 10, 'llld Hallo'
	
SECTION .text


strcmp:
	push RBP
	mov RBP, RSP
	sub RSP,16
	

	xor rsi, rsi
	xor rdi, rdi
	xor r8, r8
	xor r9, r9
	mov rsi, r14
	mov rdi, r15

	mov r10b, byte[rsi]
	mov r11b, byte[rdi]
	cmp r10b, r11b
	jg notFound
	
	add rsi, 1
	add rdi, 1

	xor rcx, rcx
	jmp ersterDurchlauf

	false:
	  	sub rcx, r10
	 	add r11, rcx
		cmp r10b, r11b
		jg notFound

		mov rsi, r14
		add rsi, 1
	ersterDurchlauf:
		xor rcx, rcx
		mov cl, r10b
		cld
		repe cmpsb

	jnz false
	mov al, byte[r15] 
	sub rax, r11
	add rax, 1
	jmp end

	notFound:
		xor rax, rax

	end:
		mov rsp,rbp
		pop rbp
		ret
	
_start:
	mov r14, s1
	mov r15, s2
	CALL strcmp
	
ende:
	mov rax, 60
	mov rdi, 0
	SYSCALL
