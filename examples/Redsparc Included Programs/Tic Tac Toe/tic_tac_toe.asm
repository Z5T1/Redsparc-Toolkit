;;;;;;;;;;;;;; Redsparc Numpad Display Example Program ;;;;;;;;;;;;;;;;;

; Included gpu.m4                                 










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
	out 65, 17		; Set command to printstring
	out str_loading, 24		; Set the string pointer
	out 1, 16								; Execute the command
	mov ax, ax								; Wait 1 cycle (the GPU gets angry otherwise)
	
	;;;;; Setup the Necessary Screens ;;;;;
	out 1, 23		; Set the buffer to Working Buffer
	
	; Print the Title String
	out str_tic_tac_toe, 24	; Set the string Pointer
	call gpu_wait
	out 1, 16								; Execute the command
	mov ax, ax								; Wait 1 cycle (the GPU gets angry otherwise)
	
	; Draw Box 1
	out 4, 17
	out 28, 18
	out 9, 19
	out 36, 20
	out 39, 21
	call gpu_wait
	out 1, 16
	mov ax, ax				; Wait 1 cycle (the GPU gets angry otherwise)
	
	; Draw Box 2
	out 20, 18
	out 19, 19
	out 44, 20
	out 29, 21
	call gpu_wait
	out 1, 16
	mov ax, ax				; Wait 1 cycle (the GPU gets angry otherwise)
	
	; Draw Box 3 (To get rid of the unwanted borders)
	out 15, 22
	out 20, 18
	out 9, 19
	out 44, 20
	out 39, 21
	call gpu_wait
	out 1, 16
	mov ax, ax				; Wait 1 cycle (the GPU gets angry otherwise)

;;;;; The Main Loop ;;;;;
; This is the location we jump back to

;;;;; X's Turn ;;;;;
player_x_turn:
	
	; Push
	out 0, 24
	out 1, 17
	out 1, 16
	
	out 11, 22

	; Print String X's Turn
	out 0, 23		; We print this directly to the display buffer so it isn't saved
	out 65, 17
	out str_x_turn, 24
	out 8, 18
	out 41, 19
	out 1, 16
	
	; Wait for X to go
	call keyboard_get
	
	; Prepare GPU
	out 1, 23		; Set Buffer Back to Working Buffer
	out 34, 24		; Set Character to X
	out 64, 17
	
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
	out 22, 18
	out 11, 19
	out 1, 16
	jmp player_o_turn
	
player_x_pressed_w:
	out 30, 18
	out 11, 19
	out 1, 16
	jmp player_o_turn

player_x_pressed_e:
	out 38, 18
	out 11, 19
	out 1, 16
	jmp player_o_turn

player_x_pressed_a:
	out 22, 18
	out 21, 19
	out 1, 16
	jmp player_o_turn
	
player_x_pressed_s:
	out 30, 18
	out 21, 19
	out 1, 16
	jmp player_o_turn

player_x_pressed_d:
	out 38, 18
	out 21, 19
	out 1, 16
	jmp player_o_turn
	
player_x_pressed_z:
	out 22, 18
	out 31, 19
	out 1, 16
	jmp player_o_turn
	
player_x_pressed_x:
	out 30, 18
	out 31, 19
	out 1, 16
	jmp player_o_turn

player_x_pressed_c:
	out 38, 18
	out 31, 19
	out 1, 16
	jmp player_o_turn

player_o_turn:
	
	; Push
	out 0, 24
	out 1, 17
	out 1, 16
	
	out 14, 22

	; Print String X's Turn
	out 0, 23		; We print this directly to the display buffer so it isn't saved
	out 65, 17
	out str_o_turn, 24
	out 8, 18
	out 41, 19
	out 1, 16
	
	; Wait for X to go
	call keyboard_get
	
	; Prepare GPU
	out 1, 23		; Set Buffer Back to Working Buffer
	out 25, 24		; Set Character to X
	out 64, 17
	
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
	out 22, 18
	out 11, 19
	out 1, 16
	jmp player_x_turn
	
player_o_pressed_w:
	out 30, 18
	out 11, 19
	out 1, 16
	jmp player_x_turn

player_o_pressed_e:
	out 38, 18
	out 11, 19
	out 1, 16
	jmp player_x_turn

player_o_pressed_a:
	out 22, 18
	out 21, 19
	out 1, 16
	jmp player_x_turn
	
player_o_pressed_s:
	out 30, 18
	out 21, 19
	out 1, 16
	jmp player_x_turn

player_o_pressed_d:
	out 38, 18
	out 21, 19
	out 1, 16
	jmp player_x_turn
	
player_o_pressed_z:
	out 22, 18
	out 31, 19
	out 1, 16
	jmp player_x_turn
	
player_o_pressed_x:
	out 30, 18
	out 31, 19
	out 1, 16
	jmp player_x_turn

player_o_pressed_c:
	out 38, 18
	out 31, 19
	out 1, 16
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
