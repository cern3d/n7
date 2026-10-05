import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 * Représente la grille sous forme de matrices de cellules
 */
public class Grille {
    private int hauteur;
    private int largeur;
    private boolean estTorrique;
    protected Cellule[][] grid;

    /**
     * Crée une grille avec les dimensions spécifiées et le type (torique ou non)
     */
    public Grille(int hauteur, int largeur, boolean estTorrique) {
        this.hauteur = hauteur;
        this.largeur = largeur;
        this.estTorrique = estTorrique;
        this.grid = new Cellule[hauteur][largeur];

        for (int i = 0; i < hauteur; i++) {
            for (int j = 0; j < largeur; j++) {
                this.grid[i][j] = new Cellule();
            }
        }
    }

    /**
     * Crée une grille non-torique avec les dimensions spécifiées
     */
    public Grille(int hauteur, int largeur) {
        this(hauteur, largeur, false);
    }

    /**
     * Obtient la hauteur de la grille
     */
    public int getHauteur() {
        return hauteur;
    }

    /**
     * Obtient la largeur de la grille
     */
    public int getLargeur() {
        return largeur;
    }

    /**
     * Vérifie si la grille est torique
     */
    public boolean estTorrique() {
        return estTorrique;
    }

    /**
     * Définit si la grille est torique
     */
    public void setEstTorrique(boolean estTorrique) {
        this.estTorrique = estTorrique;
    }

    /**
     * Obtient la cellule à la position spécifiée
     */
    public Cellule getCellule(int i, int j) {

        return grid[i][j];
    }

    /**
     * Vérifie si les coordonnées sont dans la grille
     */
    public boolean dansGrille(int i, int j) {

        return 0 <= i && i < this.hauteur && 0 <= j && j < this.largeur;
    }

    /**
     * Ramène les coordonnées dans la grille si elle est torique
     */
    public int[] ramenerDansGrilleTorrique(int i, int j) {
        if (i >= this.hauteur) {
            i = 0;
        }
        if (i < 0) {
            i = this.hauteur - 1;
        }
        if (j >= this.largeur) {
            j = 0;
        }
        if (j < 0) {
            j = this.largeur - 1;
        }
        return new int[]{i, j};
    }

    /**
     * Obtient les voisins d'une cellule
     */
    public List<Cellule> getVoisins(int i, int j) {
        List<Cellule> voisins = new ArrayList<>();
        if (this.estTorrique) {
            for (int ip = i - 1; ip <= i + 1; ip++) {
                for (int jp = j - 1; jp <= j + 1; jp++) {
                    int[] coords = this.ramenerDansGrilleTorrique(ip, jp);
                    int x = coords[0];
                    int y = coords[1];
                    if (!(ip == i && jp == j)) {
                        voisins.add(this.grid[x][y]);
                    }
                }
            }
        } else {
            for (int ip = i - 1; ip <= i + 1; ip++) {
                for (int jp = j - 1; jp <= j + 1 ; jp++) {
                    if (this.dansGrille(ip, jp) && !(ip == i && jp == j)) {
                        voisins.add(this.grid[ip][jp]);
                    }
                }
            }
        }
        return voisins;
    }

    /**
     * Affecte les voisins (attribut) à toutes les cellules de la grille
     */
    public void affecteVoisins() {
        for (int i = 0; i < this.hauteur; i++) {
            for (int j = 0; j < this.largeur; j++) {
                List<Cellule> voisins = this.getVoisins(i, j);
                this.grid[i][j].setVoisins(voisins);
            }
        }
    }

    /**
     * Remplit la grille aléatoirement avec une probabilité donnée ( cf config )
     */
    public void remplirArea(double prob) {
        Random random = new Random();
        for (int i = 0; i < this.hauteur; i++) {
            for (int j = 0; j < this.largeur; j++) {
                if (random.nextDouble() < prob) {
                    this.grid[i][j].setEtat(true);
                }
            }
        }
    }

    /**
     * Calcule l'état futur de toutes les cellules selon les règles du jeu
     */
    public void jeu() {
        this.affecteVoisins();
        for (int i = 0; i < this.hauteur; i++) {
            for (int j = 0; j < this.largeur; j++) {
                this.grid[i][j].calculeEtatFutur();
            }
        }
    }

    /**
     * Actualise l'état de toutes les cellules
     */
    public void actualise() {
        for (int i = 0; i < this.hauteur; i++) {
            for (int j = 0; j < this.largeur; j++) {
                this.grid[i][j].basculer();
            }
        }
    }

    /**
     * Réinitialise toutes les cellules à l'état mort
     */
    public void reinitialiser() {
        for (int i = 0; i < this.hauteur; i++) {
            for (int j = 0; j < this.largeur; j++) {
                this.grid[i][j].setEtat(false);
            }
        }
    }

    /**
     * affichage console
     */
    @Override
    public String toString() {
        StringBuilder resultat = new StringBuilder();
        for (int i = 0; i < this.hauteur; i++) {
            for (int j = 0; j < this.largeur; j++) {
                resultat.append(this.grid[i][j].toString());
            }
            resultat.append("\n");
        }
        return resultat.toString();
    }

}

