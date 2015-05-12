
include(gpu.m4)

; Draws the main screen for the program on the buffer specified by the
; GPU_BUFFER port
; Parameters:
;	Port 23 (GPU Buffer) - The working buffer
; Results:
;	none
; Clobbers:
;	AX
gui_draw_main_screen:
	
	;;; Setup for drawing bases
	out GPU_CMD_LARGE_PRINTCHAR, PORT_GPU_COMMAND
	out 0, PORT_GPU_COLOR
	out 60, PORT_GPU_REGISTER
	
	;;; Third Base
	out 2, PORT_GPU_X1
	out 17, PORT_GPU_Y1
	GPU_Execute
	
	;;; First Base
	out 24, PORT_GPU_X1
	call gpu_wait
	GPU_Execute
	
	;;; Second Base
	out 13, PORT_GPU_X1
	out 2, PORT_GPU_Y1
	call gpu_wait
	GPU_Execute
	
	;;; Home Plate
	out 32, PORT_GPU_Y1
	out 1, PORT_GPU_COLOR
	call gpu_wait
	GPU_Execute
	
	; Home plate requires some additional modification to make it a
	; pentagon shape.
	out GPU_CMD_SET_PIXEL, PORT_GPU_COMMAND
	out 15, PORT_GPU_COLOR
	call gpu_wait
	GPU_Execute
	
	out 14, PORT_GPU_X1
	GPU_Execute
	
	out 16, PORT_GPU_X1
	GPU_Execute
	
	out 17, PORT_GPU_X1
	GPU_Execute
	
	out 13, PORT_GPU_X1
	out 33, PORT_GPU_Y1
	GPU_Execute
	
	out 17, PORT_GPU_X1
	GPU_Execute
	
	;;; Pitcher
	out 14, PORT_GPU_X1
	out 14, PORT_GPU_Y1
	out GPU_CMD_SMALL_PRINTCHAR, PORT_GPU_COMMAND
	out 2, PORT_GPU_COLOR
	out 55, PORT_GPU_REGISTER
	call gpu_wait
	GPU_Execute
	
	;;; SBO Counter Setup
	out GPU_CMD_LARGE_PRINTCHAR, PORT_GPU_COMMAND
	out 4, PORT_GPU_COLOR
	
	;;; Strike Counter
	out 34, PORT_GPU_X1
	out 2, PORT_GPU_Y1
	out 29, PORT_GPU_REGISTER	; Set the Letter to S
	call gpu_wait
	GPU_Execute
	
	;;; Ball Counter
	out 11, PORT_GPU_Y1
	out 12, PORT_GPU_REGISTER	; Set the Letter to B
	call gpu_wait
	GPU_Execute
	
	;;; Out Counter
	out 20, PORT_GPU_Y1
	out 25, PORT_GPU_REGISTER	; Set the Letter to O
	call gpu_wait
	GPU_Execute
	
	;;; Scoreboard
	
	; Border
	out 48, PORT_GPU_X1
	out 64, PORT_GPU_X2
	out GPU_CMD_BORDER, PORT_GPU_COMMAND
	out 9, PORT_GPU_Y1
	out 19, PORT_GPU_Y2
	call gpu_wait
	GPU_Execute
	
	out 29, PORT_GPU_Y2
	call gpu_wait
	GPU_Execute
	
	out 0, PORT_GPU_Y1
	out 39, PORT_GPU_Y2
	out 56, PORT_GPU_X1
	call gpu_wait
	GPU_Execute
	
	out 48, PORT_GPU_X1
	out 15, PORT_GPU_COLOR
	call gpu_wait
	GPU_Execute
	
	; A
	out GPU_CMD_LARGE_PRINTCHAR, PORT_GPU_COMMAND
	out 50, PORT_GPU_X1
	out 1, PORT_GPU_Y1
	out 14, PORT_GPU_COLOR
	out 11, PORT_GPU_REGISTER	; Set Letter to A
	call gpu_wait
	GPU_Execute
	
	; H
	out 58, PORT_GPU_X1
	out 11, PORT_GPU_COLOR
	out 18, PORT_GPU_REGISTER	; Set Letter to H
	call gpu_wait
	GPU_Execute
	
	ret

; Updates the GUI, updating the status of the SBO and the bases. This
; method assumes that all the bases and the SBO are blank.
; Parameters:
;	Port 22 (GPU Color) - The color to make the players on the bases
;	Port 23 (GPU Buffer) - The working buffer
; Results:
;	none
; Clobbers:
;	AX
; Max Exec Time: 9.25 seconds
gui_update:

	;;; Setup ;;;
	; Set GPU command to small printchar
	out GPU_CMD_SMALL_PRINTCHAR, PORT_GPU_COMMAND
	; Set the character to * (the character for a player)
	out 55, PORT_GPU_REGISTER

_gui_update_first_base:
	;;; First Base ;;;
	; Check
	mov ax, [first_base]
	cmp ax, 0
	je _gui_update_second_base
	
	; Draw
	out 25, PORT_GPU_X1
	out 18, PORT_GPU_Y1
	;call gpu_wait
	GPU_Execute
	
_gui_update_second_base:
	;;; Second Base ;;;
	; Check
	mov ax, [second_base]
	cmp ax, 0
	je _gui_update_thrid_base
	
	; Draw
	out 14, PORT_GPU_X1
	out 3, PORT_GPU_Y1
	;call gpu_wait
	GPU_Execute

_gui_update_thrid_base:
	;;; Thrid Base ;;;
	; Check
	mov ax, [third_base]
	cmp ax, 0
	je _gui_update_SBO
	
	; Draw
	out 3, PORT_GPU_X1
	out 18, PORT_GPU_Y1
	;call gpu_wait
	GPU_Execute

_gui_update_SBO:
	;;; Setup ;;;
	out GPU_CMD_LARGE_PRINTCHAR, PORT_GPU_COMMAND

	;;; Strikes ;;;;
	out 41, PORT_GPU_X1
	out 2, PORT_GPU_Y1
	mov ax, [strikes]
	inc ax
	out ax, PORT_GPU_REGISTER
	GPU_Execute
	
	;;; Balls ;;;;
	out 11, PORT_GPU_Y1
	mov ax, [balls]
	inc ax
	out ax, PORT_GPU_REGISTER
	GPU_Execute
	
	;;; Outs ;;;;
	out 20, PORT_GPU_Y1
	mov ax, [outs]
	inc ax
	out ax, PORT_GPU_REGISTER
	GPU_Execute
	
	;;; Done ;;;
	ret
	

; Waits for the GPU to finish its current operation
; Clobbers:
;	AX
gpu_wait:
	in ax, 25
	cmp ax, 0
	jne gpu_wait
	ret
