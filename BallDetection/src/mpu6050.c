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

int read_word_2c(int addr)
{
int val;
val = wiringPiI2CReadReg8(fd, addr);
val = val << 8;
val += wiringPiI2CReadReg8(fd, addr+1);
if (val >= 0x8000)
val = -(65536 - val);
 
return val;
}
 
double dist(double a, double b)
{
return sqrt((a*a) + (b*b));
}
 
double get_y_rotation(double x, double y, double z)
{
double radians;
radians = atan2(x, dist(y, z));
return -(radians * (180.0 / M_PI));
}
 
double get_x_rotation(double x, double y, double z)
{
double radians;
radians = atan2(y, dist(x, z));
return (radians * (180.0 / M_PI));
}
 
int main()
{

unsigned int iter = 0;

fd = wiringPiI2CSetup (0x68);
wiringPiI2CWriteReg8 (fd,0x6B,0x00);//disable sleep mode
printf("set 0x6B=%X\n",wiringPiI2CReadReg8 (fd,0x6B));
ini = 1;

while(1) {
	
tacclX = read_word_2c(0x3B);
tacclY = read_word_2c(0x3D);
tacclZ = read_word_2c(0x3F);

if (ini){
 
	acc[0] = tacclX / 16384.0;
	acc[1] = tacclY / 16384.0;
	acc[2] = tacclZ / 16384.0;

	ini = 0;
}

else{
	acclX = tacclX / 16384.0;
	acclY = tacclY / 16384.0;
	acclZ = tacclZ / 16384.0;

	//if (accl

	printf("My acclX_scaled: %f\n", acclX);
	printf("My acclY_scaled: %f\n", acclY);
	printf("My acclZ_scaled: %f\n", acclZ);
 
	acc[0] = tacclX / 16384.0;
	acc[1] = tacclY / 16384.0;
	acc[2] = tacclZ / 16384.0;

}

printf("Inter %d\n", iter);
iter++;
delay(5000);
}
return 0;
}
