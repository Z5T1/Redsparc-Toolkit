;;;;;;;;;;;;;;;;;;;;;;;; Redsparc Marco Polo ;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Assemble with: zasm marco_polo.asm -o marco_polo.zob
; Link with: zlink marco_polo.zob -o marco_polo.rs -lgamepad

; A note to the reader: this is one of the more advanced programs. You
; should make sure you have a good understanding of the simpler programs
; before attempting to untangle this one.

; This is the classic game Marco Polo for the Redsparc. You move using
; the directional control on the gamepad (up, down, left, right) and say
; "Marco" by pressing ok on the gamepad. The arrow symbols indicate
; which direction you need to travel. The ! symbol is lit when you have
; found Polo, and the ? symbol is lit on an incorrect guess. Be warned
; however that you only have 5 guesses

; Note: We do not use BX in this program as it is clobbered by
; gamepad_get



; Register / Memory Usage:
;	SI = Marco's x coordinate
;	DI = Marco's y coordinate
;	DX = Guess counter
;	CX = Comparison register
;	polo_x = Polo's x coordinate
;	polo_y = Polo's y coordinate


; Setup for THE GAME (which I just lost)
setup:

	; Setup the stack
	mov sp, stack_top
	
	; Initialize the guess counter to 5
	mov dx, 5
	
	; Pick a random x coordinate for Polo
	mov cx, 9
	in ax, 8
	mod ax, cx
	mov [polo_x], ax
	
	; Pick a random y coordinate for Polo
	in ax, 8
	mod ax, cx
	mov [polo_y], ax
	
	; Initialize Marco's coordinates to 4, 4
	mov si, 4
	mov di, 4
	
	; Print the guess counter to the numeric display
	out dx, 1


; Start of Game
; This is the location we loop back to
top:
	
	;;;; Get Input ;;;;
	; Turn on the ? symbol
	out 1, 6
	
	; Wait for the user to move
	call gamepad_get
	
	; Turn off the ? symbol
	out 0, 6
	
	; Decrement the guess counter
	dec dx
	out dx, 1
	
	;;;; Comparison ;;;;
	; Check for up
	mov cx, 5
	cmp ax, cx
	je move_up
	
	; Check for down
	mov cx, 6
	cmp ax, cx
	je move_down
	
	; Check for left
	mov cx, 7
	cmp ax, cx
	je move_left
	
	; Check for right
	mov cx, 8
	cmp ax, cx
	je move_right
	
	; Check for ok
	mov cx, 3
	cmp ax, cx
	je ok
	
	; Jump back to top if invalid button was pressed
	jmp top


; When up is pressed
move_up:
	; Increment Y coordinate
	inc di
	
	; Jump back to top
	jmp top


; When down is pressed
move_down:
	; Decrement Y coordinate
	dec di
	
	; Jump back to top
	jmp top


; When left is pressed
move_left:
	; Decrement X coordinate
	dec si
	
	; Jump back to top
	jmp top


; When right is pressed
move_right:
	; Increment X coordinate
	inc si
	
	; Jump back to top
	jmp top


; Say marco, called when ok is pressed
ok:
	; Turn off any arrow symbols that are on
	out 0, 2
	out 0, 3
	out 0, 4
	out 0, 5

; Compare the X coordinate
cmp_x:
	mov cx, [polo_x]
	cmp si, cx
	; If Marco X < Polo X, turn > on
	jl arrow_right
	; If Marco X > Polo X, turn < on
	jg arrow_left
	; If Marco X = Polo X, turn no arrows on; procede to cmp_y_xeq

; Compare the Y coordinate when the Marco X = Polo X
cmp_y_xeq:
	mov cx, [polo_y]
	cmp si, cx
	; If Marco Y < Polo Y, turn > on
	jl arrow_up
	; If Marco Y > Polo Y, turn < on
	jg arrow_down
	; If Marco X = Polo X, the player has won!; jump to win
	jmp win

; Compare the Y coordinate when the Marco X != Polo X
cmp_y:
	mov cx, [polo_y]
	cmp si, cx
	; If Marco Y < Polo Y, turn > on
	jl arrow_up
	; If Marco Y > Polo Y, turn < on
	jg arrow_down
	; If Marco X = Polo X, turn no arrows on; jump to top
	jmp top


; Turn on the left arrow
arrow_left:
	; Turn the left symbol on
	out 1, 4
	; Jump to Y comparison
	jmp cmp_y


; Turn on the right arrow
arrow_right:
	; Turn the right symbol on
	out 1, 5
	; Jump to Y comparison
	jmp cmp_y
	
	
; Turn on the up arrow
arrow_up:
	; Turn the up symbol on
	out 1, 2
	; Jump to top
	jmp top
	

; Turn on the down arrow
arrow_down:
	; Turn the down symbol on
	out 1, 2
	; Jump to top
	jmp top


; The player has won!
win:
	out 1, 7
	hlt

; Variable Memory
polo_x:
	dw 0
polo_y:
	dw 0

; Stack space
stack_bottom:
	; Defines 15 words of memory as zero
	dw 0 15
stack_top:
	; We define an additional value as zero at the top of the stack for
	; the first value pushed
	dw 0
