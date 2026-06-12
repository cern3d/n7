package pack;

public class Adresse {
    private int id;
    private String rue;
    private String ville;
    public static int idCompteur;

    
    public Adresse() {

    }

    public Adresse(String rue, String ville) {
        this.id = idCompteur;
        idCompteur++;
        this.rue = rue;
        this.ville = ville;
    }


    public int getId(){
        return this.id;
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
    
}
