

.include "src/kernel/definitions/defines.s"
.include "src/kernel/definitions/macros.s"

.include "src/kernel/uart_functions.s"
.include "src/kernel/testing.s"
.include "src/kernel/cmd_reader.s"
.include "src/kernel/screen/buffer.s"

.include "src/kernel/memory/atag.s"


//= Main function
kernel_main:
	bl uart_init

//	cpy r0,r2
//	bl get_mem_size

	ldr r0,=hello_str
	bl uart_puts


.mainloop:


	bl read_keyboard_input


	b .mainloop



.include "src/kernel/definitions/rodata.s"
