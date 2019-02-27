#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>

#define PORT 3500 

using namespace std;  

int start_listening();
int stop_listening(int rsocket);
int listen(int rsocket);
