

.include "src/kernel/defines.s"
.include "src/kernel/macros.s"
.include "src/kernel/uart_functions.s"
.include "src/kernel/testing.s"
.include "src/kernel/atag.s"
.include "src/kernel/cmd_reader.s"


// - Main function
kernel_main:
	bl uart_init

	cpy r0,r2
	bl get_mem_size

	ldr r0,=hello_str
	bl uart_puts

.mainloop:


	bl uart_getc
	bl uart_putc
//	putc #'\n'

	b .mainloop



.include "src/kernel/rodata.s"
