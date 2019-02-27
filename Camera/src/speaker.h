#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <string.h>
#include  <iostream>
 
#define PORT 3500 

using namespace std;

extern char OUTPUT[256];

void error(char *msg);

int start_speaking();
int meeting(int sock);
int stop_speaking(int sock);
int speak(int ssocket);

