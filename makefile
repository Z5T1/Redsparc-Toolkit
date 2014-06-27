CC = gcc
INSTALL_PATH = /usr/local/bin
LIB_PATH = /usr/local/lib/redsparc

all: zasm zlink

install: all
	cp zasm $(INSTALL_PATH)/zasm
	cp zlink $(INSTALL_PATH)/zlink
	if [ ! -e $(LIB_PATH) ]; then mkdir $(LIB_PATH); fi;
	cp libs/* $(LIB_PATH) -r

zasm: zasm.c
	$(CC) zasm.c -o zasm

zlink: zlink.c
	$(CC) zlink.c -o zlink -D DEFAULT_INCLUDE_PATH="\"$(LIB_PATH)\""
