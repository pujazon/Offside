#include "interlanguage.h"
#include <iostream>

std::unique_ptr<MATLABEngine> matlabPtr;
matlab::data::ArrayFactory Factory;

std::vector<matlab::data::Array> PlayersMatrix; 


//+1 because first element is id_ball
uint32_t C_PlayersMatrix[N];

int i;


int iniMATLAB(){
		matlabPtr = startMATLAB();
		return 0;
}

int endMATLAB(){
	matlab::engine::terminateEngineClient();
	return 0;
}

uint32_t *getPlayersMatrix(int isIni, uint32_t *old) {   

   int i;
   std::vector<int> tmp;
   for(i = 0; i < (1+(NPlayers*Fields)+3);i++) tmp.push_back(old[i]);
   
    // Create MATLAB input array with PlayersMatrix
    matlab::data::ArrayFactory factory;
    auto old_PlayersMatrix = factory.createArray({1,1}, tmp.cbegin(), tmp.cend());
	
	if(isIni){
		
		std::vector<matlab::data::Array> aPlayersMatrix  = matlabPtr->feval("handler_ini",1,{});
		auto ttmp = aPlayersMatrix[0]; 
		for (i=0; i<(1+NPlayers*Fields+3); i++) { C_PlayersMatrix[i] = uint32_t(ttmp[i]); }		
	}
	else{ 
		auto bPlayersMatrix = matlabPtr->feval("handler_tracking",old_PlayersMatrix);		
		for (i=0; i<(1+NPlayers*Fields+3); i++) { C_PlayersMatrix[i] = uint32_t(bPlayersMatrix[i]); }		
	}

	return C_PlayersMatrix;

}
