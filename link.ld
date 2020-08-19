mmio        = 0xfffffffff8000000;
fb          = 0xfffffffffc000000;
kernel_base = 0xffffffffffe00000;
user_base   = 0x0000000008000000;

SECTIONS {
    . = kernel_base;

    bootboot = .;
    . += 0x1000;

    environment = .;
    . += 0x1000;

    .text : {
        *(.text)
        *(.rodata)
    }
    .data : ALIGN(0x1000) {
        *(.data)
    }
    .bss (NOLOAD) : ALIGN(0x1000) {
        *(.bss)
    }
    /DISCARD/ : {
        *(.eh_frame)
        *(.comment)
    }

    . = user_base;
    .user.text : {
        *(.user.text)
        *(.user.rodata)
    }
    .user.data : ALIGN(0x1000) {
        *(.user.data)
    }
    .user.bss (NOLOAD) : ALIGN(0x1000) {
        *(.user.bss)
    }
    /DISCARD/ : {
        *(.user.debug_*)
        *(.user.note.*)
        *(.user.comment)
        *(.user.eh_frame)
    }
}
