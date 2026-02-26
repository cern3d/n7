package pack;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/Serv")
public class Serv extends HttpServlet {

    final String path = "http://localhost:8080/facade";
Facade facade;
public Serv () {
ResteasyClient client = new ResteasyClientBuilder ().build();
ResteasyWebTarget target = client.target(UriBuilder.fromPath(path));
facade = target.proxy(Facade.class);
}
}