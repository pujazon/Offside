#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "speaker.h"
#include "mpu6050.h"

int main(int argc, char *argv[]) {

	int Bstatus;
	int conection, ssocket;
	unsigned int trigger = 0;

	Bstatus = setupMPU6050();
	ssocket = start_speaking();

	if(Bstatus != 0 || ssocket <= 0){
		printf("Bstatus != 0 || ssocket <= 0\n");
		exit(1);
	}

	conection = meeting(ssocket);

	if(conection <= 0){
		printf("conection <= 0\n");
		exit(1);
	}

	printf("Setup OK;\n");

	while(1){

		trigger = isTrigger();
		if(trigger == 1)
			speak(conection);
	}

	stop_speaking(ssocket);

}
