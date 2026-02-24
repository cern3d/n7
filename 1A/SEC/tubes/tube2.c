
#include <stdio.h>      // printf
#include <stdlib.h>     // exit
#include <unistd.h>     // fork, getpid, getppid

int main(void){
int p[2];
int n =5;
pipe(p);
if (pipe(p)==-1){
    printf("Echec");
}
write(p[1],&n,sizeof(n));
close(p[1]);
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
}
}