#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <unistd.h>     // fork, getpid, getppid
#include <sys/types.h>
#include <sys/wait.h>
#include <signal.h>
#include <dirent.h>
#include <fcntl.h>
#include <sys/stat.h>
#define N 100


int p[2];

void sigchld_handler(int sig) {
    int buff[10];
    int lus = read(p[0],buff,sizeof(buff));
}

int main(void){
int n[N];
// for (int i=0;i<N;i++){
//     n[i]=i;
// }

pipe(p);
if (pipe(p)==-1){
    printf("Echec");
}
switch(fork()){
    case -1:
        printf("Echec");
    case 0:
        close(p[1]);
        signal(SIGINT, &sigchld_handler);
        signal(SIGTSTP, &sigchld_handler);
        pause();
        close(p[0]);
        exit(EXIT_SUCCESS);
        break;
    default:
        close(p[0]);
        int i;
        while(true){
        i++;
        int k = write(p[1],&n[i],sizeof(n));
        sleep(1);
        printf("Valeur de write %d \n",n[i]);
        }
        close(p[1]);
        exit(EXIT_SUCCESS);
        break;
}
}