#Object files shouldn't be on the repository. 
#They must be compilated on time
.PHONY: all

CCC=g++
CC=gcc
CFLAGS=
RBPI_CFLAGS=-lwiringPi
OBJS=./objs/
HEADERS=./include/
BIN=./bin/
SRC=./src/

#all: BallDetection

BallDetection: main.o speaker.o mpu6050.o
	
	mkdir $(BIN)
	$(CCC) -o $(BIN)BallDetection $(OBJS)main.o $(OBJS)mpu6050.o $(OBJS)speaker.o $(RBPI_CFLAGS) -lm

dir: 
	mkdir $(OBJS)
	mkdir $(BIN)
	
mpu6050.o:

	$(CCC) -c $(RBPI_CFLAGS) ./src/mpu6050.cpp
	# if not exist mkdir $(OBJS)
	mv mpu6050.o $(OBJS)	
	
speaker.o:

	$(CCC) -c $(CFLAGS) ./src/speaker.cpp
	# if not exist mkdir $(OBJS)
	mv speaker.o $(OBJS)		
	
main.o:

	$(CCC) -c $(CFLAGS) ./src/main.cpp
	# if not exist mkdir $(OBJS)
	mv main.o $(OBJS)	
	
	
clean:

	if [ -d "$(OBJS)" ]; then rm -r $(OBJS); fi
	if [ -d "$(BIN)" ]; then rm -r $(BIN); fi

	
