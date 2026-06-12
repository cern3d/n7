package n7.facade;

import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.*;

@Entity
public class Personne {

    @Id
    @GeneratedValue ( strategy = GenerationType . IDENTITY )
    private int id;

    private String nom;
    private String prenom;
    
    @OneToMany(mappedBy = "personne", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Adresse> adresses = new ArrayList<>();

    public static int idCompteur = 0;

    public Personne() {
    }

    public Personne(String nom, String prenom) {
        this.nom = nom;
        this.prenom = prenom;
    }

    public int getId(){
        return this.id;
    }

    public void setId(int id){
        this.id = id;
    }


    public String getNom(){
        return this.nom;
    }

    public String getPrenom(){
        return this.prenom;
    }

    public void setNom(String nom){
        this.nom = nom;
    }

    public void setPrenom(String pr){
    this.prenom = pr;
    }

    public List<Adresse> getAdresses(){
        return this.adresses;
    }


    public void ajouterAdresse(Adresse newAdresse) {
        adresses.add(newAdresse);
        newAdresse.setPersonne(this); // maintain both sides
    }
    
}
