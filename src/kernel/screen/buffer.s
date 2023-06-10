

//= Get buffer length
//= Input:    r0
//= Output:   NONE
//= Destroys: r0,r1,r2
get_value_buffer_len:
	ldr r1,[r0]

	ldr r2,FB_ALLOCATE_BUFFER
	tst r1,r2
	beq .ret_8

	ldr r2,FB_GET_PHYSICAL_DIMENSIONS
	tst r1,r2
	beq .ret_8

	ldr r2,FB_SET_PHYSICAL_DIMENSIONS
	tst r1,r2
	beq .ret_8

	ldr r2,FB_GET_VIRTUAL_DIMENSIONS
	tst r1,r2
	beq .ret_8

	ldr r2,FB_SET_VIRTUAL_DIMENSIONS
	tst r1,r2
	beq .ret_8

	ldr r2,FB_GET_BITS_PER_PIXEL
	tst r1,r2
	beq .ret_4

	ldr r2,FB_SET_BITS_PER_PIXEL
	tst r1,r2
	beq .ret_4

	ldr r2,FB_GET_BYTES_PER_ROW
	tst r1,r2
	beq .ret_4

	ldr r2,FB_RELEASE_BUFFER
	tst r1,r2
	beq .ret_0

.ret_0:
	mov r0,#0
	ret

.ret_4:
	mov r0,#4
	ret

.ret_8:
	mov r0,#8
	ret



//= Send messages
//= Input:    NONE
//= Output:   NONE
//= Destroys: 
send_messages:
	ret
	// Get total size
//	mov r3,5
//.
//	mov r0,#0x40000000
//	mov r1,#0xFF
//	str r1,[r0]




//= 
//= Input:    NONE
//= Output:   NONE
//= Destroys: 
framebuffer_init:
	mov r0,#0x40000000

	ldr r1,#FB_SET_PHYSICAL_DIMENSIONS
	str r1,[r0]
	mov r1,#640
	str r1,[r0,#0x04]
	str r1,[r0,#0x10]
	mov r1,#480
	str r1,[r0,#0x08]
	str r1,[r0,#0x14]

	ldr r1,#FB_SET_VIRTUAL_DIMENSIONS
	str r1,[r0,#0x0C]

	ldr r1,#FB_SET_BITS_PER_PIXEL
	str r1,[r0,#0x18]
	mov r1,#24
	str r1,[r0,#0x1C]

	// send_message

	

	ret



//= 
//= Input:    NONE
//= Output:   NONE
//= Destroys: 
