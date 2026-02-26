package war;
import java.util.ArrayList;
import java.util.List;

public class Personne {

    private int id;
    private String nom;
    private List<Adresse> adds;
    public List<Adresse> getAdds() {
        return adds;
    }

    public int getId() {
        return id;
    }

    public String getNom() {
        return nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public Personne(int id, String nom, String prenom) {
        this.nom = nom;
        this.prenom = prenom;
        this.id = id;
        this.adds = new ArrayList<>();
    }

    private String prenom;

    public void ajouterAdresse(Adresse adresse) {
        this.adds.add(adresse);
    }public Personne() {
    }
    
}