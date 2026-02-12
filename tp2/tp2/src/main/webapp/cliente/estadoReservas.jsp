<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, sql.DatabaseConnection, java.text.DecimalFormat" %>
<%@ page import="java.util.Currency" %>
<!DOCTYPE html>
<html lang="pt">
<head>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Consultar Estado da Reserva</title>
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
        
	    .texto {
	        padding: 100px 50px 50px 50px;
        	height: 100px;
        	width: 900px;
        	align-items: center;
        	text-align: center; 
	    }
	
	    form {
	        display: flex;
	        flex-direction: column;
	    }
	
	    label {
	        margin-bottom: 5px;
	        font-size: 1.4rem;
	    }
	
	    input[type="text"], select {
	        padding: 10px;
	        margin-bottom: 15px;
	        font-size: 1rem;
	        border: 1px solid #ccc;
	        border-radius: 5px;
	    }
	
	    input[type="submit"] {
	        padding: 10px;
	        background-color: #4c5c6c;
	        color: white;
	        border: none;
	        border-radius: 10px;
	        font-size: 1rem;
	        cursor: pointer;
	        transition: background-color 0.3s;
	    }
	
	    input[type="submit"]:hover {
	        background-color: #3a4b5c;
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
	conseguir realizar a reserva de um veiculo -->
    <div class="texto">
    <h1>Consultar o Estado da Reserva</h1>
	    <form method="post">
	        <label for="nif">NIF:</label>
	        <input type="text" id="nif" name="nif" value="<%= request.getParameter("nif") != null ? request.getParameter("nif") : "" %>" required><br><br>
	
	        <label for="numeroCarta">Número da Carta de Condução:</label>
	        <input type="text" id="numeroCarta" name="numeroCarta" value="<%= request.getParameter("numeroCarta") != null ? request.getParameter("numeroCarta") : "" %>"><br><br>
	
	        <label for="moeda">Moeda preferida:</label>
	        <select id="moeda" name="moeda" required>
	            <option value="EUR" <%= "EUR".equals(request.getParameter("moeda")) ? "selected" : "" %>>Euro (EUR)</option>
	            <option value="USD" <%= "USD".equals(request.getParameter("moeda")) ? "selected" : "" %>>Dólar (USD)</option>
	            <option value="GBP" <%= "GBP".equals(request.getParameter("moeda")) ? "selected" : "" %>>Libra Esterlina (GBP)</option>
	        </select><br><br>
	
	        <label for="codigoDesconto">Código de Desconto (opcional):</label>
	        <input type="text" id="codigoDesconto" name="codigoDesconto" value="<%= request.getParameter("codigoDesconto") != null ? request.getParameter("codigoDesconto") : "" %>"><br><br>
	
	        <input type="submit" value="Consultar Reservas">
	    </form>
	    
	    <%
	    
	    //Para se conseguir efetuar uma reserva, o cliente necessita de disponibilizar
	    //os dados necessários para a mesma, ou seja, nif, numero da carta de condução, 
	    //moeda preferencial e codigoDesconto se o cliente possuir um.
        String nifCliente = request.getParameter("nif");
        String numeroCarta = request.getParameter("numeroCarta");
        String moedaPreferida = request.getParameter("moeda");
        String codigoDesconto = request.getParameter("codigoDesconto");
        
        //São criadas duas variaveis com o objetivo de armazenar o desconto e o valor do mesmo.
        double desconto = 0;
        double descontoValor = 0;
        StringBuilder mensagemDesconto = new StringBuilder();

        //Nexta parte, apenas são convertidas as moedas para usd e gbp a partir do euro, consoante a moeda que
        //o cliente escolher fazer o pagamento.
        double taxaConversao = "USD".equals(moedaPreferida) ? 1.04 : "GBP".equals(moedaPreferida) ? 0.83 : 1.0;

     	// Verificar se um código de desconto foi fornecido
        if (codigoDesconto != null && !codigoDesconto.isEmpty()) {
            if (codigoDesconto.startsWith("DISCOUNT")) {
                try {
                    //Depois do utilizador escrever o seu respetivo desconto, mais uma vez, o mesmo tem de
                    //começar por DISCOUNT, sendo que o valor que meter a seguir é o que conta para o calculo
                    double descontoCodigo = Integer.parseInt(codigoDesconto.replace("DISCOUNT", "")) / 100.0;
                    desconto = descontoCodigo;
                    mensagemDesconto.append("<p>Desconto aplicado pelo código: ").append(descontoCodigo * 100).append("%</p>");
                } catch (NumberFormatException e) {
                    mensagemDesconto.append("<p>Código de desconto inválido. Nenhum desconto será aplicado.</p>");
                }
            }
        }
        
     	//De seguida, uma tentativa de conexão à base de dados, para se conseguir verificar a reputação
     	//do condutor caso o numero respetivo da sua carta de condução tenha sido fornecido.
        try (Connection conn = DatabaseConnection.getConnection()) {
            int reputacao = 0;
            if (numeroCarta != null && !numeroCarta.isEmpty()) {
                String reputacao1 = "SELECT Reputacao FROM Condutor WHERE NumeroCarta = ?";
                try (PreparedStatement reputacaoState = conn.prepareStatement(reputacao1)) {
                	reputacaoState.setString(1, numeroCarta);
                    try (ResultSet resultado = reputacaoState.executeQuery()) {
                        if (resultado.next()) {
                            reputacao = resultado.getInt("Reputacao");
                            out.println("<h2>Reputação do Condutor (Número da Carta " + numeroCarta + "): " + reputacao + "/10</h2>");
                        } else {
                            out.println("<p>Sem informações de reputação para o condutor com o número de carta fornecido</p>");
                        }
                    }
                }
            }

            //Tendo em conta a reputaçao do cliente, se o mesmo tiver 10 na sua carta de condução
            //será aplicado um desconto automático de 15%
            if (reputacao == 10) {
                descontoValor = 0.15;
                out.println("<p>Desconto de 15%: Reputação perfeita (DISCOUNT15)</p>");
            }

            //De seguida, o mesmo será feito para se o cliente for uma empresa, ou seja, irá ser efetuada uma consulta à base de dados
            //selecionar o NIF do cliente, e verificar qual é que é o tipo de cliente a efetuar uma reserva
            String desconto1 = "SELECT Tipo FROM Cliente WHERE NIF = ?";
            String tipoCliente = null;
            try (PreparedStatement descontoState = conn.prepareStatement(desconto1)) {
            	descontoState.setString(1, nifCliente);
                try (ResultSet resultado = descontoState.executeQuery()) {
                    if (resultado.next()) {
                        tipoCliente = resultado.getString("Tipo");
                    }
                }
            }
			//Se o cliente, for efetivamente uma empresa, será aplicado um desconto de 20%.
            if ("empresa".equalsIgnoreCase(tipoCliente)) {
            	descontoValor = Math.max(desconto, 0.20);
                out.println("<p>Desconto de 20%: Cliente do tipo Empresa (DISCOUNT20)</p>");
            }

            //Por fim, também foi incluído a situação do cliente efetuar a reserva de um motociclo.
            //Mais uma vez, selecionar o tipo de reserva efetuada. Neste caso, estas reservas são
            //as reservas pendentes
            String tipoReserva1 = "SELECT Tipo FROM Reservas WHERE NIFClienteReserva = ? ";
            String tipoReserva = null;
            try (PreparedStatement tipoVeiculoState = conn.prepareStatement(tipoReserva1)) {
            	tipoVeiculoState.setString(1, nifCliente);
                try (ResultSet resultado = tipoVeiculoState.executeQuery()) {
                    if (resultado.next()) {
                    	//Se efetivamente a reserva efetuado for de um motociclo, o cliente
                    	//terá um desconto de 10%
                    	tipoReserva = resultado.getString("Tipo");
                        if ("motociclo".equalsIgnoreCase(tipoReserva)) {
                        	descontoValor = Math.max(desconto, 0.10);
                            out.println("<p>Desconto de 10%: Veículo do tipo Motociclo (DISCOUNT10)</p>");
                        }
                    }
                }
            }
            
            
            //O mesmo será feito para as reservas do aluguer, ou seja, as reservas confirmadas
            String tipoAluguer1 = "SELECT Tipo FROM Aluguer WHERE NIFCliente = ? ";
            String tipoAluguer = null;
            try (PreparedStatement tipoVeiculoState = conn.prepareStatement(tipoAluguer1)) {
            	tipoVeiculoState.setString(1, nifCliente);
                try (ResultSet resultado = tipoVeiculoState.executeQuery()) {
                    if (resultado.next()) {
                    	tipoAluguer = resultado.getString("Tipo");
                        if ("motociclo".equalsIgnoreCase(tipoAluguer)) {
                        	descontoValor = Math.max(desconto, 0.10);
                            out.println("<p>Desconto de 10%: Veículo do tipo Motociclo (DISCOUNT10)</p>");
                        }
                    }
                }
            }
            

        }
        
		//De seguida, se o nif do cliente nao for nulo nem vazio, uma tentativa de ceonxão à base de dados será efetuada.
        if (nifCliente != null && !nifCliente.isEmpty()) {
            try (Connection conn = DatabaseConnection.getConnection()) {
                //Se a mesma for bem sucedida, irão ser consultadas todas as reservas da tabela reservas
                try (PreparedStatement reservasState = conn.prepareStatement("SELECT * FROM Reservas WHERE NIFClienteReserva = ?")) {
                	reservasState.setString(1, nifCliente);
                    try (ResultSet resultado = reservasState.executeQuery()) {
                        if (resultado.next()) {
                            out.println("<h2>Reservas Pendentes:</h2>");
                            do {
                                double custoOriginal = resultado.getDouble("Custo");
                                double custo = custoOriginal;

                                //Irá ser então ser exibido o custo original da reserva para depois se aplicar o seu desconto
                                //apresentá-lo também no site.
                                out.println("<p>ID Reserva: " + resultado.getInt("IDReserva") + "</p>");
                                out.println("<p>Custo original: " + new DecimalFormat("#.##").format(custoOriginal) + " " + moedaPreferida + "</p>");
                                //Se existir algum tipo de desconto, o mesmo será aplicado ao custo original da reserva
                                if (desconto > 0) {
                                    custoOriginal *= (1 - desconto);                                   
                                }
                                if (descontoValor > 0) {
                                    custo *= (1 - descontoValor);                                  
                                }
                                //Será apresentado então o custo com o seu respetivo desconto.
                                out.println("<p>Custo com desconto aplicado: " + new DecimalFormat("#.##").format(custo) + " " + moedaPreferida + "</p>");
                                
                              
                                //Depois do custo calculado, o mesmo será atualizado na tabela de reservas só após de ser
                                //aplicado o o seu respetivo desconto
                                if (desconto > 0) {
                                    try (PreparedStatement atualizarState = conn.prepareStatement("UPDATE Reservas SET Custo = ? WHERE IDReserva = ?")) {
                                    	atualizarState.setDouble(1, custo);
                                    	atualizarState.setInt(2, resultado.getInt("IDReserva"));
                                    	atualizarState.executeUpdate();
                                    }
                                }

                            } while (resultado.next());
                        }
                    }
                }

                // Consultar alugueres confirmados
                try (PreparedStatement stmt = conn.prepareStatement("SELECT * FROM Aluguer WHERE NIFCliente = ?")) {
                    stmt.setString(1, nifCliente);
                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) {
                            out.println("<h2>Reservas Confirmadas:</h2>");
                            do {
                                double custoOriginal = rs.getDouble("Custo");  // Custo original do aluguer
                                double custo = custoOriginal * taxaConversao;  // Aplicar a taxa de câmbio
            
                                // Exibir o custo original
                                out.println("<p>ID Aluguer: " + rs.getInt("IDAluguer") + "</p>");
                                out.println("<p>Custo original: " + new DecimalFormat("#.##").format(custoOriginal) + " " + moedaPreferida + "</p>");
								
                                
                             // Se um desconto for inserido, aplicá-lo
                                if (desconto > 0) {
                                    custoOriginal *= (1 - desconto); // Aplicar o desconto ao custo                                    
                                }
                                
                                if (descontoValor > 0) {
                                    custo *= (1 - descontoValor); // Aplicar o desconto ao custo                                    
                                }

                                // Exibir o custo atualizado após desconto
                                out.println("<p>Custo com desconto aplicado: " + new DecimalFormat("#.##").format(custo) + " " + moedaPreferida + "</p>");
                                
                             	// Exibir avaliações da reserva
                                String sqlAvaliacoes = "SELECT Classificacao, Comentario FROM Avaliacao WHERE IDAluguerAval = ?";
                                try (PreparedStatement stmtAvaliacoes = conn.prepareStatement(sqlAvaliacoes)) {
                                    stmtAvaliacoes.setInt(1, rs.getInt("IDAluguer"));  // Alterado de IDReserva para IDAluguer
                                    try (ResultSet rsAvaliacoes = stmtAvaliacoes.executeQuery()) {
                                        if (rsAvaliacoes.next()) {
                                            out.println("<h3>Avaliações:</h3>");
                                            do {
                                                out.println("<p>Classificação: " + rsAvaliacoes.getInt("Classificacao") + "/10</p>");
                                                out.println("<p>Comentário: " + rsAvaliacoes.getString("Comentario") + "</p>");
                                            } while (rsAvaliacoes.next());
                                        } else {
                                            out.println("<p>Sem avaliações para esta reserva.</p>");
                                        }
                                    }
                                }
                                

                                //Depois do custo calculado, o mesmo será atualizado na tabela de reservas só após de ser
                                //aplicado o o seu respetivo desconto
                                if (desconto > 0) {
                                    try (PreparedStatement updateDesconto = conn.prepareStatement("UPDATE Aluguer SET Custo = ? WHERE IDAluguer = ?")) {
                                    	updateDesconto.setDouble(1, custo);
                                    	updateDesconto.setInt(2, rs.getInt("IDAluguer"));
                                    	updateDesconto.executeUpdate();
                                    }
                                }
                             
                            } while (rs.next());
                        }
                    }
                }
            } catch (SQLException e) {
                out.println("<p>Erro ao acessar a base de dados: " + e.getMessage() + "</p>");
            }
        } else {
            out.println("<p>Por favor, insira um NIF válido.</p>");
        }

        if (mensagemDesconto.length() > 0) {
            out.println("<div id='descontos'>" + mensagemDesconto.toString() + "</div>");
        }
        
    %>
    </div>  
</body>
</html>
