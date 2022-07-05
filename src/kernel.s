
.equ GPIO_BASE, 0x3F200000

.equ GPPUD,     (GPIO_BASE + 0x94)
.equ GPPUDCLK0, (GPIO_BASE + 0x98)

.equ UART0_BASE, 0x3F201000

.equ UART0_DR,     (UART0_BASE + 0x00)
.equ UART0_RSRECR, (UART0_BASE + 0x04)
.equ UART0_FR,     (UART0_BASE + 0x18)
.equ UART0_ILPR,   (UART0_BASE + 0x20)
.equ UART0_IBRD,   (UART0_BASE + 0x24)
.equ UART0_FBRD,   (UART0_BASE + 0x28)
.equ UART0_LCRH,   (UART0_BASE + 0x2C)
.equ UART0_CR,     (UART0_BASE + 0x30)
.equ UART0_IFLS,   (UART0_BASE + 0x34)
.equ UART0_IMSC,   (UART0_BASE + 0x38)
.equ UART0_RIS,    (UART0_BASE + 0x3C)
.equ UART0_MIS,    (UART0_BASE + 0x40)
.equ UART0_ICR,    (UART0_BASE + 0x44)
.equ UART0_DMACR,  (UART0_BASE + 0x48)
.equ UART0_ITCR,   (UART0_BASE + 0x80)
.equ UART0_ITIP,   (UART0_BASE + 0x84)
.equ UART0_ITOP,   (UART0_BASE + 0x88)
.equ UART0_TDR,    (UART0_BASE + 0x8C)


.macro mmio_write p0,p1
	ldr r0,\p0
	ldr r1,\p1
	str r1,[r0]
.endm

.macro ret
	mov pc,r14
.endm


// - Input = r0:reg, r1:data
//mmio_write: 
//	str r1,[r0]
//	mov pc,r14


// - Input = r0:reg
mmio_read:
	ldr r0,[r0]
	mov pc,r14


// - Input = r0:count
delay:
	subs r0,r0,#1
	bne delay
	mov pc,r14


// - Input = NONE
uart_init:
	ldr r0,=UART0_CR
	ldr r1,=0
	str r1,[r0]

	ldr r0,=GPPUD
	ldr r1,=0
	str r1,[r0]

	ldr r0,=150
	blx delay

	ldr r0,=GPPUDCLK0
	ldr r1,=0xC000
	str r1,[r0]

	ldr r0,=150
	blx delay

	ldr r0,=GPPUDCLK0
	ldr r1,=0
	str r1,[r0]

	ldr r0,=UART0_ICR
	ldr r1,=0x7FF
	str r1,[r0]

	ldr r0,=UART0_IBRD
	ldr r1,=1
	str r1,[r0]

	ldr r0,=UART0_FBRD
	ldr r1,=40
	str r1,[r0]

	ldr r0,=UART0_LCRH
	ldr r1,=0x70
	str r1,[r0]

	ldr r0,=UART0_IMSC
	ldr r1,=0x7F2
	str r1,[r0]

	ldr r0,=UART0_CR
	ldr r1,=0x301
	str r1,[r0]

	ret


// - Input    = r0:c
// - Destroys = r0,r1
uart_putc:
	ldr r1,=UART0_FR
	ldr r1,[r1]
	and r1,r1,#0x20
	beq uart_putc

	ldr r1,=UART0_DR
	str r0,[r1]

	ret


// - Input = NONE
uart_getc:
	ldr r1,=UART0_FR
	ldr r1,[r1]
	and r1,r1,#0x10
	beq uart_getc

	ldr r1,=UART0_DR
	ldr r0,[r1]

	ret


// - Input = r0:str
uart_puts:
	mov r2,#0

.loop:
	ldr r2,[r0,r1]

	mov r0,r2
	blx uart_putc

	add r1,r1,#1
	cmp r2,#0
	bne .loop

	mov r0,r2
	
	ret



// - 
kernel_main:
	blx uart_init

	ldr r0,=hello_str
	blx uart_puts

.mainloop:
	blx uart_getc
	blx uart_putc

	ldr r0,=0x0A
	blx uart_putc

	b .mainloop


hello_str:
.ascii "Hello, World"
.byte 0
