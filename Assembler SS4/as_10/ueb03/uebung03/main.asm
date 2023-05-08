global _start

section .data
    array   dw 3, 6, 8, 55, 2, 257, 254, 0
    ; array_len equ $ - array
    array_len   dq 0
    median      dq 0
    i           dq 0
    j           dq 0

section .text
    _start:
        xor rax, rax ; index
        ; calc length of array
        for_each_element:
            cmp word [array + rax], 0
            je end_loop
            add rax, 1
            jmp for_each_element
        end_loop:
            mov qword [array_len], rax


        ; sort array
        mov rax, [array_len]
        for_each_element2:
            sub rax, 1
            cmp rax, 0
            jl end_loop2

            xor rbx, rbx
            for_each_element3:
                add rbx, 1
                cmp rbx, rax
                jg end_loop3

                ; if (array[j - 1] <= array[j])
                mov cx, word [array + rbx]
                cmp word [array + rbx - 1], cx
                jle end_loop3

                mov dx, word [array + rbx - 1]
                mov word [array + rbx - 1], cx
                mov rcx, rdx

            end_loop3:
                jmp for_each_element2
        end_loop2:

        ; check gerade oder ungerade
        mov rax, array_len
        mov rcx, array_len
        shr rcx, 1
        rcr rax, 1
        jc ungerade
        ;gerrade
            mov ax, word [array + rcx]
            mov bx, word [array + rcx - 1]
            add rax, rbx
            shr rax, 1
            mov [median], rax
            jmp end

        ungerade:
            xor ax, ax
            mov ax, word [array + rcx + 1]
            mov [median], rax

    end:
        mov rax, 60
        mov rdi, 0
        syscall