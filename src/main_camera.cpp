#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "speaker.h"
#include "camera.h"
#include "listener.h"

int main(int argc, char *argv[]) {

	int Bstatus;
	int cconection,bconection,bsocket,csocket;	
	int main_req = 0;
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

	
	//Take photo and send img to MainNode
	while(1){
	
		int res_photo = photo();	
		if(res_photo == 0) printf("Photo was taken OK;\n");
	
			
		main_req = camera_recv(cconection);
		if(main_req == 2){
			photo();
			//I know that there will be a req_camera after req_photo
			camera_recv(cconection);
		}
		printf("Req arrived Synch\n");
		speak_img(cconection);

		
	}

	stop_speaking(csocket);
}
