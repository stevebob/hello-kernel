global switch_to_user_mode
extern user_base

section .text
bits 64

switch_to_user_mode:
    mov rcx, user_base
    mov r11, 0x0200
    sysret
