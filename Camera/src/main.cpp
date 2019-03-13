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

	int res_camera = setup_camera();
	if(res_camera == 0) printf("Camera Setup OK;\n");

	//TODO: trigger must be a button
	//trigger = 1;
	
	//First take photo
	int res_photo = photo();	
	if(res_photo == 0) printf("Photo was taken OK;\n");
	
/*	//Send img to MainNode
	while(1){

		sleep(10);
		
		if(trigger == 1){
			printf("Send Image... \n");
			//Send image
			speak_img(cconection);
			speak(bconection);
		}
		
	}
*/
	stop_speaking(bsocket);
	stop_speaking(csocket);

}
