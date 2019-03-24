#include "interlanguage.h"
#include <iostream>

std::unique_ptr<MATLABEngine> matlabPtr;
matlab::data::ArrayFactory Factory;
std::vector<matlab::data::Array> PlayersMatrix; 
  
//+1 because first element is id_ball
uint32_t C_PlayersMatrix[1+NPlayers*Fields];

int i;


int iniMATLAB(){
		matlabPtr = startMATLAB();
		return 0;
}

int endMATLAB(){
	matlab::engine::terminateEngineClient();
	return 0;
}

uint32_t *getPlayersMatrix(int isIni) {     

	//matlab::data::Array X = Factory.createArray<uint8_t>({ 2,2 }); //,         { 1.0, 3.0, 2.0, 4.0 });
	if(isIni)
		PlayersMatrix = matlabPtr->feval(("handler_ini"),1,{});
	else 
		PlayersMatrix = matlabPtr->feval(("handler_tracking"),1,{});		

	auto tmp = PlayersMatrix[0]; 
	for (i=0; i<1+NPlayers*Fields; i++) { C_PlayersMatrix[i] = uint32_t(tmp[i]); }		

	return C_PlayersMatrix;

}
