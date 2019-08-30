    .file "fizzbuzz.s"

    .section .rodata
# maximum number to count to
max:
    .long 100
# syscall numbers
exit_syscall:
    .long 60

    .text
    .globl _start
_start:
    mov %rsp, %rbp # setup stack frame
    mov (max), %edi # gets extended to %rdi, implicitly
    call main
    mov %rax, %rdi # move return address for syscall
    mov (exit_syscall), %rax # exit systcall
    syscall

main:
    mov $1, %rax
    ret
