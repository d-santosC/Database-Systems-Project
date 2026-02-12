<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, sql.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <title>Administração de Clientes</title>
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

        .grelhaClientes {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 20px;
            padding: 10px;
        }

        .cartoes {
            background-color: rgba(255, 255, 255, 0.8);
            padding: 15px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
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

        .cartoes button:hover, .btn-main:hover{
            background-color: #2b4259;
            transform: scale(1.05);
        }
        
        .adicionarCliente {
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
            .grelhaClientes {
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

        <h1>Gestão de Clientes</h1>
    </header>

	<center><h2>Lista de Clientes</h2></center>
    <div class="grelhaClientes">
        <%
        		//Um script necessário para se conseguir exibir todos os clientes no formato de cartões
        		//Esta forma de apresentação é boa para se conseguir distinguir todos os clientes e se conseguir
        		//identificar todos os clientes criados. 
        		
        		//Primeiramente, uma tentativa de conexão será feita para tentar aceder à base de dados.
                try (Connection conn = DatabaseConnection.getConnection()) {
                	
                	//Se a conexão for bem sucedida, irá ser executada a instrução SELECT * FROM cliente com
                	//o intuito de se conseguir selecionar todos os dados da tabela cliente para a exibição.
                    String selecionarClientes = "SELECT * FROM cliente";
                    try (Statement clienteState = conn.createStatement(); 
                		ResultSet resultado = clienteState.executeQuery(selecionarClientes)) {
                        while (resultado.next()) {
                            %>
                            <!--Esta div apenas representa os resultados da pesquida do cliente, para
                            todos os clientes existeentes  -->
                            <div class="cartoes">
	                            <h3><%= resultado.getString("Nome") %></h3>
	                            <p><strong>NIF:</strong> <%= resultado.getString("NIF") %></p>
	                            <p><strong>Contacto:</strong> <%= resultado.getString("Contacto") %></p>
	                            <p><strong>Moeda:</strong> <%= resultado.getString("Moeda") %></p>
	                            <p><strong>Tipo:</strong> <%= resultado.getString("Tipo") %></p>
	                            <form action="editarCliente.jsp" method="get">
	                                <input type="hidden" name="nif" value="<%= resultado.getString("NIF") %>">
	                                <!-- Criação também de um botão para editar os dados do mesmo -->
	                                <button type="submit">Editar</button>
	                            </form>
                        	</div>
                            <%
                        }
                    }
                } catch (SQLException e) {
                    out.println("<tr><td colspan='10'>Erro ao conectar à base de dados: " + e.getMessage() + "</td></tr>");
                }
        %>
    </div>

	<!-- Na mesma página, é criado um formulário com o objetivo do administrador
	conseguir adicionar um novo cliente à base de dados, e apresentá-lo no site -->
    <center><h2>Adicionar Novo Cliente</h2></center>
    <div class="adicionarCliente">
        <form action="adicionarCliente.jsp" method="post" id="formCliente">
            <div class="group">
                <label for="nome">Nome:</label>
                <input type="text" id="nome" name="nome" required style="width: 170%;">
            </div>
            
            <div class="group">
                <label for="nif">NIF:</label>
                <input type="text" id="nif" name="nif" required>
                
                <label for="contacto">Contacto:</label>
                <input type="text" id="contacto" name="contacto" required>
            </div>
            
            <div class="group">
                <label for="moeda">Moeda:</label>
                <input type="text" id="moeda" name="moeda" required>
                
                <label for="tipo">Tipo:</label>
                <select id="tipo" name="tipo" required onchange="updateFields()">
                    <option value="">Selecione</option>
                    <option value="Pessoa">Pessoa</option>
                    <option value="Empresa">Empresa</option>
                </select>
            </div>
            
            <div id="pessoaDataNasc" style="display: none;">
                <div class="group">
                    <label for="dataNascimento">Data de Nascimento:</label>
                    <input type="date" id="dataNascimento" name="dataNascimento">
                </div>
            </div>
            
            <div id="empresaCapSoc" style="display: none;">
                <div class="group">
                    <label for="capitalSocial">Capital Social:</label>
                    <input type="text" id="capitalSocial" name="capitalSocial">
                </div>
            </div>
            
            <div class="group">
                <label for="rua">Rua:</label>
                <input type="text" id="rua" name="rua" required>
                
                <label for="porta">Porta:</label>
                <input type="text" id="porta" name="porta" required>
            </div>
            
            <div class="group">
                <label for="andar">Andar:</label>
                <input type="text" id="andar" name="andar">
                
                <label for="codigoPostal">Código Postal:</label>
                <input type="text" id="codigoPostal" name="codigoPostal" required>
            </div>
            
            <div class="group">
                 <label for="distrito">Distrito:</label>
			    <input type="text" id="distrito" name="distrito" required><br><br>
			
			    <label for="concelho">Concelho:</label>
			    <input type="text" id="concelho" name="concelho" required><br><br>

            </div>
            
            
            <div class="group">
                <label for="freguesia">Freguesia:</label>
			    <input type="text" id="freguesia" name="freguesia" required><br><br>
			
			    <label for="pais">País:</label>
			    <input type="text" id="pais" name="pais" required><br><br>
            </div>
            
            <center><button type="submit" class="btn-main">Adicionar Cliente</button></center>
        </form>
    </div>    


<script>
	//Um script irá também ser necessário para se conseguir editar um cliente, 
	//neste caso, assumi-lo como empresa ou como pessoa.
    function updateFields() {
        const tipo = document.getElementById("tipo").value;
        const pessoaDataNasc = document.getElementById("pessoaDataNasc");
        const empresaCapSoc = document.getElementById("empresaCapSoc");
        
        if (tipo === "Pessoa") {
        	pessoaDataNasc.style.display = "block";
        	empresaCapSoc.style.display = "none";
        } else if (tipo === "Empresa") {
        	pessoaDataNasc.style.display = "none";
        	empresaCapSoc.style.display = "block";
        } else {
        	pessoaDataNasc.style.display = "none";
        	empresaCapSoc.style.display = "none";
        }
    }
</script>

</body>
</html>
