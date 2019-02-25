#include "MatlabDataArray.hpp"
#include "MatlabEngine.hpp"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <iostream>
#include <unistd.h>

#define NPlayers 22
#define Fields 4

using namespace matlab::engine;

int iniMATLAB();
int endMATLAB();
uint32_t* getPlayersMatrix();
