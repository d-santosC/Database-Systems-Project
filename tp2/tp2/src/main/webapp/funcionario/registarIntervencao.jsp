<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, sql.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <meta charset="UTF-8">
    <title>Registar Intervenção</title>
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
    
    <!-- Um formulário é criado com o intuito do funcionário conseguir registar
    todas as intervenções que o veiculo pôde ter ao longo do tempo -->
<div class="form-container">

    <center><h1>Registar Intervenção do Veículo</h1></center>
    <form method="post" action="registarIntervencao.jsp">
        <label for="matricula">Matrícula do Veículo:</label>
        <input type="text" id="matricula" name="matricula" required>
        <br>
        <label for="tipoIntervencao">Tipo de Intervenção:</label>
        <input type="text" id="tipoIntervencao" name="tipoIntervencao" required>
        <br>
        <label for="dataIntervencao">Data da Intervenção:</label>
        <input type="date" id="dataIntervencao" name="dataIntervencao" required>
        <br>
        <center><button type="submit">Registar Intervenção</button></center>
    </form>

    <%
    	//Um script é necessário para registar um intervenção do veiculo
        String matricula = request.getParameter("matricula");
        String tipoIntervencao = request.getParameter("tipoIntervencao");
        String dataIntervencao = request.getParameter("dataIntervencao");
		
        //Uma verificação é realizada para se conseguir averiguar se os campos matricula, tipoIntervencao
        //dataIntervencao.
        if (matricula != null && tipoIntervencao != null && dataIntervencao != null) {
        	//Se estiverem preenchidos, será efetuada uma conexão à base de dados
            try (Connection conn = DatabaseConnection.getConnection()) {
                //De seguida, tem-se de verificar se o veiculo existe na tabela veiculo atraves da sua matricula
                String verificarVeiculo = "SELECT * FROM Veiculo WHERE Matricula = ?";
                PreparedStatement verificarVeiculoState = conn.prepareStatement(verificarVeiculo);
                verificarVeiculoState.setString(1, matricula);
                ResultSet resultado = verificarVeiculoState.executeQuery();

                if (resultado.next()) {
                    //Depois da verificação, são então inseridos os dados da intervencao que é composta
                    //por Tipo, DataIntervencao, MatriculaVeiculo.
                    String inserirIntervencao = "INSERT INTO Intervencao (Tipo, DataIntervencao, MatriculaVeiculo) " +
                                       "VALUES (?, ?, ?)";
                    PreparedStatement inserirIntervencaoState = conn.prepareStatement(inserirIntervencao);
                    inserirIntervencaoState.setString(1, tipoIntervencao);
                    inserirIntervencaoState.setDate(2, Date.valueOf(dataIntervencao));
                    inserirIntervencaoState.setString(3, matricula);
                    inserirIntervencaoState.executeUpdate();

                    out.println("<p>Intervenção registada com sucesso para o veículo " + matricula + ".</p>");
                } else {
                    out.println("<p>Veículo não encontrado. Verifique a matrícula.</p>");
                }
            } catch (SQLException e) {
                out.println("<p>Erro ao registar intervenção: " + e.getMessage() + "</p>");
            }
        }
    %>
</div>
</body>
</html>
