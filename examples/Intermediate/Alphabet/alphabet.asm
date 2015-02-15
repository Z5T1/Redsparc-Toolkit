;;;;;;;;;;;;;; Redsparc Numpad Display Example Program ;;;;;;;;;;;;;;;;;
; Assemble with: zasm alphabet.asm -o alphabet.zob
; Link with: zlink alphabet.zob -o alphabet.rs

; This example prints the alphabet on the screen, print one letter,
; erasing it, and then printing the next. It also makes use of double
; buffered mode.

; Setup for the program
setup:

	; Set up the stack
	mov sp, stack_top	
	
	; Set the working buffer to 1
	out 1, 23
	
	; Set up Coordinates
	out 7, 18	; X1 = 7
	out 7, 19	; Y1 = 7
	out 1, 20	; X2 = 1
	out 1, 21	; Y2 = 1
	
	; Set AX to 11 (The Letter A)
	mov ax, 11
	
; Start of the program
; This is the location we loop back to
top:

	; Erease the current character
	out 15, 22	; Set the GPU color to black
	out 3, 17	; Set the GPU command to fill
	out 1, 16	; Execute
	
	; Print the character to the buffer
	out 0, 22	; Set the GPU color to white
	out ax, 24	; Write the current character to the GPU Register
	out 64, 17	; Set GPU command to printchar
	out 1, 16	; Execute
	
	; Push the buffer
	out 0, 24	; Set the destination buffer to 0 (the screen)
	out 1, 17	; Set the GPU command to copy_buffer
	out 1, 16	; Execute
	
	; Incrament AX to the next letter
	inc ax
	
	; Check if the next character is _
	cmp ax, 37
	
	; If it is not, jump to top
	jne top
	
; End of the program
; The location we jump to after printing Z
end:
	hlt
	
; Stack memory
stack_bottom:
	; Defines 7 words of memory as zero
	dw 0 7
stack_top:
	; We define an additional value as zero at the top of the stack for
	; the first value pushed
	dw 0 1
