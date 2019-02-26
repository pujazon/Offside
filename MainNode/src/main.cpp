#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "listener.h"
#include "interlanguage.h"

uint32_t* pOut;

//TODO: Each call must have error handling

int main(int argc, char *argv[]) {

	int i;
	int MATLAB_status;
	int rsocket;
	int trigger;

	//Important the order
	MATLAB_status = iniMATLAB();
	rsocket = start_listening();


	printf("read_socket == %d and Mstatus == %d\n",rsocket,MATLAB_status);

	if(rsocket > 0 && MATLAB_status == 0){
		while(1){

            trigger = listen(rsocket);
			printf(".");
			printf("Trigger is: %d\n",trigger);


			if(trigger == 1){
				pOut = getPlayersMatrix();

				for (i=0; i<44*1; i++) {std::cout << "En el Main[i]: " << pOut[i] << std::endl;}				
			}	
		}
	}
	
	printf("End\n");
	stop_listening(rsocket);

	//TODO: Problems when closing MATLAB session. Maybe kill with sigkill
	endMATLAB();
	exit(0);

	return 0;

}
