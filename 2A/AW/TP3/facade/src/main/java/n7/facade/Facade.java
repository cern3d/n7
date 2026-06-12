package n7.facade;

import java.util.Collection;
import java.util.Optional;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;




@RestController
public class Facade {

    AdresseRepository ar;
    PersonneRepository pr;

    public Facade() {
    }


    @PostMapping("/addpersonne")
    public void ajoutPersonne(@RequestParam("nom") String nom, @RequestParam("prenom") String prenom) {
        Personne newMember = new Personne(nom, prenom);
        pr.save(newMember);
    }


    @PostMapping("/addadresse")
    public void ajoutAdresse(@RequestParam("rue") String rue, @RequestParam("ville") String ville) {
        Adresse newAdresse = new Adresse(rue, ville);
        ar.save(newAdresse);
    }


    @GetMapping("/listerpersonnes")
    public Collection<Personne> listePersonnes(){
        return pr.findAll();
    }

    @GetMapping("/listeradresses")
    public Collection<Adresse> listeAdresses() {
        return ar.findAll();
    }
    


    @PostMapping("/associer")
    public void associer(@RequestParam("personneId") long personneId, @RequestParam("adresseId") long adresseId) {
        Optional<Personne> p = pr.findById(personneId);
        if (!p.isPresent ())
            throw new RuntimeException("Personne introuvable");
        Optional<Adresse> a = ar.findById(adresseId);
        if (!a.isPresent ())
            throw new RuntimeException("Adresse introuvable");
        p.get().ajouterAdresse(a.get());
    }


    
}


