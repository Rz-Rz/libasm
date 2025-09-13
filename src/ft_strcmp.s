global ft_strcmp 

section .text

  ; int ft_strcmp(const char *s1, const char *s2);
  ; rdi: rdi = s1, rsi = s2
ft_strcmp:
  xor rax, rax 
  xor r8, r8 
  xor r9, r9

  jmp .loop 

.loop:
  mov r8b, byte [rdi + rax] ; load byte from s1
  mov r9b, byte [rsi + rax] ; load byte from s2
  cmp r8b, 0               ; check if end of s1
  je .end 
  cmp r9b, 0               ; check if end of s2
  je .end
  cmp r8b, r9b            ; compare bytes
  jne .end                 ; if not equal, exit loop
  inc rax                  ; move to next byte 
  jmp .loop

.end:
  sub r8d, r9d ; compute difference, 32 bit is enough
  mov eax, r8d ; move result to eax
  ret
