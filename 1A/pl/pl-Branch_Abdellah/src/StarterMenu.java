
import java.awt.*;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import javax.swing.ButtonGroup;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JSlider;
import javax.swing.JTextField;
import javax.swing.JToggleButton;

/**
 * Classe représentant le menu de démarrage du jeu de la vie. Permet de
 * configurer les paramètres de jeu avant de lancer la simulation.
 */
public class StarterMenu extends JFrame {

    // Composants de l'interface
    private JButton play;          // Bouton pour lancer le jeu
    private JButton quit;         // Bouton pour quitter l'application
    private JTextField hauteur;    // Champ pour saisir la hauteur de la grille
    private JTextField largeur;    // Champ pour saisir la largeur de la grille
    private JSlider refreshrate;   // Slider pour choisir la vitesse de rafraîchissement
    private JToggleButton fullscreen; // Bouton pour activer/désactiver le mode plein écran
    private JToggleButton alea; // Bouton pour activer/désactiver le mode plein écran
    private JToggleButton planneur; // Bouton pour activer/désactiver le mode plein écran
    private JToggleButton cannon; // Bouton pour activer/désactiver le mode plein écran
    private ButtonGroup grouptype = new ButtonGroup();

    /**
     * Constructeur de la classe StarterMenu. Initialise et configure
     * l'interface graphique du menu.
     */
    public StarterMenu() {
        super("Menu du Jeu");

        // Récupération de l'appareil graphique par défaut
        GraphicsDevice device = GraphicsEnvironment
                .getLocalGraphicsEnvironment()
                .getDefaultScreenDevice();

        // Création des panneaux principaux
        JPanel menu = new JPanel(new BorderLayout());            // Panneau principal
        JPanel hauteurlargeurmenu = new JPanel(new FlowLayout()); // Panneau pour les dimensions
        JPanel playquitmenu = new JPanel(new FlowLayout());      // Panneau pour les boutons jouer/quitter
        JPanel gametype = new JPanel(new BorderLayout());      // Panneau pour les boutons jouer/quitter

        // Configuration du bouton Jouer
        play = new JButton("Jouer");
        play.addActionListener(e -> {
            // Création d'une nouvelle instance du jeu avec les paramètres choisis
            JeuDeLaVieGUI jeu = new JeuDeLaVieGUI(this.gethauteur(), this.getlargeur(), this.getrefreshrate(), this.gettype());

            // Activation du mode plein écran si sélectionné
            if (fullscreen.isSelected()) {
                jeu.setExtendedState(JFrame.MAXIMIZED_BOTH);
            }

            // Fermeture du menu
            dispose();
        });

        // Configuration du bouton Plein écran
        fullscreen = new JToggleButton("Plein ecran");
        alea = new JToggleButton("Alea");
        cannon = new JToggleButton("Cannon");
        planneur = new JToggleButton("Planneur");
        grouptype.add(alea);
        grouptype.add(planneur);
        grouptype.add(cannon);

        // Configuration du bouton Quitter
        quit = new JButton("Quitter");
        quit.addActionListener(e -> dispose()); // Ferme la fenêtre lorsqu'on clique

        // Configuration du champ Hauteur
        hauteur = new JTextField("Hauteur", 10);
        hauteur.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent e) {
                // Efface le texte par défaut au premier clic
                hauteur.setText("");
            }
        });

        // Configuration du champ Largeur
        largeur = new JTextField("Largeur", 10);
        largeur.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent e) {
                // Efface le texte par défaut au premier clic
                largeur.setText("");
            }
        });

        // Configuration du slider pour la vitesse de rafraîchissement
        refreshrate = new JSlider(50, 950, 200); // Min: 50, Max: 950, Valeur initiale: 200
        refreshrate.setMajorTickSpacing(200);     // Grandes graduations tous les 200
        refreshrate.setMinorTickSpacing(100);     // Petites graduations tous les 100
        refreshrate.setPaintTicks(true);          // Affiche les graduations
        refreshrate.setPaintLabels(true);         // Affiche les valeurs

        // Ajout des composants aux panneaux
        hauteurlargeurmenu.add(hauteur);
        hauteurlargeurmenu.add(largeur);
        hauteurlargeurmenu.add(fullscreen);

        gametype.add(alea, BorderLayout.NORTH);
        gametype.add(cannon, BorderLayout.CENTER);
        gametype.add(planneur, BorderLayout.SOUTH);

        playquitmenu.add(quit);
        playquitmenu.add(play);

        // Organisation des panneaux dans le panneau principal
        menu.add(playquitmenu, BorderLayout.NORTH);
        menu.add(refreshrate, BorderLayout.CENTER);
        menu.add(gametype, BorderLayout.EAST);
        menu.add(hauteurlargeurmenu, BorderLayout.SOUTH);

        // Configuration de la fenêtre
        setContentPane(menu);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE); // Ferme l'application quand on quitte
        pack(); // Ajuste la taille de la fenêtre
        setLocationRelativeTo(null); // Centre la fenêtre
        setVisible(true); // Rend la fenêtre visible
    }

    /**
     * Récupère la hauteur de la grille saisie par l'utilisateur.
     *
     * @return La hauteur de la grille (50 par défaut si saisie invalide)
     */
    public int gethauteur() {
        // En mode plein écran, calcule la hauteur en fonction de la taille de l'écran
        if (fullscreen.isSelected()) {
            Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
            return (int) ((int) screenSize.getHeight()) / 10;
        }

        // Tentative de conversion de la saisie en entier
        int return_value;
        try {
            return_value = Integer.parseInt(this.hauteur.getText());
            return return_value;
        } catch (NumberFormatException e) {
            // Message d'erreur si la saisie n'est pas un nombre
            JOptionPane.showMessageDialog(new JFrame(),
                    "Hauteur doit etre un entier, valeur 30 prise par defaut");
        }
        return 30; // Valeur par défaut
    }

    /**
     * Récupère la largeur de la grille saisie par l'utilisateur.
     *
     * @return La largeur de la grille (50 par défaut si saisie invalide)
     */
    public int getlargeur() {
        // En mode plein écran, calcule la largeur en fonction de la taille de l'écran
        if (fullscreen.isSelected()) {
            Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
            return (int) ((int) screenSize.getWidth()) / 10;
        }

        // Tentative de conversion de la saisie en entier
        int retval;
        try {
            retval = Integer.parseInt(this.largeur.getText());
            return retval;
        } catch (NumberFormatException e) {
            // Message d'erreur si la saisie n'est pas un nombre
            JOptionPane.showMessageDialog(new JFrame(),
                    "Largeur doit etre un entier, valeur 60 prise par defaut");
        }
        return 60; // Valeur par défaut
    }

    /**
     * Récupère la vitesse de rafraîchissement choisie via le slider.
     *
     * @return La valeur actuelle du slider
     */
    public int getrefreshrate() {
        return refreshrate.getValue();
    }

    public Types gettype() {
        if (alea.isSelected()) {
            return Types.ALEA;
        } else if (alea.isSelected()) {
            return Types.ALEA;
        } else if (planneur.isSelected()) {
            return Types.PLANNEUR;
        } else if (cannon.isSelected()) {
            return Types.CANNON;
        }
        return Types.PLANNEUR;
    }
}
