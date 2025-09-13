global ft_strlen

section .text

ft_strlen:
    ; Arguments:
    ; rdi - pointer to the null-terminated string

    xor rax, rax        ; Clear rax to use it as a counter
.loop:
    cmp byte [rdi + rax], 0 ; Compare the current byte with null terminator
    je .done            ; If it's null, we're done
    inc rax             ; Increment the counter
    jmp .loop          ; Repeat the loop
.done:
    ret                 ; Return with the length in rax
