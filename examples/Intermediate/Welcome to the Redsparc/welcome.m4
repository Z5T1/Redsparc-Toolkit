;;;;;;;;;;;;;;;;;;; The Redsparc Welcome Program ;;;;;;;;;;;;;;;;;;;;;;;

include(io.m4)
include(gpu.m4)

dnl Prints the string pointed to by $1 to the working buffer at the
dnl Y coordinate specified by $2
define(`PRINT_STRING_AT_Y', `
	out $2, PORT_GPU_Y1					; Set GPU_Y1
	out $1, PORT_GPU_REGISTER			; Write String Location
	call gpu_wait						; Wait
	GPU_Execute							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we dont)
	')dnl

dnl Prints the screen specified by $1 to the working buffer
define(`PRINT_SCREEN', `
	PRINT_STRING_AT_Y(str_$1_l1, 1)
	PRINT_STRING_AT_Y(str_$1_l2, 7)
	PRINT_STRING_AT_Y(str_$1_l3, 13)
	PRINT_STRING_AT_Y(str_$1_l4, 19)
	PRINT_STRING_AT_Y(str_$1_l5, 25)
	PRINT_STRING_AT_Y(str_$1_l6, 31)
	PRINT_STRING_AT_Y(str_$1_l7, 37)
	PRINT_STRING_AT_Y(str_$1_l8, 43)
	')dnl
	
dnl Defines a screen with $1 - $8 being the text for each line
dnl respectively, and $9 being the screen name
define(`DEFINE_SCREEN', `
str_$9_l1:
	ds $1
str_$9_l2:
	ds $2
str_$9_l3:
	ds $3
str_$9_l4:
	ds $4
str_$9_l5:
	ds $5
str_$9_l6:
	ds $6
str_$9_l7:
	ds $7
str_$9_l8:
	ds $8
	')dnl
	
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

	; Print Text
	PRINT_SCREEN(s1)

	; Push Buffer 1 to the User
	out GPU_CMD_COPY_BUFFER, PORT_GPU_COMMAND	; GPU Command = copy buffer
	out 0, PORT_GPU_REGISTER			; Destination Buffer = 0 (screen)
	call gpu_wait						; Wait
	GPU_Execute							; Execute
	
; Screen 2
screen_2:
	; Clear Working Buffer
	out 1, PORT_GPU_REGISTER			; Set Destination buffer to 1 (working buffer)
	out 16, PORT_GPU_BUFFER				; Set the source buffer to 16 (Buffer 16 is guaranteed to always be blank)
	out GPU_CMD_COPY_BUFFER, PORT_GPU_COMMAND	; GPU Command = copy buffer
	GPU_Execute							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we don't)
	
	; Go Back to Text Printing Mode
	out GPU_CMD_SMALL_PRINTSTRING, PORT_GPU_COMMAND	; GPU Command = printstring
	out 1, PORT_GPU_BUFFER				; Set Working buffer to 1 (double buffer mode)
	out 1, PORT_GPU_X1					; GPU_X1 = 1

	; Print Text
	PRINT_SCREEN(s2)

	; Wait for the user
	call keyboard_get

	; Push Buffer 1 to the User
	out GPU_CMD_COPY_BUFFER, PORT_GPU_COMMAND	; GPU Command = copy buffer
	out 0, PORT_GPU_REGISTER			; Destination Buffer = 0 (screen)
	call gpu_wait						; Wait
	GPU_Execute							; Execute
	
screen_3:
	; Clear Working Buffer
	out 1, PORT_GPU_REGISTER			; Set Destination buffer to 1 (working buffer)
	out 16, PORT_GPU_BUFFER				; Set the source buffer to 16 (Buffer 16 is guaranteed to always be blank)
	out GPU_CMD_COPY_BUFFER, PORT_GPU_COMMAND	; GPU Command = copy buffer
	GPU_Execute							; Execute
	mov ax, ax							; Wait one CPU cycle (The GPU gets angry if we don't)
	
	; Go Back to Text Printing Mode
	out GPU_CMD_SMALL_PRINTSTRING, PORT_GPU_COMMAND	; GPU Command = printstring
	out 1, PORT_GPU_BUFFER				; Set Working buffer to 1 (double buffer mode)
	out 1, PORT_GPU_X1					; GPU_X1 = 1

	; Print Text
	PRINT_SCREEN(s3)

	; Wait for the user
	call keyboard_get

	; Push Buffer 1 to the User
	out GPU_CMD_COPY_BUFFER, PORT_GPU_COMMAND	; GPU Command = copy buffer
	out 0, PORT_GPU_REGISTER			; Destination Buffer = 0 (screen)
	call gpu_wait						; Wait
	GPU_Execute							; Execute
	
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

changequote(<','>)

; Loading
str_loading:
	ds "Loading..."

; Screen 1 Text
DEFINE_SCREEN(	<'"Welcome to the"'>,
				<'"Redsparc! This"'>,
				<'"tutorial will"'>,
				<'"teach you how to"'>,
				<'"use your new"'>,
				<'"computer. Press"'>,
				<'"any key to"'>,
				<'"begin."'>,
				<'s1'>)

; Screen 2 Text
DEFINE_SCREEN(	<'"In case you"'>,
				<'"didn't notice,"'>,
				<'"the Redsparc can"'>,
				<'"be a bit slow at"'>,
				<'"times. Just be"'>,
				<'"paitent and wait"'>,
				<'"Press any key to"'>,
				<'"continue."'>,
				<'s2'>)
				
; Screen 3 Text
DEFINE_SCREEN(	<'"Now let's start"'>,
				<'"by learning how"'>,
				<'"to input data to"'>,
				<'"the Redsparc. It"'>,
				<'"has several ways"'>,
				<'"of doing this."'>,
				<'"you've used the"'>,
				<'"keyboard already"'>,
				<'s3'>)
				
; Screen 4 Text
DEFINE_SCREEN(	<'"Now let's learn"'>,
				<'"how to input"'>,
				<'"numbers. If you"'>,
				<'"look to the left"'>,
				<'"you will see the"'>,
				<'"the numeric"'>,
				<'"input pad. Don't"'>,
				<'"worry, it's easier"


