#Object files shouldn't be on the repository. 
#They must be compilated on time


CC=gcc
CFLAGS=-lwiringPi
OBJS=./objs/
HEADERS=./include/
BIN=./bin/
SRC=./src/

make:$(SRC)blink.c

	$(CC) -c $(CFLAGS) ./src/blink.c
	mkdir $(OBJS)
	mv blink.o $(OBJS)	
	mkdir $(BIN)
	$(CC) -o $(BIN)blink $(SRC)blink.c $(CFLAGS)
	
clean:
	rm -r $(OBJS)
	rm -r $(BIN)
	
