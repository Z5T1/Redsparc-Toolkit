;;;;;;;;;;;;;; Redsparc Numpad Display Example Program ;;;;;;;;;;;;;;;;;
; Assemble with: zasm echo.asm -o echo.zob
; Link with: zlink echo.zob -o echo.rs -lnumpad

; This example turns on the ? symbol, waits for the user to enter a
; number on the numpad, turns off the ? symbol and prints the number to
; the numeric display.

	; Set up the stack
	mov sp, stack_top
	
	; Turn on the ? symbol
	out 1, 6

	; Calls numpad input
	call numpad_get
	
	; Turn off the ? symbol
	out 0, 6
	
	; Print AX
	; Remember, numpad_get stores its result in AX
	out ax, 1

	; Halts upon completion
	hlt

; Stack memory
stack_bottom:
	; Defines 8 words of memory as zero
	dw 0 8
stack_top:
	
