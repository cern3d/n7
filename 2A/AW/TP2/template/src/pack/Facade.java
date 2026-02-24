package pack;

import java.sql.*;
import java.util.*;

public class Facade {

    private Connection con;

    public Facade() throws SQLException, ClassNotFoundException {
        String db_url = "jdbc:hsqldb:hsql://localhost/xdb";
        String db_user = "sa";

            Class.forName("org.hsqldb.jdbcDriver");
        

            this.con = DriverManager.getConnection(db_url, db_user, null);
        
    }

    public void ajoutPersonne(String nom, String prenom) {
        String sql = "INSERT INTO PERSONNE (NOM, PRENOM) VALUES (?, ?)";

        try (PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nom);
            ps.setString(2, prenom);

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void ajoutAdresse(String rue, String ville) {
        String sql = "INSERT INTO ADRESSE (RUE, VILLE) VALUES (?, ?)";

        try (PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, rue);
            ps.setString(2, ville);

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Collection<Personne> listePersonnes() throws SQLException {

    List<Personne> personnes = new ArrayList<>();

    String sql = "SELECT * FROM Personne";
    String sql2 = "SELECT * FROM Adresse WHERE personneid = ?";

    try (
        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        PreparedStatement pss = con.prepareStatement(sql2)
    ) {

        while (rs.next()) {

            int id = rs.getInt("id");
            String nom = rs.getString("nom");
            String prenom = rs.getString("prenom");

            Personne p = new Personne(id, nom, prenom);

            pss.setInt(1, id);
            try (ResultSet rss = pss.executeQuery()) {

                while (rss.next()) {
                    int idd = rss.getInt("id");
                    String rue = rss.getString("rue");
                    String ville = rss.getString("ville");

                    Adresse d = new Adresse(idd, rue, ville);
                    p.ajouterAdresse(d);
                }
            }

            personnes.add(p);
        }
    }

    return personnes;
}


    public Collection<Adresse> listeAdresses() throws SQLException{
        List<Adresse> adresses = new ArrayList<>();
        String sql = "SELECT * FROM ADRESSE";

        PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("ID");
                String rue = rs.getString("RUE");
                String ville = rs.getString("VILLE");

                adresses.add(new Adresse(id, rue, ville));
            }

        return adresses;
    }

    public void associer(int personneId, int adresseId) {
        String sql = "UPDATE Adresse SET personneid = ? WHERE id = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, personneId); // set foreign key
            ps.setInt(2, adresseId); // which address

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
