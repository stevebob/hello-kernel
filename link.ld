mmio        = 0xfffffffff8000000;
fb          = 0xfffffffffc000000;
kernel_base = 0xffffffffffe00000;
user_base   = 0x0000000080000000;

PHDRS {
  boot PT_LOAD;
  user PT_LOAD;
}

SECTIONS {
    . = kernel_base;

    bootboot = .;
    . += 0x1000;

    environment = .;
    . += 0x1000;

    .text : {
        *(.text)
        *(.rodata)
    } :boot
    .data : ALIGN(0x1000) {
        *(.data)
    } :boot
    .bss (NOLOAD) : ALIGN(0x1000) {
        *(.bss)
    } :boot

    . = user_base;
    . = ALIGN(0x1000);
    user_text_start = .;
    .user.text : {
        *(.user.text)
        *(.user.rodata)
    } :user
    . = ALIGN(0x1000);
    user_text_end = .;
    user_data_start = .;
    .user.data : {
        *(.user.data)
    } :user
    . = ALIGN(0x1000);
    user_data_end = .;
    user_bss_start = .;
    .user.bss (NOLOAD) : {
        *(.user.bss)
    } :user
    . = ALIGN(0x1000);
    user_bss_end = .;

    /DISCARD/ : {
        *(.eh_frame)
        *(.comment)
        *(.note.*)
    }
}
