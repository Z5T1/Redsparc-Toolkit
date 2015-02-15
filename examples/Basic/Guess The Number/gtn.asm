;;;;;;;;;;;;;;;;;;; Redsparc Guess the Number Game ;;;;;;;;;;;;;;;;;;;;;
; Assemble with: zasm gtn.asm -o gtn.zob
; Link with: zlink gtn.zob -o gtn.rs -lnumpad

; A note to the reader: this is one of the more advanced programs. You
; should make sure you have a good understanding of the simpler programs
; before attempting to untangle this one.

; This is a guess the number game for the Redsparc. It generates a
; random number between 1 and 25 (inclusive), which the user must then
; guess. It uses the arrows to indicate which direction the answer is,
; and the ! symbol to indicate when you have guessed the number

; Note: We do not use BX in this program as it is clobbered by
; numpad_get

; Setup for the Game
setup:
	
	; Setup the Stack
	mov sp, stack_top
	
	; Read the random number into CX
	in cx, 8
	
	; Reduce the range of CX to 1 - 25
	mov dx, 25
	mod cx, dx
	inc cx
	
	; Reset DX to 0 as we will be using it to store the guess count
	mov dx, 0
	
; Start of Game
; This is the location we loop back to
top:

	; Turn on ? symbol
	out 1, 6
	
	; Get guess
	call numpad_get
	
	; Turn off ? symbol
	out 0, 6
	
	; Print guess to display
	out ax, 1
	
	; Increment guess count
	inc dx
	
	; Compare the guess to the answer and jump accordingly
	cmp ax, cx
	jl up		; If guess < answer
	jg down		; If guess > answer
	
	
; When guess = answer
equal:

	; Turn off ^ and v Symbols
	out 0, 2
	out 0, 3

	; Turn on ! symbol
	out 1, 7
	
	; Print number of guesses
	out dx, 1
	
	; Halt
	hlt

; When guess < answer
up:
	
	; Turn v off
	out 0, 3
	
	; Turn ^ on
	out 1, 2
	
	; Jump to top
	jmp top

; When guess > answer
down:
	
	; Turn ^ off
	out 0, 2
	
	; Turn v on
	out 1, 3
	
	; Jump to top
	jmp top

; Stack Memory
stack_bottom:
	; Defines 15 words of memory as zero
	dw 0 15
stack_top:
	; We define an additional value as zero at the top of the stack for
	; the first value pushed
	dw 0 1
