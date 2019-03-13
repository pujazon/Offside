#include <ctime>
#include <fstream>
#include <iostream>
#include <raspicam/raspicam.h>
#include <unistd.h> // for usleep()

using namespace std;

#define NFRAMES 1000
#define WIDTH   1280
#define HEIGHT  960

extern raspicam::RaspiCam Camera;

int setup_camera();
int photo();
