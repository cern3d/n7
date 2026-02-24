#include <stdio.h>
#include <stdlib.h>
#include "readcmd.h"
#include <stdbool.h>
#include <string.h>
#include <unistd.h> // fork, getpid, getppid
#include <sys/types.h>
#include <sys/wait.h>
#include <signal.h>
#include <dirent.h>
#include <fcntl.h>
#include <sys/stat.h>

// Gestionnaire de signal SIGCHLD pour suivre l'état des processus enfants
void sigchld_handler(int sig)
{
    int status;
    pid_t pid = waitpid(-1, &status, WNOHANG | WUNTRACED | WCONTINUED);
    
    if (sig == SIGCHLD) {
        if (pid > 0) {
            if (WIFEXITED(status)) {
                printf("Un processus fils (PID: %d) vient de se terminer.\n", pid);
            }
            else if (WIFSIGNALED(status)) {
                printf("Un processus fils (PID: %d) vient d'être suspendu.\n", pid);
            }
            else if (WIFSTOPPED(status)) {
                printf("Un processus fils (PID: %d) vient d'être suspendu par SIGSTOP.\n", pid);
            }
            else if (WIFCONTINUED(status)) {
                printf("Le processus fils (PID: %d) a été repris avec SIGCONT.\n", pid);
            }
        }
    }
}

// Fonction de changement de répertoire (cd)
void cd(const char *chemin)
{
    const char *directory = chemin;

    // Si aucun chemin n'est fourni, on utilise le répertoire home
    if (chemin == NULL) {
        directory = getenv("HOME");
    }

    // Essayer de changer de répertoire
    if (chdir(directory) == -1) {
        perror("Erreur de changement de répertoire");
    }
}

// Fonction pour lister les fichiers d'un répertoire
void dir(const char *chemin)
{
    if (chemin == NULL) {
        chemin = "."; // Si aucun chemin n'est fourni, on liste le répertoire courant
    }

    DIR *directory = opendir(chemin);
    if (!directory) {
        perror("Erreur ouverture répertoire");
        return;
    }

    struct dirent *entry;
    while ((entry = readdir(directory)) != NULL) {
        printf("%s\n", entry->d_name); // Afficher chaque fichier
    }

    closedir(directory);
}

int main(void)
{
    bool fini = false;

    // Initialisation du gestionnaire de signal SIGCHLD
    struct sigaction sachld;
    sachld.sa_handler = sigchld_handler;
    sigemptyset(&sachld.sa_mask);
    sachld.sa_flags = SA_RESTART;

    // Enregistrement du gestionnaire de signal pour SIGCHLD
    if (sigaction(SIGCHLD, &sachld, NULL) == -1) {
        perror("sigaction");
        exit(EXIT_FAILURE);
    }

    // Blocage des signaux SIGINT et SIGTSTP
    sigset_t set;
    sigaddset(&set, SIGINT);
    sigaddset(&set, SIGTSTP);
    sigprocmask(SIG_SETMASK, &set, NULL);

    // Boucle principale du shell
    while (!fini) {
        printf("> ");
        struct cmdline *commande = readcmd(); // Lire la commande

        if (commande == NULL) {
            // En cas d'erreur lors de la lecture de la commande
            perror("erreur lecture commande \n");
            exit(EXIT_FAILURE);
        }
        else {
            if (commande->err) {
                // Si la commande est mal formée
                printf("erreur saisie de la commande : %s\n", commande->err);
            }
            else {
                int indexseq = 0;
                char **cmd;
                int source, dest;
                int pipe_precedente = -1;

                // Traiter chaque séquence de commandes
                while ((cmd = commande->seq[indexseq])) {
                    if (cmd[0]) {
                        if (strcmp(cmd[0], "exit") == 0) {
                            fini = true; // Quitter le shell
                            printf("Au revoir ...\n");
                        }
                        else if (strcmp(cmd[0], "cd") == 0) {
                            cd(cmd[1]); // Changer de répertoire
                        }
                        else if (strcmp(cmd[0], "dir") == 0) {
                            dir(cmd[1]); // Lister le répertoire
                        }
                        else {
                            pid_t pid_fork;
                            int p[2];
                            bool next = (commande->seq[indexseq+1] != NULL);
                            int p_succes = pipe(p); // Création d'un pipe pour les commandes en chaîne
                            if (p_succes == -1) {
                                perror("erreur pipe");
                            }

                            pid_fork = fork(); // Création du processus enfant

                            if (pid_fork == -1) {
                                printf("Erreur fork\n");
                                exit(1);
                            }
                            if (pid_fork == 0) { /* Code exécuté par le processus fils */
                                if (pipe_precedente != -1) {
                                    dup2(pipe_precedente, STDIN_FILENO); // Redirection de l'entrée standard
                                    close(pipe_precedente);
                                }
                                if (next) {
                                    close(p[0]);
                                    dup2(p[1], STDOUT_FILENO); // Redirection de la sortie standard
                                    close(p[1]);
                                }

                                // Si la commande doit être exécutée en arrière-plan
                                if (commande->backgrounded != NULL) {
                                    setpgrp();
                                }

                                // Redirection des fichiers d'entrée/sortie
                                if (indexseq == 0 && commande->in != NULL) {
                                    if ((source = open(commande->in, O_RDONLY)) == -1) {
                                        char msg[200];
                                        sprintf(msg, "Erreur Open de %s\n", commande->in);
                                        write(STDERR_FILENO, msg, strlen(msg));
                                        exit(EXIT_FAILURE);
                                    }
                                    if (dup2(source, 0) == -1) {
                                        exit(EXIT_FAILURE);
                                        perror("Erreur dup2 source\n");
                                    }
                                    close(source);
                                }
                                if (!next && commande->out != NULL) {
                                    if ((dest = open(commande->out, O_WRONLY | O_CREAT | O_TRUNC, 0644)) == -1) {
                                        char msg[200];
                                        sprintf(msg, "Erreur Open de %s\n", commande->out);
                                        write(STDERR_FILENO, msg, strlen(msg));
                                        exit(EXIT_FAILURE);
                                    }
                                    if (dup2(dest, 1) == -1) {
                                        perror("Erreur dup2 dest\n");
                                        exit(EXIT_FAILURE);
                                    }
                                    close(dest);
                                }

                                // Déblocage des signaux pour le processus fils
                                int succes = sigprocmask(SIG_UNBLOCK, &set, NULL);
                                if (succes == -1) {
                                    perror("erreur sigpromask");
                                }

                                // Exécution de la commande
                                execvp(cmd[0], cmd);
                                exit(EXIT_SUCCESS); // Bonne pratique : quitter explicitement le processus fils
                            }
                            else { /* Code exécuté par le processus père */
                                if (pipe_precedente != -1) {
                                    close(pipe_precedente); // Fermeture du précédent pipe
                                }

                                if (next) {
                                    close(p[1]);
                                    pipe_precedente = p[0]; // Préparer le pipe pour la prochaine commande
                                }

                                // Attendre la fin du processus si la commande n'est pas en arrière-plan
                                if (commande->backgrounded == NULL) {
                                    int succes = sigprocmask(SIG_SETMASK, &set, NULL);
                                    if (succes == -1) {
                                        perror("erreur sigpromask");
                                    }
                                    pause(); // Suspendre l'exécution du père en attendant le signal
                                }
                            }
                        }
                        indexseq++;
                    }
                }
            }
        }
    }
    return EXIT_SUCCESS;
}

