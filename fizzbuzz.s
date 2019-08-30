    .file "fizzbuzz.s"

    .section .rodata

# strings and corresponding lengths
fizz_num = 3
fizz_string:
    .ascii "fizz"
fizz_string_length = 4
buzz_num = 5
buzz_string:
    .ascii "buzz"
buzz_string_length = 4
comma_space:
    .ascii ", "
comma_space_length = 2

# conversion stuff
zero:
    .ascii "0"

# maximum number to count to
max=100
# syscall data
exit_syscall = 60
write_syscall = 1
stdout = 1

    .section .bss
# static buffers
int_to_string_buffer:
    .skip 10
int_to_string_buffer_end:

    .text
    .globl _start

_start:
    mov $max, %edi # gets extended to %rdi, implicitly
    call fizzbuzz

    mov %rax, %rdi # exit
    mov $exit_syscall, %eax
    syscall

    .type fizzbuzz, @function
# fizzbuzz: edi = maxmum to count to
fizzbuzz:
    mov %edi, %esi # esi = max
    mov $1, %edi # edi = 1

.Lfizzbuzz_loop_start:
    cmp %edi, %esi # while %edi <= max
    jl .Lfizzbuzz_loop_end

    cmp $1, %edi # if %edi != 1, display comma-space
    je .Lfizzbuzz_no_comma_space
    push %rdi
    push %rsi
    call display_comma_space
    pop %rsi
    pop %rdi
.Lfizzbuzz_no_comma_space:

    xor %cl, %cl # default flag is false

    # fizz - if divisible by fizz_num, print fizz, set cl
    xor %edx, %edx
    mov %edi, %eax
    mov $fizz_num, %r8d
    idiv %r8d
    and %edx, %edx
    jnz .Lfizzbuzz_not_fizz
    push %rdi
    push %rsi
    call display_fizz
    pop %rsi
    pop %rdi
    mov $1, %cl
.Lfizzbuzz_not_fizz:

    # buzz - if divisible by buzz_num, print buzz, set cl
    xor %edx, %edx
    mov %edi, %eax
    mov $buzz_num, %r8d
    idiv %r8d
    and %edx, %edx
    jnz .Lfizzbuzz_not_buzz
    push %rdi
    push %rsi
    call display_buzz
    pop %rsi
    pop %rdi
    mov $1, %cl
.Lfizzbuzz_not_buzz:

    # else - if not default, display int
    and %cl, %cl
    jnz .Lfizzbuzz_no_default
    push %rdi
    push %rsi
    call display_int
    pop %rsi
    pop %rdi
.Lfizzbuzz_no_default:
    
    inc %edi
    jmp .Lfizzbuzz_loop_start
.Lfizzbuzz_loop_end:

    xor %rax, %rax # return
    ret

    .type display_int, @function
# display_int: edi = integer to display, > 0, <= UINT_MAX
display_int:
    xor %rcx, %rcx # length = 0
    mov $int_to_string_buffer_end, %r8 # r8 = current byte to write
    dec %r8

.Ldisplay_int_loop_start:
    and %edi, %edi # while edi > 0
    jz .Ldisplay_int_loop_end

    xor %edx, %edx # divide and modulo
    mov %edi, %eax

    mov $10, %edi
    
    idiv %edi
    
    mov %eax, %edi # eax / 10 is moved to edi
    
    add (zero), %dl # (dl % 10) + '0' is moved to the buffer - single byte operation, never overflows
    mov %dl, (%r8)
    
    inc %rcx # buffer is long enough that it will never overflow
    dec %r8

    jmp .Ldisplay_int_loop_start
.Ldisplay_int_loop_end:

    mov $write_syscall, %eax
    mov $stdout, %edi
    inc %r8
    mov %r8, %rsi
    mov %rcx, %rdx
    syscall

    ret # return void

# display ", "
display_comma_space:
    mov $write_syscall, %eax
    mov $stdout, %edi
    mov $comma_space, %rsi
    mov $comma_space_length, %rdx
    syscall
    ret # return void

# display "fizz"
display_fizz:
    mov $write_syscall, %eax
    mov $stdout, %edi
    mov $fizz_string, %rsi
    mov $fizz_string_length, %rdx
    syscall
    ret # return void

# display "buzz"
display_buzz:
    mov $write_syscall, %eax
    mov $stdout, %edi
    mov $buzz_string, %rsi
    mov $buzz_string_length, %rdx
    syscall
    ret # return void
