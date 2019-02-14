#Object files shouldn't be on the repository. 
#They must be compilated on time
.PHONY: all

CC=gcc
CFLAGS=
LIBFLAGS= -fPIC
OBJS=./objs/
HEADERS=./include/
BIN=./bin/
SRC=./src/

#TODO:if not exist mkdir $(OBJS)
#all: Server

#Workarround
dir:
	mkdir $(OBJS)
	mkdir $(BIN)

lib: l_listener.o

	#mkdir $(BIN)
	$(CC) $(OBJS)l_listener.o -shared -o $(BIN)lib_Server.so

Server: main.o listener.o
	
	#mkdir $(BIN)
	$(CC) -o $(BIN)Server $(OBJS)main.o $(OBJS)listener.o $(CFLAGS) -lm
	
listener.o:

	$(CC) -c $(CFLAGS) ./src/listener.c
	# if not exist mkdir $(OBJS)
	mv listener.o $(OBJS)		
	
l_listener.o:

	$(CC) -c $(LIBFLAGS) ./src/listener.c
	# if not exist mkdir $(OBJS)
	mv listener.o l_listener.o
	mv l_listener.o $(OBJS)		
	
main.o:

	$(CC) -c $(CFLAGS) ./src/main.c
	#mkdir $(OBJS)
	mv main.o $(OBJS)	
	
	
clean:

	if [ -d "$(OBJS)" ]; then rm -r $(OBJS); fi
	if [ -d "$(BIN)" ]; then rm -r $(BIN); fi

	