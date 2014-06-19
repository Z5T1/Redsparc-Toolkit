;;;;;;;;;;;;;;; Redsparc Numpad Input Example Program ;;;;;;;;;;;;;;;;;;
; Assemble with: zasm numpad_input.asm -o numpad_input.zob
; Link with: zlink numpad_input.zob -o numpad_input.rs -lnumpad

; This example's pretty simple. It just gets input from the numpad and
; saves it to ax. To view the contents of ax in game, simply type:
;	/var print [reg0]

	; Set up the stack
	mov sp, stack_top

	; Calls numpad input
	call numpad_get

	; Halts upon completion
	hlt

; Stack memory
stack_bottom:
	dw 0 8
stack_top:
