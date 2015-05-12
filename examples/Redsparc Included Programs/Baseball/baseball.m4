;;;;;;;;;;;;;;;;;;;;;;;; Redsparc Baseball Game ;;;;;;;;;;;;;;;;;;;;;;;;

include(gpu.m4)

define(BUFFER_DISPLAY, 0)
define(BUFFER_WORKING, 1)
define(BUFFER_BASE, 2)

; Setup for the program
setup:
	; Setup the stack
	mov sp, stack_top
	
	;;;; Draw the main GUI screen ;;;
	; Set the working GPU buffer to BUFFER_BASE
	out BUFFER_BASE, PORT_GPU_BUFFER	
	; Call the routine to draw the main GUI
	call gui_draw_main_screen
	call gpu_wait
	
	;;; Push the base buffer to the display buffer
	; Set the command to copybuffer
	out GPU_CMD_COPY_BUFFER, PORT_GPU_COMMAND
	; Set the destination buffer to BUFFER_DISPLAY
	out BUFFER_WORKING, PORT_GPU_REGISTER
	; Execute
	GPU_Execute
	
	;;; Update the Bases ;;;
	out 14, PORT_GPU_COLOR
	out BUFFER_DISPLAY, PORT_GPU_BUFFER
	call gui_update
	
top:
	; Halt (for now)
	hlt


; Pitches the ball and waits for the batter to hit it
; Parameters:
;	Port 23 (GPU Buffer) - The working buffer
;	Port 24 (GPU Register) - The display buffer
; Results:
;	none
; Clobbers:
;	AX, BX, CX, DX
pitch:
	;;; Setup ;;;
	; Set the initial coordinates
	out 15, PORT_GPU_X1
	out 17, PORT_GPU_Y1
	; Set the ball color
	out 0, PORT_GPU_COLOR
	; Set the command
	out GPU_CMD_SET_PIXEL, PORT_GPU_COMMAND
	


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
