

// - Attempts to print input
// - Input:    r0:uint
// - Output:   NONE
// - Destroys: 
print_reg:
	stmdb sp!,{r4,lr}

	cpy r4,r0

	ldr r0,=print_reg_start
	bl uart_puts

	mov r3,#28

.print_reg_loop:
	mov r0,r4,lsr r3
	bl read_4bit
	bl uart_putc

	cmp r3,#16
	moveq r0,#'-'
	bleq uart_putc

	sub r3,r3,#4

	cmp r3,#0
	bne .print_reg_loop

	mov r0,r4
	bl read_4bit
	bl uart_putc

	putc #'\n'

	ldmia sp!,{r4,pc}



// - Reads lower 4-bits from input
// - Input:    r0:char
// - Output:   r0:char
// - Destroys: r0
read_4bit:
	and r0,r0,#0xF

	cmp r0,#0
	moveq r0,#'0'
	beq .leave_read_4bit
	
	cmp r0,#1
	moveq r0,#'1'
	beq .leave_read_4bit
	
	cmp r0,#2
	moveq r0,#'2'
	beq .leave_read_4bit
	
	cmp r0,#3
	moveq r0,#'3'
	beq .leave_read_4bit
	
	cmp r0,#4
	moveq r0,#'4'
	beq .leave_read_4bit
	
	cmp r0,#5
	moveq r0,#'5'
	beq .leave_read_4bit
	
	cmp r0,#6
	moveq r0,#'6'
	beq .leave_read_4bit
	
	cmp r0,#7
	moveq r0,#'7'
	beq .leave_read_4bit
	
	cmp r0,#8
	moveq r0,#'8'
	beq .leave_read_4bit
	
	cmp r0,#9
	moveq r0,#'9'
	beq .leave_read_4bit
	
	cmp r0,#10
	moveq r0,#'A'
	beq .leave_read_4bit
	
	cmp r0,#11
	moveq r0,#'B'
	beq .leave_read_4bit
	
	cmp r0,#12
	moveq r0,#'C'
	beq .leave_read_4bit
	
	cmp r0,#13
	moveq r0,#'D'
	beq .leave_read_4bit
	
	cmp r0,#14
	moveq r0,#'E'
	beq .leave_read_4bit
	
	cmp r0,#15
	moveq r0,#'F'
	beq .leave_read_4bit


.leave_read_4bit:
	ret

