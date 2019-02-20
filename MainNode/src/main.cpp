#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "listener.h"
#include "interlanguage.h"

int main(int argc, char *argv[]) {

	//Testing.
	
	int cas = atoi(argv[1]);
	
	printf("argv[1] = %d\n",cas);
	
	switch(cas){

		case 0:
			listener();
			break;
			
		case 1:
			callgetVars();
			break;
			
		default:
			printf("Usage: Must pass one argument and must be 0;");
			printf("if 0 := ( run s_connect() );");
			exit(1);
	}

}