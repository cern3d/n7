package pack;

import java.util.*;
import javax.ws.rs.*;

@Path("/")

public interface Facade {


    @POST
@Path("/ajouterPersonne")
@Consumes("application/json")
    void ajoutPersonne(String nom, String prenom) ;

    @POST
@Path("/ajouterAdresse")
@Consumes("application/json")
    void ajoutAdresse(String rue, String ville) ;

@GET
@Path("/listerP")
@Produces("application/json")
    Collection<Personne> listePersonnes();


@GET
@Path("/listerA")
@Produces("application/json")
    Collection<Adresse> listeAdresses();

    @POST
@Path("/associer")
@Consumes("application/json")
    void associer(int personneId, int adresseId) ;
}
