<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, sql.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

<meta charset="UTF-8">
<title>Atribuir Veiculos</title>
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
            margin: 20px;
            background-color: rgba(255, 255, 255, 0.7);
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 40px;
            width: 900px;
        }
        
        button {
            background-color: #4c5c6c;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 4px;
            cursor: pointer;
        }
        
        button:hover {
            background-color: #2e4359;
        }
        
        .btn-main {
            background-color: #a24c5d;
            color: white;
            padding: 15px 30px;
            border-radius: 50px;
            font-size: 1.2rem;
            font-weight: bold;
            text-decoration: none;
            transition: background-color 0.3s ease, transform 0.3s ease;
        }

        .btn-main:hover {
            background-color: #430e1e;
            transform: scale(1.1);
        }
        
        .form-group {
		    display: flex;
		    justify-content: center;
		    align-items: center;
		    gap: 15px;
		    margin-bottom: 15px;
		}
		
		.form-group label {
		    width: 20%;
		    text-align: right;
		}
		
		.form-group input {
		    width: 70%;
		    padding: 8px;
		    border: 2px solid #ccc;
		    border-radius: 4px;
		}
		.card-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin: 20px 0;
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
		        
	</style>
</head>
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
	<center><h1>Atribuir Veículos</h1></center>
	<center><h2>Lista de Reservas Pendentes</h2></center>
	<div class="card-container">

            <%
            	//Esta secção irá apresentar as reservas pendentes feitas por clientes.
            	//É necessária uma tentativa de conexão à base de dados para se conseguir verificar
            	//que tipo de reserva foi efetuada, selecionadno tudo da tabela reservas.
                try (Connection conn = DatabaseConnection.getConnection()) {
                    String reserva = "SELECT * FROM reservas";
                    try (Statement reservaState = conn.createStatement(); 
                    	ResultSet resultado = reservaState.executeQuery(reserva)) {
                        while (resultado.next()) {
                            %>
                            <!-- Aqui serão então apresentadas as reservas pendentes com todos os dados necessários -->
                            <div class="card">
                                <h3><%= resultado.getString("IDReserva") %></h3>
                                <p><strong>NIF: </strong><%= resultado.getString("NIFClienteReserva") %></p>
                                <p><strong>Número da Carta: </strong><%= resultado.getString("NumeroCartaCondutor") %></p>
                                <p><strong>Tipo: </strong><%= resultado.getString("Tipo") %></p>
                                <p><strong>Marca: </strong><%= resultado.getString("Marca") %></p>
                                <p><strong>Hora Inicial: </strong><%= resultado.getString("HoraInicioReserva") %></p>
                                <p><strong>Hora Final: </strong><%= resultado.getString("HoraFimReserva") %></p>
                                <p><strong>Localidade do Parque: </strong><%= resultado.getString("LocalidadeParque") %></p>                               
                                <p>
                                    <form action="editarReserva.jsp" method="get">  
                                    	<input type="hidden" name="idReserva" value="<%= resultado.getString("IDReserva") %>">	  
                                        <button type="submit">Editar</button>
                                    </form>
                                </p>
                            </div>
                            <%
                        }
                    }
                } catch (SQLException e) {
                    out.println("<tr><td colspan='10'>Erro ao conectar à base de dados: " + e.getMessage() + "</td></tr>");
                }
            %>
	</div>
    
    <!-- É necessário um formulário para o funcionario conseguir pesquisar por um veiculo especifico
    e conseguir atribuir o mesmo a uma reserva que esteja pendente, pedida por um cliente. -->
    <div class="form-container">
	    <h2>Pesquisar Veículos</h2>
	    <form method="get" action="atribuirVeiculo.jsp">
	        <div class="form-group">
	            <label for="tipo">Tipo:</label>
	            <input type="text" id="tipo" name="tipo" placeholder="Digite o tipo do veículo">
	        </div>
	        <div class="form-group">
	            <label for="marca">Marca:</label>
	            <input type="text" id="marca" name="marca" placeholder="Digite a marca do veículo">
	        </div>
	        <div class="form-group">
	            <label for="localidade">Localidade:</label>
	            <input type="text" id="localidade" name="localidade" placeholder="Digite a localidade do veículo">
	        </div>
	        <center><button type="submit">Pesquisar</button></center>
	    </form>
	</div>


