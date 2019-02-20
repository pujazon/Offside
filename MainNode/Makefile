#Object files shouldn't be on the repository. 
#They must be compilated on time
.PHONY: all

CC=gcc
CCC=g++
CFLAGS= -std=c++11 -pthread
LIBFLAGS= -fPIC
OBJS=./objs/
HEADERS=./include/
BIN=./bin/
SRC=./src/
MATLAB_ROOT=/mnt/c/Program\ Files/MATLAB/R2017b/
MATLAB_CC_API_LIB=-lMatlabDataArray -lMatlabEngine

#TODO:if not exist mkdir $(OBJS)
#all: MainNode

#Workarround


MainNode: main.o listener.o interlanguage.o
	
	#mkdir $(BIN)
	$(CCC) $(CFLAGS) -I $(MATLAB_ROOT)extern/include/ -L $(MATLAB_ROOT)extern/bin/win64/ -o $(BIN)MainNode $(OBJS)interlanguage.o -lm
	#$(CCC) $(CFLAGS) -I $(MATLAB_ROOT)extern/include/ -L $(MATLAB_ROOT)extern/bin/glnxa64/ $(MATLAB_CC_API_LIB) -o $(BIN)MainNode $(OBJS)main.o $(OBJS)listener.o $(OBJS)interlanguage.o -lm

setup: 
	mkdir $(OBJS) 
	mkdir $(BIN)
	#cp /mnt/c/Program\ Files/MATLAB/R2017b/extern/include/MatlabDataArray.hpp ./src/
	#cp /mnt/c/Program\ Files/MATLAB/R2017b/extern/include/MatlabEngine.hpp ./src/

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
	
	$(CCC) -c $(CFLAGS) -I $(MATLAB_ROOT)extern/include/ -L $(MATLAB_ROOT)extern/bin/win64/ ./src/interlanguage.cpp 
	#$(MATLAB_CC_API_LIB)
	# if not exist mkdir $(OBJS)
	mv interlanguage.o $(OBJS)	
	
	
main.o:

	$(CCC) -c $(CFLAGS) ./src/main.cpp
	#mkdir $(OBJS)
	mv main.o $(OBJS)	
	
	
clean:

	if [ -d "$(OBJS)" ]; then rm -r $(OBJS); fi
	if [ -d "$(BIN)" ]; then rm -r $(BIN); fi

	