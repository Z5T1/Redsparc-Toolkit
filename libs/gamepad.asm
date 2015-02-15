;;;;;;;;;;;;;;;;;;; Gamepad Library for Redsparc ;;;;;;;;;;;;;;;;;;;;;;;
; This library provides the ability to interface with the gamepad on the
; Redsparc computer.

; Link with: -lgamepad


; Flushes the gamepad input buffer, resetting it for next use
; NOTE:
;	You're better off just using:
;		out 0, 9
;	instead of calling this. You save 2 CPU cycles that way.
; Parameters:
;	none
; Results:
;	none
; Clobbers:
;	none
gamepad_flush:
	out 0, 9
	ret
	
; Waits for the user to press a button on the gamepad, flushing the
; input buffer upon completion
; Parameters:
;	none
; Results:
;	AX = value read (see the Gamepad Key Values table)
; Clobbers:
;	AX
gamepad_get:
	in ax, 9
	cmp ax, 0
	je gamepad_get
_gamepad_get_loop_end:
	out 0, 9
	ret
	
	
