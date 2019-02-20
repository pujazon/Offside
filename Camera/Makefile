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

#all: Camera

Camera: main.o speaker.o
	
	#mkdir $(BIN)
	$(CCC) -o $(BIN)Camera $(OBJS)main.o $(OBJS)speaker.o -lm

dir: 
	mkdir $(OBJS)
	mkdir $(BIN)	
	
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

	
