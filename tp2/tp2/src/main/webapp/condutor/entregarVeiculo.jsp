<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, sql.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <title>Entregar Veículo</title>
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
        
        button {
			height: 40px;
		    background-color: #4c5c6c;
		    color: white;
		    padding: 8px 12px;
		    border: none;
		    border-radius: 10px;
		    cursor: pointer;
		    transition: background-color 0.3s ease, transform 0.3s ease;
		    width: 80%;
		}
		
		a.btn-main:hover {
		    background-color: #2b4259;
		    transform: scale(1.1);
		}
		
		a.btn-main {
		    background-color: #4c5c6c;
		    color: white;
		    padding: 8px 12px;
		    border: none;
		    border-radius: 10px;
		    cursor: pointer;
		    transition: background-color 0.3s ease, transform 0.3s ease;
		    text-decoration: none;
		    display: inline-block;
		    margin-top: 20px;
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
    
    <!-- Na mesma página, é criado um formulário com o objetivo do cliente
	conseguir entregar o veiculo a um parque mais próximo de si, num lugar vago -->
    <div class="form-container">
        <h1>Entregar Veículo</h1>
        <form method="post" style="padding-bottom: 50px">
            <label for="numeroCarta">Número da Carta de Condução:</label>
            <input type="text" id="numeroCarta" name="numeroCarta" required><br><br>

            <label for="parque">Escolha o Parque mais Próximo:</label>
            <select id="parque" name="parque" required>
                <option value="Montijo">Montijo</option>
                <option value="Leiria">Leiria</option>
                <option value="Faro">Faro</option>
            </select><br><br>

            <input type="submit" value="Procurar Lugares Vagos">
        </form>

        <%
        	//Um script é necessário para o cliente conseguir fazer a entrega do veiculo
        	//num parque à sua escolha, de preferencia mais perto de si.
            String numeroCarta = request.getParameter("numeroCarta");
            String parqueEscolhido = request.getParameter("parque");

            //Para essa entrega, uma verificação tem de ser executado para averiguar se os
            //campos do numero da carta de condução e da escolha do parque se encontram vazios
            //ou nulos.
            if (numeroCarta != null && !numeroCarta.isEmpty() && parqueEscolhido != null) {
            	//Se não for o caso, uma conexão `base de dados será estabelecida.
                try (Connection conn = DatabaseConnection.getConnection()) {
                    //De seguida, é necessário uma consulta à base de dados com o inutuito de
                    //procurar um lugar para o veiculo.
                    String procuraLugar = "SELECT * FROM Lugar WHERE MatriculaVeiculo IS NULL AND LocalidadeParque = ?";
                    try (PreparedStatement procuraState = conn.prepareStatement(procuraLugar)) {
                    	procuraState.setString(1, parqueEscolhido);
                        ResultSet resultado = procuraState.executeQuery();

                        //Se existirem lugares vazios para entregar o veículo, é dada a opção
                        //ao cliente para escolher um deles. Tal como a opção de deixar ou não
                        //uma classificação/Comentário. Por fim, o cliente também terá de fornecer
                        //a informação de quantos km realizou para uma conta posterior.
                        if (resultado.next()) {
                            out.println("<form method='post'>");
                            out.println("<input type='hidden' name='numeroCarta' value='" + numeroCarta + "'>");
                            out.println("<input type='hidden' name='parque' value='" + parqueEscolhido + "'>");
                            out.println("<label for='lugar'>Escolha o Lugar de Estacionamento:</label>");
                            out.println("<select id='lugar' name='lugar' required>");
                            do {
                                int idLugar = resultado.getInt("IDLugar");
                                String fila = resultado.getString("Fila");
                                int posicao = resultado.getInt("Posicao");
                                out.println("<option value='" + idLugar + "'>Fila: " + fila + ", Posição: " + posicao + "</option>");
                            } while (resultado.next());
                            out.println("</select><br><br>");

                            out.println("<label for='classificacao'>Classificação (opcional):</label>");
                            out.println("<input type='number' id='classificacao' name='classificacao' min='1' max='5'><br><br>");

                            out.println("<label for='comentario'>Comentário (opcional):</label>");
                            out.println("<textarea id='comentario' name='comentario'></textarea><br><br>");

                            out.println("<label for='quilometros'>Quilómetros Feitos:</label>");
                            out.println("<input type='number' id='quilometros' name='quilometros' required><br><br>");

                            out.println("<input type='submit' value='Entregar Veículo'>");
                            out.println("</form>");
                        } else {
                            out.println("<p>Não há lugares vagos disponíveis no parque " + parqueEscolhido + ".</p>");
                        }
                    }
                } catch (SQLException e) {
                    out.println("<p>Erro ao processar a entrega: " + e.getMessage() + "</p>");
                }
            }
        %>

        <%
            //De seguida, é necessário processar o lugarEscolhido tal como os km feitos pelo condutor
            //apos a entrega, daí serem criadas duas variaveis para armazenar isso mesmo, respetivamente
            String lugarEscolhido = request.getParameter("lugar");
            String quilometrosFeitos = request.getParameter("quilometros");
            
            //Uma verificação será feita com o objetivo de averiguar se o lugar está vazio ou não.
            if (lugarEscolhido != null) {
            	//Se o mesmo não estiver, é necessária uma consulta à base de dados para se conseguir
            	//procurar a matricula do veiculo no mesmo a partir da tabela Aluguer, através do
            	//numero da carta de condução.
                String matriculaVeiculo = null;
            	
                String matricula = "SELECT MatriculaAluguer FROM Aluguer WHERE NumeroCarta = ?";
                try (Connection conn = DatabaseConnection.getConnection();
                     PreparedStatement matriculaState = conn.prepareStatement(matricula)) {
                	matriculaState.setString(1, numeroCarta);
                    ResultSet resultado = matriculaState.executeQuery();
                    if (resultado.next()) {
                        matriculaVeiculo = resultado.getString("MatriculaAluguer");
                    }

                    if (matriculaVeiculo != null) {
                        //De seguida, o lugar é atualizado com a matrícula do veículo
                        String atualizarLugar = "UPDATE Lugar SET MatriculaVeiculo = ? WHERE IDLugar = ?";
                        try (PreparedStatement atualizarLugarState = conn.prepareStatement(atualizarLugar)) {
                        	atualizarLugarState.setString(1, matriculaVeiculo);
                        	atualizarLugarState.setInt(2, Integer.parseInt(lugarEscolhido));
                        	atualizarLugarState.executeUpdate();
                        }

                        //Os Km do mesmo serão também atualizados tendo em conta a matricula do veiculo
                        String atualizarKm = "UPDATE Veiculo SET QuilometrosFeitos = QuilometrosFeitos + ? WHERE Matricula = ?";
                        try (PreparedStatement atualizarKmState = conn.prepareStatement(atualizarKm)) {
                        	atualizarKmState.setInt(1, Integer.parseInt(quilometrosFeitos));
                            atualizarKmState.setString(2, matriculaVeiculo);
                            atualizarKmState.executeUpdate();
                        }

                        //Por fim, depois das alterações anteriores efetuadas, é necessário retirar o registo da
                        //tabela Ativos
                        String delAtivo = "DELETE FROM Ativos WHERE NumeroCartaCondutor = ?";
                        try (PreparedStatement delAtivoState = conn.prepareStatement(delAtivo)) {
                        	delAtivoState.setString(1, numeroCarta);
                        	delAtivoState.executeUpdate();
                        }

                        out.println("<p>Veículo entregue com sucesso!</p>");

                        //De seguida, também se vai verificar se o condutor deixou ou não
                        //uma classificação/comentário daí serem criadas duas variaveis para
                        //serem armazenados esses propósitos
                        String classificacao = request.getParameter("classificacao");
                        String comentario = request.getParameter("comentario");

                        //Se a classificação foi fornecida e é um número válido, ou se o comentário é fornecido
                        //será efetuada uma consulta à base de dados para inserir uma avaliação na tabela Avaliacao
                        //sendo que é composta por classificacao, comentario e idAluguerAval.
                        if (classificacao != null || comentario != null) {
                            String inserirAval = "INSERT INTO Avaliacao (Classificacao, Comentario, IDAluguerAval) " +
                                                         "SELECT ?, ?, IDAluguer FROM Aluguer WHERE MatriculaAluguer = ?";
                            try (PreparedStatement inserirAvalState = conn.prepareStatement(inserirAval)) {
                                //De seguida, se a classificação foi fornecida e é válida, 
                                //a mesma é convertida para um número inteiro e é inserida.
                                if (classificacao != null && !classificacao.isEmpty()) {
                                    try {
                                    	inserirAvalState.setInt(1, Integer.parseInt(classificacao));
                                    } catch (NumberFormatException e) {
                                    	inserirAvalState.setNull(1, java.sql.Types.INTEGER);
                                    }
                                } else {
                                	inserirAvalState.setNull(1, java.sql.Types.INTEGER);
                                }
								
                                //Por fim, o comentário e a matrícula do veículo são associados 
                                //à avaliação e a instrução é executada para a alteração na base de dados.
                                inserirAvalState.setString(2, comentario);
                                inserirAvalState.setString(3, matriculaVeiculo);
                                inserirAvalState.executeUpdate();

                                out.println("<p>Avaliação realizada com sucesso!</p>");
                            }
                        }
                    } else {
                        out.println("<p>Não foi encontrado veículo associado ao condutor.</p>");
                    }
                } catch (SQLException e) {
                    out.println("<p>Erro ao processar a entrega: " + e.getMessage() + "</p>");
                }
            }
        %>
    </div>
        <center><a href="condutor.jsp" class="btn-main">Voltar</a></center>
</body>
</html>
