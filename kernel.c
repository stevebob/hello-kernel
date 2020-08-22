void putc(char c);
void puts(char* s);

void* __user__start1;
int foo;
int bar = 5;

void _start() {
    puts("Hello, World!\n");
    //__user__start();
    if (__user__start1 == 0) {
        puts("woo\n");
    }
    while(1);
}

void puts(char* s) {
    do {
        putc(*(s++));
    } while (*s);
}
