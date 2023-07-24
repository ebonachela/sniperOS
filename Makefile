all: final
	echo "Build sucess!"

final: sniperOS.bin
	echo "[4] Generating ISO"
	mkdir -p isodir/boot/grub
	cp sniperOS.bin isodir/boot/sniperOS.bin
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o sniperOS.iso isodir
	cp sniperOS.iso /home/snipa/shares/Ubuntu

boot.o: boot.s
	echo "[1] Building boot.s"
	i686-elf-as boot.s -o boot.o

kernel.o: kernel.c
	echo "[2] Building kernel.s"
	i686-elf-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

sniperOS.bin: boot.o kernel.o
	echo "[3] Linking files"
	i686-elf-gcc -T linker.ld -o sniperOS.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc

clear:
	echo "Removing binary files."
	rm -r boot.o kernel.o sniperOS.bin sniperOS.iso isodir