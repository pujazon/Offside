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

uint32_t *getPlayersMatrix(int isIni, int *old) {   
	
	std::vector<int> tmp;
	for(i = 0; i < (1+(NPlayers*Fields)+3);i++) old_local_PlayerMatrix.push_back(old[i]);

    // Create MATLAB input array with PlayersMatrix
    matlab::data::ArrayFactory factory;
    auto old_PlayersMatrix = factory.createArray({1,1}, tmp.cbegin(), tmp.cend());
	
	if(isIni)
		PlayersMatrix = matlabPtr->feval(("handler_ini"),1,{});
	else 
		PlayersMatrix = matlabPtr->feval(("handler_tracking"),1,old_PlayersMatrix);		

	auto ttmp = PlayersMatrix[0]; 
	for (i=0; i<(1+NPlayers*Fields+3); i++) { C_PlayersMatrix[i] = uint32_t(ttmp[i]); }		

	return C_PlayersMatrix;

}
