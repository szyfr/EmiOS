
GPIO_BASE:    .int 0x3F200000
GPPUD:        .int 0x3F200094
GPPUDCLK0:    .int 0x3F200098

UART0_BASE:   .int 0x3F201000
UART0_DR:     .int 0x3F201000
UART0_RSRECR: .int 0x3F201004
UART0_FR:     .int 0x3F201018
UART0_ILPR:   .int 0x3F201020
UART0_IBRD:   .int 0x3F201024
UART0_FBRD:   .int 0x3F201028
UART0_LCRH:   .int 0x3F20102C
UART0_CR:     .int 0x3F201030
UART0_IFLS:   .int 0x3F201034
UART0_IMSC:   .int 0x3F201038
UART0_RIS:    .int 0x3F20103C
UART0_MIS:    .int 0x3F201040
UART0_ICR:    .int 0x3F201044
UART0_DMACR:  .int 0x3F201048
UART0_ITCR:   .int 0x3F201080
UART0_ITIP:   .int 0x3F201084
UART0_ITOP:   .int 0x3F201088
UART0_TDR:    .int 0x3F20108C


.macro mmio_write reg,data
	ldr r0,\reg
	mov r1,\data
	str r1,[r0]
.endm

.macro mmio_read reg
	ldr r1,\reg
	ldr r0,[r1]
.endm

.macro delay count
	mov r0,\count
.delay_\@:
	subs r0,r0,#1
	bne .delay_\@
.endm


// - Input = NONE
uart_init:
	mmio_write UART0_CR,#0
	mmio_write GPPUD,#0
	delay #150

	mmio_write GPPUDCLK0,#0xC000
	delay #150

	mmio_write GPPUDCLK0,#0
	mmio_write UART0_ICR,#0x7FF
	mmio_write UART0_IBRD,#1
	mmio_write UART0_FBRD,#40
	mmio_write UART0_LCRH,#0x70
	mmio_write UART0_IMSC,#0x7F2
	mmio_write UART0_CR,#0x301

	bx lr


// - Input    = r0:c
// - Destroys = r0,r1
uart_putc:
	ldr r2,UART0_FR
	ldr r1,[r2]
	tst r1,#0x20
	bne uart_putc
	
	ldr r2,UART0_DR
	str r0,[r2]

	bx lr


// - Input = NONE
uart_getc:
	ldr r1,UART0_FR
	ldr r0,[r1]
	and r0,r0,#0x10
	cmp r0,#0
	bne uart_getc

	mmio_read UART0_DR

	bx lr


// - Input = r0:str
uart_puts:
	stmdb sp!,{r4,lr}
	cpy r4,r0
	ldrb r0,[r4,#0]
	cmp r0,#0

	ldmeqia sp!,{r4,pc}

.loop:
	bl uart_putc
	ldrb r0,[r4,#1]!
	cmp r0,#0
	bne .loop

	ldmia sp!,{r4,pc}



// - 
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
