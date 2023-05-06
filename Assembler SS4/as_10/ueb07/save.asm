;   file-name:      save.asm
;   titel:          Element-list
;   author:         John Lienau
;					Tobias Pinnau
;   version:        v1.1
;   date:           14.06.2022
;   copyright:      Copyright (c) 2022

;   brief:          Fügt sortiert Elemente ein

; nasm -f elf64 -g -F dwarf %f; ld -I/lib64/ld-linux-x86-64.so.2 -lc -o %e %e.o

GLOBAL _start

EXTERN printf
EXTERN malloc

SECTION .stack

SECTION .data
	Anzahl EQU 15
	; Knoten:
	; Wert: qword
	; Next: qword
	LaengeKnoten EQU 16
	EinfuegeZahlen dq 0,5, 1 , 17 ,15
	EinfuegeZahlenLaenge EQU ($-EinfuegeZahlen)
	LoeschZahlen dq 1,0,2,8,15,17,8
	LoeschZahlenLaenge EQU ($-LoeschZahlen)

SECTION .text

; Parameter:
; in/out: R12 - Zeiger auf den Listenanfang
; in: R13 - einzufuegende Zahl
ElementEinfuegen: ; am Listenanfang
	ENTER 0,0
	PUSH RAX
	PUSH RCX ; wird überschrieben durch malloc
	PUSH RDI

  ; neuen Knoten erzeugen:
	MOV RDI,LaengeKnoten
	CALL malloc ; zurück RAX: Zeiger auf neuen Knoten
	MOV qword[RAX],R13 ; Wert in den neuen Knoten
	MOV qword[RAX+8],0 ; Next auf NIL

	CMP R12,0 ; Liste leer?
	JE .nil
	MOV qword[RAX+8],R12 ; sonst Next auf vorherigen ersten Knoten

  	.nil:
		MOV R12,RAX ; immer: Listenanfang auf neuen Knoten

  	.ende:
		POP RDI
		POP RCX
		POP RAX
		LEAVE
		RET ; ElementEinfuegen

; Parameter:
; in: R12 - Zeiger auf den Listenanfang
ListeAusgeben:
	ENTER 0,0
	PUSH RAX ; sonst Segmentation fault (printf)
	PUSH RDI
	PUSH RSI
	PUSH R14
	MOV R14,R12 ; Runpointer 

  	.startloop:
		CMP R14,0 ; Liste zu ende?
		JE .nil 
		MOV RDI,formatstring ; für printf
		MOV RSI,[R14] ; Zahl ausgeben       
		CALL printf
		MOV R14,[R14+8] ; run:=run^.next
		JMP .startloop

  	.nil:
		MOV RDI,formatstring2
		CALL printf
		POP R14
		POP RSI
		POP RDI
		POP RAX
		LEAVE
		RET

formatstring db 'Zahl = %i',10,0 ; Variablen im Textsegment!
formatstring2 db 'Fertig',10,0
; Ende ListeAusgeben


; Parameter:
; in/out: R12 - Zeiger auf den Listenanfang
; in: R13 - einzufügende Zahl
ElementSortiertEinfuegen:
	ENTER 0,0
	PUSH RAX
	PUSH RCX ; wird überschrieben durch malloc
	PUSH RDI
	push r14
	push r13
	push r15
	mov r15, r12
	
	cmp r15,0 ;leere liste?
	je .einfuegenanfang
	
	.anfang:
		;ueberpruefung sonst weiter springen
		cmp R13, [r15]
		jle .einfuegenanfang
		
		mov r14, [r15+8] ; ein Zeiger weiter
		
		cmp r14 ,0
		je .einfuegen
		cmp R13, [r14]
		jle .einfuegen
		
		mov r15, [r15 + 8] 
		jmp .anfang

	; "normal" einfuegen
	.einfuegen:
		MOV RDI,LaengeKnoten
		CALL malloc ; zurück RAX: Zeiger auf neuen Knoten
		MOV qword[RAX],R13 ; Wert in den neuen Knoten
		MOV qword[RAX+8],r14 ; Next auf zeiger next
		mov [r15 + 8], RAX  ; zuweisung des neuen Zeigers
		jmp .endee

	;anfang einfuegen
	.einfuegenanfang:
		MOV RDI,LaengeKnoten
		CALL malloc ; zurück RAX: Zeiger auf neuen Knoten
		MOV qword[RAX],R13 ; Wert in den neuen Knoten
		MOV qword[RAX+8],r15 ; Next Zeiger
		mov r12,rax
		
		jmp .endee

	;einfuegen
	.endee:
		pop r15
		pop r13
		pop r14
		POP RDI
		POP RCX
		POP RAX
		LEAVE
		RET ; ElementSortiertEinfuegen

; Parameter:
; in/out: R12 - Zeiger auf den Listenanfang
; in: R13 - zu löschende Zahl
ElementLoeschen: ; Erstes Vorkommen der Zahl löschen
	ENTER 0,0
	PUSH RAX
	PUSH RCX ; wird überschrieben durch malloc
	PUSH RDI
	push r14
	push r13
	push r15
	mov r15, r12
	
	cmp r15,0 ;leere liste?
	je .vorbei
	
	.beginnn:
		mov r14, [r15+8] ; ein Zeiger weiter
		
		;ueberpruefung sonst weiter springen
		cmp R13, [r15]
		je .loeschenStart
	
		cmp r14 ,0
		je .vorbei
		cmp R13, [r14]
		je .loeschenZwei
		
		mov r15, [r15 + 8] 
		jmp .beginnn
		; "normal" einfuegen

	.loeschenZwei:
		mov r14, [r14+8]
		mov [r15 + 8], r14  ; Zeiger mit nächstem überschreiben
		jmp .vorbei

	;anfang einfuegen
	.loeschenStart:
		mov r12, r14 ; Zeiger mit nächstem überschreiben
		jmp .vorbei

	;einfuegen
 	.vorbei:
		pop r15
		pop r13
		pop r14
		POP RDI
		POP RCX
		POP RAX
		LEAVE
		RET ; ElementLoeschen

_start:	; main
	XOR R12,R12 ; R12 Zeiger auf den Anfang der Liste := nil (0)
  ; Liste aufbauen:
	MOV RCX,Anzahl
  	bauauf:
		MOV R13,RCX ; einzufügende Zahl
		CALL ElementEinfuegen
		LOOP bauauf

		CALL ListeAusgeben
		
	; Neue Elemente sortiert einfügen:
		XOR RAX,RAX

  	fuegein:
		MOV R13,[EinfuegeZahlen+RAX] ; einzufügende Zahl
		CALL ElementSortiertEinfuegen
		ADD RAX,8
		CMP RAX,EinfuegeZahlenLaenge
		JNE fuegein

		CALL ListeAusgeben

	; Elemente löschen:
		XOR RAX,RAX

  	loesch:
		MOV R13,[LoeschZahlen+RAX] ; zu löschende Zahl
		CALL ElementLoeschen
		ADD RAX,8
		CMP RAX,LoeschZahlenLaenge
		JNE loesch

		CALL ListeAusgeben
		
	; alle restlichen Elemente raus:
		MOV RCX,Anzahl + 5 ; 

  	raus:
		MOV R13,RCX ; zu löschende Zahl
		CALL ElementLoeschen
		loop raus

		CALL ListeAusgeben

	MOV RAX,60  
	MOV RDI,0   
	SYSCALL