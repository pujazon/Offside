#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <string.h>
#include <iostream>
#include <fstream>

#define APORT 3500 
#define BPORT 3600

using namespace std;

extern char OUTPUT[256];

void error(char *msg);

int start_speaking(int port);
int meeting(int sock);
int stop_speaking(int sock);
int speak(int ssocketnt,char value);
int speak_img(int ssock);
