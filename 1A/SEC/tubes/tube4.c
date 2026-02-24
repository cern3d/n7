

#include <stdio.h>      // printf
#include <stdlib.h>     // exit
#include <unistd.h>     // fork, getpid, getppid
#define N 5

int main(void){
int p[2];
pipe(p);
if (pipe(p)==-1){
    printf("Echec");
}
switch(fork()){
    case -1:
        printf("Echec");
    case 0:
        close(p[1]);
        int val;
        int lus;
        while (lus = read(p[0],&val,sizeof(val))){
            printf("lus %d, val%d\n",lus,val);
        } 
        printf("Sorite de boucle");
        close(p[0]);
        exit(EXIT_SUCCESS);
        break;
    default:
        close(p[0]);
        for (int n=0;n<=N;n++){
        write(p[1],&n,sizeof(n));
        }
        close(p[1]);
        sleep(10);
        exit(EXIT_SUCCESS);
        break;
}
}