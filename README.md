# Hello Kernel

Small x64 kernel-mode program that boots with BOOTBOOT and prints "Hello, World!"
over serial. Depends on BOOTBOOT's `mkbootimg` (not the android tool!).
Get it from here: [gitlab.com/bztsrc/bootboot](https://gitlab.com/bztsrc/bootboot/)

## Running

### Linux
```
make run
```

### FreeBSD

```
CC=clang LD=ld.lld gmake run
```

## Debugging

Run the `run-debug` target. Execution (in qemu) will pause until a debugger (gdb) is attached. In a separate terminal, run:

```
$ gdb kernel.elf
(gdb) target remote localhost:1234
(gdb) c
```

Hit ctrl+c to pause execution.
