#include <chrono>
#include <ctime>
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

extern char PASS[256];
extern int BUTTON[256];
extern char BALL_REQ[256];
extern char CAMERA_REQ[256];
extern char BUTTON_REQ[256];

void error(char *msg);

int start_speaking(int port);
int meeting(int sock);
int stop_speaking(int sock);
int req_ball(int ssocket);
int req_camera(int ssocket);
int req_button(int ssocket);
int speak_pass(int ssocketnt,char value);
int speak_img(int ssock);
int speak_button(int ssock, int value);
