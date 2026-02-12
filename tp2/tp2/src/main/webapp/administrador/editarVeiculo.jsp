<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, sql.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Editar Veículo</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f4f4f4;
		}
        .editarVeiculo {
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
		
		.btn-main {
            background-color: #4c5c6c;
            color: white;
            padding: 8px 12px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.3s ease;
            margin-bottom: 40px;
            text-decoration: none;
        }
        
        .btn-main:hover{
            background-color: #2b4259;
            transform: scale(1.1);
        }
    </style>
</head>
<body>
    <%
	    //Um script é necessário para editar um dos veiculos escolhidos, já existentes.
		//Primeiramente, como a matricula é uma primary key, é apenas dela que se necessita para
		//identificar o veiculo, e inicializa as outras diversas variáveis associadas ao mesmo,
		//onde as mesmas podem ser editadas.
        String matricula = request.getParameter("matricula");
        String tipoMotor = "", capacidadeCarga = "", potencia = "", quilometrosFeitos = "";
        String quantidadeLugares = "", quantidadePortas = "", idTipo = "", localidade = "", chassi = "";
        String modelo = "", tipo = "", marca = "";

      	//Uma verificação é feita apenas para averiguar se a matricula não é nula, vai ser efetuada uma
        //conexão à base de dados onde será selecionado tudo do veiculo com a sua determinada matricula.
        try (Connection conn = DatabaseConnection.getConnection()) {
            if (matricula != null && !matricula.isEmpty()) {
                String veiculo = "SELECT * FROM veiculo WHERE Matricula = ?";
                try (PreparedStatement veiculoSate = conn.prepareStatement(veiculo)) {
                	veiculoSate.setString(1, matricula);
                    try (ResultSet resultado = veiculoSate.executeQuery()) {
                    	//E se o veiculo for encontrado na base de dados, os dados do mesmo
                    	//irão ser armazenados nas variáveis seguintes, correspondentes.
                        if (resultado.next()) {
                            tipoMotor = resultado.getString("TipoMotor");
                            capacidadeCarga = resultado.getString("CapacidadeCarga");
                            potencia = resultado.getString("Potencia");
                            quilometrosFeitos = resultado.getString("QuilometrosFeitos");
                            quantidadeLugares = resultado.getString("QuantidadeLugares");
                            quantidadePortas = resultado.getString("QuantidadePortas");
                            idTipo = resultado.getString("IDTipoVeiculo");
                            localidade = resultado.getString("LocalidadeVeiculo");
                            chassi = resultado.getString("ChassiVeiculo");
                        }
                    }
                }

              	//Uma verificação irá ser realizada com o intuito de garantir que o valor
              	//do chassi do veiculo seja válido antes de se consultar a base de dados
                if (chassi != null && !chassi.isEmpty()) {
                    String tipoVeiculo = "SELECT * FROM TipoVeiculo WHERE Chassi = ?";
                    try (PreparedStatement chassiSate = conn.prepareStatement(tipoVeiculo)) {
                    	chassiSate.setString(1, chassi);
                        try (ResultSet resultado = chassiSate.executeQuery()) {
                            if (resultado.next()) {
                                modelo = resultado.getString("Modelo");
                                tipo = resultado.getString("Tipo");
                                marca = resultado.getString("Marca");
                            }
                        }
                    }
                }
            }
        } catch (SQLException e) {
            out.println("<p>Erro ao conectar à base de dados.</p>");
        }

        //De seguida, irá ser averiguada uma verificação que permite adquirir os 
        //parâmetros no formulário e atualizá-los conforme necessário.
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            tipoMotor = request.getParameter("tipoMotor");
            capacidadeCarga = request.getParameter("capacidadeCarga");
            potencia = request.getParameter("potencia");
            quilometrosFeitos = request.getParameter("quilometrosFeitos");
            quantidadeLugares = request.getParameter("quantidadeLugares");
            quantidadePortas = request.getParameter("quantidadePortas");
            idTipo = request.getParameter("idTipo");
            localidade = request.getParameter("localidade");         
            modelo = request.getParameter("modelo");
            tipo = request.getParameter("tipo");
            marca = request.getParameter("marca");

            //Uma nova tentativa de conexão será feita com a base de dados para se verificar
            //se existem mudanças nos dados do veiculo ou não.
            try (Connection conn = DatabaseConnection.getConnection()) {
                String updateVeiculo = "UPDATE veiculo SET TipoMotor = ?, CapacidadeCarga = ?, Potencia = ?, QuilometrosFeitos = ?, QuantidadeLugares = ?, QuantidadePortas = ?, IDTipoVeiculo = ?, LocalidadeVeiculo = ? WHERE Matricula = ?";
                //A utilização de WHERE Matricula = ? será para garantir que todos os dados a serem atualizados
                //apenas correspondem ao veiculo com a determinada matricula
                try (PreparedStatement veiculoState = conn.prepareStatement(updateVeiculo)) {
                	veiculoState.setString(1, tipoMotor);
                	veiculoState.setString(2, capacidadeCarga);
                	veiculoState.setString(3, potencia);
                	veiculoState.setString(4, quilometrosFeitos);
                	veiculoState.setString(5, quantidadeLugares);
                    veiculoState.setString(6, quantidadePortas);
                    veiculoState.setString(7, idTipo);
                    veiculoState.setString(8, localidade);
                    veiculoState.setString(9, matricula);

                    veiculoState.executeUpdate();
                }
				
                //O mesmo que foi executado na tebalo veiculo, irá ser executado na tabela tipoVeiculo
                //mas desta vez com o determinado chassi, sendo que é a primary key
                String updateTipoVeiculo = "UPDATE TipoVeiculo SET IDTipo = ?, Modelo = ?, Tipo = ?, Marca = ? WHERE Chassi = ?";
                try (PreparedStatement tipoVeiculoState = conn.prepareStatement(updateTipoVeiculo)) {
                	tipoVeiculoState.setString(1, chassi);
                	tipoVeiculoState.setString(2, idTipo);
                	tipoVeiculoState.setString(3, modelo);
                	tipoVeiculoState.setString(4, tipo);
                	tipoVeiculoState.setString(5, marca);

                	tipoVeiculoState.executeUpdate();
                }

                out.println("<p>Veículo atualizado com sucesso!</p>");
                
            } catch (SQLException e) {
                out.println("<p>Erro ao atualizar os dados.</p>");
                out.println("<p>Detalhes do erro: " + e.getMessage() + "</p>");
            }
        }
    %>
    <!-- Na mesma página, é criado um formulário com o objetivo do administrador
	conseguir editar um dos veiculos já existentes na base de dados -->
	<center><h2>Editar Veículo</h2></center> 
    <div class="editarVeiculo">
        <form action="editarVeiculo.jsp" method="post">
            <input type="hidden" name="matricula" value="<%= matricula %>">

            <div class="group">
                <label for="tipoMotor">Tipo de Motor:</label>
                <input type="text" id="tipoMotor" name="tipoMotor" value="<%= tipoMotor %>">
            </div>

            <div class="group">
                <label for="capacidadeCarga">Capacidade de Carga:</label>
                <input type="text" id="capacidadeCarga" name="capacidadeCarga" value="<%= capacidadeCarga %>">
            </div>

            <div class="group">
                <label for="potencia">Potência:</label>
                <input type="text" id="potencia" name="potencia" value="<%= potencia %>">
            </div>
            
            <div class="group">
                <label for="quilometrosFeitos">Quilometros Feitos:</label>
                <input type="text" id="quilometrosFeitos" name="quilometrosFeitos" value="<%= quilometrosFeitos %>">
            </div>
            
            <div class="group">
                <label for="quantidadeLugares">Quantidade de Lugares:</label>
                <input type="text" id="quantidadeLugares" name="quantidadeLugares" value="<%= quantidadeLugares %>">
            </div>

            <div class="group">
                <label for="quantidadePortas">Quantidade de Portas:</label>
                <input type="text" id="quantidadePortas" name="quantidadePortas" value="<%= quantidadePortas %>">
            </div>

            <div class="group">
                <label for="modelo">Modelo:</label>
                <input type="text" id="modelo" name="modelo" value="<%= modelo %>">
            </div>

            <div class="group">
                <label for="idTipo">ID Tipo:</label>
                <input type="text" id="idTipo" name="idTipo" value="<%= idTipo %>">
            </div>
            
            <div class="group">
                <label for="tipo">Tipo:</label>
                <input type="text" id="tipo" name="tipo" value="<%= tipo %>">
            </div>

            <div class="group">
                <label for="marca">Marca:</label>
                <input type="text" id="marca" name="marca" value="<%= marca %>">
            </div>
                       
            <div class="group">
                <label for="localidade">Localidade:</label>
                <input type="text" id="localidade" name="localidade" value="<%= localidade %>">
            </div>

             <center><button type="submit" class="btn-main">Atualizar Veículo</button></center>
        </form>
        <center><a href="adminVeiculos.jsp" class="btn-main">Voltar</a></center>
    </div>
</body>
</html>
