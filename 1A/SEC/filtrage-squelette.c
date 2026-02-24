#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <fcntl.h>
#include <stdbool.h>
#include <sys/select.h>

#define BUFSIZE 512

void traiter(char tampon [], char cde, int nb) {
    int i;
    switch(cde) {
    case 'X' :
        break;
    case 'Q' :
        exit(0);
        break;
    case 'R' :
        write(1,tampon,nb);
        break;
    case 'M' :
        for (i=0; i<nb; i++) {
            tampon[i]=toupper(tampon[i]);
        }
        write(1,tampon,nb);
        break;
    case 'm' :
        for (i=0; i<nb; i++) {
            tampon[i]=tolower(tampon[i]);
        }
        write(1,tampon,nb);
        break;
    default :
        printf("????\n");
    }
}

int main (int argc, char *argv[]) {
    int p[2];
    pid_t pid;
    int d, nlus;
    char buf[BUFSIZE];
    char commande = 'R'; /* mode normal */

    if (argc != 2) {
        printf("utilisation : %s <fichier source>\n", argv[0]);
        exit(1);
    }

    if (pipe(p) == -1) {
        perror("pipe");
        exit(2);
    }

    pid = fork();
    if (pid == -1) {
        perror("fork");
        exit(3);
    }

    if (pid == 0) {   /* processus fils */
        d = open(argv[1], O_RDONLY);
        if (d == -1) {
            fprintf(stderr, "Impossible d'ouvrir le fichier ");
            perror(argv[1]);
            exit(4);
        }

        close(p[0]); /* fermeture de l'entrée du pipe */

        while (true) {
            while ((nlus = read(d, buf, BUFSIZE)) > 0) {
                write(p[1], buf, nlus);
                sleep(5);
            }
            sleep(5);
            printf("on recommence...\n");
            lseek(d, (off_t) 0, SEEK_SET);
        }

    } else {   /* processus père */
        close(p[1]); // fermeture de la sortie du pipe

        system("stty -icanon min 1"); // lecture clavier sans tampon

        fd_set readfds;
        int maxfd = (p[0] > 0 ? p[0] : 0) + 1;

        while (true) {
            FD_ZERO(&readfds);
            FD_SET(0, &readfds);     // stdin
            FD_SET(p[0], &readfds);  // pipe

            if (select(maxfd, &readfds, NULL, NULL, NULL) == -1) {
                perror("select");
                exit(5);
            }

            if (FD_ISSET(0, &readfds)) {
                if (read(0, &commande, sizeof(char)) > 0) {
                    printf("-->%c\n", commande);
                }
            }

            if (FD_ISSET(p[0], &readfds)) {
                bzero(buf, BUFSIZE);
                nlus = read(p[0], buf, BUFSIZE);
                if (nlus > 0) {
                    traiter(buf, commande, nlus);
                }
            }
        }
    }

    return 0;
}

