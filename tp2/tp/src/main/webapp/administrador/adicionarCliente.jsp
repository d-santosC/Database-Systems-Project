<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, sql.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Adicionar Cliente</title>
</head>
<body>
    <h1>Processando Novo Cliente</h1>
    <%
        String nif = request.getParameter("nif");
        String nome = request.getParameter("nome");
        String contacto = request.getParameter("contacto");
        String moeda = request.getParameter("moeda");
        String tipo = request.getParameter("tipo");
        String rua = request.getParameter("rua");
        String porta = request.getParameter("porta");
        String andar = request.getParameter("andar");
        String codigoPostal = request.getParameter("codigoPostal");

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Verificar se a morada já existe
            String checkMoradaSQL = "SELECT COUNT(*) FROM morada WHERE Rua = ? AND Porta = ? AND Andar = ? AND CodigoPostal = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkMoradaSQL)) {
                checkStmt.setString(1, rua);
                checkStmt.setString(2, porta);
                checkStmt.setString(3, andar);
                checkStmt.setString(4, codigoPostal);

                ResultSet rs = checkStmt.executeQuery();
                rs.next();
                if (rs.getInt(1) == 0) {
                    // Inserir a morada, pois não existe
                    String insertMoradaSQL = "INSERT INTO morada (Rua, Porta, Andar, CodigoPostal) VALUES (?, ?, ?, ?)";
                    try (PreparedStatement insertStmt = conn.prepareStatement(insertMoradaSQL)) {
                        insertStmt.setString(1, rua);
                        insertStmt.setString(2, porta);
                        insertStmt.setString(3, andar);
                        insertStmt.setString(4, codigoPostal);
                        insertStmt.executeUpdate();
                    }
                }
            }

            // Inserir o cliente
            String insertClienteSQL = "INSERT INTO cliente (NIF, Nome, Contacto, Moeda, Tipo, Rua, Porta, Andar, CodigoPostal) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(insertClienteSQL)) {
                pstmt.setString(1, nif);
                pstmt.setString(2, nome);
                pstmt.setString(3, contacto);
                pstmt.setString(4, moeda);
                pstmt.setString(5, tipo);
                pstmt.setString(6, rua);
                pstmt.setString(7, porta);
                pstmt.setString(8, andar);
                pstmt.setString(9, codigoPostal);

                int rows = pstmt.executeUpdate();

                if (rows > 0) {
                    out.println("<p>Cliente adicionado com sucesso!</p>");
                } else {
                    out.println("<p>Erro ao adicionar cliente.</p>");
                }
            }
        } catch (SQLException e) {
            out.println("<p>Erro: " + e.getMessage() + "</p>");
        }
    %>
    <a href="adminClientes.jsp">Voltar</a>
</body>
</html>
