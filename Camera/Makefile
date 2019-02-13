#Object files shouldn't be on the repository. 
#They must be compilated on time


CC=gcc
CFLAGS=
OBJS=./objs/
HEADERS=./include/
BIN=./bin/
SRC=./src/

all: c_socket

	
c_socket:

	$(CC) -c $(CFLAGS) ./src/c_socket.c
	mkdir $(OBJS)
	mv c_socket.o $(OBJS)	
	mkdir $(BIN)
	$(CC) -o $(BIN)c_socket $(SRC)c_socket.c $(CFLAGS) -lm
	
	
clean:
	rm -r $(OBJS)
	rm -r $(BIN)	
