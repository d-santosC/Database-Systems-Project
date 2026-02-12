<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, sql.DatabaseConnection" %>
<%
	//Um script necessário com o objetivo de atribuir um veiculo a uma reserva pendente.
	//O mesmo permite "tranferir" os dados da reserva para a tabela Aluguer para
	//remover a reserva original.
    String matricula = request.getParameter("matricula");
    String idReserva = request.getParameter("idReserva");

    try (Connection conn = DatabaseConnection.getConnection()) {
    	//Irão ser necessários então os dados da reserva
        String reserva = "SELECT * FROM Reservas WHERE IDReserva = ?";
        PreparedStatement pstmtReserva = conn.prepareStatement(reserva);
        pstmtReserva.setInt(1, Integer.parseInt(idReserva));
        ResultSet rsReserva = pstmtReserva.executeQuery();

        if (rsReserva.next()) {
            //Necessários obter as horas de inicio e de fim da reserva
            Timestamp horaInicio = rsReserva.getTimestamp("HoraInicioReserva");
            Timestamp horaFim = rsReserva.getTimestamp("HoraFimReserva");

            //Para o calculo de dias
            long duracaoMillis = horaFim.getTime() - horaInicio.getTime();
            double duracaoHoras = duracaoMillis / (1000.0 * 60.0 * 60.0);

            //Inserir os dados necessários na tabela Aluguer
            String inserirAluguer = "INSERT INTO Aluguer (MatriculaAluguer, Tipo, HoraInicio, HoraFim, Custo, NIFCliente, NumeroCarta, Duracao) " +
                                   "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement inserirAluguerState = conn.prepareStatement(inserirAluguer);
            inserirAluguerState.setString(1, matricula);
            inserirAluguerState.setString(2, rsReserva.getString("Tipo"));
            inserirAluguerState.setTimestamp(3, horaInicio);
            inserirAluguerState.setTimestamp(4, horaFim);
            inserirAluguerState.setBigDecimal(5, rsReserva.getBigDecimal("Custo"));
            inserirAluguerState.setInt(6, rsReserva.getInt("NIFClienteReserva"));
            inserirAluguerState.setString(7, rsReserva.getString("NumeroCartaCondutor"));
            inserirAluguerState.setDouble(8, duracaoHoras);
            inserirAluguerState.executeUpdate();
			
            //Depois de inseridos os dados na tebal Aluguer, os mesmo são removidos na tabela Reservas
            String deleteReserva = "DELETE FROM Reservas WHERE IDReserva = ?";
            PreparedStatement pstmtDelete = conn.prepareStatement(deleteReserva);
            pstmtDelete.setInt(1, Integer.parseInt(idReserva));
            pstmtDelete.executeUpdate();

            out.println("<p>Veículo atribuído com sucesso!</p>");
        } else {
            out.println("<p>Reserva não encontrada.</p>");
        }
    } catch (SQLException e) {
        out.println("<p>Erro ao atribuir veículo: " + e.getMessage() + "</p>");
    }
%>
<a href="atribuirVeiculo.jsp">Voltar</a>