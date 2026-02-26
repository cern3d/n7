package pack;

public class Adresse {

    private int id;
    private String rue;
    private String ville;

    public String getRue() {
        return rue;
    }
    public String getVille() {
        return ville;
    }
    public Adresse(int id ,String rue, String ville) {
        this.rue = rue;
        this.ville = ville;
        this.id = id;
    }
    public int getId() {
        return id;
    }

}