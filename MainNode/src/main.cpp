#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "listener.h"
#include "interlanguage.h"

//TODO: Each call must have error handling

int main(int argc, char *argv[]) {

	int status;
	int trigger;

	status = start_listening();

	if(status == 0){

		while(1){
			trigger = getTrigger();
			printf("Trigger is: %d\n",trigger);
		}
	}
	else{
		stop_listening();
		exit(1);
	}

	stop_listening();

	return 0;

}
