#include "interlanguage.h"
#include <iostream>

std::unique_ptr<MATLABEngine> matlabPtr;
matlab::data::ArrayFactory Factory;
  
uint32_t C_PlayersMatrix[NPlayers*Fields];

int i;


int iniMATLAB(){
		matlabPtr = startMATLAB();
		return 0;
}

int endMATLAB(){
	matlab::engine::terminateEngineClient();
	return 0;
}

uint32_t *getPlayersMatrix() {     

	//matlab::data::Array X = Factory.createArray<uint8_t>({ 2,2 }); //,         { 1.0, 3.0, 2.0, 4.0 });

	std::vector<matlab::data::Array> PlayersMatrix = matlabPtr->feval(("test"),1,{});

	auto tmp = PlayersMatrix[0]; 
	for (i=0; i<2; i++) { C_PlayersMatrix[i] = uint32_t(tmp[i]); }		

	return C_PlayersMatrix;

}
