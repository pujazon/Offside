#include <stdio.h>
#include <stdlib.h>
#include <algorithm>
#include <string.h>
#include <chrono>
#include <ctime>    

using namespace std;

#define NPlayers 8
#define Fields 4

#define NTestCases 2

//TODO: Main.h

uint32_t top_offset = 0;
uint32_t bottom_offset = 1;
uint32_t left_offset = 2;
uint32_t right_offset = 3;

uint32_t tc_PlayersMatrix[NTestCases*2][1+NPlayers*Fields] = {
	{1,10,13,26,29,19,21,33,36,19,22,19,22,27,29,26,29,28,31,44,47,30,32,3,7,37,40,34,36,38,41,17,20},
	{2,10,13,26,29,19,21,33,36,19,22,19,22,27,29,26,29,28,31,44,47,30,32,3,7,37,40,34,36,38,41,17,20},
	{2,42,43,26,29,19,21,33,36,19,22,19,22,27,29,26,29,28,31,44,47,30,32,3,7,37,40,34,36,38,41,17,20},
	{1,10,13,26,29,19,21,33,36,19,22,19,22,27,29,26,29,28,31,44,47,30,32,3,7,37,40,34,36,38,41,17,20},
};

uint32_t tc_result[NTestCases] = {0,1};

uint32_t top[NPlayers/2];
uint32_t bottom[NPlayers/2];

//TODO: Variables or Invariant to know where each has to score (pe: Team A top Team B bottom)
//		Important in isOffside check (*)

//Workarround. Only one is set because the other team will score on the other direction.
// 1 means top; 0 means bottom;
uint32_t dirTeamA = 1;

const uint32_t TeamA = 1;
const uint32_t TeamB = 0;

//TODO: Each call must have error handling
//TODO: Format and size of PlayersMatrix is not correct yet. Goalkeapers (?)

uint32_t max_top(uint32_t* old, uint32_t team){

	uint32_t result = 0;
	uint32_t i = 0;
	uint32_t Boffset = 0;

	printf("Input MAX TOP old: {");
	for(i = 0; i<(1+NPlayers*Fields); i++)
		printf("%d,",old[i]);
	printf("}\n");
	
	switch (team){
	    case TeamA:
	    	//Prepare team A top array
	    	for(i=0;i < (NPlayers/2); i++){
			printf("TeamA index=%d\n",1+(i*Fields)+top_offset);
			top[i] = old[1+(i*Fields)+top_offset];
			printf("top[%d] = %d\n",i,top[i]);
		}
	        break;

	    case TeamB:
	    	//Prepare team B top array
	    	Boffset = (NPlayers/2)*Fields;
	    	for(i=0;i < (NPlayers/2); i++){ 
			printf("TeamB index = %d\n",1+Boffset+((i*Fields)+top_offset));
			top[i] = old[1+Boffset+((i*Fields)+top_offset)];
			printf("top[%d] = %d\n",i,top[i]);
		}
	        break;
	}
	
	printf("top: {");
	for(i = 0; i<(NPlayers/2); i++)
		printf("%d,",top[i]);
	printf("}\n");
	
	result = *max_element(&top[0],&top[NPlayers/2]);	
	return result;
}

uint32_t min_bottom(uint32_t* old, uint32_t team){

	uint32_t result = 0;
	uint32_t i = 0;
	uint32_t Boffset = 0;

	printf("Input MIN BOTTOM old: {");
	for(i = 0; i<(1+NPlayers*Fields); i++)
		printf("%d,",old[i]);
	printf("}\n");
	
	switch (team){
	    case TeamA:
	    	//Prepare team A top array
	    	for(i=0;i < (NPlayers/2); i++){
			printf("Team index = %d,\n",1+(i*Fields)+bottom_offset);
			bottom[i] = old[1+(i*Fields)+bottom_offset];
			printf("bottom[%d] = %d\n",i,bottom[i]);
		}
	        break;

	    case TeamB:
	    	//Prepare team B top array
	    	Boffset = (NPlayers/2)*Fields;
	    	for(i=0;i < (NPlayers/2); i++) {
			printf("TeamB index = %d\n",1+Boffset+((i*Fields)+bottom_offset));	
			bottom[i] = old[1+Boffset+((i*Fields)+bottom_offset)];
			printf("bottom[%d] = %d\n",i,bottom[i]);
		}
	        break;
	}

	printf("bottom: {");
	for(i = 0; i<(NPlayers/2); i++)
		printf("%d,",bottom[i]);
	printf("}\n");
	
	result = *min_element(&bottom[0],&bottom[NPlayers/2]);	
	return result;
}

