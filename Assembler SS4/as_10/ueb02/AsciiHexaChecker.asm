;   file-name:      AsciiHexaChecker.asm
;   titel:          ASCII Range Checker
;   author:         John Lienau (yourmom@ctemplar.com)
;   version:        v1.0
;   date:           29.04.2022
;   copyright:      Copyright (c) 2022

;   brief:          Checks the Ascii range for a hexadecimal number

global _start
section .text

_start:
    mov al, 'G' ;start al = "A"
    mov dl, 10  ;multiplicator

;check for range and convert to decimal
;==================================================
    ;check for al is '0'..'9'
    cmp al, '0' ;is al below '0' then not a hex
    jl end

    cmp al, '9' ;is al less/equal to '9'
    jle isNumber

    ;check for is 'A'..'F'
    cmp al, 'F' ;is al above 'F' then not a hex
    jg end
    ;is al less then 'A' then not a hex
    cmp al, 'A'
    jl end

    ;al is 'A'..'F' -> al -= 7
    sub al, 7

isNumber:
    sub al, 0x30 ;convert to decimal
;==================================================


;multiply and split values to al and bl
;==================================================
    mul dl ;multiply ax with dl
    mov bl, al ;copy al
    ;remove every other bits from al without 4 righ
    and al, 0b00001111

    shr bl, 4 ;get the 4 of left bits to rightside
    and bl, 0b00001111
;==================================================


;convert al number to ascii
;==================================================
    ;check num or hex
    cmp al, 9 ;if less/qual do 9 -> number
    jle alConvertIsNumber

    ;add 7 to get the ascii-hex range
    add al, 7

alConvertIsNumber:
    add al, 0x30 ;now in ascii range
;==================================================


;convert bl number to ascii
;==================================================
    ;check num or hex
    cmp bl, 9 ;if less/qual do 9 -> number
    jle blConvertIsNumber

    ;add 7 to get the ascii-hex range
    add bl, 7

blConvertIsNumber:
    add bl, 0x30 ;now in ascii range
;==================================================


;copy bl to ah
;==================================================
    shl bx, 8
    or ax, bx
;==================================================

; ===> Fist Hex in "ah" Second Hex in "al"
;print with "p/c $ah ($al)"

;end program
end:
    mov rax, 60     ;functionNum: programm end
    mov rdi, 0      ;return 0
    syscall