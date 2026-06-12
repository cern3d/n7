package pack;

import java.sql.ResultSet;
import java.sql.Statement;
import java.util.HashMap;

public class Personne {

    private int id;
    private String nom;
    private String prenom;
    private HashMap<Integer, Adresse> adresses = new HashMap<>();
    public static int idCompteur = 0;


    public Personne() {

    }

    public Personne(String nom, String prenom) {
        this.id = idCompteur;
        idCompteur++;
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

    public HashMap<Integer, Adresse> getAdresses(){
        // HashMap<Integer, Adresse> adresses = new HashMap<>();
        // try {
        //     Statement stmt = Facade.getConnection().createStatement();
        //     ResultSet rs = stmt.executeQuery("SELECT a.* FROM Adresse a JOIN AssociationPerAddr ap ON a.id = ap.adresseId WHERE ap.personneId = " + String.valueOf(this.id) + ";");

        //     while (rs.next()) {
        //         int id = rs.getInt("id");
        //         String rue = rs.getString("rue");
        //         String ville = rs.getString("ville");
        //         adresses.put(id, new Adresse(rue, ville));
        //     }


        // } catch (Exception e) {
        //     e.printStackTrace();
        // }

        // return adresses;

        return this.adresses;
    }


    public void ajouterAdresse(Adresse newAdresse) {
        adresses.put(newAdresse.getId(), newAdresse);
    }
    
}
