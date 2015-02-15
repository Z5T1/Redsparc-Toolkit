;;;;;;;;;;;;;; Redsparc Numpad Display Example Program ;;;;;;;;;;;;;;;;;
; Assemble with: zasm numeric_display.asm -o numeric_display.zob
; Link with: zlink numeric_display.zob -o numeric_display.rs

; This example's pretty simple. It just prints the number 12345 to the
; numeric display.

; Since we aren't calling anything or using push/pop, there is no need
; to setup the stack.

	; Writes 12345 to Serial Port 1 (The Numeric Display Port)
	out 12345, 1
	
	; Halt upon completion
	hlt
