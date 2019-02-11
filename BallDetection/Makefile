#Object files shouldn't be on the repository. 
#They must be compilated on time


CC=gcc
CFLAGS=
RBPI_CFLAGS=-lwiringPi
OBJS=./objs/
HEADERS=./include/
BIN=./bin/
SRC=./src/

all: mpu6050 c_socket

mpu6050:

	$(CC) -c $(RBPI_CFLAGS) ./src/mpu6050.c
	mkdir $(OBJS)
	mv mpu6050.o $(OBJS)	
	mkdir $(BIN)
	$(CC) -o $(BIN)mpu6050 $(SRC)mpu6050.c $(RBPI_CFLAGS) -lm
	
c_socket:

	$(CC) -c $(CFLAGS) ./src/c_socket.c
	mkdir $(OBJS)
	mv c_socket.o $(OBJS)	
	mkdir $(BIN)
	$(CC) -o $(BIN)c_socket $(SRC)c_socket.c $(CFLAGS) -lm
	
	
clean:
	rm -r $(OBJS)
	rm -r $(BIN)
	
