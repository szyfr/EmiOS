@echo off

cls

arm-none-eabi-gcc -mcpu=cortex-a7 -fpic -ffreestanding -c src/boot.s -o target/boot.o
arm-none-eabi-gcc -T linker.ld -o target/EmiOS.elf -ffreestanding -O2 -nostdlib target/boot.o

"C:\Program Files\qemu\qemu-system-arm" -m 1024 -machine type=raspi2b -serial stdio -kernel target/EmiOS.elf