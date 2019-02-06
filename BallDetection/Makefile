#Object files shouldn't be on the repository. 
#They must be compilated on time


CC=gcc
CFLAGS=-lwiringPi
OBJS=./objs/
HEADERS=./include/
BIN=./bin/
SRC=./src/
PROG=mpu6050

make:$(SRC)mpu6050.c

	$(CC) -c $(CFLAGS) ./src/$(PROG).c
	mkdir $(OBJS)
	mv $(PROG).o $(OBJS)	
	mkdir $(BIN)
	$(CC) -o $(BIN)$(PROG) $(SRC)$(PROG).c $(CFLAGS)
	
clean:
	rm -r $(OBJS)
	rm -r $(BIN)
	
