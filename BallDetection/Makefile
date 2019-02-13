#Object files shouldn't be on the repository. 
#They must be compilated on time
.PHONY: all

CC=gcc
CFLAGS=
RBPI_CFLAGS=-lwiringPi
OBJS=./objs/
HEADERS=./include/
BIN=./bin/
SRC=./src/

#all: BallDetection

BallDetection: main.o c_socket.o mpu6050.o
	
	mkdir $(BIN)
	$(CC) -o $(BIN)BallDetection $(OBJS)main.o $(OBJS)mpu6050.o $(OBJS)c_socket.o $(CFLAGS) -lm

mpu6050.o:

	$(CC) -c $(RBPI_CFLAGS) ./src/mpu6050.c
	# if not exist mkdir $(OBJS)
	mv mpu6050.o $(OBJS)	
	
c_socket.o:

	$(CC) -c $(CFLAGS) ./src/c_socket.c
	# if not exist mkdir $(OBJS)
	mv c_socket.o $(OBJS)		
	
main.o:

	$(CC) -c $(CFLAGS) ./src/main.c
	mkdir $(OBJS)
	mv main.o $(OBJS)	
	
	
clean:

	if [ -d "$(OBJS)" ]; then rm -r $(OBJS); fi
	if [ -d "$(BIN)" ]; then rm -r $(BIN); fi

	