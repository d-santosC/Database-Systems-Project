<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, sql.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Editar Reserva</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f4f4f4;
		}
        .editarReserva {
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
		
		.group select {
		    width: 72%;
		    padding: 10px;
		    font-size: 14px;
		    border: 1px solid grey;
		    border-radius: 5px;
		}
		
		.group input{
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
	    //Um script é necessário para editar uma das reservas pendentes.
		//Primeiramente, como o idReserva é uma primary key, é apenas dele que se necessita para
		//identificar a reserva, e inicializa as outras diversas variáveis associadas à mesma,
		//onde podem ser editadas.
        String idReserva = request.getParameter("idReserva");
        String tipo = "";
        String marca = "";
        String horaInicio = "";
        String horaFim = "";
        String localidade = "";
        
        //Uma verificação é feita apenas para averiguar se o idReserva não é nulo, vai ser efetuada uma
        //conexão à base de dados onde será selecionado tudo da tabela reservas com o seu determinado idReserva
        if (idReserva != null && !idReserva.isEmpty()) {
            try (Connection conn = DatabaseConnection.getConnection()) {
                String reserva = "SELECT * FROM reservas WHERE IDReserva = ?";
                try (PreparedStatement reservaState = conn.prepareStatement(reserva)) {
                	reservaState.setString(1, idReserva);
                    try (ResultSet resultado = reservaState.executeQuery()) {
                        if (resultado.next()) {     
                        	//E se a reserva for encontrada na baswe de dados, os dados da mesma
                        	//irão ser armazenados nas variáveis seguintes, correspondentes.
                        	tipo = resultado.getString("Tipo");
                        	marca = resultado.getString("Marca");
                        	horaInicio = resultado.getString("HoraInicioReserva");
                        	horaFim = resultado.getString("HoraFimReserva");
                        	localidade = resultado.getString("LocalidadeParque");                          
                        } else {
                            out.println("<p>Reserva não encontrada.</p>");
                        }
                    }
                }
            } catch (SQLException e) {
                out.println("<p>Erro ao conectar à base de dados: " + e.getMessage() + "</p>");
            }
        }
		
        //De seguida, irá ser averiguada uma verificação que permite adquirir os 
        //parâmetros no formulário e atualizá-los conforme necessário.
        if ("POST".equalsIgnoreCase(request.getMethod())) {            
            tipo = request.getParameter("tipo");
            marca = request.getParameter("marca");
            horaInicio = request.getParameter("horaInicio");
            horaFim = request.getParameter("horaFim");
            localidade = request.getParameter("localidade");
			
            //Uma nova tentativa ne conexão será feita com a base de dados para se verificar
            //se existem mudanças nos dados das reservas ou não.
            try (Connection conn = DatabaseConnection.getConnection()) {
                //Será entao criada uma instância de StringBuilder para se conseguir construir
            	//uma string com várias partes, como neste caso, o uso do UPDATE reservas SET com
            	//todos os seus parâmetros, que podem ou não ser alterados.
                StringBuilder updateState = new StringBuilder("UPDATE reservas SET ");
            	
                //Uma variável booleana e criada para verificar se existem mudanças nos dados
            	//da reserva em questão ou não.
                boolean mudancas = false;

                //Para todas as verificações seguintes, é averiguado se o label em questão
            	//(tipo, marca, localidadeparque, etc) não é nulo e não está vazio. E se assim 
            	//acontecer, cada um dos campos serão incluídos na consulta à base de dados para
            	//serem atualizados, e define que existiram alterações, ou seja, o campo será atualizado
                if (tipo != null && !tipo.isEmpty()) {
                	updateState.append("Tipo = ?, ");
                	mudancas = true;
                }
                if (marca != null && !marca.isEmpty()) {
                	updateState.append("Marca = ?, ");
                	mudancas = true;
                }
                if (horaInicio != null && !horaInicio.isEmpty()) {
                	updateState.append("HoraInicioReserva = ?, ");
                	mudancas = true;
                }
                if (horaFim != null && !horaFim.isEmpty()) {
                	updateState.append("HoraFimReserva = ?, ");
                	mudancas = true;
                }
                if (localidade != null && !localidade.isEmpty()) {
                	updateState.append("LocalidadeParque = ?, ");
                	mudancas = true;
                }

                //De seguida, se tiverem existido quaisquer tipos de alterações aos dados da reserva,
                //será necessário o comando WHERE IDReserva = ?, para garantir que a reserva correta em questão
                //é a mesma a ser atualizada, ao conseguir identificá-lo pelo IDReserva.
                if (mudancas) {
                	updateState.setLength(updateState.length() - 2);
                	updateState.append(" WHERE IDReserva = ?");

                	//Entra-se então na consulta para se conseguir executar, de forma segura, a troca
                	//dos valores alterados pelos parâmetros definidos abaixo.
                    try (PreparedStatement trocaState = conn.prepareStatement(updateState.toString())) {
                    	
                    	//É criada uma variável para permitir a ordem dos parâmetros a consultar, tal 
                    	//como pela ordem os quais foram verificados.
                    	int indexParametros = 1;

                    	//Faz-se então a verificação de que nenhum campo é nulo ou vazio e atribui-se o
                    	//valor correspondente aos parâmetros de consulta.
                        if (tipo != null && !tipo.isEmpty()) trocaState.setString(indexParametros++, tipo);
                        if (marca != null && !marca.isEmpty()) trocaState.setString(indexParametros++, marca);
                        if (horaInicio != null && !horaInicio.isEmpty()) trocaState.setString(indexParametros++, horaInicio);
                        if (horaFim != null && !horaFim.isEmpty()) trocaState.setString(indexParametros++, horaFim);
                        if (localidade != null && !localidade.isEmpty()) trocaState.setString(indexParametros++, localidade);

                        //Como se selecionou a reserva a partir do seu idReserva não é necessário verificação.
                        trocaState.setString(indexParametros, idReserva);

                        //Uma variável criada para verificar o número de linhas que foram atualizadas e se
                        //o número das mesmas for maior que 0, significa que a reserva foi atualizada com
                        //sucesso.
                        int linhasAtualizadas = trocaState.executeUpdate();
                        if (linhasAtualizadas > 0) {
                            out.println("<p>Reserva atualizada com sucesso!</p>");
                        } else {
                            out.println("<p>Erro ao atualizar reserva.</p>");
                        }
                    }
                } else {
                    out.println("<p>Nenhum campo foi alterado.</p>");
                }
            } catch (SQLException e) {
                out.println("<p>Erro ao atualizar a base de dados: " + e.getMessage() + "</p>");
            }
        }
    %>

<!-- Na mesma página, é criado um formulário com o objetivo de se conseguir
editar uma reserva pendente feita por um cliente -->
<center><h2>Editar Reserva</h2></center>
    <div class="editarReserva">
        <form action="editarReserva.jsp" method="post">
            <input type="hidden" name="idReserva" value="<%= idReserva %>">

            <div class="group">
                <label for="tipo">Selecione o Tipo de Veículo:</label>
		        <select id="tipo" name="tipo">
		            <option value="<%= tipo %>"><%= tipo %></option>
		            <option value="Comercial">Comercial</option>
		            <option value="Familiar">Familiar</option>
		            <option value="Motociclo">Motociclo</option>
		        </select>
            </div>

            <div class="group">
                <label for="marca">Marca:</label>
                <input type="text" id="marca" name="marca" value="<%= marca %>">
            </div>
            
            <div class="group">
                <label for="horaInicio">Data/Hora de Início:</label>
        		<input type="text" id="horaInicio" name="horaInicio" value="<%= horaInicio %>">
            </div>

            <div class="group">
                <label for="horaFim">Data/Hora de Fim:</label>
        		<input type="text" id="horaFim" name="horaFim" value="<%= horaFim %>">
            </div>

            <div class="group">
                <label for="parque">Localidade do Parque:</label>
		        <select id="parque" name="localidade">
		            <option value="<%= localidade %>"><%= localidade %></option>
		            <%
		            	//Um script necessário para se conseguir efetuar uma consulta à base de 
		            	//dados e verificar todas as localidades da tabela ParqueEstacionamento
		                try (Connection conn = DatabaseConnection.getConnection()) {
		                    String parque = "SELECT Localidade FROM ParqueEstacionamento";
		                    try (Statement parqueState = conn.createStatement(); 
		                    	ResultSet resultado = parqueState.executeQuery(parque)) {
		                        while (resultado.next()) {
		                            String localidade1 = resultado.getString("Localidade");
		            %>				
		            				<!--Depois de sabidas todas as localidades de parque disponiveis,
		            				consegue-se colocar cada uma delas num option value para o funcionario
		            				as conseguir editar. -->
		                            <option value="<%= localidade1 %>"><%= localidade1 %></option>
		            <%
		                        }
		                    }
		                } catch (SQLException e) {
		                    out.println("<option disabled>Erro ao carregar as localidades</option>");
		                }
		            %>
		        </select>
            </div>

            <center><button type="submit" class="btn-main">Atualizar Cliente</button></center>
        </form>
        <center><a href="atribuirVeiculo.jsp" class="btn-main">Voltar</a></center>
    </div>

</body>
</html>
