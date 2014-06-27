;;;;;;;;;;;;;; Redsparc Symbol Display Example Program ;;;;;;;;;;;;;;;;;
; Assemble with: zasm symbol_display.asm -o symbol_display.zob
; Link with: zlink symbol_display.zob -o symbol_display.rs

; This example's pretty neat. It makes the arrow on the symbol display
; rotate clockwise.

; Since we aren't calling anything or using push/pop, there is no need
; to setup the stack.

; Top of the program
; We put a label here to we can jump back to it later
top:
	
	; Up
	out 1, 2	; Turn up arrow on
	out 0, 4	; Turn left arrow off
	
	; Right
	out 1, 5	; Turn right arrow on
	out 0, 2	; Turn up arrow off
	
	; Down
	out 1, 3	; Turn down arrow on
	out 0, 5	; Turn right arrow off
	
	; Left
	out 1, 4	; Turn left arrow on
	out 0, 3	; Turn down arrow off
	
	; Now jump back to top and do it all over again!
	jmp top
