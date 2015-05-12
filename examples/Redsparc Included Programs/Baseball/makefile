# NOTE: All changes to the source of this program should be made in the
# file baseball.m4. All other files will be overwritten at assemble time.

OBJECTS = \
	baseball.zob \
	gui.zob

baseball.rs: $(OBJECTS)
	zlink $(OBJECTS) -lgamepad -o baseball.rs

%.zob: %.asm
	zasm $^ -o $@

%.asm: %.m4
	m4 $^ > $@
