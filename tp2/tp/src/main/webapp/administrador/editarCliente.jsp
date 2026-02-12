<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, sql.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Editar Cliente</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f4f4f4;
        }
        h1 {
            color: #333;
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
    <h1>Editar Cliente</h1>
    <%
        // Obter o parâmetro "nif" da requisição
        String nif = request.getParameter("nif");
        String nome = "";
        String contacto = "";
        String moeda = "";
        String tipo = "";
        String rua = "";
        String porta = "";
        String andar = "";
        String codigoPostal = "";

        // Conexão e recuperação dos dados do cliente para edição
        if (nif != null && !nif.isEmpty()) {
            try (Connection conn = DatabaseConnection.getConnection()) {
                String sql = "SELECT * FROM cliente WHERE NIF = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setString(1, nif);
                    try (ResultSet rs = pstmt.executeQuery()) {
                        if (rs.next()) {
                            nome = rs.getString("Nome");
                            contacto = rs.getString("Contacto");
                            moeda = rs.getString("Moeda");
                            tipo = rs.getString("Tipo");
                            rua = rs.getString("Rua");
                            porta = rs.getString("Porta");
                            andar = rs.getString("Andar");
                            codigoPostal = rs.getString("CodigoPostal");
                        } else {
                            out.println("<p>Cliente não encontrado.</p>");
                        }
                    }
                }
            } catch (SQLException e) {
                out.println("<p>Erro ao conectar à base de dados: " + e.getMessage() + "</p>");
            }
        }

        // Atualizar os dados do cliente se o formulário for enviado
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            nome = request.getParameter("nome");
            contacto = request.getParameter("contacto");
            moeda = request.getParameter("moeda");
            tipo = request.getParameter("tipo");
            rua = request.getParameter("rua");
            porta = request.getParameter("porta");
            andar = request.getParameter("andar");
            codigoPostal = request.getParameter("codigoPostal");

            try (Connection conn = DatabaseConnection.getConnection()) {
                String updateSql = "UPDATE cliente SET Nome = ?, Contacto = ?, Moeda = ?, Tipo = ?, Rua = ?, Porta = ?, Andar = ?, CodigoPostal = ? WHERE NIF = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(updateSql)) {
                    pstmt.setString(1, nome);
                    pstmt.setString(2, contacto);
                    pstmt.setString(3, moeda);
                    pstmt.setString(4, tipo);
                    pstmt.setString(5, rua);
                    pstmt.setString(6, porta);
                    pstmt.setString(7, andar);
                    pstmt.setString(8, codigoPostal);
                    pstmt.setString(9, nif);

                    int rowsUpdated = pstmt.executeUpdate();
                    if (rowsUpdated > 0) {
                        out.println("<p>Cliente atualizado com sucesso!</p>");
                    } else {
                        out.println("<p>Erro ao atualizar cliente.</p>");
                    }
                }
            } catch (SQLException e) {
                out.println("<p>Erro ao atualizar a base de dados: " + e.getMessage() + "</p>");
            }
        }
    %>

    <!-- Formulário de edição -->
    <div class="form-container">
        <form action="editarCliente.jsp" method="post">
            <input type="hidden" name="nif" value="<%= nif %>">

            <label for="nome">Nome:</label>
            <input type="text" id="nome" name="nome" value="<%= nome %>" required><br><br>

            <label for="contacto">Contacto:</label>
            <input type="text" id="contacto" name="contacto" value="<%= contacto %>" required><br><br>

            <label for="moeda">Moeda:</label>
            <input type="text" id="moeda" name="moeda" value="<%= moeda %>" required><br><br>

            <label for="tipo">Tipo:</label>
            <input type="text" id="tipo" name="tipo" value="<%= tipo %>" required><br><br>

            <label for="rua">Rua:</label>
            <input type="text" id="rua" name="rua" value="<%= rua %>" required><br><br>

            <label for="porta">Porta:</label>
            <input type="text" id="porta" name="porta" value="<%= porta %>" required><br><br>

            <label for="andar">Andar:</label>
            <input type="text" id="andar" name="andar" value="<%= andar %>"><br><br>

            <label for="codigoPostal">Código Postal:</label>
            <input type="text" id="codigoPostal" name="codigoPostal" value="<%= codigoPostal %>" required><br><br>

            <button type="submit">Atualizar Cliente</button>
        </form>
    </div>

    <a href="adminClientes.jsp">Voltar</a>
</body>
</html>
