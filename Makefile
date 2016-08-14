AUXFILES := Makefile README.md
PROJDIRS := bootloader build src
SRCFILES := $(shell find $(PROJDIRS) -type f -name "*.cc")
HDRFILES := $(shell find $(PROJDIRS) -type f -name "*.h")
CXXOBJFILES := $(patsubst %.cc,%.o,$(SRCFILES))
OBJFILES := $(CXXOBJFILES) boot.o
TSTFILES := $(patsubst %.cc,%_t,$(SRCFILES))
DEPFILES    := $(patsubst %.cc,%.d,$(SRCFILES))
TSTDEPFILES := $(patsubst %,%.d,$(TSTFILES))
ALLFILES := $(SRCFILES) $(HDRFILES) $(AUXFILES)
CC := i686-elf-gcc
CXX := i686-elf-g++
AS := i686-elf-as

WARNINGS := -pedantic -Wall -Wextra -Wcast-align -Wcast-qual -Wctor-dtor-privacy -Wdisabled-optimization \
  -Wformat=2 -Winit-self -Wlogical-op -Wmissing-include-dirs -Wnoexcept \
  -Woverloaded-virtual -Wredundant-decls -Wshadow -Wsign-promo \
  -Wstrict-null-sentinel -Wstrict-overflow=5 -Wswitch-default -Wundef -Werror -Wno-unused

CXXFLAGS := -std=c++11 -ffreestanding -O2 -fno-exceptions $(WARNINGS)

.PHONY: all clean

all: image.iso

clean:
	$(RM) -r -f $(wildcard $(OBJFILES) $(DEPFILES) image.bin isodir image.iso)

run: image.iso
	qemu-system-i386 -cdrom image.iso

image.iso: image.bin build/grub.cfg
	mkdir -p isodir/boot/grub
	cp image.bin isodir/boot/image.bin
	cp build/grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o $@ isodir

image.bin: $(OBJFILES)
	$(CC) -T build/linker.ld -nostdlib -lgcc $^ -o $@

boot.o: bootloader/boot.s
	$(AS) $^ -o $@

%.o: %.cc Makefile
	$(CXX) $(CXXFLAGS) -MMD -MP -c $< -o $@

-include $(DEPFILES) $(TSTDEPFILES)
