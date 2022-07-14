
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
	mov r2,#MEM_CHAROFF
	ldr r1,[r2]
	add r1,#1
	str r1,[r2]

	// Push character to text buffer
	mov r2,#MEM_TXTBUF
	add r2,r2,r1
	str r0,[r2]

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
read_textbuffer:
	mov r1,#MEM_TXTBUF

	ret


// - Clears the MEM_TXTBUF and sets MEM_CHAROFF to zero
// - Input:    NONE
// - Output:   NONE
// - Destroys: r0,r1,r2
clear_textbuffer:
	mov r0,#0
	mov r1,#MEM_CHAROFF
	mov r2,#MEM_TXTBUF

.clear_textbuffer_loop:
	str  r0,[r2,r1]
	subs r1,#1
	beq  .clear_textbuffer_loop

	ret

