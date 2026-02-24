import java.util.List;

/**
 * Représente une cellule dans le jeu de la vie
 */
public class Cellule {
    private boolean actuel;
    private boolean futur;
    private List<Cellule> voisins;

    /**
     * constructeur par défaut, crée une cellule morte
     */
    public Cellule() {
        this.actuel = false;
        this.futur = false;
        this.voisins = null;
    }

    /**
     * vérifie si la cellule est vivante
     */
    public boolean estVivant() {
        return this.actuel;
    }

    /**
     * change l'état actuel de la cellule
     */
    public void setEtat(boolean etat) {
        this.actuel = etat;
    }

    /**
     * change l'attribut voisins de la cellule
     */
    public void setVoisins(List<Cellule> voisins) {
        this.voisins = voisins;
    }

    /**
     * Obtient la liste des voisins de la cellule
     */
    public List<Cellule> getVoisins() {
        return this.voisins;
    }

    /**
     * Change l'état futur de la cellule à vivant
     */
    public void nait() {
        this.futur = true;
    }

    /**
     * Change l'état futur de la cellule à mort
     */
    public void meurt() {
        this.futur = false;
    }

    /**
     * Bascule l'état actuel avec l'état futur et réinitialise l'état futur
     */
    public int basculer() {
        boolean a = this.actuel;
        this.actuel = this.futur;
        this.futur = false;
        if (a == this.actuel) {
            return 0;
        } else {
            return 1;
        }
    }

    /**
     * Inverse l'état actuel de la cellule
     */
    public void inverserEtat() {
        this.actuel = !this.actuel;
    }

    /**
     * Calcule l'état futur de la cellule selon les règles du jeu de la vie
     * TODO : rendre ça modifiable ?
     */
    public void calculeEtatFutur() {
        List<Cellule> voisins = this.getVoisins();
        int count = 0;
        for (Cellule voisin : voisins) {
            if (voisin.estVivant()) {
                count++;
            }
        }

        if (this.actuel && count != 2 && count != 3) {
            this.meurt();
        } else if (this.actuel && (count == 2 || count == 3)) {
            this.nait();
        } else if (!this.actuel && count == 3) {
            this.nait();
        } else {
            this.meurt();
        }
    }

    /**
    * affichage console
     */
    @Override
    public String toString() {
        if (this.estVivant()) {
            return " ■ ";
        } else {
            return "   ";
        }
    }
}