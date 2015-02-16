;;;;;;;;;;;;;;;;;;; The Redsparc Welcome Program ;;;;;;;;;;;;;;;;;;;;;;;

include(io.m4)
include(gpu.m4)

; This program welcomes the user to the Redsparc, giving him a brief
; tutorial of how to use the computer.

; Loading Screen
screen_loading:
	out GPU_CMD_LARGE_PRINTSTRING, PORT_GPU_COMMAND	; GPU Command = printstring
	out 1, PORT_GPU_X1					; GPU_X1 = 1
	out 1, PORT_GPU_Y1					; GPU_Y1 = 1
	out str_loading, PORT_GPU_REGISTER	; Write String Location
	GPU_Execute							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we don't)

; Screen 1
screen_1:
	out GPU_CMD_SMALL_PRINTSTRING, PORT_GPU_COMMAND	; GPU Command = printstring
	out 1, PORT_GPU_BUFFER				; Set Working buffer to 1 (double buffer mode)
	out 1, PORT_GPU_X1					; GPU_X1 = 1

	; Line 1
	out 1, PORT_GPU_Y1					; GPU_Y1 = 1
	out str_s1_l1, PORT_GPU_REGISTER	; Write String Location
	call gpu_wait						; Wait
	GPU_Execute							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we don't)
	
	; Line 2
	out 7, PORT_GPU_Y1					; GPU_Y1 = 7
	out str_s1_l2, PORT_GPU_REGISTER	; Write String Location
	call gpu_wait						; Wait
	GPU_Execute							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we don't)
	
	; Line 3
	out 13, PORT_GPU_Y1					; GPU_Y1 = 13
	out str_s1_l3, PORT_GPU_REGISTER	; Write String Location
	call gpu_wait						; Wait
	GPU_Execute							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we don't)
	
	; Line 4
	out 19, PORT_GPU_Y1					; GPU_Y1 = 19
	out str_s1_l4, PORT_GPU_REGISTER	; Write String Location
	call gpu_wait						; Wait
	GPU_Execute							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we don't)
	
	; Line 5
	out 25, PORT_GPU_Y1					; GPU_Y1 = 25
	out str_s1_l5, PORT_GPU_REGISTER	; Write String Location
	call gpu_wait						; Wait
	GPU_Execute							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we don't)
	
	; Line 6
	out 31, PORT_GPU_Y1					; GPU_Y1 = 31
	out str_s1_l6, PORT_GPU_REGISTER	; Write String Location
	call gpu_wait						; Wait
	GPU_Execute							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we don't)

	; Line 7
	out 37, PORT_GPU_Y1					; GPU_Y1 = 37
	out str_s1_l7, PORT_GPU_REGISTER	; Write String Location
	call gpu_wait						; Wait
	GPU_Execute							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we don't)
	
	; Line 8
	out 43, PORT_GPU_Y1					; GPU_Y1 = 43
	out str_s1_l8, PORT_GPU_REGISTER	; Write String Location
	call gpu_wait						; Wait
	GPU_Execute							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we don't)
	
	; Push Buffer 1 to the User
	out GPU_CMD_COPY_BUFFER, PORT_GPU_COMMAND	; GPU Command = copy buffer
	out 0, PORT_GPU_REGISTER			; Destination Buffer = 0 (screen)
	call gpu_wait						; Wait
	GPU_Execute							; Execute
	
	; Wait for the user
	call keyboard_get
	
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

;;;;; Strings ;;;;;

; Loading
str_loading:
	ds "Loading..."

; Screen 1 Text
str_s1_l1:
	ds "Welcome to the"
str_s1_l2:
	ds "Redsparc! This"
str_s1_l3:
	ds "tutorial will"
str_s1_l4:
	ds "teach you how to"
str_s1_l5:
	ds "use your new"
str_s1_l6:
	ds "computer. Press"
str_s1_l7:
	ds "any key to"
str_s1_l8:
	ds "begin."
	
; Screen 2 Text
str_s2_l1:
	ds "Press any"
str_s2_l2:
	ds "key to"
str_s2_l3:
	ds "advance to"
str_s2_l4:
	ds "the next"
str_s2_l5:
	ds "screen at"
str_s2_l6:
	ds "any point."

; Screen 3 Text
;"          "
;"This tut-"
;"orial will"
;"explain to"
;"you how to"
;"use your"
;"Redsparc"

