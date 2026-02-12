<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, sql.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <title>Administração de Veículos</title>
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
        
        .grelhaVeiculos {
		    display: grid;
            grid-template-columns: repeat(6, 1fr);
            padding: 10px;
		}
		
		.cartoes {
		    background-color: rgba(255, 255, 255, 0.7);
		    padding: 10px;
		    border-radius: 10px;
		    width: 250px;
		    text-align: center;
		    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
		    margin-bottom: 20px;
		}
		
		.cartoes img {
		    width: 100%;
		    height: 165px;
		    border-radius: 5px;
		}
		
		.cartoes h3 {
		    font-size: 1.5rem;
		    color: #4c5c6c;
		}
		
		.cartoes p {
		    font-size: 1rem;
		    margin: 5px 0;
		}
		
		.cartoes form {
		    margin-top: 15px;
		}
		
		.cartoes button, .btn-main {
		    background-color: #4c5c6c;
            color: white;
            padding: 8px 12px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.3s ease;
		}
		
		.cartoes button:hover, .btn-main:hover {
		    background-color: #2b4259;
            transform: scale(1.05);
		}
		
		.adicionarVeiculo {
		    max-width: 1250px;
		    margin: 0 auto;
		    padding: 30px;
		    background-color: #fff;
		    border-radius: 8px;
		    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
		}
		
		.group {
		    display: flex;
		    justify-content: space-between;
		    align-items: center;
		    margin-bottom: 20px;
		}
		
		.group label {
		    width: 25%;
		    color: black;
		    font-size: 20px;
		}
		
		.group input, .group select {
		    width: 70%;
		    padding: 10px;
		    font-size: 14px;
		    border: 1px solid grey;
		    border-radius: 5px;
		}
		@media screen and (max-width: 1024px) {
        .grelhaVeiculos {
            grid-template-columns: repeat(3, 1fr); /* Menos colunas em telas menores */
        }

        .cartoes {
            padding: 10px;
            font-size: 14px;
        }

        .iconesPaginaInicial a {
            width: 75px;
            height: 55px;
            font-size: 12px;
        }

        header h1 {
            font-size: 1.7rem;
        }

        .adicionarVeiculo {
            width: 90%; /* Ajuste para telas menores */
            padding: 15px;
        }

        .group {
            flex-direction: column;
            align-items: flex-start;
        }

        .group label, .group input {
            width: 100%;
        }

        .group input {
            margin-bottom: 10px;
        }
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

        <h1>Gestão de Veículos</h1>
    </header>

    <center><h2>Lista de Veículos</h2></center>
<div class="grelhaVeiculos">
    <%
			    //Um script necessário para se conseguir exibir todos os veiculos no formato de cartões
				//Esta forma de apresentação é boa para se conseguir distinguir todos os veiculos e se conseguir
				//identificar todos os veiculos criados. 
				//Primeiramente, uma tentativa de conexão será feita para tentar aceder à base de dados.
			    try (Connection conn = DatabaseConnection.getConnection()) {
			    	
			    	//Se a conexão for bem sucedida, irá ser executada a instrução SELECT DISTINCT com
                	//o intuito de se conseguir selecionar todos os dados das tabelas necessários aos veiculos.
			        String selecionarVeiculos = "SELECT DISTINCT " +
			                     "veiculo.Matricula, veiculo.TipoMotor, veiculo.CapacidadeCarga, veiculo.Potencia, " +
			                     "veiculo.QuantidadeLugares, veiculo.QuantidadePortas, veiculo.IDTipoVeiculo, " +
			                     "tipoveiculo.Modelo, tipoveiculo.Tipo, tipoveiculo.Marca, veiculo.ChassiVeiculo " +
			                     "FROM veiculo " +
			                     "JOIN tipoveiculo ON veiculo.ChassiVeiculo = tipoveiculo.Chassi"; 
			        
			    	//De seguida, uma consulta à base de dados será realizada para se conseguir aceder a todos
			    	//os dados doss veiculos, percorrendo todos os dados, com a ajuda do metodo next().
			        try (Statement veiculoSate = conn.createStatement(); 
			    		ResultSet resultado = veiculoSate.executeQuery(selecionarVeiculos)) {
			            while (resultado.next()) {
			            	//Como o veiculo terá uma imagem associada a ele, uma variável chassiVeiculo
			            	//será criada para armazenar a chassi do mesmo, para se conseguir exibir a 
			            	//mesma ao utilizadar o chassi como paraâmetro, para a imgUrl.
			                String chassiVeiculo = resultado.getString("ChassiVeiculo");
			                String imageUrl = "../servlets/imageServlet?chassi=" + chassiVeiculo;
			%>
					<!--Esta div apenas representa os resultados da pesquida do veiculo, para
                    todos os veiculos existeentes, juntamente com as suas respetivas fotos  -->
                    <div class=cartoes>
                        <img src="<%= imageUrl %>" alt="Imagem do Veículo" width="100" height="100">
                        <p><strong>Matricula:</strong> <%= resultado.getString("Matricula") %></p>
                        <p><strong>Tipo Motor:</strong> <%= resultado.getString("TipoMotor") %></p>
                        <p><strong>Capacidade de Carga:</strong> <%= resultado.getString("CapacidadeCarga") %></p>
                        <p><strong>Potência:</strong> <%= resultado.getString("Potencia") %></p>
                        <p><strong>Quantidade de Lugares:</strong> <%= resultado.getString("QuantidadeLugares") %></p>
                        <p><strong>Quantidade de Portas:</strong> <%= resultado.getString("QuantidadePortas") %></p>
                        <p><strong>Modelo:</strong> <%= resultado.getString("Modelo") %></p>
                        <p><strong>Marca:</strong> <%= resultado.getString("Marca") %></p>
                        <form action="editarVeiculo.jsp" method="get">
                            <input type="hidden" name="matricula" value="<%= resultado.getString("Matricula") %>">
                            <button type="submit">Editar</button>
                        </form>
                    </div>
    <%
                }
            }
        } catch (SQLException e) {
            out.println("<tr><td colspan='12'>Erro ao conectar à base de dados: " + e.getMessage() + "</td></tr>");
        }
    %>
</div>


	<!-- Na mesma página, é criado um formulário com o objetivo do administrador
	conseguir adicionar um novo veiculo à base de dados, e apresentá-lo no site -->
    <center>
        <h2>Adicionar Novo Veículo</h2>
        <div class="adicionarVeiculo">
            <form action="adicionarVeiculo.jsp" method="post" enctype="multipart/form-data">
                <div class="group">
                    <label for="matricula">Matricula:</label>
                    <input type="text" id="matricula" name="matricula" required>
                    <label for="tipoMotor">Tipo de Motor:</label>
                    <input type="text" id="tipoMotor" name="tipoMotor" required>
                </div>

                <div class="group">
                    <label for="capacidadeCarga">Capacidade de Carga:</label>
                    <input type="text" id="capacidadeCarga" name="capacidadeCarga" required>
                    
                    <label for="potencia">Potência:</label>
                    <input type="text" id="potencia" name="potencia" required>
                </div>

                <div class="group">
                    <label for="quantidadeLugares">Quantidade de Lugares:</label>
                    <input type="text" id="quantidadeLugares" name="quantidadeLugares" required>
                    
                    <label for="quantidadePortas">Quantidade de Portas:</label>
                    <input type="text" id="quantidadePortas" name="quantidadePortas" required>
                </div>

                <div class="group">
                    <label for="idTipoVeiculo">ID Tipo Veículo:</label>
                    <input type="text" id="idTipoVeiculo" name="idTipoVeiculo" required>
                    
                    <label for="modelo">Modelo:</label>
                    <input type="text" id="modelo" name="modelo" required>
                </div>
                
				<div class="group">
                    <label for="tipo">Tipo:</label>
                    <input type="text" id="tipo" name="tipo" required>
                    
                    <label for="marca">Marca:</label>
                    <input type="text" id="marca" name="marca" required>
                </div>
                
                <div class="group">
                    <label for="localidade">Localidade do Veiculo:</label>
                    <input type="text" id="localidade" name="localidade" required>
                    
                    <label for="quilometros">Quilometros Feitos:</label>
                    <input type="text" id="quilometros" name="quilometros" required>
                </div>
                
                
                <div class="group">
                    <label for="chassi">Chassi:</label>
                    <input type="text" id="chassi" name="chassi" required style="width: 170%">      
                </div>
                
                <div class="group">
                <label for="imagem">Imagem do Veículo:</label>
                <input type="file" id="imagem" name="imagem" accept="image/*" required>
            	</div>

                <button type="submit" class="btn-main">Adicionar Veículo</button>
            </form>
        </div>
    </center>

</body>
</html>
