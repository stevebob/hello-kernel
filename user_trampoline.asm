extern __user__start
extern user_stack_top
section .user.trampoline
bits 64
mov rsp, user_stack_top
jmp __user__start
