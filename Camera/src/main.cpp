#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "speaker.h"


int main(int argc, char *argv[]) {

	int Bstatus;
	int conection, ssocket;
	unsigned int trigger = 0;

	ssocket = start_speaking();

	if(ssocket <= 0){
		printf("ssocket <= 0\n");
		exit(1);
	}

	conection = meeting(ssocket);

	if(conection <= 0){
		printf("conection <= 0\n");
		exit(1);
	}

	printf("Setup OK;\n");

	trigger = 1;
	while(1){

		sleep(10);
		
		if(trigger == 1){
			printf("Send Image... \n");
			//Send image
			speak_img(conection);
		}
	}

	stop_speaking(ssocket);

}
