<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, sql.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <title>Histórico do Veículo</title>
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
	    }
	
	    .card {
	        border: 1px solid #ddd;
	        border-radius: 8px;
	        padding: 15px;
	        background-color: #f9f9f9;
	        width: calc(33% - 20px);
	        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
	    }
	
	    .card h3 {
	        margin: 0 0 10px;
	    }
	
	    .card p {
	        margin: 5px 0;
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
            <a href="gerente.jsp"><i class="fa-solid fa-users"></i><span>Gerente</span></a>
        </div>

    </header>
	<!-- Na mesma página, é criado um formulário com o objetivo de se conseguir
	verificar o historico do veiculo, como registo de intervencoes, alugueres ou avaliacoes -->
    <div class="form-container">
    
        <center><h1>Histórico do Veículo</h1></center>
        <form method="get" action="">
            <label for="matricula">Digite a matrícula do veículo:</label>
            <input type="text" id="matricula" name="matricula" required>
            <button type="submit">Pesquisar</button>
        </form>

        <%
           	//Um script necessário para se conseguir consultar todas as intervencoes
           	//que o veiculo possuiu, identificando-o pela sua maricula
            String matricula = request.getParameter("matricula");
			
        	//Uma verificação é realizado com o intuito de ver se a matricula não é nula nem vazia
            if (matricula != null && !matricula.isEmpty()) {
            	//Se a mesma for válida, um atentativa de conexão à base de dados será efetuada.
                try (Connection conn = DatabaseConnection.getConnection()) {
                    //De seguida, é necessário uma consulta à base de dados para se conseguir retirar o e a
                    //data de intervencao do veiculo
                    String intervencao = "SELECT Tipo, DataIntervencao FROM Intervencao WHERE MatriculaVeiculo = ? ORDER BY DataIntervencao";
                    PreparedStatement intervencaoState = conn.prepareStatement(intervencao);
                    intervencaoState.setString(1, matricula);
                    ResultSet resultadoInter = intervencaoState.executeQuery();

                    //O mesmo faz-se para todos os alugueres que o veiculo pode ter tido.
                    String aluguer = "SELECT Tipo, HoraInicio, HoraFim, Custo FROM Aluguer WHERE MatriculaAluguer = ? ORDER BY HoraInicio";
                    PreparedStatement aluguerState = conn.prepareStatement(aluguer);
                    aluguerState.setString(1, matricula);
                    ResultSet resultadoAlug = aluguerState.executeQuery();

                    //Por fim, realiza-se extamente a mesma situação para todas as avaliações que o veiculo pode ter tido.
                    String avaliacao = "SELECT Classificacao, Comentario FROM Avaliacao WHERE IDAluguerAval IN (SELECT IDAluguer FROM Aluguer WHERE MatriculaAluguer = ?) ORDER BY IDAvaliacao";
                    PreparedStatement avaliacaoState = conn.prepareStatement(avaliacao);
                    avaliacaoState.setString(1, matricula);
                    ResultSet resultadoAval = avaliacaoState.executeQuery();
        %>
		<!-- Trêas secções serão criadas apenas para se conseguir apresentar todos
		os tipos de intervenções que o veiculo teve no site. -->
        <h2>Intervenções</h2>
        <div class="card-container">
            <%
                while (resultadoInter.next()) {
            %>
            <div class="card">
                <h3><%= resultadoInter.getString("Tipo") %></h3>
                <p><%= resultadoInter.getDate("DataIntervencao") %></p>
            </div>
            <%
                }
            %>
        </div>

        <h2>Alugueres</h2>
        <div class="card-container">
            <%
                while (resultadoAlug.next()) {
            %>
            <div class="card">
                <h3><%= resultadoAlug.getString("Tipo") %></h3>
                <p><%= resultadoAlug.getTimestamp("HoraInicio") %></p>
                <p><%= resultadoAlug.getTimestamp("HoraFim") %></p>
                <p><%= resultadoAlug.getDouble("Custo") %></p>
            </div>
            <%
                }
            %>
        </div>

        <h2>Avaliações</h2>
        <div class="card-container">
            <%
                while (resultadoAval.next()) {
            %>
            <div class="card">
                <p><%= resultadoAval.getInt("Classificacao") %></p>
                <p><%= resultadoAval.getString("Comentario") %></p>
            </div>
            <%
                }
            %>
        </div>
        <%
                } catch (SQLException e) {
                    out.println("<p>Erro ao conectar com o banco de dados: " + e.getMessage() + "</p>");
                }
            }
        %>
    </div>
</body>
</html>
