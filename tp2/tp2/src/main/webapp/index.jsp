<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>
<html>
<head>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <title>Empresa GoDaMa</title>

    <style>
        body {
        	background: url("images/background.jpg") no-repeat center center fixed;
            font-family: Arial, sans-serif;
            margin: 0;
        }

        header {
		    height: 120px;
		    background-color: #4c5c6c;
		    color: white;
		    display: flex;
		    align-items: center;
		    justify-content: space-between;
		    padding: 0 20px;
		}
		
		header h1 {
		    margin: 0;
		    font-size: 2rem;
		    text-align: right;
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
        
        .texto{
        	padding: 100px 50px 50px 50px;
        	height: 100px;
        	width: 900px;
        	align-items: center;
        	text-align: center; 
        }
        
        @media (max-width: 768px) {
            header {
                flex-direction: column;
                text-align: center;
                height: auto;
                padding: 10px;
            }

            header h1 {
                font-size: 1.5rem;
            }

            .iconesPaginaInicial {
                flex-wrap: wrap;
                justify-content: center;
                gap: 15px;
            }

            .iconesPaginaInicial a {
                width: 70px;
                height: 55px;
                font-size: 12px;
                padding: 8px;
            }

            .texto {
                padding: 50px 20px;
            }

            .texto h1 {
                font-size: 1.5rem;
            }

            .texto h2 {
                font-size: 1rem;
            }
        }

        @media (max-width: 480px) {
            .iconesPaginaInicial a {
                width: 60px;
                height: 50px;
                font-size: 11px;
                padding: 7px;
            }

            .texto h1 {
                font-size: 1.2rem;
            }

            .texto h2 {
                font-size: 0.9rem;
            }
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
		

        
    </header>

    <div class="texto">
		<h1>Bem-vindo/a à Empresa GoDaMa</h1>
		<h2>Por favor, escolha uma das opções do menu para continuar!</h2>  
		<h2>Não deixe para amanhã o que pode alugar hoje!</h2>
		<img src="images/1.png">
    </div>
    
</body>
</html>
