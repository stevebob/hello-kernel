extern __user__start
section .user.trampoline
bits 64
call __user__start
