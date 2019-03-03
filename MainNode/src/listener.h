#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>

#define PORTA 3500 
#define PORTB 3600 

using namespace std;  

int start_listening(int port);
int stop_listening(int rsocket);
int listen(int rsocket);
int listen_img(int rsocket);
