#Object files shouldn't be on the repository. 
#They must be compilated on time


CC=gcc
CFLAGS=-lwiringPi
OBJS=./objs/
HEADERS=./include/
EXE=./bin/
SRC=./src/

make: $(SRC)blink.c
	$(CC) -c $(CFLAGS) ./src/blink.c
	mv blink.o $(OBJS)	
	$(CC) -o $(EXE)blink $(SRC)blink.c $(CFLAGS)
	
clean:
	rm ./objs/*.o
