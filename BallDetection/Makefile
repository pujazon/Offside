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
	
	$(CCC) -o $(BIN)BallDetection $(OBJS)main.o $(OBJS)mpu6050.o $(OBJS)speaker.o $(RBPI_CFLAGS) -lm

setup: 
	mkdir $(OBJS)
	mkdir $(BIN)
	
mpu6050.o:

	$(CCC) -c $(RBPI_CFLAGS) ./src/mpu6050.cpp
	mv mpu6050.o $(OBJS)	
	
speaker.o:

	$(CCC) -c $(CFLAGS) ./src/speaker.cpp
	mv speaker.o $(OBJS)		
	
main.o:

	$(CCC) -c $(CFLAGS) ./src/main.cpp
	mv main.o $(OBJS)	
	
	
clean:

	if [ -d "$(OBJS)" ]; then rm -r $(OBJS); fi
	if [ -d "$(BIN)" ]; then rm -r $(BIN); fi

	
