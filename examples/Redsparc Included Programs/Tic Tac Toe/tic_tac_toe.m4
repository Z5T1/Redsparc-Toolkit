;;;;;;;;;;;;;;;;;;;; Redsparc Tic Tac Toe Game ;;;;;;;;;;;;;;;;;;;;;;;;;

include(gpu.m4)

define(`WORKING_BUFFER', 1)
define(`DISPLAY_BUFFER', 0)

define(`PLAYER_X', 34)
define(`PLAYER_O', 25)

define(`COLOR_X', 11)
define(`COLOR_O', 14)

; This is the classic tic tac toe game recreated for the redsparc.
; Unfortunately, it does not have win detection.

; It reads input from the keyboard. Each box corresponds to a key as follows:
;  Q | W | E
; ---+---+---
;  A | S | D
; ---+---+---
;  Z | X | C

; Setup
setup:
	
	;;;;; Setup the Stack ;;;;;
	mov sp, stack_top
	
	;;;;; Display Loading Message ;;;;;
	out GPU_CMD_LARGE_PRINTSTRING, PORT_GPU_COMMAND		; Set command to printstring
	out str_loading, PORT_GPU_REGISTER		; Set the string pointer
	GPU_Execute								; Execute the command
	mov ax, ax								; Wait 1 cycle (the GPU gets angry otherwise)
	
	;;;;; Setup the Necessary Screens ;;;;;
	out WORKING_BUFFER, PORT_GPU_BUFFER		; Set the buffer to Working Buffer
	
	; Print the Title String
	out str_tic_tac_toe, PORT_GPU_REGISTER	; Set the string Pointer
	call gpu_wait
	GPU_Execute								; Execute the command
	mov ax, ax								; Wait 1 cycle (the GPU gets angry otherwise)
	
	; Draw Box 1
	out GPU_CMD_BORDER, PORT_GPU_COMMAND
	out 28, PORT_GPU_X1
	out 9, PORT_GPU_Y1
	out 36, PORT_GPU_X2
	out 39, PORT_GPU_Y2
	call gpu_wait
	GPU_Execute
	mov ax, ax				; Wait 1 cycle (the GPU gets angry otherwise)
	
	; Draw Box 2
	out 20, PORT_GPU_X1
	out 19, PORT_GPU_Y1
	out 44, PORT_GPU_X2
	out 29, PORT_GPU_Y2
	call gpu_wait
	GPU_Execute
	mov ax, ax				; Wait 1 cycle (the GPU gets angry otherwise)
	
	; Draw Box 3 (To get rid of the unwanted borders)
	out 15, PORT_GPU_COLOR
	out 20, PORT_GPU_X1
	out 9, PORT_GPU_Y1
	out 44, PORT_GPU_X2
	out 39, PORT_GPU_Y2
	call gpu_wait
	GPU_Execute
	mov ax, ax				; Wait 1 cycle (the GPU gets angry otherwise)

;;;;; The Main Loop ;;;;;
; This is the location we jump back to

;;;;; X's Turn ;;;;;
player_x_turn:
	
	; Push
	out DISPLAY_BUFFER, PORT_GPU_REGISTER
	out GPU_CMD_COPY_BUFFER, PORT_GPU_COMMAND
	GPU_Execute
	
	out COLOR_X, PORT_GPU_COLOR

	; Print String X's Turn
	out DISPLAY_BUFFER, PORT_GPU_BUFFER		; We print this directly to the display buffer so it isn't saved
	out GPU_CMD_LARGE_PRINTSTRING, PORT_GPU_COMMAND
	out str_x_turn, PORT_GPU_REGISTER
	out 8, PORT_GPU_X1
	out 41, PORT_GPU_Y1
	GPU_Execute
	
	; Wait for X to go
	call keyboard_get
	
	; Prepare GPU
	out WORKING_BUFFER, PORT_GPU_BUFFER		; Set Buffer Back to Working Buffer
	out 34, PORT_GPU_REGISTER		; Set Character to X
	out GPU_CMD_LARGE_PRINTCHAR, PORT_GPU_COMMAND
	
	;;; Check which key was pressed ;;;
	; Q
	cmp ax, 27
	je player_x_pressed_q
	
	; W
	cmp ax, 33
	je player_x_pressed_w
	
	; E
	cmp ax, 15
	je player_x_pressed_e
	
	; A
	cmp ax, 11
	je player_x_pressed_a
	
	; S
	cmp ax, 29
	je player_x_pressed_s
	
	; D
	cmp ax, 14
	je player_x_pressed_d
	
	; Z
	cmp ax, 36
	je player_x_pressed_z
	
	; X
	cmp ax, 34
	je player_x_pressed_x
	
	; C
	cmp ax, 13
	je player_x_pressed_c
	
	jmp player_o_turn

player_x_pressed_q:
	out 22, PORT_GPU_X1
	out 11, PORT_GPU_Y1
	GPU_Execute
	jmp player_o_turn
	
player_x_pressed_w:
	out 30, PORT_GPU_X1
	out 11, PORT_GPU_Y1
	GPU_Execute
	jmp player_o_turn

player_x_pressed_e:
	out 38, PORT_GPU_X1
	out 11, PORT_GPU_Y1
	GPU_Execute
	jmp player_o_turn

player_x_pressed_a:
	out 22, PORT_GPU_X1
	out 21, PORT_GPU_Y1
	GPU_Execute
	jmp player_o_turn
	
player_x_pressed_s:
	out 30, PORT_GPU_X1
	out 21, PORT_GPU_Y1
	GPU_Execute
	jmp player_o_turn

player_x_pressed_d:
	out 38, PORT_GPU_X1
	out 21, PORT_GPU_Y1
	GPU_Execute
	jmp player_o_turn
	
player_x_pressed_z:
	out 22, PORT_GPU_X1
	out 31, PORT_GPU_Y1
	GPU_Execute
	jmp player_o_turn
	
player_x_pressed_x:
	out 30, PORT_GPU_X1
	out 31, PORT_GPU_Y1
	GPU_Execute
	jmp player_o_turn

player_x_pressed_c:
	out 38, PORT_GPU_X1
	out 31, PORT_GPU_Y1
	GPU_Execute
	jmp player_o_turn

player_o_turn:
	
	; Push
	out DISPLAY_BUFFER, PORT_GPU_REGISTER
	out GPU_CMD_COPY_BUFFER, PORT_GPU_COMMAND
	GPU_Execute
	
	out COLOR_O, PORT_GPU_COLOR

	; Print String X's Turn
	out DISPLAY_BUFFER, PORT_GPU_BUFFER		; We print this directly to the display buffer so it isn't saved
	out GPU_CMD_LARGE_PRINTSTRING, PORT_GPU_COMMAND
	out str_o_turn, PORT_GPU_REGISTER
	out 8, PORT_GPU_X1
	out 41, PORT_GPU_Y1
	GPU_Execute
	
	; Wait for X to go
	call keyboard_get
	
	; Prepare GPU
	out WORKING_BUFFER, PORT_GPU_BUFFER		; Set Buffer Back to Working Buffer
	out 25, PORT_GPU_REGISTER		; Set Character to X
	out GPU_CMD_LARGE_PRINTCHAR, PORT_GPU_COMMAND
	
	;;; Check which key was pressed ;;;
	; Q
	cmp ax, 27
	je player_o_pressed_q
	
	; W
	cmp ax, 33
	je player_o_pressed_w
	
	; E
	cmp ax, 15
	je player_o_pressed_e
	
	; A
	cmp ax, 11
	je player_o_pressed_a
	
	; S
	cmp ax, 29
	je player_o_pressed_s
	
	; D
	cmp ax, 14
	je player_o_pressed_d
	
	; Z
	cmp ax, 36
	je player_o_pressed_z
	
	; X
	cmp ax, 34
	je player_o_pressed_x
	
	; C
	cmp ax, 13
	je player_o_pressed_c
	
	jmp player_x_turn

player_o_pressed_q:
	out 22, PORT_GPU_X1
	out 11, PORT_GPU_Y1
	GPU_Execute
	jmp player_x_turn
	
player_o_pressed_w:
	out 30, PORT_GPU_X1
	out 11, PORT_GPU_Y1
	GPU_Execute
	jmp player_x_turn

player_o_pressed_e:
	out 38, PORT_GPU_X1
	out 11, PORT_GPU_Y1
	GPU_Execute
	jmp player_x_turn

player_o_pressed_a:
	out 22, PORT_GPU_X1
	out 21, PORT_GPU_Y1
	GPU_Execute
	jmp player_x_turn
	
player_o_pressed_s:
	out 30, PORT_GPU_X1
	out 21, PORT_GPU_Y1
	GPU_Execute
	jmp player_x_turn

player_o_pressed_d:
	out 38, PORT_GPU_X1
	out 21, PORT_GPU_Y1
	GPU_Execute
	jmp player_x_turn
	
player_o_pressed_z:
	out 22, PORT_GPU_X1
	out 31, PORT_GPU_Y1
	GPU_Execute
	jmp player_x_turn
	
player_o_pressed_x:
	out 30, PORT_GPU_X1
	out 31, PORT_GPU_Y1
	GPU_Execute
	jmp player_x_turn

player_o_pressed_c:
	out 38, PORT_GPU_X1
	out 31, PORT_GPU_Y1
	GPU_Execute
	jmp player_x_turn
	
; This shouldn't happen, but just in case
end:
	hlt
	
; Waits for the GPU to finish its current operation
; Clobbers:
;	AX
gpu_wait:
	in ax, 25
	cmp ax, 0
	jne gpu_wait
	ret
	

;;;;; Strings ;;;;
str_loading:
	ds "Loading..."
str_tic_tac_toe:
	ds "Tic Tac Toe"
str_x_turn:
	ds "X's Turn"
str_o_turn:
	ds "O's Turn"

;;;;; Stack Memory ;;;;
stack_bottom:
	dw 0 15
stack_top:
	dw 0
