#include "c_socket.h"

void error(char *msg){
	perror(msg);
	exit(0);
}

int c_connect(){
	
	int sid, length, n, status;
	struct sockaddr_in server, from;
	struct hostent *hp;
	char buffer[256];

	BallTrigger = 1;

	//socket:
	//0 Family (int) pe: PF_INET
	//1 Tyep (datagram UDP or scoket TCP)
	//2 Protocol (0 default, can be set. Why 0 ? )
	// ret socket descriptor

	sid= socket(AF_INET, SOCK_STREAM, 0);

	if (sid == -1) { 
        printf("Socket creation failed...\n"); 
        exit(0); 
    } 

    // We need to set Server sockaddr_in 

    server.sin_family = AF_INET; 	 
    //IP address. TODO: Hardcoded, parameter ? 
    server.sin_addr.s_addr = inet_addr("127.0.0.1"); 
    //TODO: Same;
    server.sin_port = htons(PORT); 

	//Now after Server have initialized we must connect to them
	status = connect(sid,(struct sockaddr *) &server, sizeof(server)!= 0);

    // connect the client socket to server socket 
    // size ?
    if (connect(sid, (struct sockaddr*)&server, sizeof(server)) != 0) { 
        printf("Connection with the server failed...\n"); 
        exit(0); 
    } 
    else {
        printf("connected to the server..\n");     
	}

	//What we have to send in BallDetection is a boolean, byte, 
	//Saying if there is BallTrigger or not
	//extern int BallTrigger;

	//TODO: When send, how send, loop... must be done
    for (;;) { 

        write(sid,&BallTrigger, sizeof(BallTrigger)); 
      	
      	//We don't need to recive answer, only if we want to know if message have been lost and must be resend
      	//in TCP happens? 
        //read(sockfd, buff, sizeof(buff)); if(contains retry) (...)
    } 

	//If comunication is sent i should close socket
	// Good: Security, Bad: time (?)
	    close(sid); 
}
