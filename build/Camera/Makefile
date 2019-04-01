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
SRC=../../src/

#all: BallDetection

Camera: main.o speaker.o camera.o listener.o 
	
	$(CCC) -I '/usr/local/include/raspicam' -o $(BIN)Camera  $(OBJS)main_camera.o $(OBJS)listener.o $(OBJS)camera.o $(OBJS)speaker.o $(RBPI_CFLAGS) $(RBPI_CAM_CFLAGS) -lm


setup: 
	mkdir $(OBJS)
	mkdir $(BIN)

listener.o:

	$(CCC) -c $(CFLAGS) $(SRC)listener.cpp
	mv listener.o $(OBJS)		
	
speaker.o:

	$(CCC) -c $(CFLAGS) $(SRC)speaker.cpp
	mv speaker.o $(OBJS)		
	

camera.o:

	$(CCC) -c $(CFLAGS) $(SRC)camera.cpp
	mv camera.o $(OBJS)		
	
main.o:

	$(CCC) -c $(CFLAGS) $(SRC)main_camera.cpp
	mv main_camera.o $(OBJS)	
	
	
clean:

	if [ -d "$(OBJS)" ]; then rm -r $(OBJS); fi
	if [ -d "$(BIN)" ]; then rm -r $(BIN); fi

	
