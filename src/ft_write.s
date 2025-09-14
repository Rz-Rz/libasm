extern __errno_location

global ft_write 

section .text
; ssize_t write(int fd, const void *buf, size_t count);
; fd in rdi, buf in rsi, count in rdx
ft_write: 
    mov rax, 1          ; syscall number for sys_write
    syscall             ; invoke the kernel
    test rax, rax       ; 
    js .syscall_error   ; jmp is sign bit is set
    ret

.syscall_error:
    neg rax 
    mov rdi, rax       ; move errno to rdi for __errno_location
    call __errno_location wrt ..plt ; get pointer to errno 
    mov [rax], edi     ; store errno value
    mov rax, -1        ; return -1 to indicate error
    ret

