#include "speaker.h"

char OUTPUT[256];

int start_speaking(){

	struct sockaddr_in server;
	char in[1];
	int sock = 0;
	int port = 0;

	sock = socket(AF_INET, SOCK_STREAM, 0);

	if (sock == -1) fprintf(stderr, "failed\n");
	else printf("Sock %d connection is establisshed\n",sock);

	server.sin_family = AF_INET;
	server.sin_addr.s_addr = htonl(INADDR_ANY );
	server.sin_port = htons(PORT);

	int status = bind(sock, (struct sockaddr*) &server, sizeof(server));

	if (status == 0) printf("Connection completed\n");
	else printf("Problem is encountered %d \n",status);

	return sock;

}

int meeting(int sock){

	status = listen(sock, 1);
	if (status == 0) printf("App is ready to work\n");
	else
	{
		printf("Connection is failed\n");
		return -1;
	}

	struct sockaddr_in client = { 0 };
	int sclient = 0;
	unsigned int len = sizeof(client);


    int childSocket = accept(sock, (struct sockaddr*) &client, &len);
    if (childSocket == -1)
    {
		printf("cannot accept connection\n");
		close(sock);
		return -1; 
    }

    return childSocket;
}

int speak(int ssocket){

	OUTPUT[0] = '1';
	printf("speak() == %c\n",OUTPUT[0]);

	send(ssocket,&OUTPUT[0],1,0);
	//write(childSocket, OUTPUT, sizeof(OUTPUT));

	return 0;
}

int stop_speaking(int sock){
  
  close(sock);
  return 0;
  
}
