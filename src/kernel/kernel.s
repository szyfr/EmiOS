

.include "src/kernel/defines.s"
.include "src/kernel/macros.s"
.include "src/kernel/uart_functions.s"


// - Main function
kernel_main:
	bl uart_init

	ldr r0,=hello_str
	bl uart_puts

.mainloop:
	bl uart_getc
	bl uart_putc

	ldr r0,=0x0A
	bl uart_putc

	b .mainloop


.section ".rodata"
hello_str:
.ascii "Hello, World\r\n"
