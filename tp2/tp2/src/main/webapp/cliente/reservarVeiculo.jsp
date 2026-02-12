<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*, sql.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <title>Reservar Veículo</title>
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
		
		form {
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
		
		button {
			height: 40px;
		    background-color: #4c5c6c;
		    color: white;
		    padding: 8px 12px;
		    border: none;
		    border-radius: 10px;
		    cursor: pointer;
		    transition: background-color 0.3s ease, transform 0.3s ease;
		    width: 80%;
		}
		
		button:hover, a.btn-main:hover {
		    background-color: #2b4259;
		    transform: scale(1.1);
		}
		
		a.btn-main {
		    background-color: #4c5c6c;
		    color: white;
		    padding: 8px 12px;
		    border: none;
		    border-radius: 10px;
		    cursor: pointer;
		    transition: background-color 0.3s ease, transform 0.3s ease;
		    text-decoration: none;
		    display: inline-block;
		    margin-top: 20px;
		}
    </style>
    <script>
    	//Um script é necessário para se conseguir validar as datas e horas que foram
    	//inseridas pelo utilizador
        function validarDataHora() {
            var horaInicial = document.getElementById("inicio").value;
            var horaFinal = document.getElementById("fim").value;

            //Apenas regula a data e hora inserida no formato yyyy-mm-dd HH:mm
            var regular = /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}$/;

            //Irá verificar então se os campos da hora inicial e final estão no formato
            //e se assim, acontecer, a mfunção retorna true o que permite enviar esses
            //dados, o formulario.
            if (!regular.test(horaInicial) || !regular.test(horaFinal)) {
                alert("Por favor, insira a data e hora no formato 'yyyy-MM-dd HH:mm'.");
                return false;
            }

            return true;
        }
    </script>
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
    
    <!--Um formulário é necessário para o utilizador conseguir realizar uma reserva de um veiculo.-->
    <form action="confirmarReserva.jsp" method="post" onsubmit="return validarDataHora()">
    
        <center><h1>Reservar Veículo</h1></center>
        <div class="group">
            <label for="tipo">Selecione o Tipo de Veículo:</label>
            <select id="tipo" name="tipo" required>
                <option value="Comercial">Comercial</option>
                <option value="Familiar">Familiar</option>
                <option value="Motociclo">Motociclo</option>
            </select>
        </div>

        <div class="group">
            <label for="marca">Marca do Veículo:</label>
            <input type="text" id="marca" name="marca" placeholder="Insira a marca desejada" required>
        </div>

        <div class="group">
            <label for="inicio">Data/Hora de Início:</label>
            <input type="text" id="inicio" name="inicio" placeholder="yyyy-MM-dd HH:mm" required>
        </div>

        <div class="group">
            <label for="fim">Data/Hora de Fim:</label>
            <input type="text" id="fim" name="fim" placeholder="yyyy-MM-dd HH:mm" required>
        </div>

        <div class="group">
            <label for="parque">Localidade do Parque:</label>
            <select id="parque" name="parque" required>
                <%
                	//Um script necessário para se conseguir adquirir as localidades a partir da base
                	//de dados. É iniciado uma conexão com a base de dados.
                    try (Connection conn = DatabaseConnection.getConnection()) {
                    	//Irá ser selecionada entao as localidades dos parques de estacionamento
                    	//para as opções do utilizador.
                        String localidadeParque = "SELECT Localidade FROM ParqueEstacionamento";
                        try (Statement localidadeParqueState = conn.createStatement(); 
                        	ResultSet resultado = localidadeParqueState.executeQuery(localidadeParque)) {
                            while (resultado.next()) {
                                String localidade = resultado.getString("Localidade");
                %>
                				<!--Todas as que forem encontradas serão colocadas numa option value
                				para o utilizador conseguir escolher a que mais lhe der jeito.  -->
                                <option value="<%= localidade %>"><%= localidade %></option>
                <%
                            }
                        }
                    } catch (SQLException e) {
                        out.println("<option disabled>Erro ao carregar as localidades</option>");
                    }
                %>
            </select>
        </div>

        <div class="group">
            <label for="nif">NIF do Cliente:</label>
            <input type="text" id="nif" name="nif" placeholder="Insira o seu NIF" required>
        </div>

        <div class="group">
            <label for="numeroCarta">Nº da Carta de Condução:</label>
            <input type="text" id="numeroCarta" name="numeroCarta" placeholder="Insira o Nº da Carta de Condução" required>
        </div>

        <div class="group">
            <label for="dataEmissao">Data de Emissão da Carta de Condução:</label>
            <input type="text" id="dataEmissao" name="dataEmissao" placeholder="yyyy-MM-dd HH:mm" required>
        </div>

        <div class="group">
            <label for="dataValidade">Data de Validade da Carta de Condução:</label>
            <input type="text" id="dataValidade" name="dataValidade" placeholder="yyyy-MM-dd HH:mm" required>
        </div>

        <div class="group">
            <label for="reputacao">Reputação do Condutor:</label>
            <input type="text" id="reputacao" name="reputacao" placeholder="Reputação do Condutor" required>
        </div>

        <center><button type="submit">Confirmar Reserva</button></center>
    </form>
    <center><a href="cliente.jsp" class="btn-main">Voltar</a></center>
</body>
</html>