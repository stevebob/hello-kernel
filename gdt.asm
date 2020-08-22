global install_gdt
global enable_sce
global enable_star

bits 64

section .rodata

gdt64_addr:
dw (gdt64_end - gdt64) - 1       ; gdt size minus 1
dq gdt64                         ; start of gdt

; Global Descriptor Table (64-bit)
align 8
gdt64:

    ; 0x00: NULL Descriptor
    dq 0

    %define .SEGMENT_KERNEL_BASE 0x08
    %define .SEGMENT_KERNEL_CODE 0x08
    ; 0x08: Kernel Code
    dw 0                         ; Limit (low).
    dw 0                         ; Base (low).
    db 0                         ; Base (middle)
    db 10011010b                 ; Access (present/exec/read).
    db 00100000b                 ; Flags 64-bit descriptor
    db 0                         ; Base (high).


    %define .SEGMENT_KERNEL_DATA 0x10
    ; 0x10: Kernel Data
    dw 0                         ; Limit (low).
    dw 0                         ; Base (low).
    db 0                         ; Base (middle)
    db 10010010b                 ; Access (present/read&write).
    db 00100000b                 ; Flags 64-bit descriptor.
    db 0                         ; Base (high).

    %define .SEGMENT_USER_BASE 0x18
    ; 0x18: NULL Descriptor
    dq 0

    ; 0x20: User Code
    dw 0                         ; Limit (low).
    dw 0                         ; Base (low).
    db 0                         ; Base (middle)
    db 10011010b                 ; Access (present/exec/read).
    db 00100000b                 ; Flags 64-bit descriptor
    db 0                         ; Base (high).


    ; 0x28: User Data
    dw 0                         ; Limit (low).
    dw 0                         ; Base (low).
    db 0                         ; Base (middle)
    db 10010010b                 ; Access (present/read&write).
    db 00100000b                 ; Flags 64-bit descriptor.
    db 0                         ; Base (high).
gdt64_end:

section .text

install_gdt:
    ; install new gdt
    lgdt [gdt64_addr]

    ; set segment registers to kernel data segment (all except cs)
    mov ax, .SEGMENT_KERNEL_DATA
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; use far return to load cs with kernel code segment
    o64 pop rdi
    o64 push .SEGMENT_KERNEL_CODE
    o64 push rdi
    o64 retf

enable_sce:
    %define .MSR_EFER 0xC0000080
    mov rcx, .MSR_EFER
    rdmsr
    or eax, 1
    wrmsr
    ret

enable_star:
    %define .MSR_STAR 0xC0000081
    mov rcx, .MSR_STAR
    rdmsr
    mov edx, (.SEGMENT_USER_BASE << 16 | .SEGMENT_KERNEL_BASE)
    wrmsr
    ret
