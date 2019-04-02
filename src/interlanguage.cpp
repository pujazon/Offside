#include "interlanguage.h"
#include <iostream>

std::unique_ptr<MATLABEngine> matlabPtr;
matlab::data::ArrayFactory Factory;

std::vector<matlab::data::Array> PlayersMatrix; 


//+1 because first element is id_ball
uint32_t C_PlayersMatrix[N];
uint32_t pOut[N];
int i;


int iniMATLAB(){
		matlabPtr = startMATLAB();
		return 0;
}

int endMATLAB(){
	matlab::engine::terminateEngineClient();
	return 0;
}

int getPlayersMatrix(int isIni, uint32_t *old) {   

   int i;
   matlab::data::ArrayFactory factory;

   printf("isInit==%d\n",isIni);

   std::vector<matlab::data::Array> args({
	factory.createScalar<double>(old[0]),
	factory.createScalar<double>(old[1]),
	factory.createScalar<double>(old[2]),
	factory.createScalar<double>(old[3]),
	factory.createScalar<double>(old[4]),
	factory.createScalar<double>(old[5]),
	factory.createScalar<double>(old[6]),
	factory.createScalar<double>(old[7]),
	factory.createScalar<double>(old[8]),
	factory.createScalar<double>(old[9]),
	factory.createScalar<double>(old[10]),
	factory.createScalar<double>(old[11]),
	factory.createScalar<double>(old[12]),
	factory.createScalar<double>(old[13]),
	factory.createScalar<double>(old[14]),
	factory.createScalar<double>(old[15]),
	factory.createScalar<double>(old[16]),
	factory.createScalar<double>(old[17]),
	factory.createScalar<double>(old[18]),
	factory.createScalar<double>(old[19]),
	factory.createScalar<double>(old[20]),
	factory.createScalar<double>(old[21]),
	factory.createScalar<double>(old[22]),
	factory.createScalar<double>(old[23]),
	factory.createScalar<double>(old[24]),
	factory.createScalar<double>(old[25]),
	factory.createScalar<double>(old[26]),
	factory.createScalar<double>(old[27]),
	factory.createScalar<double>(old[28]),
	factory.createScalar<double>(old[29]),
	factory.createScalar<double>(old[30]),
	factory.createScalar<double>(old[31]),
	factory.createScalar<double>(old[32]),
	factory.createScalar<double>(old[33]),
	factory.createScalar<double>(old[34]),
	factory.createScalar<double>(old[35])
   });
//  auto old_PlayersMatrix = factory.createArray<uint32_t>({1,36},std::begin(form),std::end(form));
    
   if(isIni){		
		PlayersMatrix  = matlabPtr->feval("handler_ini",1,{});
		matlab::data::Array ttmp = PlayersMatrix[0]; 
 
		for(i=0;i<N;i++){
			pOut[i] = (uint32_t) ttmp[i];
			printf("{%d}",(pOut[i]));
		}
  
	}
	else{ 

		PlayersMatrix  = matlabPtr->feval("handler_tracking",1,args);
		matlab::data::Array tmp = PlayersMatrix[0]; 
 
		for(i=0;i<N;i++){
			pOut[i] = (uint32_t) tmp[i];
			printf("{%d}",(pOut[i]));
		}
  
	}
        
	return 0;

}