<%
	//Um script é necessário para se conseguir filtrar a pesquisa dos veiculos consoante
	//o fiuncionario escreve nos campos de pesquisa.
    String tipo = request.getParameter("tipo");
    String marca = request.getParameter("marca");
    String localidade = request.getParameter("localidade");

    if (tipo != null || marca != null || localidade != null) {
        try (Connection conn = DatabaseConnection.getConnection()) {
        	//Depois da verificação dos campos de tipo marca e localidade não sejam nulos, e depois da tentativa de conexão
            //à base de dados, uma consulta à mesma será efetuada com o obejtivo de remover todos os veiculos que ja estejam
            //alugados
            String atribuiVeiculo = "SELECT v.Matricula, v.TipoMotor, v.LocalidadeVeiculo, t.Tipo, t.Marca " +
                         "FROM Veiculo v " +
                         "JOIN TipoVeiculo t ON v.ChassiVeiculo = t.Chassi " +
                         "WHERE (? IS NULL OR t.Tipo LIKE ?) " +
                         "AND (? IS NULL OR t.Marca LIKE ?) " +
                         "AND (? IS NULL OR v.LocalidadeVeiculo LIKE ?) " +
                         "AND v.Matricula NOT IN (SELECT MatriculaAluguer FROM Aluguer)";
                         
            try (PreparedStatement atribuiVeiculoState = conn.prepareStatement(atribuiVeiculo)) {
            	atribuiVeiculoState.setString(1, tipo);
            	atribuiVeiculoState.setString(2, tipo != null ? "%" + tipo + "%" : null);
            	atribuiVeiculoState.setString(3, marca);
            	atribuiVeiculoState.setString(4, marca != null ? "%" + marca + "%" : null);
            	atribuiVeiculoState.setString(5, localidade);
            	atribuiVeiculoState.setString(6, localidade != null ? "%" + localidade + "%" : null);

                try (ResultSet resultado = atribuiVeiculoState.executeQuery()) {
                    if (!resultado.isBeforeFirst()) {
                        out.println("<p>Nenhum veículo encontrado.</p>");
                    } else {
                        %>
                        <!-- Uma tabela é necessária para exibir todos os dados -->
                        <table>
						    <thead>
						        <tr>
						            <th>Matrícula</th>
						            <th>Tipo Motor</th>
						            <th>Localidade</th>
						            <th>Tipo</th>
						            <th>Marca</th>
						            <th>Ações</th>
						        </tr>
						    </thead>
						    <tbody>
						    <%
						    while (resultado.next()) {
						        %>
						        <tr>
						            <td><%= resultado.getString("Matricula") %></td>
						            <td><%= resultado.getString("TipoMotor") %></td>
						            <td><%= resultado.getString("LocalidadeVeiculo") %></td>
						            <td><%= resultado.getString("Tipo") %></td>
						            <td><%= resultado.getString("Marca") %></td>
						            <td>
						                <form action="confirmarAtribuir.jsp" method="post">
						                    <input type="hidden" name="matricula" value="<%= resultado.getString("Matricula") %>">
						                    <input type="text" name="idReserva" placeholder="IDReserva" required>
						                    <button type="submit">Atribuir</button>
						                </form>
						            </td>
						        </tr>
						        <%
						    }
						    %>
						    </tbody>
						</table>
                        <%
                    }
                }
            }
        } catch (SQLException e) {
            out.println("<p>Erro ao realizar a pesquisa: " + e.getMessage() + "</p>");
        }
    }
%>	
</body>
</html>