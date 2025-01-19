#ifndef COMPLEX_H
#define COMPLEX_H

// Type utilisateur complexe_t
struct complexe_t {
    double reelle;
    double imaginaire;
};
typedef struct complexe_t complexe_t;

// Fonctions reelle et imaginaire
/**
 * reelle
 * Renvoie la partie reelle d'un nombre complexe.
 * 
 * Parametres :
 *  Z               [in] Complexe dont on veut la valeur de sa partie.
 * 
 * Pre-conditions : 
 * Post-conditions : reelle(Z) = Re(Z)
 * 
 */
double reelle(complexe_t Z);

/**
 * imaginaire
 * Renvoie la partie imaginaire d'un nombre complexe.
 * 
 * Parametres :
 *  Z               [in] Complexe dont on veut la valeur de sa partie.
 * 
 * Pre-conditions : 
 * Post-conditions : imaginaire(Z) = Im(Z)
 * 
 */
double imaginaire(complexe_t Z);

// Procédures set_reelle, set_imaginaire et init
/**
 * set_reelle
 * Change la valeur du reelle d'un nombre complexe.
 * 
 * Parametres :
 *  Z               [out] Complexe dont on veut changer la valeur.
 *  re              [in] La valeur qu'on veut associer a la partie reelle de Z.
 * 
 * Pre-conditions : Z non null
 * Post-conditions : reelle(*Z) = re
 * 
 */
void set_reelle(complexe_t* Z, double re);

/**
 * set_imaginaire
 * Change la valeur de l'imaginaire d'un nombre complexe.
 * 
 * Parametres :
 *  Z               [out] Complexe dont on veut changer la valeur.
 *  im              [in] La valeur qu'on veut associer a la partie imaginaire de Z.
 * 
 * Pre-conditions : Z non null
 * Post-conditions : imaginaire(*Z) = im
 * 
 */
void set_imaginaire(complexe_t* Z, double im);

/**
 * init
 * Change la valeur de l'imaginaire et du reelle d'un nombre complexe.
 * 
 * Parametres :
 *  Z               [out] Complexe dont on veut changer la valeur.
 *  im              [in] La valeur qu'on veut associer a la partie imaginaire de Z.
 *  re              [in] La valeur qu'on veut associer a la partie relle de Z.
 * 
 * Pre-conditions : Z non null
 * Post-conditions : imaginaire(*Z) = im et reelle(*Z) = re
 * 
 */
void init(complexe_t* Z, double re, double im);

// Procédure copie
/**
 * copie
 * Copie les composantes du complexe donné en second argument dans celles du premier.
 * argument
 *
 * Paramètres :
 *   resultat       [out] Complexe dans lequel copier les composantes
 *   autre          [in]  Complexe à copier
 *
 * Pré-conditions : resultat non null
 * Post-conditions : resultat et autre ont les mêmes composantes
 */
void copie(complexe_t* resultat, complexe_t autre);

// Algèbre des nombres complexes
/**
 * conjugue
 * Calcule le conjugué du nombre complexe op et le sotocke dans resultat.
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   op             [in]  Complexe dont on veut le conjugué
 *
 * Pré-conditions : resultat non-null
 * Post-conditions : reelle(*resultat) = reelle(op), complexe(*resultat) = - complexe(op)
 */
void conjugue(complexe_t* resultat, complexe_t op);

/**
 * ajouter
 * Réalise l'addition des deux nombres complexes gauche et droite et stocke le résultat
 * dans resultat.
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   gauche         [in]  Opérande gauche
 *   droite         [in]  Opérande droite
 *
 * Pré-conditions : resultat non-null
 * Post-conditions : *resultat = gauche + droite
 */
void ajouter(complexe_t* resultat, complexe_t gauche, complexe_t droite);

/**
 * soustraire
 * Réalise la soustraction des deux nombres complexes gauche et droite et stocke le résultat
 * dans resultat.
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   gauche         [in]  Opérande gauche
 *   droite         [in]  Opérande droite
 *
 * Pré-conditions : resultat non-null
 * Post-conditions : *resultat = gauche - droite
 */
void soustraire(complexe_t* resultat, complexe_t gauche, complexe_t droite);

/**
 * multiplier
 * Réalise le produit des deux nombres complexes gauche et droite et stocke le résultat
 * dans resultat.
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   gauche         [in]  Opérande gauche
 *   droite         [in]  Opérande droite
 *
 * Pré-conditions : resultat non-null
 * Post-conditions : *resultat = gauche * droite
 */
void multiplier(complexe_t* resultat, complexe_t gauche, complexe_t droite);

/**
 * echelle
 * Calcule la mise à l'échelle d'un nombre complexe avec le nombre réel donné (multiplication
 * de op par le facteur réel facteur).
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   op             [in]  Complexe à mettre à l'échelle
 *   facteur        [in]  Nombre réel à multiplier
 *
 * Pré-conditions : resultat non-null
 * Post-conditions : *resultat = op * facteur
 */
void echelle(complexe_t* resultat, complexe_t op, double facteur);

/**
 * puissance
 * Calcule la puissance entière du complexe donné et stocke le résultat dans resultat.
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   op             [in]  Complexe dont on veut la puissance
 *   exposant       [in]  Exposant de la puissance
 *
 * Pré-conditions : resultat non-null, exposant >= 0
 * Post-conditions : *resultat = op * op * ... * op
 *                                 { n fois }
 */
void puissance(complexe_t* resultat, complexe_t op, int exposant);

// Module et argument
/**
 * module_carre
 * Renvoie le module au carre d'un nombre complexe.
 *
 * Paramètres :
 *   Z             [in]  Complexe dont on veut le module au carre
 *
 * Pré-conditions :
 * Post-conditions : resultat = imaginaire(Z)**2 + reelle(Z)**2
 */
double module_carre(complexe_t Z);

/**
 * module
 * Renvoie le module d'un nombre complexe.
 *
 * Paramètres :
 *   Z             [in]  Complexe dont on veut le module
 *
 * Pré-conditions :
 * Post-conditions : resultat**2 = imaginaire(z)**2 + reelle(Z)**2
 */
double module(complexe_t Z);

/**
 * argument
 * Renvoie l'argument d'un nombre complexe.
 *
 * Paramètres :
 *   op             [in]  Complexe dont on veut l'argument
 *
 * Pré-conditions :
 * Post-conditions : resultat = arg(Z)
 */
double argument(complexe_t Z);


#endif // COMPLEXE_H



