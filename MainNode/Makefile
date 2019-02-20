#Object files shouldn't be on the repository. 
#They must be compilated on time
.PHONY: all

CC=gcc
CCC=g++
CFLAGS=
LIBFLAGS= -fPIC
OBJS=./objs/
HEADERS=./include/
BIN=./bin/
SRC=./src/

#TODO:if not exist mkdir $(OBJS)
#all: MainNode

#Workarround


MainNode: main.o listener.o
	
	#mkdir $(BIN)
	$(CCC) -o $(BIN)MainNode $(OBJS)main.o $(OBJS)listener.o $(CFLAGS) -lm

dir: 
	mkdir $(OBJS)
	mkdir $(BIN)

lib: l_listener.o l_interlanguage.o

	#mkdir $(BIN)
	$(CCC) $(OBJS)l_listener.o $(OBJS)l_interlanguage.o -shared -o $(BIN)lib_Server.so

	
listener.o:

	$(CCC) -c $(CFLAGS) ./src/listener.cpp
	# if not exist mkdir $(OBJS)
	mv listener.o $(OBJS)		
	
l_listener.o:

	$(CCC) -c $(LIBFLAGS) ./src/listener.cpp
	# if not exist mkdir $(OBJS)
	mv listener.o l_listener.o
	mv l_listener.o $(OBJS)		
	
l_interlanguage.o:

	$(CCC) -c $(LIBFLAGS) ./src/interlanguage.cpp
	# if not exist mkdir $(OBJS)
	mv interlanguage.o l_interlanguage.o
	mv l_interlanguage.o $(OBJS)	

interlanguage.o:

	$(CCC) -c $(CFLAGS) ./src/interlanguage.cpp
	# if not exist mkdir $(OBJS)
	mv listener.o $(OBJS)	
	
	
main.o:

	$(CCC) -c $(CFLAGS) ./src/main.cpp
	#mkdir $(OBJS)
	mv main.o $(OBJS)	
	
	
clean:

	if [ -d "$(OBJS)" ]; then rm -r $(OBJS); fi
	if [ -d "$(BIN)" ]; then rm -r $(BIN); fi

	