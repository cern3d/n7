<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.Collection" %>
<%@ page import="pack.Personne" %>
<%@ page import="pack.Adresse" %>

<html>
<head>
    <title>Associer</title>
</head>
<body>

<h2>Associer une Personne à une Adresse</h2>

<form action="Serv" method="post">
    <input type="hidden" name="op" value="association">

    <label>Personne :</label>
    <select name="personneID">
        <%
            Collection<Personne> personnes = (Collection<Personne>) request.getAttribute("personnes");
            if(personnes != null){
                for(Personne p : personnes){
        %>
            <option value="<%= p.getId() %>">
                <%= p.getNom() %> <%= p.getPrenom() %>
            </option>
        <%
                }
            }
        %>
    </select>

    <br><br>

    <label>Adresse :</label>
    <select name="adresseID">
        <%
            Collection<Adresse> adresses = (Collection<Adresse>) request.getAttribute("adresses");
            if(adresses != null){
                for(Adresse a : adresses){
        %>
            <option value="<%= a.getId() %>">
                <%= a.getRue() %> - <%= a.getVille() %>
            </option>
        <%
                }
            }
        %>
    </select>

    <br><br>

    <input type="submit" value="Valider Association">
</form>

<br>
<a href="index.html">Retour</a>

</body>
</html>