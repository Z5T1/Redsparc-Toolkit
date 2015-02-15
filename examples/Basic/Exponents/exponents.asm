;;;;;;;;;;;;;; Redsparc Numpad Display Example Program ;;;;;;;;;;;;;;;;;
; Assemble with: zasm exponents.asm -o exponents.zob
; Link with: zlink exponents.zob -o exponents.rs -lnumpad

; This example turns on the ? symbol, waits for the user to enter a
; number on the numpad, and then prints exponents of that number.
; Eg. You enter 2, the program prints 2, 4, 8, 16 and so on


; Setup for the program; get the base number
setup:
	; Set up the stack
	mov sp, stack_top
	
	; Turn on the ? symbol
	out 1, 6

	; Calls numpad input
	call numpad_get
	
	; Turn off the ? symbol
	out 0, 6
	
	; Copy the input into BX
	mov bx, ax

; Loop top
top:
	; Print AX
	out ax, 1

	; Multiply by the base
	mul ax, bx
	
	; Jump back to the loop top
	jmp top

; Stack memory
stack_bottom:
	; Defines 8 words of memory as zero
	dw 0 8
stack_top:
