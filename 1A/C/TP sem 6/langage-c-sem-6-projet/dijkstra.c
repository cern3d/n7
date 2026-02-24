#include "dijkstra.h"
#include <stdlib.h>
#include <math.h>
void construire_chemin_vers(liste_noeud_t** chemin, liste_noeud_t* visites, noeud_id_t noeud) {
    if (precedent_noeud_liste(visites, noeud) == NO_ID) {
        inserer_noeud_liste(*chemin, noeud, NO_ID, distance_noeud_liste(visites, noeud));
        return;
    }
    construire_chemin_vers(chemin, visites, precedent_noeud_liste(visites, noeud));
    inserer_noeud_liste(*chemin, noeud, precedent_noeud_liste(visites, noeud), distance_noeud_liste(visites, noeud));
}

void algo_D(
    const struct graphe_t* graphe, 
    noeud_id_t source,  
    liste_noeud_t* Avisiter, liste_noeud_t* visite) {

    inserer_noeud_liste(Avisiter, source, NO_ID, 0.0);

    while (!est_vide_liste(Avisiter)) {
        noeud_id_t n_courant = min_noeud_liste(Avisiter);
        double d_courant = distance_noeud_liste(Avisiter, n_courant);
        noeud_id_t pred = precedent_noeud_liste(Avisiter, n_courant);

        inserer_noeud_liste(visite, n_courant, pred, d_courant);
        supprimer_noeud_liste(Avisiter, n_courant);

        int n_voisins = nombre_voisins(graphe, n_courant);
        noeud_id_t* voisins = malloc(n_voisins * sizeof(noeud_id_t));
        noeuds_voisins(graphe, n_courant, voisins);

        for (int i = 0; i < n_voisins; ++i) {
            noeud_id_t v = voisins[i];
            double delta = d_courant + noeud_distance(graphe, n_courant, v);
            if (distance_noeud_liste(visite, v) == INFINITY) {
                if (distance_noeud_liste(Avisiter, v) > delta) {
                    changer_noeud_liste(Avisiter, v, n_courant, delta);
                }
            }
        }

        free(voisins);
    }
}

float dijkstra(const struct graphe_t* graphe, noeud_id_t source, noeud_id_t destination, liste_noeud_t** chemin) {
    liste_noeud_t* Avisiter = creer_liste();
    liste_noeud_t* visite = creer_liste();

    algo_D(graphe, source, Avisiter, visite);

    *chemin = creer_liste();
    construire_chemin_vers(chemin, visite, destination);

    double dist = distance_noeud_liste(visite, destination);
    detruire_liste(&Avisiter);
    detruire_liste(&visite);
    return dist;
}
