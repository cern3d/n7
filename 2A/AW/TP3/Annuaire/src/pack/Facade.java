package pack;
import java.util.Collection;

import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;

@Path("/")
public interface Facade {

    @POST
    @Path("/addpersonne")
    public void ajoutPersonne(@QueryParam("nom") String nom, @QueryParam("prenom") String prenom);

    @POST
    @Path("/addadresse")
    public void ajoutAdresse(@QueryParam("rue") String rue, @QueryParam("ville") String ville);



    @GET
    @Path("/listerpersonnes")
    @Produces({"application/json"})
    public Collection<Personne> listePersonnes();


    @GET
    @Path("/listeradresses")
    @Produces({"application/json"})
    public Collection<Adresse> listeAdresses();


    @POST
    @Path("/associer")
    public void associer( @QueryParam("personneId") int personneId, @QueryParam("adresseId") int adresseId);
}