package pack;

import java.io.IOException;

import javax.ws.rs.core.UriBuilder;

import org.jboss.resteasy.client.jaxrs.ResteasyClient;
import org.jboss.resteasy.client.jaxrs.ResteasyClientBuilder;
import org.jboss.resteasy.client.jaxrs.ResteasyWebTarget;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/Serv")
public class Serv extends HttpServlet {
 
    // private Facade facade = new Facade();

    final String path = "http://localhost:8080/facade";
    Facade facade;

    public Serv() {
        ResteasyClient client = new ResteasyClientBuilder().build();
        ResteasyWebTarget target = client.target(UriBuilder.fromPath(path));
        facade = target.proxy(Facade.class);
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
        
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String op = request.getParameter("op");

        switch (op) {
            case "ajoutpersonne":
                facade.ajoutPersonne(request.getParameter("nom"), request.getParameter("prenom"));
                request.getRequestDispatcher("index.html").forward(request, response);
                break;

            case "ajoutadresse":
                facade.ajoutAdresse(request.getParameter("rue"), request.getParameter("ville"));
                request.getRequestDispatcher("index.html").forward(request, response);
                break;

            case "associer":
                request.setAttribute("personnes", facade.listePersonnes());
                request.setAttribute("adresses", facade.listeAdresses());
                request.getRequestDispatcher("associer.jsp").forward(request, response);
                break;



            case "association":
                int personneId = (int) Integer.parseInt(request.getParameter("personneID"));
                int addressId = (int) Integer.parseInt(request.getParameter("adresseID"));
                facade.associer(personneId, addressId);
                request.getRequestDispatcher("index.html").forward(request, response);
                break;

            case "lister":
                request.setAttribute("personnes", facade.listePersonnes());
                request.getRequestDispatcher("lister.jsp").forward(request, response);
                break;
            
            default:
                request.getRequestDispatcher("index.html").forward(request, response);
                break;
        }
    }
}