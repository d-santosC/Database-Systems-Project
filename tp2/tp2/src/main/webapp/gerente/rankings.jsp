<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, sql.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <title>Rankings - Avaliações e Lucros</title>
    <style>
        body {
        	background: url("../images/background.jpg");
            font-family: Arial, sans-serif;
            margin: 0;
        }
        
        header {
            height: 120px;
            background-color: #4c5c6c;
            color: white;
            display: flex;
            align-items: center;
            position: relative;
            padding: 0 20px;
        }

        header h1 {
            margin: 0;
            font-size: 2rem;
            text-align: center;
            flex-grow: 1;
        }

        .iconesPaginaInicial {
            display: flex;
            gap: 10px;
            position: absolute;
            left: 20px;
        }

        .iconesPaginaInicial a, .texto a{
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background-color: #fff;
            color: #4c5c6c;
            text-decoration: none;
            font-size: 13px;
            font-weight: bold;
            padding: 10px;
            border-radius: 50%;
            width: 85px;
            height: 60px;
            transition: background-color 0.3s ease, transform 0.3s ease;
        }

        .iconesPaginaInicial a:hover {
            background-color: #4c5c6c;
            color: white;
            transform: scale(1.1);
        }

        .iconesPaginaInicial i, .texto a i {
            font-size: 20px;
            margin-bottom: 5px;
        }
        .card-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin: 20px 10px;
        }
        .card {
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            width: 300px;
            padding: 15px;
            text-align: left;
        }
        .card h3 {
            font-size: 18px;
            margin: 0 0 10px 0;
            color: #333;
        }
        .card p {
            margin: 5px 0;
            color: #555;
        }
    </style>
</head>
<body>
    <header>
    	<!-- Botões criados para se conseguir navegar pelo site -->
        <div class="iconesPaginaInicial">
        	<a href="../index.jsp"><i class="fa-solid fa-house"></i><span>Home</span></a>
            <a href="../administrador/admin.jsp"><i class="fa-solid fa-lock"></i><span>Administração</span></a>
            <a href="../cliente/cliente.jsp"><i class="fa-solid fa-user"></i><span>Cliente</span></a>
            <a href="../condutor/condutor.jsp"><i class="fa-solid fa-car"></i><span>Condutor</span></a>
            <a href="../funcionario/funcionario.jsp"><i class="fa-solid fa-user-tie"></i><span>Funcionário</span></a>
            <a href="gerente.jsp"><i class="fa-solid fa-users"></i><span>Gerente</span></a>
        </div>

    </header>

    <center><h1>Rankings</h1></center>
    <center><h2>5 Modelos de Veículo com Melhor Avaliação (Semana Passada)</h2></center>
    <div class="card-container">
            <%
            	//Script necessário para se conseguir averiguar quais os 5 modelos de veículo com melhor avaliação na semana passada
            	//com base na média das avaliações.
                try (Connection conn = DatabaseConnection.getConnection()) {
                	//Para isso uma consulta é feita, com o intuito de obter todos os dados
                    String aval = "SELECT tv.Modelo, tv.Marca, AVG(a.Classificacao) AS MediaAvaliacao " +
                                 "FROM Aluguer al " +
                                 "JOIN Avaliacao a ON al.IDAluguer = a.IDAluguerAval " +
                                 "JOIN Veiculo v ON al.MatriculaAluguer = v.Matricula " +
                                 "JOIN TipoVeiculo tv ON v.ChassiVeiculo = tv.Chassi " +
                                 "WHERE a.IDAvaliacao > 0 " +
                                 "AND al.HoraFim BETWEEN CURDATE() - INTERVAL 7 DAY AND CURDATE() " + 
                                 "GROUP BY tv.Marca, tv.Modelo " +
                                 "ORDER BY MediaAvaliacao DESC " +
                                 "LIMIT 5";
                    try (PreparedStatement avalState = conn.prepareStatement(aval)) {
                        ResultSet resultado = avalState.executeQuery();

                        while (resultado.next()) {
                            String modelo = resultado.getString("Modelo");
                            String marca = resultado.getString("Marca");
                            double mediaAvaliacao = resultado.getDouble("MediaAvaliacao");
            %>
                            <div class="card">
                                <h3><%= modelo %> - <%= marca %></h3>
                                <p>Média de Avaliação: <strong><%= String.format("%.2f", mediaAvaliacao) %></strong></p>
                            </div>
            <%
                        }
                    }
                } catch (SQLException e) {
                    out.println("<tr><td colspan='3'>Erro ao carregar os dados: " + e.getMessage() + "</td></tr>");
                }
            %>
   </div>

    <h2>3 Marcas com Menor Lucro</h2>
	<div class="card-container">
            <%
          	//Script necessário para se conseguir averiguar quais as 3 marcas de veículo com menor lucro
            try (Connection conn = DatabaseConnection.getConnection()) {
                    String lucro = "SELECT tv.Marca, SUM(a.Custo) AS TotalLucro " +
                                 "FROM Aluguer a " +
                                 "JOIN Veiculo v ON a.MatriculaAluguer = v.Matricula " +
                                 "JOIN TipoVeiculo tv ON v.ChassiVeiculo = tv.Chassi " +
                                 "GROUP BY tv.Marca " +
                                 "ORDER BY TotalLucro ASC " +
                                 "LIMIT 3";
                    try (PreparedStatement lucroState = conn.prepareStatement(lucro)) {
                        ResultSet resultado = lucroState.executeQuery();
                        
                        while (resultado.next()) {
                            String marca = resultado.getString("Marca");
                            double totalLucro = resultado.getDouble("TotalLucro");
            %>
                            <div class="card">
                                <h3><%= marca %></td>
                                <p>Menos Lucro: <strong><%= String.format("%.2f", totalLucro) %></strong></p>
                            </div>
            <%
                        }
                    }
                } catch (SQLException e) {
                    out.println("<tr><td colspan='2'>Erro ao carregar os dados: " + e.getMessage() + "</td></tr>");
                }
            %>
