

top:
	; Setup the GPU Coordinates
	out 1, 18 	; X1 = 1
	out 1, 19	; Y1 = 1
	out 4, 22	; Color = Yellow
	
	; Set the GPU Command
	out 81, 17	; GPU_CMD = s_printstring
	
	; Set the GPU Register to the string pointer
	out string, 24
	
	; Execute the Command
	out 1, 16
	
	; Halt
	hlt

; FOO!
string:
	ds "Hello World!"
