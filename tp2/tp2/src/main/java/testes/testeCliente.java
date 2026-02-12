package testes;

import sql.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

@WebServlet("/testeCliente")
public class testeCliente extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        try (PrintWriter out = response.getWriter()) {
            out.println("<h1>Clientes na Base de Dados</h1>");
            try (Connection connection = DatabaseConnection.getConnection();
                 Statement statement = connection.createStatement()) {
                String query = "SELECT * FROM CLIENTE";
                ResultSet resultSet = statement.executeQuery(query);

                out.println("<table border='1'>");
                out.println("<tr><th>NIF</th><th>Nome</th><th>Contacto</th><th>Moeda</th><th>Tipo</th></tr>");
                while (resultSet.next()) {
                    String nif = resultSet.getString("NIF");
                    String nome = resultSet.getString("Nome");
                    String contacto = resultSet.getString("Contacto");
                    String moeda = resultSet.getString("Moeda");
                    String tipo = resultSet.getString("Tipo");
                    out.println("<tr>");
                    out.println("<td>" + nif + "</td>");
                    out.println("<td>" + nome + "</td>");
                    out.println("<td>" + contacto + "</td>");
                    out.println("<td>" + moeda + "</td>");
                    out.println("<td>" + tipo + "</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
            } catch (Exception e) {
                out.println("<p style='color:red;'>Erro ao acessar a base de dados: " + e.getMessage() + "</p>");
                e.printStackTrace(out);
            }
        }
    }
}