<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, sql.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <meta charset="UTF-8">
    <title>Localizar Veículo</title>
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

        .iconesPaginaInicial a {
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

        .iconesPaginaInicial i {
            font-size: 20px;
            margin-bottom: 5px;
        }
		.form-container {
            max-width: 400px;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        form label {
            font-size: 16px;
            color: black;
            display: block;
            margin-bottom: 5px;
        }

        form input[type="text"] {
            width: 95%;
            padding: 10px;
            font-size: 14px;
            border: 1px solid grey;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        form input[type="submit"] {
            width: 100%;
            padding: 10px;
            background-color: #4c5c6c;
            color: white;
            font-size: 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.3s ease;
        }

        form input[type="submit"]:hover {
            background-color: #2b4259;
            transform: scale(1.05);
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
            <a href="../gerente/gerente.jsp"><i class="fa-solid fa-users"></i><span>Gerente</span></a>
        </div>
    </header>
    
    <!-- Na mesma página, é criado um formulário com o objetivo de seconseguir
    localizar um veiculo -->
	<div class="form-container">
        <center><h1>Localizar Veículo</h1></center>
	    <form method="get" action="localizarVeiculo.jsp">
	        <label for="matricula">Matrícula do Veículo:</label>
	        <input type="text" id="matricula" name="matricula" required>
	        <center><button type="submit">Localizar</button></center>
	    </form>
	        <%
	    //Um script é necessário para a atribuição de veiculos a um lugar e para a localização do mesmo
        String matricula = request.getParameter("matricula");
		
        if (matricula != null && !matricula.isEmpty()) {
            try (Connection conn = DatabaseConnection.getConnection()) {
                //É necessário uma consulta para localizar o veículo com base na matrícula fornecida
                String localizarVeiculo = "SELECT l.Piso, l.Fila, l.Posicao, p.Localidade, p.Latitude, p.Longitude " +
                             "FROM Lugar l " +
                             "JOIN ParqueEstacionamento p ON l.LocalidadeParque = p.Localidade " +
                             "WHERE l.MatriculaVeiculo = ?";

                PreparedStatement localizarVeiculoState = conn.prepareStatement(localizarVeiculo);
                localizarVeiculoState.setString(1, matricula);
                ResultSet resultado = localizarVeiculoState.executeQuery();

                if (resultado.next()) {
                    //Depois da consulta, se o veiculo estiver estacionado, é apresentada no site
                    //toda a informação do mesmo.
                    String piso = resultado.getString("Piso");
                    String fila = resultado.getString("Fila");
                    int posicao = resultado.getInt("Posicao");
                    String localidade = resultado.getString("Localidade");
                    double latitude = resultado.getDouble("Latitude");
                    double longitude = resultado.getDouble("Longitude");
                    out.println("<div class='result'>");
                    out.println("<h3>Localização do Veículo:</h3>");
                    out.println("<p><strong>Piso:</strong> " + piso + "</p>");
                    out.println("<p><strong>Fila:</strong> " + fila + "</p>");
                    out.println("<p><strong>Posição:</strong> " + posicao + "</p>");
                    out.println("<p><strong>Localidade do Parque:</strong> " + localidade + "</p>");
                    out.println("<p><strong>Latitude:</strong> " + latitude + "</p>");
                    out.println("<p><strong>Longitude:</strong> " + longitude + "</p>");
                    out.println("</div>");
                } else {
                    out.println("<p>Veículo não encontrado ou não está estacionado.</p>");
                }
            } catch (SQLException e) {
                out.println("<p>Erro ao localizar veículo: " + e.getMessage() + "</p>");
            }
        }

        //De seguida, para uma outra parte da mesma págiuna, é necessário um campo para adicionar
        //um veiculo a um determinado lugar, daí a necessidade de ir consultar os parametros
        //abaixos descritos.
        String matriculaInput = request.getParameter("matriculaInput");
        String piso = request.getParameter("piso");
        String fila = request.getParameter("fila");
        String posicao = request.getParameter("posicao");
        String localidade = request.getParameter("localidade");

        if (matriculaInput != null && piso != null && fila != null && posicao != null && localidade != null) {
            try (Connection conn = DatabaseConnection.getConnection()) {
            	//Depois da verificação dos campos que não estejam nulos ou vazios, e depois da tentativa de conexão
            	//aà base de dados, uma consulta à mesma será efetuada com o obejtivo de inserir os dados de um veiculo
            	//no lugar especifico escolhido pelo utilizador no parque de estacionamento
                String inserirLugar = "INSERT INTO Lugar (MatriculaVeiculo, Piso, Fila, Posicao, LocalidadeParque) " +
                                   "VALUES (?, ?, ?, ?, ?)";
                PreparedStatement inserirLugarState = conn.prepareStatement(inserirLugar);
                inserirLugarState.setString(1, matriculaInput);
                inserirLugarState.setString(2, piso);
                inserirLugarState.setString(3, fila);
                inserirLugarState.setInt(4, Integer.parseInt(posicao));
                inserirLugarState.setString(5, localidade);
                inserirLugarState.executeUpdate();

                out.println("<p>Veículo " + matriculaInput + " foi atribuído ao lugar no Piso " + piso + ", Fila " + fila + ", Posição " + posicao + ".</p>");
            } catch (SQLException e) {
                out.println("<p>Erro ao associar veículo ao lugar: " + e.getMessage() + "</p>");
            }
        }
    %>
	</div>

	<!-- Na mesma página, é criado um formulário com o objetivo do funcionario
    conseguir adicionar um determinada veiculo a um determinado lugar -->
	<div class="form-container">
	    <form method="post" action="localizarVeiculo.jsp">
	        <center><h3>Adicionar Veículo ao Lugar</h3></center>
	        <label for="matriculaInput">Matrícula do Veículo:</label>
	        <input type="text" id="matriculaInput" name="matriculaInput" required>
	
	        <label for="piso">Piso:</label>
	        <input type="number" id="piso" name="piso" required>
	
	        <label for="fila">Fila:</label>
	        <input type="text" id="fila" name="fila" required>
	
	        <label for="posicao">Posição:</label>
	        <input type="number" id="posicao" name="posicao" required>
	
	        <label for="localidade">Localidade do Parque:</label>
	        <input type="text" id="localidade" name="localidade" required>
	
	        <center><button type="submit">Atribuir Veículo ao Lugar</button></center>
	    </form>
    </div>
</body>
</html>
