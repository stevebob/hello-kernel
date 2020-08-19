void putc(char c);
void puts(char* s);

void __user__start();

void _start() {
    puts("Hello, World!\n");
    __user__start();
    while(1);
}

void puts(char* s) {
    do {
        putc(*(s++));
    } while (*s);
}
