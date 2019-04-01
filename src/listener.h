#include <iostream>
#include <chrono>
#include <ctime>
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

int start_listening(int port,char *ADDR);
int stop_listening(int rsocket);
int listen_pass(int rsocket);
int listen_img(int rsocket);
int ball_recv(int rsocket);
int camera_recv(int rsocket);

