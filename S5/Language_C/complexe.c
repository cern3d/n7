#include "complexe.h"
#include <math.h>           // Pour certaines fonctions trigo notamment

const double PI = 3.14159265358979323846;
// Implantations de reelle et imaginaire
double reelle(complexe_t Z) {
    return Z.reelle;
}
double imaginaire(complexe_t Z) {
    return Z.imaginaire;
}

// Implantations de set_reelle et set_imaginaire
void set_reelle(complexe_t* Z, double re){
    Z->reelle = re;
}
void set_imaginaire(complexe_t* Z, double im){
    Z->imaginaire = im;
}
void init(complexe_t* Z, double re, double im){
    set_reelle(Z,re);
    set_imaginaire(Z,im);
}


// Implantation de copie
void copie(complexe_t* resultat, complexe_t autre){
    resultat->imaginaire = imaginaire(autre);
    resultat->reelle = reelle(autre);
}

// Implantations des fonctions algébriques sur les complexes
void conjugue(complexe_t* resultat, complexe_t op){
    resultat->imaginaire = - op.imaginaire;
    resultat->reelle = op.reelle;
}
void ajouter(complexe_t* resultat, complexe_t gauche, complexe_t droite){
    resultat->imaginaire =  gauche.imaginaire + droite.imaginaire;
    resultat->reelle = gauche.reelle + droite.reelle;
}
void soustraire(complexe_t* resultat, complexe_t gauche, complexe_t droite){
    resultat->imaginaire =  gauche.imaginaire - droite.imaginaire;
    resultat->reelle = gauche.reelle - droite.reelle;
}
void multiplier(complexe_t* resultat, complexe_t gauche, complexe_t droite){
    resultat->imaginaire =  gauche.imaginaire*droite.reelle + droite.imaginaire*gauche.reelle;
    resultat->reelle = gauche.reelle*droite.reelle - gauche.imaginaire*droite.imaginaire;
}
void echelle(complexe_t* resultat, complexe_t op, double facteur){
    resultat->imaginaire =  op.imaginaire*facteur;
    resultat->reelle = op.reelle*facteur;
}

void puissance(complexe_t* resultat, complexe_t op, int exposant){
    int i;
    if (exposant >0){
    *resultat = op;
    for (i=1; i <exposant; i++){
        multiplier(resultat,*resultat,op);
    }
    } else {
    init(resultat,1.0,0.0);
    }
}

// Implantations du module et de l'argument
double module_carre( complexe_t Z){
    double resultat;
    resultat = imaginaire(Z)*imaginaire(Z) + reelle(Z)*reelle(Z);
    return resultat;
}
double module( complexe_t Z){
    double resultat;
    resultat = sqrt(module_carre(Z));
    return resultat;
}
double argument( complexe_t Z){
    return atan2(imaginaire(Z),reelle(Z));
}



