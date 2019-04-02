#include "MatlabDataArray.hpp"
#include "MatlabEngine.hpp"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <iostream>
#include <unistd.h>

#define BallOwner_Fields	1
#define NPlayers 			8
#define Fields 				4
#define Grass_Fields		3

#define N BallOwner_Fields+(NPlayers*Fields)+Grass_Fields

using namespace matlab::engine;

int iniMATLAB();
int endMATLAB();
uint32_t* getPlayersMatrix(int isIni, uint32_t *old);
