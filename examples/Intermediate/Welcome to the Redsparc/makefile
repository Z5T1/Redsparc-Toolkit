# NOTE: All changes to the source of this program should be made in the
# file welcome.m4. All other files will be overwritten at assemble time.

welcome.rs: welcome.zob
	zlink welcome.zob -lkeyboard -lnumpad -lgamepad -o welcome.rs
	
welcome.zob: welcome.asm
	zasm welcome.asm -o welcome.zob
	
welcome.asm: welcome.m4
	m4 welcome.m4 > welcome.asm
