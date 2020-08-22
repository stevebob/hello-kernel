mmio        = 0xfffffffff8000000;
fb          = 0xfffffffffc000000;
kernel_base = 0xffffffffffe00000;
user_base   = 0x0000000040000000;

user_stack_size = 0x1000;

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
    .user.trampoline : ALIGN(0x1000) {
        *(.user.trampoline)
    } :user
    .user.text : ALIGN(0x1000) {
        *(.user.text)
        *(.user.rodata)
    } :user
    .user.data : ALIGN(0x1000) {
        *(.user.data)
    } :user
    .user.bss (NOLOAD) : ALIGN(0x1000) {
        *(.user.bss)
    } :user
    .user.stack (NOLOAD) : ALIGN(0x1000) {
        user_stack_bottom = .;
        . += user_stack_size;
        user_stack_top = .;
    } :user

    /DISCARD/ : {
        *(.eh_frame)
        *(.comment)
        *(.note.*)
    }
}
