#include "speaker.h"

char OUTPUT[256];

int speaker(){

  OUTPUT[0] = '1';
  char in[1];
  int sock = 0;
  int port = 0;
  int count = 0;

  sock = socket(AF_INET, SOCK_STREAM, 0);

  if (sock == -1)
    fprintf(stderr, "failed\n");
  else
    printf("Sock %d connection is establisshed\n",sock);

  struct sockaddr_in server;
  server.sin_family = AF_INET;
  server.sin_addr.s_addr = htonl(INADDR_ANY );
  server.sin_port = htons(PORT);

  int status = bind(sock, (struct sockaddr*) &server, sizeof(server));
  if (status == 0)
    printf("connection completed\n");
  else
    printf("problem is encountered %d \n",status);

  status = listen(sock, 5);
  if (status == 0)
    printf("app is ready to work\n");
  else
  {
    printf("connection is failed\n");
    return 0;
  }

  
  while (cin >> in){
    printf("Input value %d\n",in);
    struct sockaddr_in client = { 0 };
    int sclient = 0;
    unsigned int len = sizeof(client);
    int childSocket = accept(sock, (struct sockaddr*) &client, &len);
    if (childSocket == -1)
    {
      printf("cannot accept connection\n");
      close(sock);
      break;
    }

    write(childSocket, OUTPUT, sizeof(OUTPUT));
    count++;
    OUTPUT[0] = 0;
    if (count == 10){
	    OUTPUT[0] = 1;
    	    count = 0; 
    }
     // sleep(5000);
    //close(childSocket);
  }
  
  close(sock);
  return 0;
  
}
