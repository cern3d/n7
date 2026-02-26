<%@ page import="java.util.*, pack.*" %>

<h1>Création d'une association</h1>

<form action="Serv" method="post">
<input type="hidden" name="action" value="associer">

Choisir la personne:<br>
<%
for (Personne p : (Collection<Personne>)request.getAttribute("personnes")) {
%>
<input type="radio" name="personne" value="<%=p.getId()%>">
<%=p.getNom()%> <%=p.getPrenom()%><br>
<% } %>

<br>Choisir l'adresse:<br>
<%
for (Adresse a : (Collection<Adresse>)request.getAttribute("adresses")) {
%>
<input type="radio" name="adresse" value="<%=a.getId()%>">
<%=a.getRue()%> <%=a.getVille()%><br>
<% } %>

<br>
<input type="submit" value="OK">
</form>
