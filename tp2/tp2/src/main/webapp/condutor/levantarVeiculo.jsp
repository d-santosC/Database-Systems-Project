<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, sql.DatabaseConnection, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Levantar Veículo</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <style>
        body {
            background: url("images/background.jpg");
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

	<!--Um formulário para o utilizador conseguir fazer o levantamento 
	de um veiculo consoante a sua necessidade -->
	<div class="form-container">
        <center><h1>Levantar Veículo</h1></center>
	    <form method="post">
	        <label for="numeroCarta">Número da Carta de Condução:</label>
	        <input type="text" id="numeroCarta" name="numeroCarta" required><br><br>
	        <input type="submit" value="Consultar Veículo">
	    </form>
	    <%
	    //Um script necessário para se conseguir gerir a reservas dos veiculos 
	    //tal como o levantamento dos mesmos pelos condutores.
        String numeroCarta = request.getParameter("numeroCarta");
        
	    //Uma verificação será realizada para averiguar que o numero da carta de conduçao do condutor nao é
	    //nula nem vazia.
        if (numeroCarta != null && !numeroCarta.isEmpty()) {
            try (Connection conn = DatabaseConnection.getConnection()) {
                //Se assim acontecer, um conexão será estabelecida para se conseguir consultar 
                //o veículo atribuído à reserva, tendo em conta todos os dados necessários para
                //a mesma.
                String reserva = "SELECT v.Matricula, v.TipoMotor, v.CapacidadeCarga, v.Potencia, v.QuilometrosFeitos, v.QuantidadeLugares, v.QuantidadePortas, l.Piso, l.Fila, l.Posicao, l.LocalidadeParque " +
                                    "FROM Aluguer a " +
                                    "JOIN Veiculo v ON a.MatriculaAluguer = v.Matricula " +
                                    "JOIN Lugar l ON v.Matricula = l.MatriculaVeiculo " +
                                    "WHERE a.NumeroCarta = ? AND a.HoraFim > NOW()";


	    		//De seguida, será efetuada uma consulta à base de dados com o objetivo de conseguir mostrar
	    		//no site, todos os dados que sao associados ao veiculo da reserva feita
                try (PreparedStatement reservaState = conn.prepareStatement(reserva)) {
                	reservaState.setString(1, numeroCarta);
                    try (ResultSet resultado = reservaState.executeQuery()) {
                        if (resultado.next()) {
                            out.println("<h2>Dados do Veículo:</h2>");
                            out.println("<p>Matricula: " + resultado.getString("Matricula") + "</p>");
                            out.println("<p>Tipo de Motor: " + resultado.getString("TipoMotor") + "</p>");
                            out.println("<p>Capacidade de Carga: " + resultado.getDouble("CapacidadeCarga") + " kg</p>");
                            out.println("<p>Potência: " + resultado.getDouble("Potencia") + " CV</p>");
                            out.println("<p>Km: " + resultado.getInt("QuilometrosFeitos") + " km</p>");
                            out.println("<p>Quantidade de Lugares: " + resultado.getInt("QuantidadeLugares") + "</p>");
                            out.println("<p>Quantidade de Portas: " + resultado.getInt("QuantidadePortas") + "</p>");
                            out.println("<h3>Localização no Parque:</h3>");
                            out.println("<p>Piso: " + resultado.getInt("Piso") + "</p>");
                            out.println("<p>Fila: " + resultado.getString("Fila") + "</p>");
                            out.println("<p>Posição: " + resultado.getInt("Posicao") + "</p>");
                            out.println("<p>Localidade do Parque: " + resultado.getString("LocalidadeParque") + "</p>");
                            
                            //Depois dos dados serem apresentados, um botão levantar irá aparecer, para dar a
                            //oportunidade do condutor conseguir levantar o veiculo em questão, e demosntrar que
                            //o levantamento foi ou não efetuado com sucesso.
                            out.println("<form method='post' action='levantarVeiculo.jsp'>");
                            out.println("<input type='hidden' name='numeroCarta' value='" + numeroCarta + "'>");
                            out.println("<input type='hidden' name='matricula' value='" + resultado.getString("Matricula") + "'>");
                            out.println("<input type='submit' name='submit' value='Levantar'>");
                            out.println("</form>");
                        } else {
                            out.println("<p>Não há veículo atribuído a essa reserva ou a reserva já terminou.</p>");
                        }
                    }
                }

             	//Quando o botão levantar for pressionado pelo utilizador, o levantamento em questão
             	//será adicionado na tabela Ativos
                if ("Levantar".equals(request.getParameter("submit"))) {
                    String matricula = request.getParameter("matricula");

                    String levantar = "INSERT INTO Ativos (NumeroCartaCondutor, MatriculaAtiva, DataLevantamento) VALUES (?, ?, ?)";
                    try (PreparedStatement levantarState = conn.prepareStatement(levantar)) {
                    	levantarState.setString(1, numeroCarta);
                    	levantarState.setString(2, matricula);
                    	//Um setTimestamp() para se verificar a data e hora exatas do levantamento
                    	levantarState.setTimestamp(3, new java.sql.Timestamp(System.currentTimeMillis()));
                    	levantarState.executeUpdate();
                        out.println("<p>Veículo levantado com sucesso!</p>");
                    }

                    //E, de seguida, atualizar a tabela Lugar, para se conseguir remover a matrícula do veículo
                    //no respetivo lugar, depois de levantado
                    String lugar = "UPDATE Lugar SET MatriculaVeiculo = NULL WHERE MatriculaVeiculo = ?";
                    try (PreparedStatement lugarState = conn.prepareStatement(lugar)) {
                    	lugarState.setString(1, matricula);
                    	lugarState.executeUpdate();
                        out.println("<p>Lugar de estacionamento atualizado com sucesso!</p>");
                    }

                }

            } catch (SQLException e) {
                out.println("<p>Erro ao acessar a base de dados: " + e.getMessage() + "</p>");
            }
        }
    %>
	</div>

</body>
</html>
