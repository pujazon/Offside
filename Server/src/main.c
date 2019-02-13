#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "s_socket.h"

int main(int argc, char *argv[]) {

	//Testing.
	
	int cas = atoi(argv[1]);
	
	printf("argv[1] = %d\n",cas);
	
	switch(cas){

		case 0:
			s_connect();
			break;
		default:
			printf("Usage: Must pass one argument and must be 0;");
			printf("if 0 := ( run s_connect() );");
			exit(1);
	}

}