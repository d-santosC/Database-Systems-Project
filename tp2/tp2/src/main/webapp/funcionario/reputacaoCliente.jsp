<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*, java.text.DecimalFormat" %>
<%@ page import="java.sql.*, java.util.*, sql.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

<meta charset="UTF-8">
<title>Reputação do Cliente</title>
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
    
    <!-- Na mesma página, é criado um formulário com o objetivo de seconseguir
    pesquisar, pelo NIF do cliente, qual a sua reputação na carta de condução -->
    <div class="form-container">
    
    <center><h1>Reputação do Cliente</h1></center>
    <form method="post">
        <label for="nif">NIF do Cliente:</label>
        <input type="text" id="nif" name="nif" required>
        <center><button type="submit">Procurar</button></center>
    </form>
    <%
    	//Um script será necessário para se conseguir pesquisar o cliente 
        String nif = request.getParameter("nif");
        String desconto = request.getParameter("desconto");
        
        //Uma verificação será feita com o intuito de ver se o campo NIF do cliente
        //se encontra vazio ou nulo.
        if (nif != null && !nif.isEmpty()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                //Se o NIF for válido é executada uma conexão à bsase de dados
                Connection conn = DatabaseConnection.getConnection();
                
                //Depois da conexão feita, será necessário uma consulta à mesma base de dados qu
                //permite procurar todos os do cliente a partir do seu NIF.
                String cliente = "SELECT c.Nome, c.Contacto, cd.Reputacao, a.Custo, a.IDAluguer " +
                               "FROM Cliente c " +
                               "JOIN Condutor cd ON c.NIF = cd.NIFCliente " +
                               "JOIN Aluguer a ON c.NIF = a.NIFCliente " +
                               "WHERE c.NIF = ?";
                PreparedStatement clienteState = conn.prepareStatement(cliente);
                clienteState.setInt(1, Integer.parseInt(nif));
                ResultSet resultado = clienteState.executeQuery();
                
                if (resultado.next()) {
                    String nome = resultado.getString("Nome");
                    String contacto = resultado.getString("Contacto");
                    int reputacao = resultado.getInt("Reputacao");
                    double custo = resultado.getDouble("Custo");
                    int idAluguer = resultado.getInt("IDAluguer");
                    
                    DecimalFormat df = new DecimalFormat("#.00");
                    
                    //De seguida, se o cliente decidir colocar um tipo de desconto, o mesmo
                    //será processado
                    if (desconto != null && desconto.matches("DISCOUNT\\d+")) {
                        int descontoPercentual = Integer.parseInt(desconto.replace("DISCOUNT", ""));
                        custo -= custo * descontoPercentual / 100.0;
                        
                        //Depois do desconto calculado, a tabela Aluguer será alterada e atualizada, tendo
                        //em conta o custo, o codigo desconto e o seu ID
                        String atualizarAlug = "UPDATE Aluguer SET Custo = ?, CodigoDesconto = ? WHERE IDAluguer = ?";
                        PreparedStatement atualizarAlugState = conn.prepareStatement(atualizarAlug);
                        atualizarAlugState.setDouble(1, custo);
                        atualizarAlugState.setString(2, desconto);
                        atualizarAlugState.setInt(3, idAluguer);
                        atualizarAlugState.executeUpdate();
                        atualizarAlugState.close();
                    }
    %>
    				<!-- Uma secção criada apenas para a representação
    				da reputação do cliente.-->
                    <div class="result">
                        <p><strong>Nome:</strong> <%= nome %></p>
                        <p><strong>Contacto:</strong> <%= contacto %></p>
                        <p><strong>Reputação:</strong> <%= reputacao %></p>
                        <p><strong>Custo Atual:</strong> €<%= df.format(custo) %></p>
                        <form method="post">
                            <input type="hidden" name="nif" value="<%= nif %>">
                            <label for="desconto">Aplicar Desconto:</label>
                            <input type="text" id="desconto" name="desconto" placeholder="Ex: DISCOUNT10">
                            <center><button type="submit">Aplicar</button></center>
                        </form>
                    </div>
    <%
                } else {
    %>
                    <div class="result">
                        <p>Cliente não encontrado.</p>
                    </div>
    <%
                }
                resultado.close();
                clienteState.close();
                conn.close();
            } catch (Exception e) {
    %>
                <div class="result">
                    <p>Ocorreu um erro: <%= e.getMessage() %></p>
                </div>
    <%
            }
        }
    %>
    </div>
  
</body>
</html>
