package servlets;

import java.io.*;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sql.DatabaseConnection;

//Atribui um endpoint a este servlet, se o utilizador fizer uma requisição para este URL, o servlet será executado
@WebServlet("/servlets/imageServlet")

//Esta classe tem como objetivo mostrar as imagens dos veículos no site, para isso o mesmo herda da classe HttpServlet que é responsável
//por processar pedidos HTTP
public class ImageServlet extends HttpServlet {

private static final long serialVersionUID = 1L;

//Quando o servidor recebe um pedido HTTP (GET) este método irá ser chamado.
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //Guarda o parametro "chassi" do pedido (request) numa variável para facilitar a escrita de código
        String chassi = request.getParameter("chassi");

        //Inicializa variáveis úteis na conexão da database, para a instruçao SQL que irá ser utilizada e na resposta que
        //este método irá dar
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        //Tenta-se estabelecer uma conexão com a database, caso a mesma seja bem estabelecida cria-se uma query SQL que irá selecionar
        //a imagem de um carro de acordo com um determinado Chassi (que neste momento está representado por ?), altera-se o ?
        //pelo valor do chassi declarado anteriormente e finalmente executa-se a query do SQL
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT Imagem FROM TipoVeiculo WHERE Chassi = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, chassi);
            rs = stmt.executeQuery();
            
            //Verifica se o ResultSet conseguiu encontrar o chassi indicado
            if (rs.next()) {
                //Se sim os bytes da imagem irão ser guardados numa variável
                byte[] imageBytes = rs.getBytes("Imagem");
                
                //Verifica-se então se a imagem existe (diferente de null e tem mais de 0 bytes), caso
                //a imagem exista podemos continuar o processo
                if (imageBytes != null && imageBytes.length > 0) {
                    //Define-se o tipo da resposta como uma imagem e o seu tamanho como o tamanho do array onde os bytes
                    //da mesma ficaram guardados
                    response.setContentType("image/png");
                    response.setContentLength(imageBytes.length);

                    //Tenta-se por fim dar print da imagem utilizando os bytes da mesma
                    try (OutputStream out = response.getOutputStream()) {
                        out.write(imageBytes);
                        out.flush();
                    //Caso ocorra um erro no envio dos bytes dá-se um erro no envio
                    } catch (IOException e) {
                        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao enviar a imagem.");
                    }
                //Caso o chassi referido não tenha uma imagem associada dá-se um erro
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Imagem não encontrada.");
                }
            //Caso o chassi não exista e/ou não tenha sido encontrado dá-se um erro
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Chassi não encontrado.");
            }
        //Caso a conexão não tenha sido bem estabelecida dá-se um erro
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());

        //Por fim fecham-se o ResultSet, a Conexão e a Instrução SQL de modo a que da próxima vez que este servlet seja
        //requisitado não haja erros em relação a nenhum deles
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            //Caso alguma das variáveis não feche ocorre um erro que irá ser impresso
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}