<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <title>Painel de Cliente</title>
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
		    padding: 150px 50px 50px 50px;
		    width: 900px;
		    text-align: center;
		    display: flex;
		    flex-direction: column;
		    align-items: center;
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
            <a href="cliente.jsp"><i class="fa-solid fa-user"></i><span>Cliente</span></a>
            <a href="../condutor/condutor.jsp"><i class="fa-solid fa-car"></i><span>Condutor</span></a>
            <a href="../funcionario/funcionario.jsp"><i class="fa-solid fa-user-tie"></i><span>Funcionário</span></a>
            <a href="../gerente/gerente.jsp"><i class="fa-solid fa-users"></i><span>Gerente</span></a>
        </div>

        
    </header>
    
        <div class="texto">
        <h1>Painel de Cliente</h1>
	    <h2>Escolha uma das opções abaixo:</h2>
	    <div class="botoes">
	        <a href="reservarVeiculo.jsp"><i class="fa-solid fa-truck-monster"></i><span>Reservar Veiculo</span></a>
	        <a href="estadoReservas.jsp"><i class="fa-solid fa-table-cells"></i><span>Consultar Reservas</span></a>
	    </div>
	    <a href="../index.jsp"><i class="fa-solid fa-house"></i><span>Voltar</span></a>  
	</div>
    
</body>
</html>
