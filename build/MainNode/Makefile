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
SRC=../../src/
MATLAB_ROOT=../Tools/MATLAB_libs/extern/
MATLAB_CC_API_LIB=-lMatlabDataArray -lMatlabEngine

#TODO:if not exist mkdir $(OBJS)
#all: MainNode

#Workarround

Debug: main_debug.o 

	$(CCC) $(CFLAGS) -I $(MATLAB_ROOT)include/ -L $(MATLAB_ROOT)bin/glnxa64/ -o $(BIN)Debug $(OBJS)main_debug.o  $(MATLAB_CC_API_LIB) -lm 
	

MainNode: main.o listener.o interlanguage.o speaker.o
	
	#mkdir $(BIN)
	$(CCC) $(CFLAGS) -I $(MATLAB_ROOT)include/ -L $(MATLAB_ROOT)bin/glnxa64/ -o $(BIN)MainNode  $(OBJS)interlanguage.o $(OBJS)speaker.o $(OBJS)main_node.o  $(OBJS)listener.o  $(MATLAB_CC_API_LIB) -lm 
	#$(CCC) $(CFLAGS) -I $(MATLAB_ROOT)extern/include/ -L $(MATLAB_ROOT)extern/bin/glnxa64/ $(MATLAB_CC_API_LIB) -o $(BIN)MainNode $(OBJS)main.o $(OBJS)listener.o $(OBJS)interlanguage.o -lm

setup:	
	cp ../Tools/setup_var.sh .
	./setup_var.sh
	rm setup_var.sh
	mkdir $(OBJS) 
	mkdir $(BIN)
	mkdir MATLAB_libs
	mv  MATLAB_libs ../Tools/
	cp -r /usr/local/MATLAB/R2018b/extern/ $(MATLAB_ROOT)
	cp -r ../PlayerDetection/* $(BIN)	
	#cp -r /mnt/c/Program\ Files/MATLAB/glib/extern/ $(MATLAB_ROOT)
	#cp $(MATLAB_ROOT)bin/glnxa64/* /usr/lib/
	#cp /mnt/c/Program\ Files/MATLAB/R2017b/extern/include/MatlabDataArray.hpp ./src/
	#cp /mnt/c/Program\ Files/MATLAB/R2017b/extern/include/MatlabEngine.hpp ./src/

lib: l_listener.o l_interlanguage.o

	#mkdir $(BIN)
	$(CCC) $(OBJS)l_listener.o $(OBJS)l_interlanguage.o -shared -o $(BIN)lib_Server.so
		
speaker.o:

	$(CCC) -c $(CFLAGS) $(SRC)speaker.cpp
	# if not exist mkdir $(OBJS)
	mv speaker.o $(OBJS)		
	
listener.o:

	$(CCC) -c $(CFLAGS) $(SRC)listener.cpp
	# if not exist mkdir $(OBJS)
	mv listener.o $(OBJS)		
	
l_listener.o:

	$(CCC) -c $(LIBFLAGS) $(SRC)listener.cpp
	# if not exist mkdir $(OBJS)
	mv listener.o l_listener.o
	mv l_listener.o $(OBJS)		
	
l_interlanguage.o:
	
	$(CCC) -c $(LIBFLAGS) $(SRC)interlanguage.cpp
	# if not exist mkdir $(OBJS)
	mv interlanguage.o l_interlanguage.o
	mv l_interlanguage.o $(OBJS)

interlanguage.o:
	
	#g++ -std=c++11 -I '../../Tools/MATLAB_libs/extern/include/' -L '../../Tools/MATLAB_libs/extern/bin/glnxa64/' -pthread interlanguage.cpp -lMatlabEngine -lMatlabDataArray 

	$(CCC) -c $(CFLAGS) -I $(MATLAB_ROOT)include/ -L $(MATLAB_ROOT)bin/glnxa64/ $(MATLAB_CC_API_LIB) ./src/interlanguage.cpp 
	#$(MATLAB_CC_API_LIB) glnxa64 win64
	# if not exist mkdir $(OBJS)
	mv interlanguage.o $(OBJS)	
	
	#.m file must be on bin folder
	cp $(SRC)*.m $(BIN)	
	
main.o:

	$(CCC) -c $(CFLAGS) -I $(MATLAB_ROOT)include/ -L $(MATLAB_ROOT)bin/glnxa64/ $(MATLAB_CC_API_LIB) $(SRC)main_node.cpp 
	#mkdir $(OBJS)
	mv main_node.o $(OBJS)		
	
main_debug.o:

	$(CCC) -c $(CFLAGS) -I $(MATLAB_ROOT)include/ -L $(MATLAB_ROOT)bin/glnxa64/ $(MATLAB_CC_API_LIB) $(SRC)main_debug.cpp 
	#mkdir $(OBJS)
	mv main_debug.o $(OBJS)		
	

clean:

	if [ -d "$(OBJS)" ]; then rm -r $(OBJS); fi
	if [ -d "$(BIN)" ]; then rm -r $(BIN); fi
	if [ -d "$(MATLAB_ROOT)" ]; then rm -r $(MATLAB_ROOT); fi

	
