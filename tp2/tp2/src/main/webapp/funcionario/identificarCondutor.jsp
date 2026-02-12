<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, sql.DatabaseConnection" %>

<!DOCTYPE html>
<html>
<head>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <meta charset="UTF-8">
    <title>Identificar Condutor</title>
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
    identificar o condutor de um determinada veiculo a partir da sua matricula, numa
    /determinada data -->
    <div class="form-container">
    
        <center><h1>Identificar Condutor</h1></center>
        <form method="GET">
	        <label for="matricula">Matrícula:</label>
	        <input type="text" id="matricula" name="matricula" required>
	        <label for="data">Data:</label>
	        <input type="date" id="data" name="data" required>
	        <button type="submit">Pesquisar</button>
    	</form>
    	<% 
            //É necessário um script para se conseguir identificar o condutor de um veiculo
            //numa certa data.
            String matricula = request.getParameter("matricula");
            String data = request.getParameter("data");

            if (matricula != null && !matricula.isEmpty() && data != null && !data.isEmpty()) {
                try (Connection conn = DatabaseConnection.getConnection()) {
                	//Depois da verificação dos campos de matricula e data não estejam nulos ou vazios, e depois da tentativa de conexão
                	//aà base de dados, uma consulta à mesma será efetuada com o obejtivo de selecionar todas as informações que compôem
                	//o condutor associado a um veiculo na data especifica escolhida.
                    String condutor = "SELECT c.NumeroCarta, c.NIFCliente, c.Reputacao, cl.Nome, cl.Contacto " +
                                 "FROM Aluguer a " +
                                 "JOIN Condutor c ON a.NumeroCarta = c.NumeroCarta " +
                                 "JOIN Cliente cl ON c.NIFCliente = cl.NIF " +
                                 "WHERE a.MatriculaAluguer = ? " +
                                 "AND ? BETWEEN a.HoraInicio AND a.HoraFim";

                    PreparedStatement condutorState = conn.prepareStatement(condutor);
                    condutorState.setString(1, matricula);
                    condutorState.setString(2, data);

                    ResultSet resultado = condutorState.executeQuery();

                    if (resultado.next()) {
                        //Serão então exibidas todas as informações do condutor no ecra
                        out.println("<h3>Detalhes do Condutor:</h3>");
                        out.println("<p><strong>Número da Carta:</strong> " + resultado.getString("NumeroCarta") + "</p>");
                        out.println("<p><strong>Nome:</strong> " + resultado.getString("Nome") + "</p>");
                        out.println("<p><strong>Contacto:</strong> " + resultado.getString("Contacto") + "</p>");
                        out.println("<p><strong>Reputação:</strong> " + resultado.getInt("Reputacao") + "</p>");
                    } else {
                        out.println("<p><strong>Nenhum condutor encontrado para a matrícula '" + matricula +
                                    "' na data '" + data + "'.</strong></p>");
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    out.println("<p><strong>Ocorreu um erro ao procurar o condutor.</strong></p>");
                }
            } else {
                out.println("<p>Preencha os campos acima e clique em 'Pesquisar'.</p>");
            }
        %>
    </div>
</body>
</html>
