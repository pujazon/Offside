#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "speaker.h"
#include "mpu6050.h"

int main(int argc, char *argv[]) {

	int Bstatus;
	int conection, ssocket;
	unsigned int trigger = 0;


	ssocket = start_speaking(3600);

	if(ssocket <= 0){
		printf("ssocket <= 0\n");
		exit(1);
	}

	conection = meeting(ssocket);

	if(conection <= 0){
		printf("conection <= 0\n");
		exit(1);
	}

	Bstatus = setupMPU6050();

	if(Bstatus != 0){
		printf("Bstatus != 0\n");
		exit(1);
	}


	printf("Setup OK;\n");

	while(1){

		trigger = isTrigger();
		if(trigger == 1) speak(conection,'1');
		else speak(conection,'0');
	}

	stop_speaking(ssocket);

}
