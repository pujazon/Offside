#include <netdb.h> 
#include <netinet/in.h> 
#include <stdlib.h> 
#include <string.h> 
#include <sys/socket.h> 
#include <sys/types.h> 
#include <stdio.h>
#include <unistd.h>
#define N 256
#define PORT 8080 
  
  
// Driver function 
int s_connect();