#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "speaker.h"
#include "mpu6050.h"
#include "listener.h" 

int main(int argc, char *argv[]) {

	int Bstatus;
	int conection, ssocket;
	char trigger = '0';

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
	 	ball_recv(conection);
		printf("Synch\n");
		sleep(10);
		trigger = isTrigger();
		printf("Trigger %c\n",trigger);
		speak_pass(conection,trigger);
	}

	stop_speaking(ssocket);

}
