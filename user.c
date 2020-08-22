int x;
int y = 42;

void foo() {
    x=0x1234;
    for (int i = 0; i < x; i++);
}

void _start() {
    foo();
    while(y);
}
