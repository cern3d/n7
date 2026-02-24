/**
 * Classe contenant des méthodes pour créer différentes configurations initiales
 */
class Configuration {

    /**
     * Crée une grille avec des cellules vivantes placées aléatoirement
     * @param L largeur
     * @param H hauteur
     * @param taux probabilité qu'une cellule soit vivante
     * @return une nouvelle grille avec la configuration aléatoire
     */
    public static Grille gAlea(int L, int H, double taux) {
        Grille a = new Grille(H, L);
        a.remplirArea(taux);
        return a;
    }

    /**
     * Crée une grille avec un planneur (glider).
     * @param H hauteur (>= 10)
     * @param L largeur (>= 10)
     * @return une nouvelle grille avec un planneur
     */
    public static Grille gPlanneur(int H, int L) {
        Grille a = new Grille(H, L, true);
        a.grid[3][3].setEtat(true);
        a.grid[3][4].setEtat(true);
        a.grid[3][5].setEtat(true);
        a.grid[2][5].setEtat(true);
        a.grid[1][4].setEtat(true);
        return a;
    }

    /**
     * Crée une grille avec un canon à planeurs de Gosper
     * @return une nouvelle grille avec un canon à planeurs
     */
    public static Grille gCannon() {
        Grille a = new Grille(30, 60);
        // Première partie du canon
        a.grid[5][1].setEtat(true);
        a.grid[5][2].setEtat(true);
        a.grid[6][1].setEtat(true);
        a.grid[6][2].setEtat(true);

        // Deuxième partie du canon
        a.grid[5][11].setEtat(true);
        a.grid[6][11].setEtat(true);
        a.grid[7][11].setEtat(true);
        a.grid[4][12].setEtat(true);
        a.grid[8][12].setEtat(true);
        a.grid[3][13].setEtat(true);
        a.grid[9][13].setEtat(true);
        a.grid[3][14].setEtat(true);
        a.grid[9][14].setEtat(true);
        a.grid[6][15].setEtat(true);
        a.grid[4][16].setEtat(true);
        a.grid[8][16].setEtat(true);
        a.grid[5][17].setEtat(true);
        a.grid[6][17].setEtat(true);
        a.grid[7][17].setEtat(true);
        a.grid[6][18].setEtat(true);

        // Troisième partie du canon
        a.grid[3][21].setEtat(true);
        a.grid[4][21].setEtat(true);
        a.grid[5][21].setEtat(true);
        a.grid[3][22].setEtat(true);
        a.grid[4][22].setEtat(true);
        a.grid[5][22].setEtat(true);
        a.grid[2][23].setEtat(true);
        a.grid[6][23].setEtat(true);
        a.grid[1][25].setEtat(true);
        a.grid[2][25].setEtat(true);
        a.grid[6][25].setEtat(true);
        a.grid[7][25].setEtat(true);

        // Quatrième partie du canon
        a.grid[3][35].setEtat(true);
        a.grid[4][35].setEtat(true);
        a.grid[3][36].setEtat(true);
        a.grid[4][36].setEtat(true);

        return a;
    }
}