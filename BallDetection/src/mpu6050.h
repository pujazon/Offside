#include <wiringPiI2C.h>
#include <wiringPi.h>
#include <stdio.h>
#include <math.h>

int read_word_2c(int addr);

double dist(double a, double b);

double get_y_rotation(double x, double y, double z);

double get_x_rotation(double x, double y, double z);

double dabs(double a, double b);

int setupMPU6050();

unsigned int isTrigger();
