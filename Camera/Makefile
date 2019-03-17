#Object files shouldn't be on the repository. 
#They must be compilated on time
.PHONY: all

CCC=g++
CC=gcc
CFLAGS=
RBPI_CFLAGS=-lwiringPi
RBPI_CAM_CFLAGS= -lraspicam 
#-lmmal -lmmal_core -lmmal_util

OBJS=./objs/
HEADERS=./include/
BIN=./bin/
SRC=./src/

#all: BallDetection

Camera: main.o speaker.o camera.o 
	
	$(CCC) -I '/usr/local/include/raspicam' -o $(BIN)Camera  $(OBJS)main.o $(OBJS)camera.o $(OBJS)speaker.o $(RBPI_CFLAGS) $(RBPI_CAM_CFLAGS) -lm


setup: 
	mkdir $(OBJS)
	mkdir $(BIN)

speaker.o:

	$(CCC) -c $(CFLAGS) ./src/speaker.cpp
	mv speaker.o $(OBJS)		
	

camera.o:

	$(CCC) -c $(CFLAGS) ./src/camera.cpp
	mv camera.o $(OBJS)		
	
main.o:

	$(CCC) -c $(CFLAGS) ./src/main.cpp
	mv main.o $(OBJS)	
	
	
clean:

	if [ -d "$(OBJS)" ]; then rm -r $(OBJS); fi
	if [ -d "$(BIN)" ]; then rm -r $(BIN); fi

	
