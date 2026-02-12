<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, sql.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Editar Cliente</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f4f4f4;
		}
        .editarCliente {
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
    	//Um script é necessário para editar um dos clientes escolhidos, já existentes.
    	//Primeiramente, como o NIF é uma primary key, é apenas dele que se necessita para
    	//identificar o cliente, e inicializa as outras diversas variáveis associadas ao mesmo,
    	//onde as mesmas podem ser editadas.
        String nif = request.getParameter("nif");
        String nome = "";
        String contacto = "";
        String moeda = "";
        String tipo = "";

        //Uma verificação é feita apenas para averiguar se o NIF não é nulo, vai ser efetuada uma
        //conexão à base de dados onde será selecionado tudo do cliente com o seu determinado NIF.
        if (nif != null && !nif.isEmpty()) {
            try (Connection conn = DatabaseConnection.getConnection()) {
                String cliente = "SELECT * FROM cliente WHERE NIF = ?";
                try (PreparedStatement clienteState = conn.prepareStatement(cliente)) {
                	clienteState.setString(1, nif);
                    try (ResultSet resultado = clienteState.executeQuery()) {
                    	//E se o cliente for encontrado na baswe de dados, os dados do mesmo
                    	//irão ser armazenados nas variáveis seguintes, correspondentes.
                        if (resultado.next()) {
                            nome = resultado.getString("Nome");
                            contacto = resultado.getString("Contacto");
                            moeda = resultado.getString("Moeda");
                            tipo = resultado.getString("Tipo");
                        } else {
                            out.println("<p>Cliente não encontrado.</p>");
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
            nome = request.getParameter("nome");
            contacto = request.getParameter("contacto");
            moeda = request.getParameter("moeda");
            tipo = request.getParameter("tipo");

            //Uma nova tentativa ne conexão será feita com a base de dados para se verificar
            //se existem mudanças nos dados do cliente ou não.
            try (Connection conn = DatabaseConnection.getConnection()) {
            	//Será entao criada uma instância de StringBuilder para se conseguir construir
            	//uma string com várias partes, como neste caso, o uso do UPDATE cliente SET com
            	//todos os seus parâmetros, que podem ou não ser alterados.
                StringBuilder updateSate = new StringBuilder("UPDATE cliente SET ");
            	
            	//Uma variável booleana e criada para verificar se existem mudanças nos dados
            	//do cliente em questão ou não.
                boolean mudancas = false;

            	//Para todas as verificações seguintes, é averiguado se o label em questão
            	//(nome, contacto, moeda, etc) não é nulo e não está vazio. E se assim 
            	//acontecer, cada um dos campos serão incluídos na consulta à base de dados para
            	//serem atualizados, e define que existiram alterações, ou seja, o campo será atualizado
                if (nome != null && !nome.isEmpty()) {
                	updateSate.append("Nome = ?, ");
                	mudancas = true;
                }
                if (contacto != null && !contacto.isEmpty()) {
                	updateSate.append("Contacto = ?, ");
                	mudancas = true;
                }
                if (moeda != null && !moeda.isEmpty()) {
                	updateSate.append("Moeda = ?, ");
                	mudancas = true;
                }
                if (tipo != null && !tipo.isEmpty()) {
                	updateSate.append("Tipo = ?, ");
                	mudancas = true;
                }

                //De seguida, se tiverem existido quaisquer tipos de alterações aos dados do cliente,
                //será necessário o comando WHERE NIF = ?, para garantir que o cliente correto em questão
                //é o mesmo a ser atualizado, ao conseguir identificá-lo pelo NIF.
                if (mudancas) {
                	updateSate.setLength(updateSate.length() - 2);
                	updateSate.append(" WHERE NIF = ?");

                	//Entra-se então na consulta para se conseguir executar, de forma segura, a troca
                	//dos valores alterados pelos parâmetros definidos abaixo.
                    try (PreparedStatement trocaState = conn.prepareStatement(updateSate.toString())) {
                    	
                    	//É criada uma variável para permitir a ordem dos parâmetros a consultar, tal 
                    	//como pela ordem os quais foram verificados.
                        int indexParametros = 1;

                    	//Faz-se então a verificação de que nenhum campo é nulo ou vazio e atribui-se o
                    	//valor correspondente aos parâmetros de consulta.
                        if (nome != null && !nome.isEmpty()) trocaState.setString(indexParametros++, nome);
                        if (contacto != null && !contacto.isEmpty()) trocaState.setString(indexParametros++, contacto);
                        if (moeda != null && !moeda.isEmpty()) trocaState.setString(indexParametros++, moeda);
                        if (tipo != null && !tipo.isEmpty()) trocaState.setString(indexParametros++, tipo);

                        //Como se selecionou o cliente a partir do seu NIF não é necessário verificação.
                        trocaState.setString(indexParametros, nif);

                        //Uma variável criada para verificar o número de linhas que foram atualizadas e se
                        //o número das mesmas for maior que 0, significa que o cliente foi atualizado com
                        //sucesso.
                        int linhasAtualizadas = trocaState.executeUpdate();
                        if (linhasAtualizadas > 0) {
                            out.println("<p>Cliente atualizado com sucesso!</p>");
                        } else {
                            out.println("<p>Erro ao atualizar cliente.</p>");
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
    <!-- Na mesma página, é criado um formulário com o objetivo do administrador
	conseguir editar um dos clientes já existentes na base de dados -->
	<center><h2>Editar Cliente</h2></center>
    <div class="editarCliente">
        <form action="editarCliente.jsp" method="post">
            <input type="hidden" name="nif" value="<%= nif %>">

            <div class="group">
                <label for="nome">Nome:</label>
                <input type="text" id="nome" name="nome" value="<%= nome %>" required>
            </div>

            <div class="group">
                <label for="contacto">Contacto:</label>
                <input type="text" id="contacto" name="contacto" value="<%= contacto %>" required>
            </div>

            <div class="group">
                <label for="moeda">Moeda:</label>
                <input type="text" id="moeda" name="moeda" value="<%= moeda %>" required>
            </div>

            <div class="group">
                <label for="tipo">Tipo:</label>
                <input type="text" id="tipo" name="tipo" value="<%= tipo %>" required>
            </div>

            <center><button type="submit" class="btn-main">Atualizar Cliente</button></center>
        </form>
            <center><a href="adminClientes.jsp" class="btn-main">Voltar</a></center>
    </div>


</body>
</html>
