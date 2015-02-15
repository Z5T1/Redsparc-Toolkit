;;;;;;;;;;;;;; Redsparc Numpad Display Example Program ;;;;;;;;;;;;;;;;;
; Assemble with: zasm typing.asm -o typing.zob
; Link with: zlink typing.zob -o typing.rs -lkeyboard -lnumpad

; This example waits for the user to press a key on the keyboard and
; then prints that character to the screen.

; Register Usage:
;	AX - Character
;	BX - Color
;	CX - Column
;	DX - Line

; Function Keys
;	F1 - Change Color

; Changing the Color
;	To change the color, press F1 and enter the new color's color code
;	on the numpad.

; Setup for the program
setup:

	; Set up the stack
	mov sp, stack_top
	
	; Set up Coordinates
	mov cx, 1	; Column * 5
	mov dx, 1	; Line * 7
	out 1, 18	; X1 = 5
	out 1, 19	; Y1 = 7
	out 1, 20	; X2 = 1
	out 1, 21	; Y2 = 1
	
; Start of the program
; This is the location we loop back to
top:

	; Get the keyboard input
	call keyboard_get
	
	; Check for special keys (BS, CR, F1, F2)
	; We check AX, as keyboard_get stores its results in AX
	; Before we check for special keys, we check to see if it is not a
	; special key. If it is not, we bypass the entire check to save time.
		cmp ax, 58
		jl putchar
	; Carriage Return
		je carriage_return
	; Backspace
		cmp ax, 60
		je backspace
	; F1 - Change Color
		cmp ax, 64
		je change_color

; Print the character to the screen
putchar:
	
	out bx, 22	; Set the GPU color to BX (the color register)
	out ax, 24	; Write the current character to the GPU Register
	out 64, 17	; Set GPU command to printchar
	out 1, 16	; Execute
	
	; Increase the column number
	add cx, 6	; 1 column = 6 pixels
	out cx, 18	; Write the column (CX) to X1
	
	; Jump back to the top
	jmp top
	
; Print a backspace
; Erases the previous character and moves the cursor
backspace:
	
	; Move the column back 1 character (6 pixels)
	sub cx, 6
	
	; Erease the current character
	out cx, 18	; Write the column (CX) to X1
	out 15, 22	; Set the GPU color to black
	out 60, 24	; Set the character to backspace
	out 1, 16	; Execute
	
	; Jump back to the top
	jmp top
	
; Starts a new line
carriage_return:

	; Increment the line (add 8 pixels)
	add dx, 8
	out dx, 19
	
	; Reset the column (set it to 1)
	mov cx, 1
	out cx, 18
	
	; Jump back to the top
	jmp top

; Changes the color
change_color:

	; Get the numpad input
	call numpad_get
	
	; Copy the number entered (AX) to the color register (BX)
	mov bx, ax
	
	; Jump back to the top
	jmp top


; End of the program
end:
	hlt
	
; Stack memory
stack_bottom:
	; Defines 7 words of memory as zero
	dw 0 7
stack_top:
	; We define an additional value as zero at the top of the stack for
	; the first value pushed
	dw 0 1
