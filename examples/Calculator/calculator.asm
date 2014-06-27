;;;;;;;;;;;;;;;;;;;; Redsparc Calculator Program ;;;;;;;;;;;;;;;;;;;;;;;
; Assemble with: zasm calculator.asm -o calculator.zob
; Link with: zlink calculator.zob -o calculator.rs -lnumpad -lgamepad

; This is the calculator program for the Redsparc. It waits for the user
; to enter a number, then an operation and then another number.
; Operations are entered on the gamepad as follows:
;	A = Addition
;	B = Subtraction
;	X = Multiplication
;	Y = Division

; Register Usage:
;	AX = first operand
;	BX = comparison value
;	CX = second operand
;	DX = operation


; Setup for the program
setup:

	; Set up the stack
	mov sp, stack_top
	
; Start of the program
top:

	;;;; Get User Input ;;;;

	; Gets operand 1 and copies it to CX
	call numpad_get
	mov cx, ax
		
	; Gets operation and copies it to DX
	call gamepad_get
	mov dx, ax
	
	; Gets operand 2 and leaves it in AX
	call numpad_get
	
	;;;; Compare Operation ;;;;
	; Addition
	mov bx, 9
	cmp bx, dx
	je addition
	
	; Subtraction
	mov bx, 10
	cmp bx, dx
	je subtraction
	
	; Multiplication
	mov bx, 11
	cmp bx, dx
	je multiplication
	
	; Division
	mov bx, 12
	cmp bx, dx
	je division
	
	out 1, 7
	hlt

; Addition Operation
addition:
	add cx, ax
	jmp result

; Subtraction Operation
subtraction:
	sub cx, ax
	jmp result

; Multiplication Operation
multiplication:
	mul cx, ax
	jmp result
	
; Division Operation
division:
	div cx, ax
	jmp result

; Print Result
result:
	out cx, 1
	hlt

; Stack memory
stack_bottom:
	; Defines 7 words of memory as zero
	dw 0 7
stack_top:
	; We define an additional value as zero at the top of the stack for
	; the first value pushed
	dw 0 1
