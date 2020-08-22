void putc(char c);
void puts(char* s);

int foo;
int bar = 5;

void _start() {
    puts("Hello, World!\n");
    while(1);
}

void puts(char* s) {
    do {
        putc(*(s++));
    } while (*s);
}
