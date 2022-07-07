

// - Initializes uart
// - Input:    NONE
// - Output:   NONE
// - Destroys: r0,r1
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

	ret


// - Prints input character through uart
// - Input:    r0:uchar
// - Output:   NONE
// - Destroys: r0,r1,r2
uart_putc:
	ldr r2,UART0_FR
	ldr r1,[r2]
	tst r1,#0x20
	bne uart_putc
	
	ldr r2,UART0_DR
	str r0,[r2]

	ret


// - Gets character from over uart
// - Input:    NONE
// - Output:   r0:uchar
// - Destroys: r0,r1
uart_getc:
	ldr r1,UART0_FR
	ldr r0,[r1]
	and r0,r0,#0x10
	cmp r0,#0
	bne uart_getc

	mmio_read UART0_DR

	ret


// - Prints null-terminated string over uart
// - Input:    r0:char*
// - Output:   NONE
// - Destroys: r0,r1,r2,r4
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
