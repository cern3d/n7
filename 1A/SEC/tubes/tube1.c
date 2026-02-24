#include <stdio.h>      // printf
#include <stdlib.h>     // exit
#include <unistd.h>     // fork, getpid, getppid

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
        int lus = read(p[0],&val,sizeof(val));
        close(p[0]);
        printf("lus %d\n",val);
        break;
    default:
        close(p[0]);
        int n =4;
        write(p[1],&n,sizeof(n));
        close(p[1]);
        exit(EXIT_SUCCESS);
        break;
}
}