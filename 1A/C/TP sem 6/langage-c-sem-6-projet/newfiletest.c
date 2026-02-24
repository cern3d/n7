#include <stdio.h>
#include <stdlib.h>
#include "liste_noeud.c"

void print_list(liste_noeud_t* listee) {
    printf("Contenu de la liste :\n");
    cellule* liste = listee->tete;
    while (liste != NULL) {
        printf(" - Noeud: %ld | Distance: %.2f | Précédent: %ld\n", 
            liste->noeud, liste->distance, liste->precedent);
        liste = liste->suivant;
    }
}

int main() {

    // Insertion de quelques nœuds
    liste_noeud_t* t = creer_liste();
        inserer_noeud_liste(t, 1, 10, 1.0);
        inserer_noeud_liste(t, 2, 11, 2.0);
        inserer_noeud_liste(t, 3, 12, 3.0);
        inserer_noeud_liste(t, 4, 13, 4.0);
        contient_noeud_liste(t, 1);
        contient_noeud_liste(t, 2);
        contient_noeud_liste(t, 3);
        contient_noeud_liste(t, 4);
        !contient_noeud_liste(t, 10);
    print_list(t);

    // Nettoyage
    detruire_liste(&t);

    return 0;
}
