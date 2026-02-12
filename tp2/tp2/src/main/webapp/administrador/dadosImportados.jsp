<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Exportação/Importação</title>
</head>
<body>
	<% 
    String status = request.getParameter("status");
    if (status != null) {
        if ("success".equals(status)) {
	%>
	    	<p>Importação realizada com sucesso!</p>
	<%  }else if ("error".equals(status)) { %>
	        <p>Erro na importação dos dados. Tente novamente.</p>
	<%  }
	}
	%>
</body>
</html>