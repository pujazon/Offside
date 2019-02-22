#include "listener.h"


//Globals

char buffer[256] = "";
const char *ADDR = "192.168.1.43"; 
 
int sock;
int port;
int status;

struct sockaddr_in servaddr;


//TODO: Each function must have error handling
  
int start_listening(){
	
  sock = 0;
  port = 0;
  sock = socket(AF_INET, SOCK_STREAM, 0);
  status = 0;  
  
  if (sock == -1){
    printf("could not establish connection\n");
	return 1;
  }

  servaddr.sin_family = AF_INET;
  servaddr.sin_addr.s_addr = inet_addr(ADDR);
  servaddr.sin_port = htons(PORT);
  status = connect(sock, (struct sockaddr*) &servaddr, sizeof(servaddr));
  
  if (status == 0) printf("connection is established successfully\n");
  else{
    printf("could not run the app\n");
    return 2;
  }

  return 0;
}


int getTrigger(){

  int result = -1;

  //Only 1 byte is send so sizeof(buffer) cannot be the expected length; infintie loop
  status = read(sock,&buffer[0],1);
  
  if (status > 0){
	result = atoi(&buffer[0]);
  }

  return result;
}


int stop_listening(){
  close(sock);
}

