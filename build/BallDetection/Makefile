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
SRC=../../src/

#all: BallDetection

Button:
	g++ $(SRC)button.cpp -lwiringPi
	mv a.out ./button.out

BallDetection: main.o speaker.o mpu6050.o listener.o
	
	$(CCC) -o $(BIN)BallDetection $(OBJS)main_ball.o $(OBJS)mpu6050.o $(OBJS)speaker.o $(OBJS)listener.o $(RBPI_CFLAGS) -lm

setup: 
	mkdir $(OBJS)
	mkdir $(BIN)
	
mpu6050.o:

	$(CCC) -c $(RBPI_CFLAGS) $(SRC)mpu6050.cpp
	mv mpu6050.o $(OBJS)	
		
listener.o:

	$(CCC) -c $(CFLAGS) $(SRC)listener.cpp
	mv listener.o $(OBJS)		
	
speaker.o:

	$(CCC) -c $(CFLAGS) $(SRC)speaker.cpp
	mv speaker.o $(OBJS)		
	
main.o:

	$(CCC) -c $(CFLAGS) $(SRC)main_ball.cpp
	mv main_ball.o $(OBJS)	
	
	
clean:

	if [ -d "$(OBJS)" ]; then rm -r $(OBJS); fi
	if [ -d "$(BIN)" ]; then rm -r $(BIN); fi

	
