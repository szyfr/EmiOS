
// - Reads keyboard input, pushes it to the screen, and copies it to MEM_TXTBUF.
// - Input:    NONE
// - Output:   NONE
// - Destroys: r0,r1,r2
read_keyboard_input:
	stmdb sp!,{r4,lr}

	// Get character, then send it to screen
	bl uart_getc
	bl uart_putc

	// Increment character offset
	mov  r2,#MEM_CHAROFF
	ldrb r1,[r2]
	add  r1,#1
	strb r1,[r2]

	// Push character to text buffer
	mov  r2,#MEM_TXTBUF
	strb r0,[r2,r1]

	// Test if character is new line
	// If false, leave
	teq r0,#0x0D
	bne .read_keyboard_input_leave

	// Push new line to screen
	putc #0x0A

	// Read buffer
	bl read_textbuffer

	// Execute command

	// Clear buffer
	bl clear_textbuffer

.read_keyboard_input_leave:
	ldmia sp!,{r4,pc}


// - Reads the MEM_TXTBUF and returns the command
// - Input:    NONE
// - Output:   r0:command
// - Destroys: 
// TODO: Error when non-hex input
// TODO: multiple output with :NUM_BYTES
read_textbuffer:
	stmdb sp!,{r4,lr}

	mov  r1,#MEM_TXTBUF
	mov  r2,#1
	mov  r4,#0
	mov  r5,#8
	ldrb r0,[r1,r2]

	cmp r0,#'<'
	beq .command_read

	cmp r0,#'>'
	beq .command_write

	b .leave_command


.command_read:
	add   r2,#1
	ldrb  r3,[r1,r2]

	cmp   r3,#0x0D
	beq   .command_read_leave

	lsl   r4,#4

	cmp   r3,#0x3A
	sublt r3,#0x30
	subge r3,#0x57
	add   r4,r4,r3

	subs  r5,#1
	bne   .command_read

.command_read_leave:
	mov r0,r4
	mov r5,r4
	bl  print_reg_addr
	
	putc #'\t'
	putc #':'
	putc #' '

	ldrb r0,[r5]
	bl  print_reg_byte
	
	putc #'\n'

	ldmia sp!,{r4,pc}


.command_write:
	ldmia sp!,{r4,pc}


.leave_command:
	ldmia sp!,{r4,pc}


// - Clears the MEM_TXTBUF and sets MEM_CHAROFF to zero
// - Input:    NONE
// - Output:   NONE
// - Destroys: r0,r1,r2
clear_textbuffer:
	mov  r0,#0
	mov  r2,#MEM_CHAROFF
	ldrb r1,[r2]
	mov  r3,#MEM_TXTBUF
	
.clear_textbuffer_loop:
	str  r0,[r3,r1]
	subs r1,#1
	bne  .clear_textbuffer_loop

	str  r1,[r2]
	ret

