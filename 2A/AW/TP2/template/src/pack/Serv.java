package pack;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/Serv")
public class Serv extends HttpServlet {

    private static Facade facade = new Facade();
 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("index.html");
            return;
        }

        switch (action) {

            case "lister":
                request.setAttribute("personnes", facade.listePersonnes());
                                request.setAttribute("personnes", facade.listePersonnes());

                request.getRequestDispatcher("lister.jsp")
                .forward(request, response);
                break;

            case "associerForm":
                request.setAttribute("personnes", facade.listePersonnes());
                request.setAttribute("adresses", facade.listeAdresses());
                request.getRequestDispatcher("associer.jsp").
                forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
         String action = request.getParameter("action");

        switch (action) {

            case "ajoutPersonne":
                facade.ajoutPersonne(
                        request.getParameter("nom"),
                        request.getParameter("prenom"));
                break;

            case "ajoutAdresse":
                facade.ajoutAdresse(
                        request.getParameter("rue"),
                        request.getParameter("ville"));
                break;

            case "associer":
                int pid = Integer.parseInt(request.getParameter("personne"));
                int aid = Integer.parseInt(request.getParameter("adresse"));
                facade.associer(pid, aid);
                break;
        }

            request.getRequestDispatcher("/index.html")
               .forward(request, response);
    }
}