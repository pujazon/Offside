#Object files shouldn't be on the repository. 
#They must be compilated on time
.PHONY: all

CC=gcc
CFLAGS=
OBJS=./objs/
HEADERS=./include/
BIN=./bin/
SRC=./src/

#all: Server

Server: main.o s_socket.o
	
	mkdir $(BIN)
	$(CC) -o $(BIN)Server $(OBJS)main.o $(OBJS)s_socket.o $(CFLAGS) -lm
	
s_socket.o:

	$(CC) -c $(CFLAGS) ./src/s_socket.c
	# if not exist mkdir $(OBJS)
	mv s_socket.o $(OBJS)		
	
main.o:

	$(CC) -c $(CFLAGS) ./src/main.c
	mkdir $(OBJS)
	mv main.o $(OBJS)	
	
	
clean:

	if [ -d "$(OBJS)" ]; then rm -r $(OBJS); fi
	if [ -d "$(BIN)" ]; then rm -r $(BIN); fi

	