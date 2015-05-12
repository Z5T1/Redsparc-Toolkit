;;;;;;;;;;;;;;;;;;;;;;;; Redsparc Baseball Game ;;;;;;;;;;;;;;;;;;;;;;;;

; Included gpu.m4                                 





; Setup for the program
setup:
	; Setup the stack
	mov sp, stack_top
	
	;;;; Draw the main GUI screen ;;;
	; Set the working GPU buffer to 2
	out 2, 23	
	; Call the routine to draw the main GUI
	call gui_draw_main_screen
	call gpu_wait
	
	;;; Push the base buffer to the display buffer
	; Set the command to copybuffer
	out 1, 17
	; Set the destination buffer to 0
	out 1, 24
	; Execute
	out 1, 16
	
	;;; Update the Bases ;;;
	out 14, 22
	out 0, 23
	call gui_update
	
top:
	; Halt (for now)
	hlt


; Pitches the ball and waits for the batter to hit it
; Parameters:
;	Port 23 (GPU Buffer) - The working buffer
; Results:
;	none
; Clobbers:
;	AX, BX, CX, DX
pitch:
	


; Stack Memory
stack_bottom:
	dw 0 15
stack_top:
	dw 0

; Varaible Memory
first_base:
	dw 0
second_base:
	dw 0
third_base:
	dw 0

strikes:
	dw 1
balls:
	dw 3
outs:
	dw 2

score_inning:
	dw 0
score_away:
	dw 0
score_home:
	dw 0
