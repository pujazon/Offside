#Object files shouldn't be on the repository. 
#They must be compilated on time


CC=gcc
CFLAGS=
OBJS=./objs/
HEADERS=./include/
BIN=./bin/
SRC=./src/

all: s_socket

	
s_socket:

	$(CC) -c $(CFLAGS) ./src/s_socket.c
	mkdir $(OBJS)
	mv s_socket.o $(OBJS)	
	mkdir $(BIN)
	$(CC) -o $(BIN)s_socket $(SRC)s_socket.c $(CFLAGS) -lm
	
	
clean:
	rm -r $(OBJS)
	rm -r $(BIN)	
