#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "speaker.h"
#include "mpu6050.h"
#include "listener.h" 

int main(int argc, char *argv[]) {

	int Bstatus;
	int conection,con,ssocket,bsocket;
	char trigger = '0';

	button = 0;

	//Open 2 sockets: Button && Ball
	ssocket = start_speaking(3600);
	bsocket = start_speaking(3700);

	if(ssocket <= 0){
		printf("ssocket <= 0\n");
		exit(1);
	}
	if(bsocket <= 0){
		printf("bsocket <= 0\n");
		exit(1);
	}

	conection = meeting(ssocket);
	con = meeting(bsocket);

	if(conection <= 0){
		printf("conection <= 0\n");
		exit(1);
	}
	if(con <= 0){
		printf("con <= 0\n");
		exit(1);
	}

	//Setup
	Bstatus = setupMPU6050();	
	//Button
	wiringPiSetup();
        pinMode(INPUT_PIN, INPUT);
        pullUpDnControl(INPUT_PIN, PUD_UP);
	if(Bstatus != 0){
		printf("Bstatus != 0\n");
		exit(1);
	}
	printf("Setup OK;\n");

	//Main Loop
	while(1){
		//TODO button_recv && button_req ?
	 
	 	ball_recv(conection);
		printf("Synch\n");
		trigger = isTrigger();
		printf("Trigger %c\n",trigger);
		speak_pass(conection,trigger);

		button_recv(con);
		printf("Synch button\n");
		button = isButton();
		printf("Button %c\n",button);
		speak_button(con,button);			
			
	}

	stop_speaking(ssocket);
}
