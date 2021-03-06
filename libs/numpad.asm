;;;;;;;;;;;;;;;;;;; Numpad Library for Redsparc ;;;;;;;;;;;;;;;;;;;;;;;;
; This library provides the ability to interface with the numeric input
; pad on the Redsparc computer.

; Link with: -lnumpad


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
numpad_flush:
	out 100000, 0
	ret
	
; Waits for the user to input a number, flushing the input buffer upon
; completion
; Parameters:
;	none
; Results:
;	AX = number read
; Clobbers:
;	AX
numpad_get:
	in ax, 0
	cmp ax, 100000
	je numpad_get
_numpad_get_loop_end:
	out 100000, 0
	ret
	
