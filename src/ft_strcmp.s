global ft_strcmp 

section .text

  ; int ft_strcmp(const char *s1, const char *s2);
  ; rdi: rdi = s1, rsi = s2
ft_strcmp:
  xor rax, rax 

.loop:
  movzx ecx, byte [rdi + rax] ; load byte from s1
  movzx edx, byte [rsi + rax] ; load byte from s2
  cmp cl, dl               ; compare bytes
  jne .diff
  test cl, cl
  je .eq
  inc rax
  jmp .loop

.diff:
  mov eax, ecx
  sub eax, edx
  ret

.eq:
  xor eax, eax
  ret
