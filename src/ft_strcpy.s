global ft_strcpy

ft_strcpy:
  ; char *ft_strcpy(char *dest, const char *src);
  ; rdi = dest, rsi = src
    mov     rax, rdi            ; return value = dst

.copy:
    mov     dl, [rsi]           ; dl = *src
    mov     [rdi], dl           ; *dst = dl  (also writes the '\0' when we hit it)
    inc     rsi                 ; src++
    inc     rdi                 ; dst++
    test    dl, dl              ; update flags based on dl
    jnz     .copy               ; if not, keep copying
    ret                         ; rax (dst) already set
