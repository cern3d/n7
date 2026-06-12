package n7.facade;

import jakarta.persistence.*;

@Entity
public class Adresse {

    @Id
    @GeneratedValue ( strategy = GenerationType . IDENTITY )
    private int id;

    private String rue;
    private String ville;

    @ManyToOne
    @JoinColumn(name = "personne_id") // foreign key column
    private Personne personne;

    public Adresse(String rue, String ville) {
        this.rue = rue;
        this.ville = ville;
    }


    public int getId(){
        return this.id;
    }

    public Adresse() {
    }


    public void setId(int id){
        this.id = id;
    }


    public String getRue(){
        return this.rue;
    }

    public String getVille(){
        return this.ville;
    }

    public void setRue(String r){
        this.rue = r;
    }

    public void setVille(String v){
        this.ville = v;
    }


    public Personne getPersonne() {
        return personne;
    }


    public void setPersonne(Personne personne) {
        this.personne = personne;
    }
    
}
