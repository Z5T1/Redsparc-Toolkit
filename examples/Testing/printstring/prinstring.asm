

top:
	; Setup the GPU Coordinates
	out 1, 18 	; X1 = 1
	out 1, 19	; Y1 = 1
	
	; Set the GPU Command
	out 65, 17	; GPU_CMD = l_printstring
	
	; Set the GPU Register to the string pointer
	out string, 24
	
	; Execute the Command
	out 1, 16
	
	; Halt
	hlt

; FOO!
string:
	ds "Foo!"
