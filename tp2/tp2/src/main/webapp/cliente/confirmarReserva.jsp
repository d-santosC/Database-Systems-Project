<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*, sql.DatabaseConnection, java.time.LocalDateTime, java.time.LocalDate, java.time.temporal.ChronoUnit, java.time.DayOfWeek, java.time.format.DateTimeFormatter" %>
<%
	//É necessário criar diversas variáveis com o objetivo de conseguir
	//adquirir todos os parâmetros preenchidos no formulário.
	String tipo = request.getParameter("tipo"); 
	String parque = request.getParameter("parque");
	String inicioStr = request.getParameter("inicio");
	String fimStr = request.getParameter("fim");
	String codigoDesconto = request.getParameter("codigoDesconto");
	String nif = request.getParameter("nif");
	String numeroCarta = request.getParameter("numeroCarta"); 
	String marca = request.getParameter("marca");
	String dataEmissao = request.getParameter("dataEmissao"); 
	String dataValidade = request.getParameter("dataValidade"); 
	String reputacao = request.getParameter("reputacao"); 
	
	//Apenas a conversão de ambas as datas de emissao e validade no
	//formato mais facilitado yyy-mm-dd
	DateTimeFormatter formato = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	LocalDate emissao = LocalDate.parse(dataEmissao, formato);
	LocalDate validade = LocalDate.parse(dataValidade, formato);
	
	
	try (Connection conn = DatabaseConnection.getConnection()) {
	    //Como na reserva de um veiculo todos os campos de dados devem ser preenchidos,
	    //se os mesmos nao forem todos preenchidos um erro irá ser demonstrado.
	    if (tipo == null || parque == null || inicioStr == null || fimStr == null || nif == null ||
	    	numeroCarta == null || marca == null || dataEmissao == null || dataValidade == null || reputacao == null) {
	        throw new IllegalArgumentException("Todos os campos obrigatórios devem ser preenchidos");
	    }
	
	    //Depois da tentativa de conexão ser bem sucedida, é necessário ir à procurar do NIF 
	    //do cliente para o mesmo poder fazer a reserva.
	    String verificarNIF = "SELECT COUNT(*) AS ClienteExiste FROM cliente WHERE NIF = ?";
	    try (PreparedStatement clienteState = conn.prepareStatement(verificarNIF)) {
	    	clienteState.setString(1, nif);
	        try (ResultSet resultado = clienteState.executeQuery()) {
	            if (resultado.next() && resultado.getInt("ClienteExiste") == 0) {
	                response.sendRedirect("erroCliente.jsp");
	                return;
	            }
	        }
	    }
	
	    //De seguida, é necessário também a verificação do numero da carta do condutor para averiguar se o mesmo
	    //já existe na tabela condutor.
	    String verificaNumCarta = "SELECT COUNT(*) AS CartaExiste FROM condutor WHERE NumeroCarta = ?";
	    try (PreparedStatement numCartaState = conn.prepareStatement(verificaNumCarta)) {
	    	numCartaState.setString(1, numeroCarta);
	        try (ResultSet resultado = numCartaState.executeQuery()) {
	            if (resultado.next() && resultado.getInt("CartaExiste") == 0) {
	                //Se o mesmo não for encontrado, ou seja, resultado.getInt("CartaExiste") == 0,
	                //irá ser inserido um condutor com todos esses dados necessários, sobre o seu NIF e carta de condução.
	                String inserirCondutor = "INSERT INTO condutor (NumeroCarta, DataEmissao, DataValidade, Reputacao, NIFCliente) VALUES (?,?,?,?,?)";
	                try (PreparedStatement condutorState = conn.prepareStatement(inserirCondutor)) {
	                	condutorState.setString(1, numeroCarta);
	                	condutorState.setDate(2, java.sql.Date.valueOf(emissao));
	                	condutorState.setDate(3, java.sql.Date.valueOf(validade));
	                	condutorState.setString(4, reputacao);
	                	condutorState.setString(5, nif);
	                	condutorState.executeUpdate();
	                }
	            }
	        }
	    }
	    

	    //Excerto de códigauxiliar para se conseguir determinar
	    //que tipo de tarifa é que está associada a cada um dos
	    //veículos criados, ou seja, 1 se for comercial, 2 se
	    //for familiar e 3 se for motociclo, pois para cada
	    //um deles irá existir um valor correspondente diferente
	    int idTarifa = 0;
	    if ("Comercial".equalsIgnoreCase(tipo)) {
	    	idTarifa = 1;
	    } else if ("Familiar".equalsIgnoreCase(tipo)) {
	    	idTarifa = 2;
	    } else if ("Motociclo".equalsIgnoreCase(tipo)) {
	    	idTarifa = 3;
	    } else {
	        throw new SQLException("Tipo de veículo inválido: " + tipo);
	    }
	
	    //De seguida, será necessário calcular o custo das tarifas distintas. Para isso
	    //serão necessárias duas variáveis que permitam armazenar os valores dos custos
	    //dos dias utieis e nao uteis.
	    double custoDiaUtil = 0.0;
	    double custoDiaNaoUtil = 0.0;
	    
	    //De seguida, uma consulta à base de dados é feita para se conseguir obter esses mesmos
	    //custos, consoante o id da tarifa correspondente
	    String tarifa = "SELECT CustoDiaUtil, CustoDiaNaoUtil FROM tarifa WHERE IDTipoTarifa = ?";
	    try (PreparedStatement tarifaState = conn.prepareStatement(tarifa)) {
	    	tarifaState.setInt(1, idTarifa);
	        try (ResultSet resultado = tarifaState.executeQuery()) {
	            if (resultado.next()) {
	            	//Se existirem entãoi os campos das tarifas, esses valores serão adicionados
	            	//as variaveis anteriormente criadas, para o calculo das mesmas
	                custoDiaUtil = resultado.getDouble("CustoDiaUtil");
	                custoDiaNaoUtil = resultado.getDouble("CustoDiaNaoUtil");
	            } else {
	                throw new SQLException("Tarifa não encontrada para o IDTipoTarifa: " + idTarifa);
	            }
	        }
	    }
	
	    //Mais uma vez, necessária a conversão das datas no mesmo formato
	    LocalDateTime inicio;
	    LocalDateTime fim;
	    try {
	        DateTimeFormatter formatoTarifa = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
	        inicio = LocalDateTime.parse(inicioStr, formatoTarifa);
            fim = LocalDateTime.parse(fimStr, formatoTarifa); 
	    } catch (Exception e) {
	        throw new IllegalArgumentException("Formato de data inválido");
	    }
	
	    //Por último, a necessidade de calcular os dias será útil também, para determinar
	    //o custo consoante o número de dias.
	    long diasUteis = 0;
	    long diasNaoUteis = 0;
	    
	    LocalDateTime temp = inicio;
	    
	    //Para se conseguir percorrer todos os dias uma variavel temp = será criada.
	    //Essa permite percorrer os dias todos até o mesmo for antes ou igual ao fim.
	    while (!temp.isAfter(fim)) {
	        DayOfWeek diaSemana = temp.getDayOfWeek();
	        if (diaSemana == DayOfWeek.SATURDAY || diaSemana == DayOfWeek.SUNDAY) {
	            diasNaoUteis++;
	        } else {
	            diasUteis++;
	        }
	        temp = temp.plusDays(1);
	    }
	
	    //A tarifa é calculada consoante os dias uteis / dias nao uteis com quais o condutor
	    //fica com o veiculo multiplicando cada um pelo custo do dia especifico, respetivamente
	    double custoBase = (diasUteis * custoDiaUtil) + (diasNaoUteis * custoDiaNaoUtil);
	
	    //A aplicação do desconto necessita de verificar se o campo do codigoDesconto está vazio ou null
	    //e se assim não acontecer, sendo que os codigos de desconto começam todos por DISCOUNT, seguido de um
	    //numero entre 0 e 100, esse mesmo numero é adicionado à variável desconto com o intuito de saber se
	    //o desconto será 10, 20, 30, etc...
	    double desconto = 0.0;
	    if (codigoDesconto != null && !codigoDesconto.isEmpty()) {
	        if (codigoDesconto.startsWith("DISCOUNT")) {
	            try {
	            	desconto = Integer.parseInt(codigoDesconto.replace("DISCOUNT", ""));
	            } catch (NumberFormatException e) {
	                throw new IllegalArgumentException("Código de desconto inválido.");
	            }
	        }
	    }
	    
	    //O custo final, é então calculado sabendo o custoBase da reserva tirando a esse valor, 
	    //o desconto aplicado do utilizador.
	    double custoFinal = custoBase - (custoBase * (desconto / 100));
	
	    // Inserir reserva na tabela Reservas
	    String inserirReserva = "INSERT INTO Reservas (Tipo, Marca, HoraInicioReserva, HoraFimReserva, LocalidadeParque, Custo, NIFClienteReserva, NumeroCartaCondutor) " +
	                            "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
	    try (PreparedStatement reservaState = conn.prepareStatement(inserirReserva)) {
	    	reservaState.setString(1, tipo);
	    	reservaState.setString(2, marca);
	    	reservaState.setTimestamp(3, Timestamp.valueOf(inicio));
	    	reservaState.setTimestamp(4, Timestamp.valueOf(fim));
	    	reservaState.setString(5, parque);
	    	reservaState.setDouble(6, custoFinal);
	    	reservaState.setString(7, nif);
	    	reservaState.setString(8, numeroCarta); 
	    	reservaState.executeUpdate();
	    }
	
	    //O resultado é apenas exibido no site com todas as informações necessárias
	    //para a confirmação da reserva
	    out.println("<h1>Reserva confirmada!</h1>");
	    out.println("<p>Veículo do Tipo: " + tipo + "</p>");
	    out.println("<p>Parque: " + parque + "</p>");
	    out.println("<p>Duração: " + ChronoUnit.DAYS.between(inicio, fim) + " noite(s)</p>");
	    out.println("<p>Custo final (com desconto): " + custoFinal + " EUR</p>");
	} catch (Exception e) {
	    out.println("<p>Erro ao processar a reserva: " + e.getMessage() + "</p>");
	}
%>
