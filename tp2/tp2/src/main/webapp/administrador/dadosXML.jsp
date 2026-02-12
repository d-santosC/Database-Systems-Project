<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.*, org.json.*, javax.xml.parsers.*, org.w3c.dom.*, java.io.*" %>
<%@ page import="java.sql.*, sql.DatabaseConnection" %>
<!DOCTYPE html>
<html lang="pt">
<head>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

   <title>Exportar/Importar Dados</title>
   <style>
       body {
           background-image: url('../images/background.jpg');
           background-size: cover;
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

       .pagInicial {
           color: white;
           font-size: 1.5rem;
           font-weight: bold;
           position: absolute;
       }

       header h1 {
           color: white;
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
		
		form {
		    margin: 20px auto;
		    padding: 15px;
		    width: 80%;
		    max-width: 400px;
		}
		
		label {
		    display: block;
		    margin-bottom: 5px;
		}
		
		input[type="text"]{
			width: 95%;
		    padding: 8px;
		    margin-bottom: 10px;
		    border: 1px solid black;
		    border-radius: 4px;
		    font-size: 1rem;
		}
		
		select, input[type="file"] {
		    width: 100%;
		    padding: 8px;
		    margin-bottom: 10px;
		    border: 1px solid black;
		    border-radius: 4px;
		    font-size: 1rem;
		}
		
		button {
		    width: 100%;
		    padding: 8px;
		    background-color: #4c5c6c;
		    color: white;
		    border: none;
		    border-radius: 4px;
		    font-size: 1rem;
		    cursor: pointer;
		}
		
		button:hover {
		    transform: rotate(360deg);
		    transform: scale(1.1);
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
        	<a href="../index.jsp"><i class="fa-solid fa-house"></i><span>Home</span></a>
            <a href="admin.jsp"><i class="fa-solid fa-lock"></i><span>Administração</span></a>
            <a href="../cliente/cliente.jsp"><i class="fa-solid fa-user"></i><span>Cliente</span></a>
            <a href="../condutor/condutor.jsp"><i class="fa-solid fa-car"></i><span>Condutor</span></a>
            <a href="../funcionario/funcionario.jsp"><i class="fa-solid fa-user-tie"></i><span>Funcionário</span></a>
            <a href="../gerente/gerente.jsp"><i class="fa-solid fa-users"></i><span>Gerente</span></a>
        </div>
    </header>

	<!--Um formulário é necessário para se conseguir obter a matricula do veiculo para
	a exportação dos dados. O mesmo dá a opção ao utilizador de escolher o formato do
	ficheiro a ser exportado (XML, JSON). Quando o formulário é submetido, os dados são 
	enviados através do método GET para o endpoint /tp2/exportarDados-->
    <center><h2>Exportação de Dados</h2></center>
    <form action="/tp2/exportarDados" method="get">
        <label for="matricula">Digite a matrícula do veículo:</label>
        <input type="text" id="matricula" name="matricula" required>
        
        <label for="format">Escolha o formato de exportação:</label>
        <select name="format" id="format" required>
            <option value="xml">XML</option>
            <option value="json">JSON</option>
        </select><br><br>

        <input type="hidden" name="action" value="export">
        <button type="submit">Exportar Dados</button>
    </form>
    
    <!--O mesmo será feito para a importação de dados de um veiculo. O mesmo dá a opção 
    ao utilizador de escolher o formato do ficheiro a ser importado (XML, JSON). Quando 
    o formulário é submetido, os dados são enviados através do método POST para o endpoint 
    /tp2/importarDados-->
    <center><h2>Importação de Dados</h2></center>
	<form action="/tp2/importarDados" method="post" enctype="multipart/form-data">
	    <input type="hidden" name="action" value="import">
	    <label for="format">Escolha o formato de importação:</label>
	    <select name="format" id="format" required>
	        <option value="xml">XML</option>
	        <option value="json">JSON</option>
	    </select><br><br>
	    
	    <label for="file">Escolha o arquivo:</label><br><br>
		<input type="file" name="file" id="file" required><br><br>
	    
	    <button type="submit">Importar Dados</button>
	</form>
	
    	<div class="texto">
	    <center><a href="admin.jsp"><i class="fa-solid fa-house"></i><span>Voltar</span></a></center> 
	</div>
    
</body>
</html>
