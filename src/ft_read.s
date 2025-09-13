; ft_read.s - linux x86_64 
; ssize_t ft_read(int fd, void *buf, size_t count); 

default rel

global ft_read

extern __errno_location

section .text

ft_read:
    ; Input: rdi = fd, rsi = buf, rdx = count
    ; Output: rax = number of bytes read or -1 on error
  mov rax, 0 ; __NR_read on linux x86_64
  syscall ; rax = bytes read (>=0) or rax = errno (=<0)
  
  test rax, rax ; bitwise AND to update flags   (sign flag)
  jns .ok  ; rax >= 0, no error

  ; error: RAX = -errno 
  neg rax ; flip the sign to get positive errno
  push rax ; save errno on stack 
  call __errno_location wrt ..plt ; return a pointer to thread-local errno in rax
  pop rdx ; get errno back from stack to rdx
  mov dword [rax], edx ; store errno value in *errno
  mov rax, -1 ; return -1 to indicate error
  ret



.ok:
  ret

section .note.GNU-stack noalloc
