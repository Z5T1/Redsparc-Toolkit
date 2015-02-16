;;;;;;;;;;;;;;;;;;; The Redsparc Welcome Program ;;;;;;;;;;;;;;;;;;;;;;;

; Included io.m4                   
; Included gpu.m4                                 

; This program welcomes the user to the Redsparc, giving him a brief
; tutorial of how to use the computer.

; Loading Screen
screen_loading:
	out 65, 17	; GPU Command = printstring
	out 1, 18					; GPU_X1 = 1
	out 1, 19					; GPU_Y1 = 1
	out str_loading, 24	; Write String Location
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we don't)

; Screen 1
screen_1:
	out 81, 17	; GPU Command = printstring
	out 1, 23				; Set Working buffer to 1 (double buffer mode)
	out 1, 18					; GPU_X1 = 1

	; Line 1
	out 1, 19					; GPU_Y1 = 1
	out str_s1_l1, 24	; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we don't)
	
	; Line 2
	out 7, 19					; GPU_Y1 = 7
	out str_s1_l2, 24	; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we don't)
	
	; Line 3
	out 13, 19					; GPU_Y1 = 13
	out str_s1_l3, 24	; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we don't)
	
	; Line 4
	out 19, 19					; GPU_Y1 = 19
	out str_s1_l4, 24	; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we don't)
	
	; Line 5
	out 25, 19					; GPU_Y1 = 25
	out str_s1_l5, 24	; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we don't)
	
	; Line 6
	out 31, 19					; GPU_Y1 = 31
	out str_s1_l6, 24	; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we don't)

	; Line 7
	out 37, 19					; GPU_Y1 = 37
	out str_s1_l7, 24	; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we don't)
	
	; Line 8
	out 43, 19					; GPU_Y1 = 43
	out str_s1_l8, 24	; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we don't)
	
	; Push Buffer 1 to the User
	out 1, 17	; GPU Command = copy buffer
	out 0, 24			; Destination Buffer = 0 (screen)
	call gpu_wait						; Wait
	out 1, 16							; Execute
	
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
	ds "Redsparc. Press"
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

