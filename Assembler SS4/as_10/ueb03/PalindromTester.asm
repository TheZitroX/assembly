;   file-name:      PalindromTester.asm
;   titel:          Palindrom Tester
;   author:         John Lienau (yourmom@ctemplar.com)
;					Tobias Pinnau
;   version:        v1.0
;   date:           10.05.2022
;   copyright:      Copyright (c) 2022

;   brief:          Checks a string of beeing a palidrom

GLOBAL _start

SECTION .data

	zeichenKette db 'Lage* -rre-+ .,gal  '
	zeichenKetteLenge EQU ($ - zeichenKette)
	AsciiDiff EQU 'a' - 'A'

SECTION .text

	_start:
		mov rsi, 0
		mov rdx, zeichenKetteLenge - 1

	; wenn nicht weiterspringen falls zeichen kette noch nicht vorbei sonst ende
	istZeichenA:
		mov r8b, [zeichenKette + rsi]
		mov r9b, [zeichenKette + rdx]


		CMP r8b,'A'	
		JL weiterZaelen1

		CMP r8b,'Z'	
		jle istZeichenE
		
		CMP r8b,'a'	
		JL weiterZaelen1

		CMP r8b,'z'	
		JG weiterZaelen1
		
		sub r8b , AsciiDiff
		
		jmp istZeichenE
		
	weiterZaelen1:
		add rsi,1
		jmp speicherKompletGelesen

	; wenn nicht weiterspringen falls zeichen kette noch nicht vorbei sonst ende
	istZeichenE:
		CMP r9b,'A'	
		JL weiterZaelen2

		CMP r9b,'Z'	
		jle istGleichesZeichen
		
		CMP r9b,'a'	
		JL weiterZaelen2

		CMP r9b,'z'	
		JG weiterZaelen2
		
		sub r9b , AsciiDiff
		
		jmp istGleichesZeichen
		
	weiterZaelen2:
		sub rdx,1
		jmp speicherKompletGelesen

	; alle 3 varianten testen
	istGleichesZeichen: 	
		cmp r8b, r9b
		je istRichtig
		
		mov rax, 0
		jmp ende
		
	; rax setzen +zeichenEnde +zeichenBeginn
	istRichtig:
		mov rax, 1
		add rsi, 1
		sub rdx, 1
		
	;überprüfen und von vorne anfangen
	speicherKompletGelesen:	
		cmp rsi, rdx
		jl istZeichenA
		
	ende:
		mov rax,60
		mov rdi,0
		SYSCALL
