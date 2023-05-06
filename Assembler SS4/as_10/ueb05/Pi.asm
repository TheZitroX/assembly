;   file-name:      Pi.asm
;   titel:          Pi ist Toll
;   author:         John Lienau
;					Tobias Pinnau
;   version:        v1.0
;   date:           17.05.2022
;   copyright:      Copyright (c) 2022

;   brief:          Versucht Pi zu berechnen
GLOBAL _start

Extern printf
Extern scanf

SECTION .stack
SECTION .data
	MaxDurchlaufe EQU 5000000
	summe dq 0.0
	teiler dq 1
	s1 db 'Die Zahl ist : %f',10,0
	
SECTION .text


piUnterprogram:
	push RBP
	mov RBP, RSP
	sub RSP,16
	
	;locale variablen
	mov qword[RBP-8], 4
	mov qword[RBP-16], 1
	
	;loop durch die Max durchlaufe
	FINIT
	FLD qword[summe]
	
	; for schleifen durchlaufe
	mov rcx, MaxDurchlaufe
	for:
		; berechnung
		FLD1
		FILD qword[RBP-16]
		FDIV
		FADD

		;+2 * -1
		cmp qword[RBP-16],0
		jl isnegative
		
		add qword[RBP-16],2
		neg qword[RBP-16]
		jmp endInc
		
		isnegative:
		neg qword[RBP-16]
		add qword[RBP-16],2
		
		endInc:
	loop for
	
	;*4
	FILD qword[RBP-8]	
	FMUL
	
	FST qword[summe]
	
	mov rsp,rbp
	pop rbp
	ret
	

_start:
	
	CALL piUnterprogram
	
	mov rdi, s1
	MOV RAX,1
	MOVSD XMM0,[summe]
	CALL printf
	
	;ueberpruefung
	FINIT
	FLDPi
	FSTP qword[summe]
	mov rdi, s1
	MOV RAX,1
	MOVSD XMM0,[summe]
	CALL printf

ende:
	mov rax,60
	mov rdi,0
	SYSCALL
