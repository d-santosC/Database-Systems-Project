<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, sql.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Adicionar Veiculo</title>
</head>
<body>
    <h1>Processando Novo Veiculo</h1>
    <%
        // Dados recebidos do formulário
        String matricula = request.getParameter("matricula");
        String tipoMotor = request.getParameter("tipoMotor");
        String capacidadeCarga = request.getParameter("capacidadeCarga");
        String potencia = request.getParameter("potencia");
        String quantidadeLugares = request.getParameter("quantidadeLugares");
        String quantidadePortas = request.getParameter("quantidadePortas");
        String idTipo = request.getParameter("idTipoVeiculo");
        String modelo = request.getParameter("modelo");
        String tipo = request.getParameter("tipo");
        String marca = request.getParameter("marca");
        

        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false); // Inicia transação

            // Insere na tabela tipoveiculo
            String sqlTipoveiculo = "INSERT INTO tipoveiculo (IDTipo, Modelo, Tipo, Marca) VALUES (?, ?, ?, ?)";
            try (PreparedStatement pstmtTipoveiculo = conn.prepareStatement(sqlTipoveiculo)) {
                pstmtTipoveiculo.setString(1, idTipo);
                pstmtTipoveiculo.setString(2, modelo);
                pstmtTipoveiculo.setString(3, tipo);
                pstmtTipoveiculo.setString(4, marca);
                pstmtTipoveiculo.executeUpdate();
            }

            // Insere na tabela veiculo
            String sqlVeiculo = "INSERT INTO veiculo (Matricula, TipoMotor, CapacidadeCarga, Potencia, QuantidadeLugares, QuantidadePortas, IDTipoVeiculo) VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement pstmtVeiculo = conn.prepareStatement(sqlVeiculo)) {
                pstmtVeiculo.setString(1, matricula);
                pstmtVeiculo.setString(2, tipoMotor);
                pstmtVeiculo.setString(3, capacidadeCarga);
                pstmtVeiculo.setString(4, potencia);
                pstmtVeiculo.setString(5, quantidadeLugares);
                pstmtVeiculo.setString(6, quantidadePortas);
                pstmtVeiculo.setString(7, idTipo);
                pstmtVeiculo.executeUpdate();
            }

            conn.commit(); // Confirma transação
            out.println("<p>Veículo e tipo de veículo adicionados com sucesso!</p>");
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Reverte transação em caso de erro
                } catch (SQLException rollbackEx) {
                    out.println("<p>Erro ao reverter transação: " + rollbackEx.getMessage() + "</p>");
                }
            }
            out.println("<p>Erro ao adicionar veículo: " + e.getMessage() + "</p>");
        } finally {
            if (conn != null) {
                try {
                    conn.close(); // Fecha conexão
                } catch (SQLException closeEx) {
                    out.println("<p>Erro ao fechar conexão: " + closeEx.getMessage() + "</p>");
                }
            }
        }
    %>
    <a href="adminVeiculos.jsp">Voltar</a>
</body>
</html>
