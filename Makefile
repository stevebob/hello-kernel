CC ?= clang
NASM ?= nasm
LD ?= ld
STRIP ?= strip
OBJCOPY ?= objcopy
MKBOOTIMG ?= mkbootimg
QEMU ?= qemu-system-x86_64

CFLAGS = -Werror -Wall -fpic -ffreestanding -fno-stack-protector -nostdinc -nostdlib -g

.PHONY: all clean run run-graphical strip

all: kernel.elf

clean:
	rm -f *.o *.img *.elf

run: kernel.img
	$(QEMU) -drive file=$^,format=raw -serial stdio -display none

run-graphical: kernel.img
	$(QEMU) -drive file=$^,format=raw -serial stdio

run-debug: kernel.img
	$(QEMU) -drive file=$^,format=raw -serial stdio -display none -s -S

kernel.elf: kernel.c putc.asm link.ld user.elf
	$(CC) $(CFLAGS) -mno-red-zone -c kernel.c -o kernel.o
	$(NASM) -f elf64 putc.asm -o putc.o
	$(LD) -nostdlib -nostartfiles -T link.ld kernel.o putc.o user.elf -o $@
	$(STRIP) -s -K mmio -K fb -K bootboot -K environment $@

user.elf: user.c
	$(CC) $(CFLAGS) -static $^ -o $@
	$(OBJCOPY) --prefix-symbols=__user_ --prefix-sections=.user $@

kernel.img: mkbootimg.json kernel.elf
	$(MKBOOTIMG) check kernel.elf
	$(MKBOOTIMG) mkbootimg.json kernel.elf
