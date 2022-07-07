

// - Goes through atags to get total usable memory
// TODO: Test function on real hardware once having an actual way to show something
// - Input:    r0:void*
// - Output:   r0:uint
// - Destroys: r0,r1,r2,r4
get_mem_size:
	stmdb sp!,{r4,lr}

	cpy r4,r0
	ldr r1,ATAG_MEM
	ldr r2,ATAG_NONE

	cmp r0,#0
	beq .emulator_leave

	ldr r0,[r4,#4]

	cmp r0,r1
	beq .grab_leave

.get_mem_size_loop:
	ldr r0,[r4]
	add r4,r4,r0

	ldr r0,[r4,#4]
	cmp r0,r1
	beq .grab_leave

	cmp r0,r2
	beq .zero_leave

	b .get_mem_size_loop


.grab_leave:
	ldr r0,[r4,#8]
	ldmia sp!,{r4,pc}

.zero_leave:
	mov r0,#0
	ldmia sp!,{r4,pc}

.emulator_leave:
	mov r0,#1073741824
	ldmia sp!,{r4,pc}

