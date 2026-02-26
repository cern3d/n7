<%@ page import="java.util.*, pack.*" %>

<h1>Listing</h1>

<%
for (Personne p : (Collection<Personne>)request.getAttribute("personnes")) {
%>

<b><%=p.getNom()%> <%=p.getPrenom()%></b><br>

<%
for (Adresse a : p.getAdds()) {
%>
&nbsp;&nbsp;&nbsp;<%=a.getRue()%> <%=a.getVille()%><br>
<%
}
%>
<br>

<%
}
%>
