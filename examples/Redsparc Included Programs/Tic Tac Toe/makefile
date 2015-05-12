# NOTE: All changes to the source of this program should be made in the
# file tic_tac_toe.m4. All other files will be overwritten at assemble time.

tic_tac_toe.rs: tic_tac_toe.zob
	zlink tic_tac_toe.zob -lkeyboard -o tic_tac_toe.rs
	
tic_tac_toe.zob: tic_tac_toe.asm
	zasm tic_tac_toe.asm -o tic_tac_toe.zob
	
tic_tac_toe.asm: tic_tac_toe.m4
	m4 tic_tac_toe.m4 > tic_tac_toe.asm
