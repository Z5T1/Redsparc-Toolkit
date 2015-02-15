;;;;;;;;;;;;;;;;;;; The Redsparc Welcome Program ;;;;;;;;;;;;;;;;;;;;;;;
; Assemble with: zasm welcome.asm -o welcome.zob
; Link with: zlink welcome.zob -lkeyboard -lnumpad -lgamepad -o welcome.rs

; This program welcomes the user to the Redsparc, giving him a brief
; tutorial of how to use the computer.

; Screen 1
screen_1:
	out 65, 17	; GPU Command = printstring
	out 1, 18	; GPU_X1 = 1

	; Line 1
	out 1, 19			; GPU_Y1 = 1
	out str_s1_l1, 24	; Write String Location
	out 1, 16			; Execute
	mov ax, ax			; Wait one CPU cycle (The GPU gets angry if we don't)
	
	; Line 2
	out 9, 19			; GPU_Y1 = 9
	out str_s1_l2, 24	; Write String Location
	call gpu_wait		; Wait
	out 1, 16			; Execute
	mov ax, ax			; Wait one CPU cycle (The GPU gets angry if we don't)
	
	; Line 3
	out 17, 19			; GPU_Y1 = 17
	out str_s1_l3, 24	; Write String Location
	call gpu_wait		; Wait
	out 1, 16			; Execute
	mov ax, ax			; Wait one CPU cycle (The GPU gets angry if we don't)
	
	; Line 4
	out 25, 19			; GPU_Y1 = 25
	out str_s1_l4, 24	; Write String Location
	call gpu_wait		; Wait
	out 1, 16			; Execute
	mov ax, ax			; Wait one CPU cycle (The GPU gets angry if we don't)
	
	; Line 5
	out 33, 19			; GPU_Y1 = 33
	out str_s1_l5, 24	; Write String Location
	call gpu_wait		; Wait
	out 1, 16			; Execute
	mov ax, ax			; Wait one CPU cycle (The GPU gets angry if we don't)
	
	; Line 6
	out 41, 19			; GPU_Y1 = 41
	out str_s1_l6, 24	; Write String Location
	call gpu_wait		; Wait
	out 1, 16			; Execute
	
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

; Screen 1 Text
str_s1_l1:
	ds "Welcome"
str_s1_l2:
	ds "to the"
str_s1_l3:
	ds "Redsparc!"
str_s1_l4:
	ds "Press any"
str_s1_l5:
	ds "key to"
str_s1_l6:
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
"          "
"This tut-"
"orial will"
"explain to"
"you how to"
"use your"
"Redsparc"

