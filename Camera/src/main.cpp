#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "speaker.h"

int main(int argc, char *argv[]) {

	
	int cas = atoi(argv[1]);
	
	printf("argv[1] = %d\n",cas);
	
	switch(cas){

		case 0:
			speaker();
			break;
		
		case 1:
		//Must go getImg()
			break;
			
		default:
			printf("Usage: Must pass one argument and must be 0 or 1;");
			printf("if 0 := ( run c_connect() );");
			exit(1);
	}

}