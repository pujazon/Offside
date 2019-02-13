#include <netdb.h> 
#include <stdio.h> 
#include <stdlib.h> 
#include <string.h>
#include <stdio.h>
#include <unistd.h> 
#include <sys/socket.h> 
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#define PORT 8080 

int BallTrigger;


void error(char *msg);

int c_connect();