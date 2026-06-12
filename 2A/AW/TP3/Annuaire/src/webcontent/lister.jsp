<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.Collection" %>
<%@ page import="pack.Personne" %>

<html>
<head>
    <title>Liste des Personnes</title>
</head>
<body>

<h2>Liste des Personnes</h2>

<table border="1">
    <tr>
        <th>ID</th>
        <th>Nom</th>
        <th>Prénom</th>
    </tr>

    <%
        Collection<Personne> personnes = (Collection<Personne>) request.getAttribute("personnes");
        if(personnes != null){
            for(Personne p : personnes){
    %>
        <tr>
            <td><%= p.getId() %></td>
            <td><%= p.getNom() %></td>
            <td><%= p.getPrenom() %></td>
        </tr>
    <%
            }
        }
    %>

</table>

<br>
<a href="index.html">Retour</a>

</body>
</html>