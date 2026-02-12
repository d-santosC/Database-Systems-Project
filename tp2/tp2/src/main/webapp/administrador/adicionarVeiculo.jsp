<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, sql.DatabaseConnection" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="java.nio.file.Paths" %>
<%@ page import="java.io.BufferedReader, java.io.InputStreamReader, java.io.ByteArrayOutputStream" %>
<%@ page import="java.io.FileInputStream" %>


<!DOCTYPE html>
<html>
<head>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <title>Administração de Veículos</title>
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
        	<a href="../index.jsp"><i class="fa-solid fa-house"></i><span>Home</span></a>
            <a href="../administrador/admin.jsp"><i class="fa-solid fa-lock"></i><span>Administração</span></a>
            <a href="../cliente/cliente.jsp"><i class="fa-solid fa-user"></i><span>Cliente</span></a>
            <a href="../condutor/condutor.jsp"><i class="fa-solid fa-car"></i><span>Condutor</span></a>
            <a href="../funcionario/funcionario.jsp"><i class="fa-solid fa-user-tie"></i><span>Funcionário</span></a>
            <a href="../gerente/gerente.jsp"><i class="fa-solid fa-users"></i><span>Gerente</span></a>
        </div>

        <h1>Processo Novo Veículo</h1>
    </header>
    <div class="message-container">
    <%
    		//Um script é necessário para se conseguir adicionar um veículo à base de dados
    		//Primeiramente, é preciso um caminho para as fotos dos mesmos serem armazenadas
            String loc = "C:/Temp/veiculos/";
            File dir = new File(loc);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            //De seguida, diversas variáveis são criadas com o intuito de armazenar todas as
            //informações do veiculo atravez do formulario abaixo criado
            String matricula = null, tipoMotor = null, capacidadeCarga = null, potencia = null;
            String quantidadeLugares = null, quantidadePortas = null, idTipo = null;
            String modelo = null, tipo = null, marca = null, chassi = null;
            String localidade = null, quilometros = null, imageFileName = null;

            try {
                ServletInputStream inputStream = request.getInputStream();
                ByteArrayOutputStream payloadStream = new ByteArrayOutputStream();
                byte[] buffer = new byte[4096];
                int bytesRead;

                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    payloadStream.write(buffer, 0, bytesRead);
                }

                String payload = new String(payloadStream.toByteArray(), "UTF-8");
                String boundary = "--" + request.getContentType().split("boundary=")[1];
                String[] parts = payload.split(boundary);

                for (String part : parts) {
                    if (part.contains("Content-Disposition: form-data; name=\"")) {
                        String headerEnd = "\r\n\r\n";
                        int headerIndex = part.indexOf(headerEnd);

                        if (headerIndex != -1) {
                            String header = part.substring(0, headerIndex);
                            String value = part.substring(headerIndex + headerEnd.length()).trim();

                            if (header.contains("name=\"matricula\"")) {
                                matricula = value;
                            } else if (header.contains("name=\"tipoMotor\"")) {
                                tipoMotor = value;
                            } else if (header.contains("name=\"capacidadeCarga\"")) {
                                capacidadeCarga = value;
                            } else if (header.contains("name=\"potencia\"")) {
                                potencia = value;
                            } else if (header.contains("name=\"quantidadeLugares\"")) {
                                quantidadeLugares = value;
                            } else if (header.contains("name=\"quantidadePortas\"")) {
                                quantidadePortas = value;
                            } else if (header.contains("name=\"idTipoVeiculo\"")) {
                                idTipo = value;
                            } else if (header.contains("name=\"modelo\"")) {
                                modelo = value;
                            } else if (header.contains("name=\"tipo\"")) {
                                tipo = value;
                            } else if (header.contains("name=\"marca\"")) {
                                marca = value;
                            } else if (header.contains("name=\"chassi\"")) {
                                chassi = value;
                            } else if (header.contains("name=\"localidade\"")) {
                                localidade = value;
                            } else if (header.contains("name=\"quilometros\"")) {
                                quilometros = value;
                            } else if (header.contains("name=\"imagem\"")) {
                                // Processar imagem
                                String filenameLine = header.split("filename=\"")[1];
                                imageFileName = filenameLine.split("\"")[0];
                                String fileExtension = imageFileName.split("\\.")[1]; // Obtendo a extensão do arquivo
                                byte[] binaryData = part.substring(headerIndex + headerEnd.length()).getBytes("ISO-8859-1");

                                // Defina o caminho correto para salvar o arquivo
                                File imageFile = new File(loc + imageFileName);

                                try (FileOutputStream fos = new FileOutputStream(imageFile)) {
                                    fos.write(binaryData);
                                }
                            }
                        }
                    }
                }

                
                Connection conn = DatabaseConnection.getConnection();
                conn.setAutoCommit(false);

                File imageFile = new File(loc + imageFileName);
                try (InputStream imageInputStream = new FileInputStream(imageFile)) {
                	//Irá ser efetuada uma consulta à base de dados, para se inserir na tabela tipoVeiculo
                	//todos os dados
                    String tipoVeiculo = "INSERT INTO tipoveiculo (Chassi, IDTipo, Modelo, Tipo, Marca, Imagem) VALUES (?, ?, ?, ?, ?, ?)";
                    try (PreparedStatement tipoVeiculoState = conn.prepareStatement(tipoVeiculo)) {
                    	tipoVeiculoState.setString(1, chassi);
                    	tipoVeiculoState.setString(2, idTipo);
                    	tipoVeiculoState.setString(3, modelo);
                    	tipoVeiculoState.setString(4, tipo);
                    	tipoVeiculoState.setString(5, marca);            
                    	tipoVeiculoState.setBinaryStream(6, imageInputStream, (int) imageFile.length());
                    	tipoVeiculoState.executeUpdate();
                    }
                }
				
                //O mesmo irá ser feito para a tabela veiculo com todos os dados necessários
                String veiculo = "INSERT INTO veiculo (Matricula, TipoMotor, CapacidadeCarga, Potencia, QuantidadeLugares, QuantidadePortas, IDTipoVeiculo, LocalidadeVeiculo, QuilometrosFeitos, ChassiVeiculo) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement veiculoState = conn.prepareStatement(veiculo)) {
                	veiculoState.setString(1, matricula);
                	veiculoState.setString(2, tipoMotor);
                	veiculoState.setString(3, capacidadeCarga);
                	veiculoState.setString(4, potencia);
                	veiculoState.setString(5, quantidadeLugares);
                	veiculoState.setString(6, quantidadePortas);
                	veiculoState.setString(7, idTipo);
                	veiculoState.setString(8, localidade);
                    veiculoState.setString(9, quilometros);
                    veiculoState.setString(10, chassi);
                    veiculoState.executeUpdate();
                }

                conn.commit();
                out.println("<p>Veículo adicionado com sucesso!</p>");
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p>Erro ao processar: " + e.getMessage() + "</p>");
            }
        %>
    </div>
	<div class="texto">
	    <center><a href="adminVeiculos.jsp"><i class="fa-solid fa-house"></i><span>Voltar</span></a> </center> 
	</div>
</body>
</html>
