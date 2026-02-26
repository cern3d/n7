package war;
import java.util.*;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.GetMapping;

@RestController
public class Facade {

    private Map<Integer, Personne> personnes = new HashMap<>();
    private Map<Integer, Adresse> adresses = new HashMap<>();

    private int personneIdCounter = 1;
    private int adresseIdCounter = 1;

    @PostMapping("/ajouterPersonne")
    public void ajoutPersonne(@RequestParam("nom") String nom,@RequestParam("prenom") String prenom) {
        Personne p = new Personne(personneIdCounter++, nom, prenom);
        personnes.put(p.getId(), p);
    }

    @PostMapping("/ajouterAdresse")
    public void ajoutAdresse(@RequestParam("rue") String rue,@RequestParam("ville") String ville) {
        Adresse a = new Adresse(adresseIdCounter++, rue, ville);
        adresses.put(a.getId(), a);
    }

    @GetMapping("/test")
public String test() {
    return "spring marche";
}

    @GetMapping("/listerP")
    public Collection<Personne> listePersonnes() {
        return personnes.values();
    }

    @GetMapping("/listerA")
    public Collection<Adresse> listeAdresses() {
        return adresses.values();
    }

    @PostMapping("/associer")
    public void associer(int personneId, int adresseId) {
        Personne p = personnes.get(personneId);
        Adresse a = adresses.get(adresseId);

        if (p != null && a != null) {
            p.ajouterAdresse(a);
        }
    }
}