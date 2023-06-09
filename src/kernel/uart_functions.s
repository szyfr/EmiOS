

//= Initializes uart
//= Input:    NONE
//= Output:   NONE
//= Destroys: r0,r1
uart_init:
	mov r1,#0
	ldr r0,UART0_CR
	str r1,[r0]

	ldr r0,GPPUD
	str r1,[r0]

	mov r0,#150
.delay_1:
	subs r0,r0,#1
	bne .delay_1

	mov r1,#0xC000
	ldr r0,GPPUDCLK0
	str r1,[r0]

	mov r0,#150
.delay_2:
	subs r0,r0,#1
	bne .delay_2

	mov r1,#0
	ldr r0,GPPUDCLK0
	str r1,[r0]

	mov r1,#0x7FF
	ldr r0,UART0_ICR
	str r1,[r0]

	mov r1,#1
	ldr r0,UART0_IBRD
	str r1,[r0]

	mov r1,#40
	ldr r0,UART0_FBRD
	str r1,[r0]

	mov r1,#0x70
	ldr r0,UART0_LCRH
	str r1,[r0]

	mov r1,#0x7F2
	ldr r0,UART0_IMSC
	str r1,[r0]

	mov r1,#0x301
	ldr r0,UART0_CR
	str r1,[r0]

	ret


//= Prints input character through uart
//= Input:    r0:uchar
//= Output:   NONE
//= Destroys: r0,r1,r2
uart_putc:
	ldr r2,UART0_FR
	ldr r1,[r2]
	tst r1,#0x20
	bne uart_putc
	
	ldr r2,UART0_DR
	str r0,[r2]

	ret


//= Gets character from over uart
//= Input:    NONE
//= Output:   r0:uchar
//= Destroys: r0,r1
uart_getc:
	ldr r1,UART0_FR
	ldr r0,[r1]
	and r0,r0,#0x10
	cmp r0,#0
	bne uart_getc

	mmio_read UART0_DR

	ret


//= Prints null-terminated string over uart
//= Input:    r0:char*
//= Output:   NONE
//= Destroys: r0,r1,r2,r4
uart_puts:
	stmdb sp!,{r4,lr}
	cpy r4,r0
	ldrb r0,[r4,#0]
	cmp r0,#0

	ldmeqia sp!,{r4,pc}

.uart_puts_loop:
	bl uart_putc
	ldrb r0,[r4,#1]!
	cmp r0,#0
	bne .uart_puts_loop

	ldmia sp!,{r4,pc}
