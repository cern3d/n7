<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Calculatrice</title>
</head>
<body>

<form method="post" action="Serv">
    <p>
        Number 1:
        <input type="text" name="num1"
               value="${param.num1}">
    </p>

    <p>
        Number 2:
        <input type="text" name="num2"
               value="${param.num2}">
    </p>

    <input type="submit" value="Calculer">
</form>

<%-- Display result if it exists --%>
<c:if test="${not empty result}">
    <p><strong>Résultat :</strong> ${result}</p>
</c:if>

</body>
</html>
