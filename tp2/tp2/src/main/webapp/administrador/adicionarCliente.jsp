<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, sql.DatabaseConnection, java.time.*, java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

<title>Administração de Clientes</title>
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

        .iconesPaginaInicial a, .texto a {
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


        .message-container {
            text-align: center;
            margin-top: 70px;
        }

        .message-container p {
            font-size: 1.5rem;
            font-weight: bold;
            color: #333;
            background-color: rgba(255, 255, 255, 0.8);
            padding: 20px;
            border-radius: 10px;
            display: inline-block;
        }
		
		.botoes {
			padding-top: 25px;
			padding-bottom: 25px;
		    display: flex;
		    justify-content: center;
		    gap: 30px;
		}
		
		.texto a:hover {
		    transform: rotate(360deg);
		    transition: transform 1s ease;
		} 
    </style>
</head>
<body>
    <header>
		<!-- Botões criados para se conseguir navegar pelo site -->
        <div class="iconesPaginaInicial">
        	<a href="index.jsp"><i class="fa-solid fa-house"></i><span>Home</span></a>
            <a href="administrador/admin.jsp"><i class="fa-solid fa-lock"></i><span>Administração</span></a>
            <a href="cliente/cliente.jsp"><i class="fa-solid fa-user"></i><span>Cliente</span></a>
            <a href="condutor/condutor.jsp"><i class="fa-solid fa-car"></i><span>Condutor</span></a>
            <a href="funcionario/funcionario.jsp"><i class="fa-solid fa-user-tie"></i><span>Funcionário</span></a>
            <a href="gerente/gerente.jsp"><i class="fa-solid fa-users"></i><span>Gerente</span></a>
        </div>

        <h1>Empresa GoDaMa</h1>
    </header>
    
    <div class="message-container">
    <%
    	//Para se conseguir adicionar um cliente, é necessário saber todas as informações do mesmo, ou seja,
    	//um comando request.getParameter() é utilizado para pedir todos os parâmetros, que incluem, de mais
    	//importante, um nif, nome, contacto, moeda e tipo(Pessoa, Emprtesa), entre outros, sendo que a
    	//dataNascimento/capitalSocial só aparecem comnsoante a opção proposta no tipo.
        String nif = request.getParameter("nif");
        String nome = request.getParameter("nome");
        String contacto = request.getParameter("contacto");
        String moeda = request.getParameter("moeda");
        String tipo = request.getParameter("tipo");
        String rua = request.getParameter("rua");
        String porta = request.getParameter("porta");
        String andar = request.getParameter("andar");
        String codigoPostal = request.getParameter("codigoPostal");
        String distrito = request.getParameter("distrito");
        String concelho = request.getParameter("concelho");
        String freguesia = request.getParameter("freguesia");
        String pais = request.getParameter("pais");
        String dataNascimento = request.getParameter("dataNascimento");
        String capitalSocial = request.getParameter("capitalSocial");
		
        //De seguida, é necessário então utilizar a classe DatabaseConnection para se conseguir adquirir uma conexão
        //à base de dados
        try (Connection conn = DatabaseConnection.getConnection()) {
        	
        	//Se assim acontecer, irá ser verificada a morada já existe na base de dados ou não, substituindo os ?
        	// pelos valores das variáveis correspondentes aos mesmos com a ajuda do método setString()
            String verificarMorada = "SELECT COUNT(*) FROM morada WHERE Rua = ? AND Porta = ? AND Andar = ? AND CodigoPostal = ? AND Distrito = ? AND Concelho = ? AND Freguesia = ? AND Pais = ?";
            try (PreparedStatement verificarStateMorada = conn.prepareStatement(verificarMorada)) {
            	verificarStateMorada.setString(1, rua);
            	verificarStateMorada.setString(2, porta);
            	verificarStateMorada.setString(3, andar);
            	verificarStateMorada.setString(4, codigoPostal);
            	verificarStateMorada.setString(5, distrito);
            	verificarStateMorada.setString(6, concelho);
                verificarStateMorada.setString(7, freguesia);
                verificarStateMorada.setString(8, pais);
                
                //De seguida, o resultado irá ser verificado para se averiguar se a morada já se encontra na base de
                //dados. Primeiro verifica quantas vezes é que a morada aparece na tabela morada. Logo a seguir, verifica
                //o valor da primeira coluna do resultado, resultado.getInt(1), e se o mesmo for 0, a morada ainda não existe
                //e será inserida na tabela, esta verifica «é importante para não se ter entradas duplicadas.
                ResultSet resultado = verificarStateMorada.executeQuery();
                resultado.next();
                if (resultado.getInt(1) == 0) {
                   String inserirMorada = "INSERT INTO morada (Rua, Porta, Andar, CodigoPostal, Distrito, Concelho, Freguesia, Pais) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement inserirStateMorada = conn.prepareStatement(inserirMorada)) {
                	inserirStateMorada.setString(1, rua);
                	inserirStateMorada.setString(2, porta);
                	inserirStateMorada.setString(3, andar);
                	inserirStateMorada.setString(4, codigoPostal);
                	inserirStateMorada.setString(5, distrito);
                	inserirStateMorada.setString(6, concelho);
                	inserirStateMorada.setString(7, freguesia);
                	inserirStateMorada.setString(8, pais);
                	inserirStateMorada.executeUpdate();
                }
                }
            }

            //Passa-se então para a situação de inserir um novo cliente na tabela cliente na base de dados. Começa-se por
            //definir a instrução que permiteinserir o mesmo na tabela, onde os ? serão substituidos pelos valores correspondentes
            String inserirCliente = "INSERT INTO cliente (NIF, Nome, Contacto, Moeda, Tipo, Rua, Porta, Andar, CodigoPostal) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            //Para isso, é necessário aceder à instrução acima e substituir os valores
            try (PreparedStatement clienteState = conn.prepareStatement(inserirCliente)) {
            	clienteState.setString(1, nif);
            	clienteState.setString(2, nome);
            	clienteState.setString(3, contacto);
            	clienteState.setString(4, moeda);
            	clienteState.setString(5, tipo);
            	clienteState.setString(6, rua);
            	clienteState.setString(7, porta);
            	clienteState.setString(8, andar);
            	clienteState.setString(9, codigoPostal);
            	
            	//Utiliza-se o método executeUpdate() para se conseguir inserir os dados na tabela, modificando os dados na
            	//base de dados, neste caso, ao inserir um novo cliente na tabela cliente.
            	clienteState.executeUpdate();
            }

            //Irá também ser necessário verificar se o cliente a ser adicionada é uma Pessoa ou uma Empresa, logo esta verificação
            //irá averiguar se será necessário calcular a idade (para a pessoa) ou o capital social (para a empresa).
            //A primeira verificação averigua se o tipo de cliente é uma pessoa, ignorando também as maiusculas/minusculas com a 
            //ajuda do método equalsIgnoreCase().
            if ("Pessoa".equalsIgnoreCase(tipo)) {
            	//E se assim acontecer, uma nova verificação irá ser feita com o objetivo de perceber se a data de nascimento foi
            	//fornecida ou não.
                if (dataNascimento != null && !dataNascimento.isEmpty()) {
                	
                	//Se a mesma foi inserida, irá ser convertida no formato "yyyy-MM-dd" para a maior facilidade da idade do cliente
                	//ser calculada. Depois da formatação da mesma, irá ser calculada, em anos, getYears(), o período entre a data
                	//atual e a inserida.
                    DateTimeFormatter formatoData = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                    LocalDate nascimento = LocalDate.parse(dataNascimento, formatoData);
                    int idade = Period.between(nascimento, LocalDate.now()).getYears();

                    //Depois da calculada a idade do cliente, irá ser então inserida a pessoa com o seu respetivo nif e idade na tabela
                    //Pessoa com os valores correspondentes.
                    String inserirPessoa = "INSERT INTO pessoa (NIFCliente, Idade) VALUES (?, ?)";
                    try (PreparedStatement pessoaState = conn.prepareStatement(inserirPessoa)) {
                    	pessoaState.setString(1, nif);
                    	pessoaState.setInt(2, idade);
                    	pessoaState.executeUpdate();
                    }
                    out.println("<p>Pessoa adicionada com sucesso!</p>");
                } else {
                    out.println("<p>Erro: Data de nascimento é obrigatória para Pessoas.</p>");
                }
            	
              //Por outro lado, se o cliente for uma empresa, acontece a mesma verificação de ignorar maiusculas/minusculas.
            } else if ("Empresa".equalsIgnoreCase(tipo)) {
            	//E se assim acontecer, uma nova verificação irá ser feita com o objetivo de perceber se o capitalSocial foi
            	//fornecida ou não.
                if (capitalSocial != null && !capitalSocial.isEmpty()) {
                	//Como o capitalSocial é um DECIMAL(), não é necessário fazer quaisquer tipos de verificação, logo
                	//irá ser então inserida a empresa com o seu respetivo nif e capitalSocial na Empresa com os valores correspondentes.
                    String insertEmpresa = "INSERT INTO empresa (NIFCliente, CapitalSocial) VALUES (?, ?)";
                    try (PreparedStatement empresaState = conn.prepareStatement(insertEmpresa)) {
                    	empresaState.setString(1, nif);
                    	empresaState.setString(2, capitalSocial);
                    	empresaState.executeUpdate();
                    }
                    out.println("<p>Empresa adicionada com sucesso!</p>");
                } else {
                    out.println("<p>Erro: Capital social é obrigatório para Empresas.</p>");
                }
            } else {
                out.println("<p>Erro: Tipo de cliente inválido.</p>");
            }
        } catch (SQLException e) {
            out.println("<p>Erro: " + e.getMessage() + "</p>");
        }
    %>
</div>
	<!-- Botão criado para se conseguir voltar atrás -->
	<div class="texto">
	    <center><a href="adminClientes.jsp"><i class="fa-solid fa-house"></i><span>Voltar</span></a> </center> 
	</div>

</body>
</html>