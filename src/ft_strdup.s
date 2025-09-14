; Linux, ELF64, System V AMD64 ABI
; nasm -f elf64

extern ft_strlen
extern ft_strcpy
extern malloc  ; provided by libc (GLIBC)

global ft_strdup

section .text

  ; char *ft_strdup(const char *s);
  ; rdi = s 
ft_strdup:
  push rdi ; save original pointer

  call ft_strlen
  mov rdi, rax 
  inc rdi 
  call malloc wrt ..plt
  cmp rax, 0
  je .malloc_fail ; if NULL, malloc failed
  mov rdi, rax 
  pop rsi ; restore original pointer to rsi 
  call ft_strcpy
  ret



.malloc_fail:
  pop rdi ; restore original pointer
  xor rax, rax ; return NULL
  ret

