<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, sql.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Editar Veículo</title>
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
    <h1>Editar Veículo</h1>
    <%
        String matricula = request.getParameter("matricula");
        String tipoMotor = "";
        String capacidadeCarga = "";
        String potencia = "";
        String quantidadeLugares = "";
        String quantidadePortas = "";
        String modelo = "";
        String tipo = "";
        String marca = "";

        // Obter os dados do veículo e do tipo de veículo
        if (matricula != null && !matricula.isEmpty()) {
            try (Connection conn = DatabaseConnection.getConnection()) {
                String veiculoSql = "SELECT v.*, t.Modelo, t.Tipo, t.Marca FROM veiculo v JOIN tipoveiculo t ON v.IDTipoVeiculo = t.IDTipo WHERE v.Matricula = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(veiculoSql)) {
                    pstmt.setString(1, matricula);
                    try (ResultSet rs = pstmt.executeQuery()) {
                        if (rs.next()) {
                            tipoMotor = rs.getString("TipoMotor");
                            capacidadeCarga = rs.getString("CapacidadeCarga");
                            potencia = rs.getString("Potencia");
                            quantidadeLugares = rs.getString("QuantidadeLugares");
                            quantidadePortas = rs.getString("QuantidadePortas");
                            modelo = rs.getString("Modelo");
                            tipo = rs.getString("Tipo");
                            marca = rs.getString("Marca");
                        } else {
                            out.println("<p>Veículo não encontrado.</p>");
                        }
                    }
                }
            } catch (SQLException e) {
                out.println("<p>Erro ao conectar à base de dados: " + e.getMessage() + "</p>");
            }
        }

        // Atualizar os dados do veículo e do tipo de veículo
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            matricula = request.getParameter("matricula");
            tipoMotor = request.getParameter("tipoMotor");
            capacidadeCarga = request.getParameter("capacidadeCarga");
            potencia = request.getParameter("potencia");
            quantidadeLugares = request.getParameter("quantidadeLugares");
            quantidadePortas = request.getParameter("quantidadePortas");
            modelo = request.getParameter("modelo");
            tipo = request.getParameter("tipo");
            marca = request.getParameter("marca");

            try (Connection conn = DatabaseConnection.getConnection()) {
                conn.setAutoCommit(false); // Iniciar transação

                // Atualizar a tabela veiculo
                String updateVeiculoSql = "UPDATE veiculo SET TipoMotor = ?, CapacidadeCarga = ?, Potencia = ?, QuantidadeLugares = ?, QuantidadePortas = ? WHERE Matricula = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(updateVeiculoSql)) {
                    pstmt.setString(1, tipoMotor);
                    pstmt.setString(2, capacidadeCarga);
                    pstmt.setString(3, potencia);
                    pstmt.setString(4, quantidadeLugares);
                    pstmt.setString(5, quantidadePortas);
                    pstmt.setString(6, matricula);
                    pstmt.executeUpdate();
                }

                // Atualizar a tabela tipoveiculo
                String updateTipoVeiculoSql = "UPDATE tipoveiculo SET Modelo = ?, Tipo = ?, Marca = ? WHERE IDTipo = (SELECT IDTipoVeiculo FROM veiculo WHERE Matricula = ?)";
                try (PreparedStatement pstmt = conn.prepareStatement(updateTipoVeiculoSql)) {
                    pstmt.setString(1, modelo);
                    pstmt.setString(2, tipo);
                    pstmt.setString(3, marca);
                    pstmt.setString(4, matricula);
                    pstmt.executeUpdate();
                }

                conn.commit(); // Confirmar transação
                out.println("<p>Veículo atualizado com sucesso!</p>");
            } catch (SQLException e) {
                out.println("<p>Erro ao atualizar a base de dados: " + e.getMessage() + "</p>");
            }
        }
    %>

    <!-- Formulário de edição -->
    <div class="form-container">
        <form action="editarVeiculo.jsp" method="post">
            <input type="hidden" name="matricula" value="<%= matricula %>">

            <label for="tipoMotor">Tipo de Motor:</label>
            <input type="text" id="tipoMotor" name="tipoMotor" value="<%= tipoMotor %>" required><br><br>

            <label for="capacidadeCarga">Capacidade de Carga:</label>
            <input type="text" id="capacidadeCarga" name="capacidadeCarga" value="<%= capacidadeCarga %>" required><br><br>

            <label for="potencia">Potência:</label>
            <input type="text" id="potencia" name="potencia" value="<%= potencia %>" required><br><br>

            <label for="quantidadeLugares">Quantidade de Lugares:</label>
            <input type="text" id="quantidadeLugares" name="quantidadeLugares" value="<%= quantidadeLugares %>" required><br><br>

            <label for="quantidadePortas">Quantidade de Portas:</label>
            <input type="text" id="quantidadePortas" name="quantidadePortas" value="<%= quantidadePortas %>" required><br><br>

            <label for="modelo">Modelo:</label>
            <input type="text" id="modelo" name="modelo" value="<%= modelo %>" required><br><br>

            <label for="tipo">Tipo:</label>
            <input type="text" id="tipo" name="tipo" value="<%= tipo %>" required><br><br>

            <label for="marca">Marca:</label>
            <input type="text" id="marca" name="marca" value="<%= marca %>" required><br><br>

            <button type="submit">Atualizar Veículo</button>
        </form>
    </div>

    <a href="adminVeiculos.jsp">Voltar</a>
</body>
</html>
