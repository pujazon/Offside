#include "listener.h"

const char *ADDR = "192.168.1.43";  
  
// Driver function 
int listener(){
	
  int sock = 0;
  int port = 0;
  struct sockaddr_in servaddr;
  sock = socket(AF_INET, SOCK_STREAM, 0);
  int status = 0;
  char buffer[256] = "";
  
  if (sock == -1){
    printf("could not establish connection\n");
    exit(1);
  }

  servaddr.sin_family = AF_INET;
  servaddr.sin_addr.s_addr = inet_addr(ADDR);
  servaddr.sin_port = htons(PORT);
  status = connect(sock, (struct sockaddr*) &servaddr, sizeof(servaddr));
  
  if (status == 0)
    printf("connection is established successfully\n");
  else{
    printf("could not run the app\n");
    exit(1);
  }

  status = read(sock, buffer, sizeof(buffer));
  if (status > 0)
    printf("%d: %s", status, buffer);

  close(sock);

  return 0;
}

