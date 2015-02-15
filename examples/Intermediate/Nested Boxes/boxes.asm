;;;;;;;;;;;;;; Redsparc Numpad Display Example Program ;;;;;;;;;;;;;;;;;
; Assemble with: zasm boxes.asm -o boxes.zob
; Link with: zlink boxes.zob -o boxes.rs

; This example displays a series of nested boxes on the screen.

; Register Usage:
;	AX = X1
;	BX = Y1
;	CX = X2
;	DX = Y2
;	SI = Color


; Setup for the program
setup:
	; Set up the stack
	mov sp, stack_top
	
	; Set up the starting coordinates and color
	mov ax, 0
	mov bx, 0
	mov cx, 64
	mov dx, 48
	
	; Set the starting color
	mov si, 0
	
	; Set the GPU command to fill (3)
	out 3, 17
	
	; Set the GPU buffer to 0 (the display buffer)
	out 0, 23

; Loop top
top:

	; Push the register values to the serial ports
	out ax, 18
	out bx, 19
	out cx, 20
	out dx, 21
	out si, 22

	; Fill the selected area
	out 1, 16
	
	; Shrink the selection
	inc ax
	inc bx
	dec cx
	dec dx
	
	; Go to the next color
	inc si
	
	; Check if the selection is at the center (23 Y)
	cmp bx, 25
	
	; Jump back to the top if it's not
	jl top
	
	; Otherwise halt
	hlt

; Stack memory
stack_bottom:
	; Defines 7 words of memory as zero
	dw 0 7
stack_top:
	; We define an additional value as zero at the top of the stack for
	; the first value pushed
	dw 0 1
