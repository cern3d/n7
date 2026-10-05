import java.util.Random;
import java.util.Scanner;

/**
 * Classe principale du projet
 */
public class JeuDeLaVie {
    /**
     * méthode principale
     */
    public static void main(String[] args) throws InterruptedException {
        // Par défaut, on lance la version graphique
        boolean modeConsole = false;
        boolean step = false;

        // Si l'argument -console est présent, on lance la version console
        for (String arg : args) {
            if (arg.equals("-console")) {
                modeConsole = true;
            }
            if (arg.equals("-step")) {
                step = true;
            }
        }

        if (modeConsole) {
            // Version console
            Grille g = Configuration.gPlanneur(15, 30);
            // Grille g = Configuration.gAlea(15, 30,0.5);
            // Grille g = Configuration.gCannon();
            System.out.println(g);
            Thread.sleep(2000);
            lancerModeConsole(g,step);
        } else {
            // Version graphique
            JeuDeLaVieGUI.main(args);
        }
    }

    /**
     * Lance le jeu en mode console
     */
    private static void lancerModeConsole(Grille g, boolean step) throws InterruptedException {
        while (true) {
            // Effacer l'écran
            System.out.print("\033[H\033[2J");
            System.out.flush();

            // Mettre à jour la grille
            g.jeu();
            g.actualise();

            // Afficher la grille
            System.out.println(g);

            // Attendre
            if (step){
                Scanner sc = new Scanner(System.in);
                System.out.println("Appuyer sur entrer pour continuer ou ecrire continuer pour commencer le jeux");
                String input = sc.nextLine();
                if (input.equals("continuer")){
                    step = false;
                }
            }
            else {
                Thread.sleep(200);
            }
        }
    }
}