uint32_t isOffside(uint32_t* old, uint32_t* current){

	uint32_t result = 0;
	uint32_t i;

	//Old == Passer && Current == Receiver
	uint32_t Passer_Team;
	uint32_t Receiver_Team;

	uint32_t Passer_top;
	uint32_t Passer_bottom;
	uint32_t Receiver_top;
	uint32_t Receiver_bottom;

	uint32_t old_Receiver_top;
	uint32_t old_Receiver_bottom;

	uint32_t min_Defender_bottom;
	uint32_t max_Defender_top;

	uint32_t isForward = 0;

	uint32_t id_receiver = current[0];
	uint32_t id_passer = old[0];

	
	//Printf inputs
	printf("***************************************\n");
	printf("old: {");
	for(i = 0; i<(1+NPlayers*Fields); i++)
		printf("%d,",old[i]);
	printf("}\n");
	printf("current: {");
	for(i = 0; i<(1+NPlayers*Fields); i++)
		printf("%d,",current[i]);
	printf("}\n");
	printf("***************************************\n");

	printf("Passer is Player %d\nReciver is Player %d\n",id_passer,id_receiver);

	//Get Passer and Receiver Teams. First Team A, Then Team B	
	if(id_passer < 1+((NPlayers*Fields)/2)) Passer_Team = TeamA; else Passer_Team = TeamB;
	if(id_receiver < 1+((NPlayers*Fields)/2)) Receiver_Team = TeamA; else Receiver_Team = TeamB; 

	printf("TeamA is %d, TeamB is %d\n",TeamA,TeamB);
	printf("Passer is Team %d while Receiver is Team %d\n",Passer_Team,Receiver_Team);
	printf("***************************************\n");

	//Only a pass between two players of the same team must be checked
	//If it's the same player means it is a autopass or simply he has run 
	//with the ball and in each ball touch trigger has been set, but it hasn't be checked
	if ((Passer_Team == Receiver_Team) && (id_passer != id_receiver)){

		printf("Possible Offside\n");

		//TODO: Capsule it on a function (?)
		//First: We must know if passing goes forward or backward

		//Working all the time with old positions

		Receiver_top 		=	old[((id_receiver-1)*Fields)+top_offset+1];
		Receiver_bottom 	= 	old[((id_receiver-1)*Fields)+bottom_offset+1];
		Passer_top		=	old[((id_passer-1)*Fields)+top_offset+1];
		Passer_bottom	 	= 	old[((id_passer-1)*Fields)+bottom_offset+1];

		printf("Passer top = %d,botom = %d\nReceiver top = %d,botom =%d\n",Passer_top,Passer_bottom,Receiver_top,Receiver_bottom);

		switch (Passer_Team){
		    case TeamA:
		    	//TeamA attacks top so if Reciver.top bigger than Sender.top is forward
		        if (Receiver_top > Passer_top) isForward = 1;
		        break;

		    case TeamB:
				//Team B attacks bottom so if Reciver bottom is smaller than Sender bottom is forward
				if(Receiver_bottom < Passer_bottom) isForward = 1;
		        break;
		}


		if(isForward){
			printf("***************************************\n");
			printf("Is Forward pass so possible offside\n");
			//Now we must check Reciver top or bottom with All Defense team top or bottom 
			//depending direction 	
			//We must work with old Reciver position because it's the significant one		
			//PlayersMatrix each player always have the same 

			

			switch (Receiver_Team){
			    case TeamA:
			    	//TeamA Offense is Offside if Receiver_top is bigger than max(Defense_top)
			    	max_Defender_top = max_top(old,TeamB);
				printf("if (Receiver_top (%d)  > max_Defender_top (%d))\n",Receiver_top,max_Defender_top); 
			    	if (Receiver_top  > max_Defender_top) result = 1;
			        break;

			    case TeamB:
			    	//TeamB Offense is Offside if Receiver_bottom is smaller than min(Defense_top)
			    	min_Defender_bottom = min_bottom(old,TeamA);
				printf("if (Receiver_top (%d)  > max_Defender_top (%d))\n",Receiver_bottom,min_Defender_bottom); 
			    	if (Receiver_bottom  < min_Defender_bottom) result = 1;
			        break;
			}

		}
		else printf("Pass back so cannot be offside\n");

	}
	else printf("Passer and Reciver are from different team! or are the same player (autopass); It's never Offside\n");

	return result;

}

int Check(int result, int i){

	return (result == tc_result[i]);

}

int main(int argc, char *argv[]) {

	int i,result,Offside;
	int successfull = 0;
	int failed = 0;
	
	for(i=0; i < NTestCases; i++){
	
		printf("\n\n***** TESTCASE %d ********************\n",i);				
		Offside = isOffside(&tc_PlayersMatrix[i*2][0],&tc_PlayersMatrix[1+i*2][0]); 
		result = Check(Offside,i);

		if(result){
			 printf("Test Case nº %d passed Succesfull!\n",i);
			 successfull++;
		}else{
			printf("Test Case nº %d Failed\n",i);
			failed++;
		}		
		printf("***************************************\n");
	}

	printf("Test run: %d; Successfull %d; Failed %d\n",NTestCases,successfull,failed);        

	return 0;

}
