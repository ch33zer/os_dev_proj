# os_dev_proj

Build boot: i686-elf-as boot.s -o boot.o
Build kernel: i686-elf-g++ -c kernel.cc -o kernel.o -std=c++11 -ffreestanding -O2 -Wall -Wextra -fno-exceptions
Make binary image: i686-elf-gcc -T linker.ld -o myos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc
Build iso: cp myos.bin isodir/boot/myos.bin && cp grub.cfg isodir/boot/grub/grub.cfg && grub-mkrescue -o myos.iso isodir
Run emu: qemu-system-i386 -curses -cdrom myos.iso 
Quit emu: Alt + 2 > quit
