;   file-name:      PalindromUnterprogramm.asm
;   titel:          Palindrom Tester
;   author:         John Lienau
;					Tobias Pinnau
;   version:        v1.1
;   date:           17.05.2022
;   copyright:      Copyright (c) 2022

;   brief:          Checks a string of beeing a palidrom

GLOBAL _start
SECTION .data	
SECTION .stack
SECTION  .bss
	EingabePuffer resb 51

SECTION .text
	textTrue db 'Die eingabe ist ein Palindrom',10, 0
	textFalse db 'Die eingabe ist kein Palindrom',10,0
	textEingabe db 'Bitte geben sie das zu ueberpruefende Palindrom mit biszu 50 Zeichen an',10,0
	AsciiDiff EQU 'a' - 'A'
	MaxEingabe EQU 50

	Eingabe:
		push rbp
		mov rbp, rsp

			mov rax, 0 
			mov rdi, 1
			mov rsi, EingabePuffer
			mov rdx, MaxEingabe
			SYSCALL
			
		mov rsp,rbp
		pop rbp
		ret



	laenge:	
		xor rax, rax
		.startloop:
		cmp byte[rsi + rax],0
		je .end
		inc rax
		jmp .startloop
		.end:
	ret

	ausgabe:	
		push rbp
		mov rbp, rsp

		push rax
		push rdi
		push rsi
		push rdx
		push r11
		push rcx
		
			; Textlänge ermitteln
			mov rsi, [rbp + 16]
			call laenge
			mov rdx, rax
			
			;schreiben
			mov rax, 1
			mov rdi, 1
			SYSCALL
			
		pop rcx
		pop r11
		pop rdx
		pop rsi
		pop rdi
		pop rax
			
		mov rsp,rbp
		pop rbp
		ret



	istZeichen:
		push rbp
		mov rbp, rsp
			
			CMP r12b,'A'	
			JL Nop

			CMP r12b,'Z'	
			jle Jap
			
			CMP r12b,'a'	
			JL Nop

			CMP r12b,'z'	
			JG Nop
			
			sub r12b , AsciiDiff
			
		Jap:
		; r15 als rückgabe wert
		mov r15,1
			
		mov rsp,rbp
		pop rbp
		ret
		Nop:
		; r15 als rückgabe wert
		mov r15,0
		
		mov rsp,rbp
		pop rbp
		ret
		
_start:
		
	EingabeStart:
		push textEingabe
		call ausgabe
	
		call Eingabe
		; rax ist rückgabe vom eingabe SYSCALL und giebt eingelesene Zeichen an
		sub rax,1
		mov rdx, rax
			
	EinlesenEnde:
		mov rsi, 0
	
	ZeichenueberpruefungStart:
		mov r8b, [EingabePuffer + rsi]
		mov r9b, [EingabePuffer + rdx]

		; parameterübergabe
		mov r12,r8
		call istZeichen
		; parameter rücknahme
		mov r8,r12
		; ueberpruefung des Ruekgabewertes
		cmp r15,1
		je istZeichenEnde
		; kein Gueltiges Zeichen
		add rsi,1
		jmp speicherKompletGelesen

	istZeichenEnde:
		;parameterübergabe
		mov r12,r9
		call istZeichen
		;parameter rücknahme
		mov r9,r12
		; ueberpruefung des Ruekgabewertes
		cmp r15,1
		je istGleichesZeichen
		; kein Gueltiges Zeichen
		sub rdx,1
		jmp speicherKompletGelesen

	istGleichesZeichen: 
		; beide Buchstaben auf gleichheit ueberpruefen
		cmp r8b, r9b
		je istRichtig
		
		mov rax, 0
		jmp istKeinPalyndrom
		
	istRichtig:
		; rax setzen +zeichenEnde -zeichenBeginn fuer naechstes Zeichen
		mov rax, 1
		add rsi, 1
		sub rdx, 1
	
	speicherKompletGelesen:	
		;überprüfen und von vorne anfangen
		cmp rsi, rdx
		jl ZeichenueberpruefungStart
		
	istPalyndrom:
		push textTrue
		call ausgabe
		jmp ende
		
	istKeinPalyndrom:
		
		push textFalse
		call ausgabe
	

ende:
	mov rax,60
	mov rdi,0
	SYSCALL
