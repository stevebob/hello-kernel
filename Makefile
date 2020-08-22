CC ?= gcc
NASM ?= nasm
LD ?= ld
STRIP ?= strip
OBJCOPY ?= objcopy
MKBOOTIMG ?= mkbootimg
QEMU ?= qemu-system-x86_64

CFLAGS = -Werror -Wall -fpic -ffreestanding -fno-stack-protector -nostdlib -g

.PHONY: all clean run run-graphical strip

all: kernel.elf

clean:
	rm -f *.o *.img *.elf

run: kernel.img
	$(QEMU) -drive file=$^,format=raw -serial stdio -display none

run-graphical: kernel.img
	$(QEMU) -drive file=$^,format=raw -serial stdio

run-debug: kernel.img
	$(QEMU) -drive file=$^,format=raw -serial stdio -display none -no-shutdown -no-reboot -d int -s -S

kernel.elf: kernel.c putc.asm gdt.asm user_trampoline.asm switch_to_user_mode.asm link.ld user.o
	$(CC) $(CFLAGS) -mno-red-zone -c kernel.c -o kernel.o
	$(NASM) -g -f elf64 gdt.asm -o gdt.o
	$(NASM) -g -f elf64 putc.asm -o putc.o
	$(NASM) -g -f elf64 user_trampoline.asm -o user_trampoline.o
	$(NASM) -g -f elf64 switch_to_user_mode.asm -o switch_to_user_mode.o
	$(LD)  -nostdlib --script link.ld kernel.o gdt.o putc.o switch_to_user_mode.o user_trampoline.o user.o -o $@
	$(STRIP) -s \
		--keep-symbol=mmio \
		--keep-symbol=fb \
		--keep-symbol=bootboot \
		--keep-symbol=environment \
		--keep-symbol=user_base \
		--keep-symbol=user_stack_bottom \
		--keep-symbol=user_stack_top \
		$@

user.o: user.c
	$(CC) $(CFLAGS) -static -c $^ -o $@
	$(OBJCOPY) \
		--strip-unneeded \
		--prefix-symbols=__user_ \
		--keep-symbol=__user__start \
		--rename-section .text=.user.text \
		--rename-section .rodata=.user.rodata \
		--rename-section .data=.user.data \
		--rename-section .bss=.user.bss \
		$@

kernel.img: mkbootimg.json kernel.elf
	$(MKBOOTIMG) check kernel.elf
	$(MKBOOTIMG) mkbootimg.json $@
