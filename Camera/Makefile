#Object files shouldn't be on the repository. 
#They must be compilated on time


CC=gcc
CFLAGS=

make: ./src/blink.c
	$(CC) -c $(CFLAGS) ./src/blink.c
	mv blink.o ./objs
	cd ./objs
	cp ../include/wiringPi/*.o .
	gcc -g -o blink blink.o 
	
clean:
	rm ./objs/*.o
