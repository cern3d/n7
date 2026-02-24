
import java.awt.*;
import javax.swing.*;

/**
 * GUI du projet
 */
public class JeuDeLaVieGUI extends JFrame {

    // dim par défaut, TODO : rendre ça customisable
    private int HAUTEUR;
    private int LARGEUR;
    private Types TYPE;
    private int DELAI; // tps en ms entre les updates, TODO :  a custom ?

    private Grille grille;
    private CelluleBouton[][] boutons;
    private Timer timer;
    private boolean enCours = false;

    private JButton demarrer, arreter, reset, quitter;
    private JToggleButton torique;

    /**
     * Constructeur principal
     */
    public JeuDeLaVieGUI(int HAUTEURR, int LARGEURR, int DELAI, Types TYPEE) {
        super("Jeu de la Vie"); // titre

        this.HAUTEUR = HAUTEURR;
        this.LARGEUR = LARGEURR;
        this.DELAI = DELAI;
        this.TYPE = TYPEE;

        if (this.TYPE == Types.ALEA) {

            this.grille = Configuration.gAlea(LARGEUR, HAUTEUR, 0.3);
        } else if (this.TYPE == Types.CANNON) {
            this.grille = Configuration.gCannon();
            this.HAUTEUR = 30;
            this.LARGEUR = 60;
        } else if (this.TYPE == Types.PLANNEUR) {
            this.grille = Configuration.gPlanneur(HAUTEUR, LARGEUR);
        }
        JPanel panneau = new JPanel(new BorderLayout());

        JPanel controles = new JPanel(); // pour les boutons
        torique = new JToggleButton("Grille Torique: Non");
        torique.addActionListener(e -> {
            grille.setEstTorrique(torique.isSelected());
            torique.setText("Grille Torique: " + (torique.isSelected() ? "Oui" : "Non"));
        });


        demarrer = new JButton("Démarrer");
        demarrer.addActionListener(e -> {
            enCours = true;
            timer.start();
            actualiserControles();
        });

        arreter = new JButton("Arrêter");
        arreter.addActionListener(e -> {
            enCours = false;
            timer.stop();
            actualiserControles();
        });
        arreter.setEnabled(false);

        reset = new JButton("Réinitialiser");
        reset.addActionListener(e -> {
            if (enCours) {
                timer.stop();
                enCours = false;
            }
            if (this.TYPE == Types.ALEA) {
                this.grille = Configuration.gAlea(LARGEUR,HAUTEUR ,0.3);
            } else if (this.TYPE == Types.CANNON) {
                this.grille = Configuration.gCannon();
                this.HAUTEUR = 30;
                this.LARGEUR = 60;
            } else if (this.TYPE == Types.PLANNEUR) {
                this.grille = Configuration.gPlanneur(HAUTEUR, LARGEUR);
            }
            grille.setEstTorrique(torique.isSelected());
            actualiserGrille();
            actualiserControles();
        });

        quitter = new JButton("Quitter");
        quitter.addActionListener(e -> dispose());

        controles.add(torique);
        controles.add(demarrer);
        controles.add(arreter);
        controles.add(reset);
        controles.add(quitter);

        // grille ( matrice de CelluleBouton de dim HAUTEUR x LARGEUR )
        JPanel grillePanel = new JPanel(new GridLayout(HAUTEUR, LARGEUR));
        boutons = new CelluleBouton[HAUTEUR][LARGEUR]; //pour pouvoir manip les cellules plus tard
        // on prend tt les cellules de la grille
        for (int i = 0; i < HAUTEUR; i++) {
            for (int j = 0; j < LARGEUR; j++) {
                // on en créé un bouton grace a l'autre classe
                CelluleBouton b = new CelluleBouton(i, j);
                // le setVivant est celui du bouton, pour faire le lien entre
                // la grille en matrice et la grille du GUI
                b.setVivant(grille.getCellule(i, j).estVivant());

                final int ligne = i;
                final int col = j;
                // tq il n'y a pas de simul, on peut edit la config de base
                b.addActionListener(e -> {
                    if (!enCours) {
                        b.inverserEtat();
                        grille.getCellule(ligne, col).inverserEtat();
                    }
                });

                boutons[i][j] = b;
                grillePanel.add(b);
            }
        }

        panneau.add(controles, BorderLayout.NORTH);
        panneau.add(grillePanel, BorderLayout.CENTER);
        setContentPane(panneau); // contenu principal de la fenetre ? je comprends pas trop mais ca marche

        // lance prochaineEtape toutes les <DELAI> ms
        timer = new Timer(DELAI, e -> prochaineEtape());

        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        pack();
        setLocationRelativeTo(null);
        setVisible(true);
    }

    public JeuDeLaVieGUI() {
        this(20, 30, 200, Types.PLANNEUR);
    }

    /**
     * calcul la prochaine etape de la simulation puis l'update
     */
    private void prochaineEtape() {
        grille.jeu(); // update la grille ( a rename ? nom de methode peu explicite )
        grille.actualise();
        actualiserGrille();
    }

    /**
     * update l'affichage de la grille
     */
    private void actualiserGrille() {
        for (int i = 0; i < HAUTEUR; i++) {
            for (int j = 0; j < LARGEUR; j++) {
                boutons[i][j].setVivant(grille.getCellule(i, j).estVivant());
            }
        }
    }

    /**
     * active ou noms les boutons si on run la simulation
     */
    private void actualiserControles() {
        demarrer.setEnabled(!enCours);
        arreter.setEnabled(enCours);
        torique.setEnabled(!enCours);
    }

    /**
     * classe principale (lance le gui)
     */
    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> new StarterMenu());
        //SwingUtilities.invokeLater(() -> new JeuDeLaVieGUI());

    }
}
