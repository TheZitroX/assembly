;   file-name:      bild.asm
;   titel:          Bild
;   author:         John Lienau (yourmom@ctemplar.com)
;					Tobias Pinnau
;   version:        v1.0
;   date:           12.06.2022
;   copyright:      Copyright (c) 2022

;   brief:          ein Bild auf den Framebuffer ausgeben


; nasm -f elf64 -g -F dwarf %f; ld -I/lib64/ld-linux-x86-64.so.2 -lc -o %e %e.o

GLOBAL _start

EXTERN printf
EXTERN malloc

SECTION .stack

SECTION .data
	
	fileFB db '/dev/fb0',0 	; der framebufer
	fbLaenge equ 1920
	fbhoehe equ 1080
	pixelFB equ fbLaenge*fbhoehe 
	grueseFB equ pixelFB * 4
	
	filenameMAP db 'img.data',0  ; die zu lesende datei
	laenge EQU 100 ; leange des Datensatzes
	laengePixel equ laenge*4
	hoehe equ 100 ; breite des Datensatzes
	pixel equ laenge*hoehe
	groese equ pixel*3; groeße des Gebrauchten speichers
	
	laengeRest equ fbLaenge-laenge
	laengeRestPixel equ laengeRest*4

SECTION .text

_start:	; main

; Datei öffnen MAP:
	mov rax, 2 ; oeffnen
	mov rdi, filenameMAP
	mov rsi, 0	; readonly
	mov rdx,0
	SYSCALL
	; in rax dateideskriptor
	mov r8,rax
	
; datei mappen MAP:
	mov rax,9 	; mmap
	mov rdi,0	; Adresse von os ausgegeben
	mov rsi,groese ; datei groesse
	mov RDX, 1	;read only
	mov R10,2	;Private
	mov R9,0	;offset 0
	SYSCALL
	; Zeiger auf Bild datei
	mov r12,rax
	
; Datei öffnen FB:
	mov rax, 2 ; oeffnen
	mov rdi, fileFB
	mov rsi, 2	; read and write
	mov rdx,0
	SYSCALL
	; in rax dateideskriptor
	mov r8,rax
	
; datei mappen FB:
	mov rax,9 	; mmap
	mov rdi,0	; Adresse von os ausgegeben
	mov rsi,grueseFB ; datei groesse
	mov RDX, 3	;read and write
	mov R10,1	;Shared paraleles arbeiten
	mov R9,0	;offset 0
	SYSCALL
	; Zeiber auf Framebuffer
	mov r11,rax
	
; frambuffer beschreiben
	mov rdi,0
	mov r14,0
	mov rcx,pixel
	jmp ueberspringen
	
zeilenumbruch:
	add rdi, laengeRestPixel
	

ueberspringen:
	mov r13, 0
	
startloob:
	xor r15, r15
	mov r15w,[r12+r14]
	shl r15, 8
	add r14, 2
	mov r15b, [r12+r14]
	add r14, 1
	
	mov dword[r11+rdi], r15d ; schreiben der datei in den framebuffer
	add rdi, 4
	add r13, 4

;	cmp r14, groese
;	jg ende
	
	cmp r13, laengePixel
	jge zeilenumbruch
	
	loop startloob


ende:
; Datei schliessen???
	mov rax,3
	; ab hier war es nicht mehr beschrieben :D
	mov rdi, r12
	SYSCALL

	MOV RAX,60  
	MOV RDI,0   
	SYSCALL
		

