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

	; Print Text
	
	
	out 1, 19					; Set GPU_Y1
	out str_s1_l1, 24			; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we dont)
	
	
	out 7, 19					; Set GPU_Y1
	out str_s1_l2, 24			; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we dont)
	
	
	out 13, 19					; Set GPU_Y1
	out str_s1_l3, 24			; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we dont)
	
	
	out 19, 19					; Set GPU_Y1
	out str_s1_l4, 24			; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we dont)
	
	
	out 25, 19					; Set GPU_Y1
	out str_s1_l5, 24			; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we dont)
	
	
	out 31, 19					; Set GPU_Y1
	out str_s1_l6, 24			; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we dont)
	
	
	out 37, 19					; Set GPU_Y1
	out str_s1_l7, 24			; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we dont)
	
	
	out 43, 19					; Set GPU_Y1
	out str_s1_l8, 24			; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we dont)
	
	

	; Push Buffer 1 to the User
	out 1, 17	; GPU Command = copy buffer
	out 0, 24			; Destination Buffer = 0 (screen)
	call gpu_wait						; Wait
	out 1, 16							; Execute
	
; Screen 2
screen_2:
	; Clear Working Buffer
	out 1, 24			; Set Destination buffer to 1 (working buffer)
	out 16, 23				; Set the source buffer to 16 (Buffer 16 is guaranteed to always be blank)
	out 1, 17	; GPU Command = copy buffer
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we don't)
	
	; Go Back to Text Printing Mode
	out 81, 17	; GPU Command = printstring
	out 1, 23				; Set Working buffer to 1 (double buffer mode)
	out 1, 18					; GPU_X1 = 1

	; Print Text
	
	
	out 1, 19					; Set GPU_Y1
	out str_s2_l1, 24			; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we dont)
	
	
	out 7, 19					; Set GPU_Y1
	out str_s2_l2, 24			; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we dont)
	
	
	out 13, 19					; Set GPU_Y1
	out str_s2_l3, 24			; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we dont)
	
	
	out 19, 19					; Set GPU_Y1
	out str_s2_l4, 24			; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we dont)
	
	
	out 25, 19					; Set GPU_Y1
	out str_s2_l5, 24			; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we dont)
	
	
	out 31, 19					; Set GPU_Y1
	out str_s2_l6, 24			; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we dont)
	
	
	out 37, 19					; Set GPU_Y1
	out str_s2_l7, 24			; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we dont)
	
	
	out 43, 19					; Set GPU_Y1
	out str_s2_l8, 24			; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we dont)
	
	

	; Push Buffer 1 to the User
	out 1, 17	; GPU Command = copy buffer
	out 0, 24			; Destination Buffer = 0 (screen)
	call gpu_wait						; Wait
	out 1, 16							; Execute
	
	; Wait for the user
	out 0, 10	; Flush the keyboard buffer (incase the user's impaitent)
	call keyboard_get
	
screen_3:
		; Clear Working Buffer
	out 1, 24			; Set Destination buffer to 1 (working buffer)
	out 16, 23				; Set the source buffer to 16 (Buffer 16 is guaranteed to always be blank)
	out 1, 17	; GPU Command = copy buffer
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we don't)
	
	; Go Back to Text Printing Mode
	out 81, 17	; GPU Command = printstring
	out 1, 23				; Set Working buffer to 1 (double buffer mode)
	out 1, 18					; GPU_X1 = 1

	; Print Text
	
	
	out 1, 19					; Set GPU_Y1
	out str_s3_l1, 24			; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we dont)
	
	
	out 7, 19					; Set GPU_Y1
	out str_s3_l2, 24			; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we dont)
	
	
	out 13, 19					; Set GPU_Y1
	out str_s3_l3, 24			; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we dont)
	
	
	out 19, 19					; Set GPU_Y1
	out str_s3_l4, 24			; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we dont)
	
	
	out 25, 19					; Set GPU_Y1
	out str_s3_l5, 24			; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we dont)
	
	
	out 31, 19					; Set GPU_Y1
	out str_s3_l6, 24			; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we dont)
	
	
	out 37, 19					; Set GPU_Y1
	out str_s3_l7, 24			; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we dont)
	
	
	out 43, 19					; Set GPU_Y1
	out str_s3_l8, 24			; Write String Location
	call gpu_wait						; Wait
	out 1, 16							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we dont)
	
	

	; Push Buffer 1 to the User
	out 1, 17	; GPU Command = copy buffer
	out 0, 24			; Destination Buffer = 0 (screen)
	call gpu_wait						; Wait
	out 1, 16							; Execute
	
	; Wait for the user
	out 0, 10	; Flush the keyboard buffer (incase the user's impaitent)
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
	ds "In case you"
str_s2_l2:
	ds "didn't notice,"
str_s2_l3:
	ds "the Redsparc can"
str_s2_l4:
	ds "be a bit slow at"
str_s2_l5:
	ds "times. Just be"
str_s2_l6:
	ds "paitent and wait"
str_s2_l7:
	ds "Press any key to"
str_s2_l8:
	ds "continue."
	
				
; Screen 3 Text

str_s3_l1:
	ds "Now let's start"
str_s3_l2:
	ds "by learning how"
str_s3_l3:
	ds "to input data to"
str_s3_l4:
	ds "the Redsparc. It"
str_s3_l5:
	ds "has several ways"
str_s3_l6:
	ds "of doing this."
str_s3_l7:
	ds "you've used the"
str_s3_l8:
	ds "keyboard already"
	

; Screen 3 Text
;"          "
;"This tut-"
;"orial will"
;"explain to"
;"you how to"
;"use your"
;"Redsparc"

