;;;;;;;;;;;;;;;;;;; Numpad Library for Redspace ;;;;;;;;;;;;;;;;;;;;;;;;
; This library provides the ability to interface with the numeric input
; pad on the Redsparc computer.

; Flushes the input buffer, resetting it for next use
; Parameters:
;	none
; Results:
;	none
numpad_flush:
	out 100000, 0
	ret
	
; Waits for the user to input a number, flushing the input flag upon
; completion
; Parameters:
;	none
; Results:
;	AX = number read
numpad_get:
	mov bx, 100000
_numpad_get_loop_top:
	in ax, 0
	cmp ax, bx
	je _numpad_get_loop_top
_numpad_get_loop_end:
	out 100000, 0
	ret
	
