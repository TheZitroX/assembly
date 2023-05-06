#!/bin/sh

# file:         compiler.sh
# title:        FASTER COMPILER
# author:       John Lienau
# version:      v1.1
# date:         31.05.2022
# copyright:    Copyright (c) 2022

# brief:        Use: ./compiler.sh <asm-name(OHNE .asm!)>
#               uses printf

[ $# -ne 1 ] && echo 'ERROR: missing filename!' && exit 1

nasm -f elf64 -g -F dwarf "$1.asm"
ld -I/lib64/ld-linux-x86-64.so.2 -lc -o $1 "$1.o"
gdb $1
