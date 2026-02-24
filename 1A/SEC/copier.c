
#include <stdio.h>
#include <unistd.h>     // fork, getpid, getppid
#include <stdlib.h>
#include <fcntl.h>
#include <stdbool.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>

#include <signal.h>

#define BUFFSIZE 1


void main(int argc, char **argv){
    int dest,source,Lus;
    char tampon[BUFFSIZE];

   if (argc != 3) {
    char msg[100];
    sprintf(msg,"Usage: %s file1 file2",argv[0]);
    write(STDERR_FILENO, msg, strlen(msg));
    exit(EXIT_FAILURE);
   }

   if ((source = open(argv[1], O_RDONLY)) == -1) {
    char msg[200];
    sprintf(msg,"Erreur Open de %s\n",argv[1]);
    write(STDERR_FILENO, msg, strlen(msg));
    exit(EXIT_FAILURE);
   }

   if ((dest = open(argv[2], O_WRONLY|O_CREAT|O_TRUNC, 0644)) == -1) {
    char msg[200];
    sprintf(msg,"Erreur Open de %s\n",argv[1]);
    write(STDERR_FILENO, msg, strlen(msg));
    exit(EXIT_FAILURE);
   } 
   
   while (Lus = read(source, tampon, BUFFSIZE)) {
    if (write(dest,tampon,BUFFSIZE)==0){
        perror("Erreur d'ecriture");
    }
   }

   close(dest);
   close(source);
   
   //if (dup2(source,0)== -1){
   //    exit(EXIT_FAILURE);
   //    perror("Erreur dup2 source\n");
   //}
   //close(source);

   //if (dup2(dest,0)== -1){
   //    perror("Erreur dup2 dest\n");
   //    exit(EXIT_FAILURE);
   //}
   //close(dest);
   //execlp("cat","cat",NULL);
   //perror("Erreur Cat \n");
}