</div>
    
    <h2>10 Veículos com Menos Quilómetros Percorridos no Último Trimestre</h2>
	<div class="card-container">
            <%
          		//Script necessário para se conseguir averiguar quais os 10 veículos com menos km percorridos
          		//no ultimo trimestre
                try (Connection conn = DatabaseConnection.getConnection()) {
                    String km = "SELECT v.Matricula, tv.Modelo, tv.Marca, v.QuilometrosFeitos " +
                                 "FROM Veiculo v " +
                                 "JOIN TipoVeiculo tv ON v.ChassiVeiculo = tv.Chassi " +
                                 "WHERE v.QuilometrosFeitos IS NOT NULL " +
                                 "AND v.QuilometrosFeitos > 0 " +
                                 "AND v.Matricula IN ( " +
                                     "SELECT al.MatriculaAluguer " +
                                     "FROM Aluguer al " +
                                     "WHERE al.HoraFim BETWEEN CURDATE() - INTERVAL 3 MONTH AND CURDATE() " +
                                 ") " +
                                 "ORDER BY v.QuilometrosFeitos ASC " +
                                 "LIMIT 10";
                    try (PreparedStatement kmState = conn.prepareStatement(km)) {
                        ResultSet resultado = kmState.executeQuery();
                        
                        while (resultado.next()) {
                            String matricula = resultado.getString("Matricula");
                            String modelo = resultado.getString("Modelo");
                            String marca = resultado.getString("Marca");
                            int quilometros = resultado.getInt("QuilometrosFeitos");
            %>
                            <div class="card">
                                <h3><%= matricula %></h3>
                                <h3><%= modelo %></h3>
                                <h3><%= marca %></h3>
                                <p><strong>Km: </strong><strong><%= quilometros %></strong></p>
                            </div>
            <%
                        }
                    }
                } catch (SQLException e) {
                    out.println("<tr><td colspan='4'>Erro ao carregar os dados: " + e.getMessage() + "</td></tr>");
                }
            %>
	</div>
    
    <h2>100 Clientes com Maior Reputação (Por Freguesia)</h2>
    <form class="filter-form" method="get" action="">
        <label for="freguesia">Selecione a Freguesia:</label>
        <input type="text" id="freguesia" name="freguesia" required>
        <button type="submit">Filtrar</button>
    </form>
    <div class="card-container">
            <%
	            //Script necessário para se conseguir averiguar quais os 10o clientes com melhor reputaçao
	            //filtrando-os por freguesia
                String freguesia = request.getParameter("freguesia");
                if (freguesia != null && !freguesia.isEmpty()) {
                    try (Connection conn = DatabaseConnection.getConnection()) {
                        String sql = "SELECT c.Nome, con.Reputacao, m.Freguesia " +
                                     "FROM Cliente c " +
                                     "JOIN Condutor con ON c.NIF = con.NIFCliente " +
                                     "JOIN Morada m ON c.Rua = m.Rua AND c.Porta = m.Porta AND c.Andar = m.Andar AND c.CodigoPostal = m.CodigoPostal " +
                                     "WHERE m.Freguesia = ? " +
                                     "ORDER BY con.Reputacao DESC " +
                                     "LIMIT 100";
                        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                            stmt.setString(1, freguesia);
                            ResultSet rs = stmt.executeQuery();
                            while (rs.next()) {
                                String nome = rs.getString("Nome");
                                int reputacao = rs.getInt("Reputacao");
                                String freguesiaCliente = rs.getString("Freguesia");
            %>
                                <div class="card">
	                                <h3><%= nome %></h3>
	                                <p><strong>Reputação:</strong><%= reputacao %></p>
	                                <p><strong>Freguesia:</strong><%= freguesiaCliente %></p>
                            	</div>
            <%
                            }
                        }
                    } catch (SQLException e) {
                        out.println("<tr><td colspan='3'>Erro ao carregar os dados: " + e.getMessage() + "</td></tr>");
                    }
                }
            %>
    </div>  
</body>
</html>
