
// - 
// - Input:    
// - Output:   
// - Destroys: 
read_keyboard_input:

	bl uart_getc
	bl uart_putc

	ret


	