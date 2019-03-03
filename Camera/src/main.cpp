#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "speaker.h"


int main(int argc, char *argv[]) {

	int Bstatus;
	int cconection,bconection,bsocket,csocket;
	unsigned int trigger = 0;

	csocket = start_speaking(3500);

	if(csocket <= 0){
		printf("ssocket <= 0\n");
		exit(1);
	}

	cconection = meeting(csocket);

	if(cconection <= 0){
		printf("conection <= 0\n");
		exit(1);
	}

	printf("Camera Setup OK;\n");


	bsocket = start_speaking(3600);

	if(bsocket <= 0){
		printf("ssocket <= 0\n");
		exit(1);
	}

	bconection = meeting(bsocket);

	if(bconection <= 0){
		printf("conection <= 0\n");
		exit(1);
	}

	printf("ball Setup OK;\n");

	trigger = 1;
	while(1){

		sleep(10);
		
		if(trigger == 1){
			printf("Send Image... \n");
			//Send image
			speak_img(cconection);
			speak(bconection);
		}
	}

	stop_speaking(bsocket);
	stop_speaking(csocket);

}
