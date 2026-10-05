public class StatistiquesJeuDeLaVie {
    private Grille grille;
    private int generationCourante;
    private int nombreCellulesVivantes;
    private int naissances;
    private int morts;
    private int cellulesVivantesTotales;

    private boolean[][] etatPrecedent;

    public StatistiquesJeuDeLaVie(Grille grille) {
        this.grille = grille;
        this.generationCourante = 0;
        this.nombreCellulesVivantes = 0;
        this.cellulesVivantesTotales = 0;
        this.etatPrecedent = new boolean[grille.getHauteur()][grille.getLargeur()];
        sauvegarderEtatPrecedent();
    }

    public void mettreAJourStatistiques() {
        int vivantes = 0;
        int nouvellesNaissances = 0;
        int nouveauxMorts = 0;

        for (int i = 0; i < grille.getHauteur(); i++) {
            for (int j = 0; j < grille.getLargeur(); j++) {
                Cellule cellule = grille.getCellule(i, j);
                boolean vivant = cellule.estVivant();

                if (vivant) vivantes++;

                // Comparaison avec l'état précédent
                if (vivant && !etatPrecedent[i][j]) nouvellesNaissances++;
                else if (!vivant && etatPrecedent[i][j]) nouveauxMorts++;
            }
        }

        this.nombreCellulesVivantes = vivantes;
        this.naissances = nouvellesNaissances;
        this.morts = nouveauxMorts;
        this.cellulesVivantesTotales += vivantes;
        this.generationCourante++;

        sauvegarderEtatPrecedent();
    }

    private void sauvegarderEtatPrecedent() {
        for (int i = 0; i < grille.getHauteur(); i++) {
            for (int j = 0; j < grille.getLargeur(); j++) {
                etatPrecedent[i][j] = grille.getCellule(i, j).estVivant();
            }
        }
    }

    public int getNaissances() { return naissances; }
    public int getMorts() { return morts; }
    public double getMoyenneVivantes() {
        return generationCourante == 0 ? 0 : (double) cellulesVivantesTotales / generationCourante;
    }

    /**
     * Obtient le nombre de générations
     * @return le nombre de générations
     */
    public int getGenerationCourante() {
        return generationCourante;
    }
    
    /**
     * Obtient le nombre de cellules vivantes
     * @return le nombre de cellules vivantes
     */
    public int getNombreCellulesVivantes() {
        return nombreCellulesVivantes;
    }
}
