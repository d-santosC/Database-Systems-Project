<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
    <title>Página Inicial - Empresa Wanderlust</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
            color: #333;
        }
        header {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            text-align: center;
        }
        nav {
            margin: 20px;
            text-align: center;
        }
        nav a {
            text-decoration: none;
            color: #007bff;
            margin: 0 15px;
            font-weight: bold;
        }
        nav a:hover {
            text-decoration: underline;
        }
        footer {
            background-color: #007bff;
            color: white;
            text-align: center;
            padding: 10px 0;
            position: fixed;
            width: 100%;
            bottom: 0;
        }
    </style>
</head>
<body>
    <header>
        <h1>Bem-vindo</h1>
    </header>
    <nav>
        <p>Escolha uma opção para começar:</p>
        <a href="administrador/admin.jsp">Administrador</a>
<!--         <a href="client.jsp">Cliente</a> -->
<!--         <a href="condutor.jsp">Condutor</a> -->
<!--         <a href="funcionario.jsp">Funcionário</a> -->
<!--         <a href="gestor.jsp">Gestor</a> -->
    </nav>
</body>
</html>