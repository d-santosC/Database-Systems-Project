<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, sql.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Administração de Veiculos</title>
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
        button {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        .form-container {
            margin-top: 20px;
            background: #fff;
            padding: 15px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <h1>Gestão de Veiculos</h1>

    <!-- Área de Visualização dos Veiculos -->
    <h2>Lista de Veiculos</h2>
    <table>
    <thead>
        <tr>
            <th>IDTipoVeiculo</th>
            <th>Matricula</th>
            <th>TipoMotor</th>
            <th>CapacidadeCarga</th>
            <th>Potencia</th>
            <th>QuantidadeLugares</th>
            <th>QuantidadePortas</th>
            <th>Modelo</th>
            <th>Tipo</th>
            <th>Marca</th>
            <th>Ações</th>
        </tr>
    </thead>
    <tbody>
        <%
            try (Connection conn = DatabaseConnection.getConnection()) {
                String sql = "SELECT " +
                             "veiculo.Matricula, veiculo.TipoMotor, veiculo.CapacidadeCarga, veiculo.Potencia, " +
                             "veiculo.QuantidadeLugares, veiculo.QuantidadePortas, veiculo.IDTipoVeiculo, " +
                             "tipoveiculo.Modelo, tipoveiculo.Tipo, tipoveiculo.Marca " +
                             "FROM veiculo " +
                             "LEFT JOIN tipoveiculo ON veiculo.IDTipoVeiculo = tipoveiculo.IDTipo";
                try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
                    while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("IDTipoVeiculo") %></td>
            <td><%= rs.getString("Matricula") %></td>
            <td><%= rs.getString("TipoMotor") %></td>
            <td><%= rs.getString("CapacidadeCarga") %></td>
            <td><%= rs.getString("Potencia") %></td>
            <td><%= rs.getString("QuantidadeLugares") %></td>
            <td><%= rs.getString("QuantidadePortas") %></td>
            <td><%= rs.getString("Modelo") %></td>
            <td><%= rs.getString("Tipo") %></td>
            <td><%= rs.getString("Marca") %></td>
            <td>
                <form action="editarVeiculo.jsp" method="get" style="display:inline;">
                    <input type="hidden" name="matricula" value="<%= rs.getString("Matricula") %>">
                    <button type="submit">Editar</button>
                </form>
            </td>
        </tr>
        <%
                    }
                }
            } catch (SQLException e) {
                out.println("<tr><td colspan='11'>Erro ao conectar à base de dados: " + e.getMessage() + "</td></tr>");
            }
        %>
    </tbody>
    </table>

    <!-- Área de Adicionar Novo Veiculo -->
    <h2>Adicionar Novo Veiculo</h2>
    <div class="form-container">
        <form action="adicionarVeiculo.jsp" method="post">
            <label for="matricula">Matricula:</label>
            <input type="text" id="matricula" name="matricula" required><br><br>

            <label for="tipoMotor">Tipo de Motor:</label>
            <input type="text" id="tipoMotor" name="tipoMotor" required><br><br>

            <label for="capacidadeCarga">Capacidade de Carga:</label>
            <input type="text" id="capacidadeCarga" name="capacidadeCarga" required><br><br>

            <label for="potencia">Potencia:</label>
            <input type="text" id="potencia" name="potencia" required><br><br>

            <label for="quantidadeLugares">Quantidade de Lugares:</label>
            <input type="text" id="quantidadeLugares" name="quantidadeLugares" required><br><br>

            <label for="quantidadePortas">Quantidade de Portas:</label>
            <input type="text" id="quantidadePortas" name="quantidadePortas" required><br><br>

            <label for="idTipoVeiculo">ID Tipo Veiculo:</label>
            <input type="text" id="idTipoVeiculo" name="idTipoVeiculo" required><br><br>

            <label for="modelo">Modelo:</label>
            <input type="text" id="modelo" name="modelo" required><br><br>

            <label for="tipo">Tipo:</label>
            <input type="text" id="tipo" name="tipo" required><br><br>

            <label for="marca">Marca:</label>
            <input type="text" id="marca" name="marca" required><br><br>

            <button type="submit">Adicionar Veiculo</button>
        </form>
    </div>

    <a href="admin.jsp">Voltar</a>
</body>
</html>
