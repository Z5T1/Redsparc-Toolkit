;;;;;;;;;;;;;; Redsparc Numpad Display Example Program ;;;;;;;;;;;;;;;;;
; Assemble with: zasm kcm.asm -o kcm.zob
; Link with: zlink kcm.zob -o kcm.rs -lkeyboard

; This example waits for the user to press a key on the keyboard and
; then prints the character map value for that key to the numeric
; display, looping until the user presses escape

; Setup for the program
setup:

	; Set up the stack
	mov sp, stack_top
	
; Start of the program
; This is the location we loop back to
top:

	; Get the keyboard input
	call keyboard_get
	
	; Print the value
	; Remember: keyboard_get stores the result in AX
	out ax, 1
	
	; Check if escape (key #61) was pressed
	cmp ax, 61
	
	; Loop back to the top if not equal
	jne top
	
	; If it was equal, halt
	hlt
	
; Stack memory
stack_bottom:
	; Defines 7 words of memory as zero
	dw 0 7
stack_top:
	; We define an additional value as zero at the top of the stack for
	; the first value pushed
	dw 0 1
