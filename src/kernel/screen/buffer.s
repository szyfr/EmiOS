

//= Get buffer length
//= Input:    r0
//= Output:   NONE
//= Destroys: r0,r1,r2
get_value_buffer_len:
	ldr r1,[r0]

	ldr r2,FB_ALLOCATE_BUFFER
	tst r1,r2
	be .ret_8

	ldr r2,FB_GET_PHYSICAL_DIMENSIONS
	tst r1,r2
	be .ret_8

	ldr r2,FB_SET_PHYSICAL_DIMENSIONS
	tst r1,r2
	be .ret_8

	ldr r2,FB_GET_VIRTUAL_DIMENSIONS
	tst r1,r2
	be .ret_8

	ldr r2,FB_SET_VIRTUAL_DIMENSIONS
	tst r1,r2
	be .ret_8

	ldr r2,FB_GET_BITS_PER_PIXEL
	tst r1,r2
	be .ret_4

	ldr r2,FB_SET_BITS_PER_PIXEL
	tst r1,r2
	be .ret_4

	ldr r2,FB_GET_BYTES_PER_ROW
	tst r1,r2
	be .ret_4

	ldr r2,FB_RELEASE_BUFFER
	tst r1,r2
	be .ret_0

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





//= 
//= Input:    NONE
//= Output:   NONE
//= Destroys: 
