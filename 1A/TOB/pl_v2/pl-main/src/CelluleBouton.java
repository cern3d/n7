import java.awt.*;
import javax.swing.*;

/**
 * Bouton qui représente une cellule dans le GUI
 */
public class CelluleBouton extends JButton {
    private int ligne;
    private int colonne;
    private boolean vivant;

    /**
     * Crée un nouveau bouton de cellule
     */
    public CelluleBouton(int ligne, int colonne) {
        this.ligne = ligne;
        this.colonne = colonne;
        this.vivant = false;
        setPreferredSize(new Dimension(10, 10)); // set taille
        setBackground(Color.WHITE); // couleur de la cellule
        setBorderPainted(false); // faire en sorte que la grille soit invisible
        // mettre a true pour la voir mais c'est moche
    }

    /**
     * Retourne le numéro de ligne d'une cellule
     */
    public int getLigne() {
        return ligne;
    }

    /**
     * Retourne le numéro de colonne d'une cellule
     */
    public int getColonne() {
        return colonne;
    }

    /**
     * Def l'état vivant ou mort de la cellule et update l'apparence
     */
    public void setVivant(boolean vivant) {
        this.vivant = vivant;
        miseAJour();
    }

    /**
     * Retourne l'état  de la cellule
     */
    public boolean estVivant() {
        return vivant;
    }

    /**
     * Inverse l'état de la cellule
     */
    public void inverserEtat() {
        this.vivant = !this.vivant;
        miseAJour();
    }

    /**
     * Update l'apparence du bouton en fonction de l'état
     */
    private void miseAJour() {
        if (vivant) {
            setBackground(Color.BLACK);
        } else {
            setBackground(Color.WHITE);
        }
    }
}