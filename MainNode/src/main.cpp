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
	int Listening_status;
	int trigger;

	//Important the order
	MATLAB_status = iniMATLAB();
	Listening_status = start_listening();


	printf("Lstatus == %d and Mstatus == %d\n",Listening_status,MATLAB_status);

	if(Listening_status == 0 && MATLAB_status == 0){
		while(1){

			//TODO: Too slow recv()
            trigger = getTrigger();
			printf(".");
			printf("Trigger is: %d\n",trigger);


			if(trigger == 7){
				pOut = getPlayersMatrix();

				for (i=0; i<2; i++) {std::cout << "En el Main[i]: " << pOut[i] << std::endl;}				
			}	
		}
	}
	
	printf("End\n");
	stop_listening();

	//TODO: Problems when closing MATLAB session. Maybe kill with sigkill
	endMATLAB();
	exit(0);

	return 0;

}
