#include <wiringPiI2C.h>
#include <wiringPi.h>
#include <stdio.h>
#include <math.h>

int fd;
int tacclX, tacclY, tacclZ;
int gyroX, gyroY, gyroZ;
double acclX, acclY, acclZ;
double gyroX_scaled, gyroY_scaled, gyroZ_scaled;
char ini;
double acc[3];
double thX, thY, thZ;
unsigned int internal_trigger;

int read_word_2c(int addr);

double dist(double a, double b);

double get_y_rotation(double x, double y, double z);

double get_x_rotation(double x, double y, double z);

double dabs(double a, double b);

int mpu6050();