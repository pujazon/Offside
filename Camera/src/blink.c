#include <wiringPi.h>
#include <stdio.h>

//Wiring pi id's https://es.pinout.xyz/pinout/

int main(void){

	wiringPiSetup();
	pinMode (0,OUTPUT);
	
	while(1){
		
		printf("Blink..\n");
		
		digitalWrite(0,HIGH);
		delay(500);
		
		digitalWrite(0,LOW);
		delay(500);
	}
	
	return 0;
}
