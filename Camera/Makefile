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

Camera: main.o speaker.o 
	
	$(CCC) -o $(BIN)Camera $(OBJS)main.o $(OBJS)speaker.o $(RBPI_CFLAGS) -lm

setup: 
	mkdir $(OBJS)
	mkdir $(BIN)
	

speaker.o:

	$(CCC) -c $(CFLAGS) ./src/speaker.cpp
	mv speaker.o $(OBJS)		
	
main.o:

	$(CCC) -c $(CFLAGS) ./src/main.cpp
	mv main.o $(OBJS)	
	
	
clean:

	if [ -d "$(OBJS)" ]; then rm -r $(OBJS); fi
	if [ -d "$(BIN)" ]; then rm -r $(BIN); fi

	
