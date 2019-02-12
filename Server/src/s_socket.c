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
int main() 
{ 
    int sid, connfd, len; 
    struct sockaddr_in servaddr, cli;  
    char buff[N]; 
	
	//socket:
	//0 Family (int) pe: PF_INET
	//1 Tyep (datagram UDP or scoket TCP)
	//2 Protocol (0 default, can be set. Why 0 ? )
	// ret socket descriptor

    sid = socket(AF_INET, SOCK_STREAM, 0); 
    if (sid == -1) { 
        printf("socket creation failed...\n"); 
        exit(0); 
    } 
    else
        printf("Socket successfully created..\n"); 
  
    // assign IP, PORT 
    servaddr.sin_family = AF_INET; 
	
	//Assign IP. INADDR_ANY It binds the socket to all available interfaces.
	//interfaces means eth0, wh0 ... ?
	
    servaddr.sin_addr.s_addr = htonl(INADDR_ANY); 
    servaddr.sin_port = htons(PORT); 
  
    // Binding newly created socket to given IP and verification 
    if ((bind(sid, (struct sockaddr*)&servaddr, sizeof(servaddr))) != 0) { 
        printf("Socket bind failed...\n"); 
        exit(0); 
    } 
    else
        printf("Socket successfully binded..\n"); 
  
    // Now server is ready to listen and verification 
	//sockid: integer, socket descriptor
	// queuelen: integer, # of active participants that can “wait” for a connection
	// status: 0 if listening, -1 if error 
	
	//Not blocking, cannot recive and write. ONly used on connection establishment
    if ((listen(sid, 2)) != 0) { 
        printf("Listen failed...\n"); 
        exit(0); 
    } 
    else
        printf("Server listening..\n"); 
    len = sizeof(cli); 
  
    // Accept the data packet from client and verification 
    connfd = accept(sid, (struct sockaddr*)&cli, &len); 
    if (connfd < 0) { 
        printf("Server acccept failed...\n"); 
        exit(0); 
    } 
    else
        printf("Server acccept the client...\n"); 
  
	// TODO:
	//Here we have to:
	// 1. Check where the data packet come from:
	// 1.1 If comes from BallDetection -> BalTrigger (if == 1 then do)
	// 1.2 If comes from Camera ->
		//1.2.1 Save img on Server
		// 		write on a file to trigger PlayerDetection.m run
		// 		(Or something more efficient. Search C and MATLAB communication; Or open socket in Matlab.m)
		
		//read(sockfd, buff, sizeof(buff)); 

  
    // After chatting close the socket 
    close(sid); 
} 
