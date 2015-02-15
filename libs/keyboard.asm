;;;;;;;;;;;;;;;;;; Keyboard Library for Redsparc ;;;;;;;;;;;;;;;;;;;;;;;
; This library provides the ability to interface with the keyboard on
; the Redsparc computer.

; Link with: -lkeyboard

; Flushes the input buffer, resetting it for next use
; NOTE:
;	You're better off just using:
;		out 100000, 0
;	instead of calling this. You save 2 CPU cycles that way.
; Parameters:
;	none
; Results:
;	none
; Clobbers:
;	none
keyboard_flush:
	out 0, 10
	ret
	
; Waits for the user to press a key, flushing the input buffer upon
; completion
; Parameters:
;	none
; Results:
;	AX = number read
; Clobbers:
;	AX
keyboard_get:
	in ax, 10
	cmp ax, 0
	je keyboard_get
_keyboard_get_loop_end:
	out 0, 10
	ret
