<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, sql.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Administração de Clientes</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f4f4f4;
        }
        h1 {
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #007bff;
            color: white;
        }
        .form-container {
            margin-top: 20px;
            background: #fff;
            padding: 15px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        button {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <h1>Gestão de Clientes</h1>

    <!-- Área de Visualização dos Clientes -->
    <h2>Lista de Clientes</h2>
    <table>
        <thead>
            <tr>
                <th>NIF</th>
                <th>Nome</th>
                <th>Contacto</th>
                <th>Moeda</th>
                <th>Tipo</th>
                <th>Rua</th>
                <th>Porta</th>
                <th>Andar</th>
                <th>Código Postal</th>
                <th>Ações</th>
            </tr>
        </thead>
        <tbody>
            <%
                try (Connection conn = DatabaseConnection.getConnection()) {
                    String sql = "SELECT * FROM cliente";
                    try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
                        while (rs.next()) {
                            %>
                            <tr>
                                <td><%= rs.getString("NIF") %></td>
                                <td><%= rs.getString("Nome") %></td>
                                <td><%= rs.getString("Contacto") %></td>
                                <td><%= rs.getString("Moeda") %></td>
                                <td><%= rs.getString("Tipo") %></td>
                                <td><%= rs.getString("Rua") %></td>
                                <td><%= rs.getString("Porta") %></td>
                                <td><%= rs.getString("Andar") %></td>
                                <td><%= rs.getString("CodigoPostal") %></td>
                                <td>
                                    <form action="editarCliente.jsp" method="get">
                                        <input type="hidden" name="nif" value="<%= rs.getString("NIF") %>">
                                        <button type="submit">Editar</button>
                                    </form>
                                </td>
                            </tr>
                            <%
                        }
                    }
                } catch (SQLException e) {
                    out.println("<tr><td colspan='10'>Erro ao conectar à base de dados: " + e.getMessage() + "</td></tr>");
                }
            %>
        </tbody>
    </table>

    <!-- Área de Adicionar Cliente -->
    <h2>Adicionar Novo Cliente</h2>
    <div class="form-container">
        <form action="adicionarCliente.jsp" method="post">
            <label for="nif">NIF:</label>
            <input type="text" id="nif" name="nif" required><br><br>

            <label for="nome">Nome:</label>
            <input type="text" id="nome" name="nome" required><br><br>

            <label for="contacto">Contacto:</label>
            <input type="text" id="contacto" name="contacto" required><br><br>

            <label for="moeda">Moeda:</label>
            <input type="text" id="moeda" name="moeda" required><br><br>

            <label for="tipo">Tipo:</label>
            <input type="text" id="tipo" name="tipo" required><br><br>

            <label for="rua">Rua:</label>
            <input type="text" id="rua" name="rua" required><br><br>

            <label for="porta">Porta:</label>
            <input type="text" id="porta" name="porta" required><br><br>

            <label for="andar">Andar:</label>
            <input type="text" id="andar" name="andar"><br><br>

            <label for="codigoPostal">Código Postal:</label>
            <input type="text" id="codigoPostal" name="codigoPostal" required><br><br>

            <button type="submit">Adicionar Cliente</button>
        </form>
    </div>

    <a href="admin.jsp">Voltar</a>
</body>
</html>
