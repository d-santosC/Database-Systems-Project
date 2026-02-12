<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, sql.DatabaseConnection" %>


<%
    //Script necessário para lidar com a procura sugestiva dos clientes e procurar
    //os dados do mesmo consoante o seu nome
    String nome = request.getParameter("nome");
    String nif = request.getParameter("nif");

    if (nome != null && !nome.isEmpty()) {
        response.setContentType("application/json");
        List<Map<String, String>> suggestions = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "SELECT NIF, Nome FROM Cliente WHERE Nome LIKE ? LIMIT 10";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + nome + "%");
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Map<String, String> suggestion = new HashMap<>();
                suggestion.put("NIF", rs.getString("NIF"));
                suggestion.put("Nome", rs.getString("Nome"));
                suggestions.add(suggestion);
            }
            
         	
            StringBuilder jsonResponse = new StringBuilder("[");
            for (int i = 0; i < suggestions.size(); i++) {
                Map<String, String> suggestion = suggestions.get(i);
                jsonResponse.append("{\"NIF\":\"").append(suggestion.get("NIF"))
                            .append("\", \"Nome\":\"").append(suggestion.get("Nome")).append("\"}");
                if (i < suggestions.size() - 1) {
                    jsonResponse.append(",");
                }
            }
            jsonResponse.append("]");

            response.getWriter().write(jsonResponse.toString());
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("[]");
        }
        return;
    }

    if (nif != null && !nif.isEmpty()) {
        response.setContentType("application/json");
        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "SELECT * FROM Cliente WHERE NIF = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(nif));
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                StringBuilder jsonResponse = new StringBuilder("{");
                jsonResponse.append("\"NIF\":\"").append(rs.getString("NIF")).append("\",")
                            .append("\"Nome\":\"").append(rs.getString("Nome")).append("\",")
                            .append("\"Contacto\":\"").append(rs.getString("Contacto")).append("\",")
                            .append("\"Moeda\":\"").append(rs.getString("Moeda")).append("\",")
                            .append("\"Tipo\":\"").append(rs.getString("Tipo")).append("\",")
                            .append("\"Endereco\":\"").append(rs.getString("Rua")).append(", ")
                            .append(rs.getString("Porta")).append(", ")
                            .append(rs.getString("Andar")).append(", ")
                            .append(rs.getString("CodigoPostal")).append("\"")
                            .append("}");
                response.getWriter().write(jsonResponse.toString());
            } else {
                response.getWriter().write("{}");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("{}");
        }
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <meta charset="UTF-8">
    <title>Ficha Cliente</title>
    <style>
    .autocomplete-container {
        position: relative;
    }

    .autocomplete-suggestions {
        position: absolute;
        top: 100%;
        left: 0;
        right: 0;
        background: white;
        border: 1px solid #ccc;
        z-index: 1000;
        max-height: 200px;
        overflow-y: auto;
    }

    .autocomplete-suggestion {
        padding: 8px;
        cursor: pointer;
    }

    .autocomplete-suggestion:hover {
        background-color: #f0f0f0;
    }
    
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
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
    $(document).ready(function() {
        // Mostrar as sugestões quando o usuário digitar
        $("#nomeCliente").on("input", function() {
            var query = $(this).val();
            if (query.length >= 3) {
                $.ajax({
                    url: "fichaCliente.jsp",
                    method: "GET",
                    data: { nome: query },
                    success: function(data) {
                        console.log("Resposta do servidor:", data);
                        $(".autocomplete-suggestions").remove();
                        if (data.length > 0) {
                            var suggestionList = $('<div class="autocomplete-suggestions"></div>');
                            data.forEach(function(suggestion) {
                                suggestionList.append('<div class="autocomplete-suggestion" data-nif="' + suggestion.NIF + '">' + suggestion.Nome + '</div>');
                            });
                            $(".autocomplete-container").append(suggestionList);
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("Erro na requisição:", status, error);
                    }
                });
            } else {
                $(".autocomplete-suggestions").remove();
            }
        });

        $(document).on("click", ".autocomplete-suggestion", function() {
            var nif = $(this).data("nif");
            
            $("#nomeCliente").val($(this).text());

            $.ajax({
                url: "fichaCliente.jsp",
                method: "GET",
                data: { nif: nif },
                success: function(data) {
                    console.log("Detalhes do cliente:", data);
                    if (data) {
                        var clientDetails = data;
                        var detailsHtml = "<h3>Ficha do Cliente</h3>";
                        detailsHtml += "<p><strong>Nome:</strong> " + clientDetails.Nome + "</p>";
                        detailsHtml += "<p><strong>Contacto:</strong> " + clientDetails.Contacto + "</p>";
                        detailsHtml += "<p><strong>Moeda:</strong> " + clientDetails.Moeda + "</p>";
                        detailsHtml += "<p><strong>Endereço:</strong> " + clientDetails.Endereco + "</p>";
                        $(".client-info").html(detailsHtml);
                    } else {
                        $(".client-info").html("<p>Cliente não encontrado.</p>");
                    }
                },
                error: function(xhr, status, error) {
                    console.error("Erro ao obter os detalhes do cliente:", status, error);
                }
            });

            
            $(".autocomplete-suggestions").remove();
        });

        
        $("#nomeCliente").on("blur", function() {
            setTimeout(function() {
                $(".autocomplete-suggestions").remove();
            }, 200);
        });

        $(document).on("click", function(event) {
            if (!$(event.target).closest(".autocomplete-container").length) {
                $(".autocomplete-suggestions").remove();
            }
        });
    });
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
    <div class="form-container">
    <form>
        <div class="autocomplete-container">
        
        <center><h1>Ficha de Cliente</h1></center>
            <label for="nomeCliente">Nome do Cliente:</label>
            <input type="text" id="nomeCliente" name="nomeCliente" autocomplete="off">
        </div>
    </form>
    </div>
    
    <div class="client-info"></div>
</body>
</html>
