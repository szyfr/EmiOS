

// Writing input to input mmio register
.macro mmio_write reg,data
	ldr r0,\reg
	mov r1,\data
	str r1,[r0]
.endm


// Reading value from mmio register
.macro mmio_read reg
	ldr r1,\reg
	ldr r0,[r1]
.endm


// Delay for input amount
.macro delay count
	mov r0,\count
.delay_\@:
	subs r0,r0,#1
	bne .delay_\@
.endm


// General return
.macro ret
	bx lr
.endm


// uart putc with input
.macro putc i
	mov r0,\i
	bl uart_putc
.endm


// uart puts with input
.macro puts i
	ldr r0,\i
	bl uart_puts
.endm


