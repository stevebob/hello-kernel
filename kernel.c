void putc(char c);
void puts(char* s);
void enable_sce();
void enable_star();
void switch_to_user_mode();
void install_gdt();

int foo;
int bar = 5;

void _start() {
    puts("Hello, World!\n");
    puts("Installing GDT\n");
    install_gdt();
    puts("Done!\n");
    puts("Enabling SCE...\n");
    enable_sce();
    puts("Done!\n");
    puts("Enabling STAR...\n");
    enable_star();
    puts("Done!\n");
    puts("Switching to user mode...\n");
    switch_to_user_mode();
    while(1);
}

void puts(char* s) {
    do {
        putc(*(s++));
    } while (*s);
}
