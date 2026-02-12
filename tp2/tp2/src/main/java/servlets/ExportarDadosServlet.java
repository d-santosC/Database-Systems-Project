package servlets;

import java.io.*;
import java.sql.*;
import org.json.*;
import sql.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

//Esta classe tem como objetivo exportar informações sobre veículos armazenados na database, essa exportação irá resultar
//num ficheiro do tipo JSON ou XML contêndo todos os dados sobre os mesmos. Esta classe herda do HttpServlet que é responsável
//por processar pedidos HTTP
public class ExportarDadosServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

    //Quando o servidor recebe um pedido HTTP (GET) este método irá ser chamado.
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //Guarda os parametros "action" e "format" do request HTTP (GET), o parâmetro action deverá ser ter o valor "export",
        //visto que esta classe é utilizada apenas para a exportação e o "format" irá definir o formato que o ficheiro terá
        //JSON ou XML
        String action = request.getParameter("action");
        String format = request.getParameter("format");

        //Caso a conectividade esteja corretamente estabelecida e a "action" seja export o código irá então começar o processo de exportação
        try (Connection conn = DatabaseConnection.getConnection()) {
            if ("export".equalsIgnoreCase(action)) {
                //Como a matricula é a primary key do veiculo, a mesma será utilizada para filtrar os dados da database
                String matricula = request.getParameter("matricula");

                //Declara-se uma query SQL que irá ser utilizada para procurar as informações dos veículos, a matricula inicializada anteriormente
                //irá ser substituida na linha "WHERE v.Matricula = ?", para que só se faça a procura das informações de acordo com a matricula a que
                //as mesmas correspondem
                String sql = "SELECT v.*, t.Modelo, t.Tipo, t.Marca, t.Chassi, "
                        + "i.Tipo AS TipoIntervencao, i.DataIntervencao, "
                        + "a.Tipo AS TipoAluguer, a.HoraInicio, a.HoraFim, a.Custo "
                        + "FROM Veiculo v "
                        + "JOIN TipoVeiculo t ON v.ChassiVeiculo = t.Chassi "
                        + "LEFT JOIN Intervencao i ON v.Matricula = i.MatriculaVeiculo "
                        + "LEFT JOIN Aluguer a ON v.Matricula = a.MatriculaAluguer "
                        + "WHERE v.Matricula = ?";
                
                //Prepara a instrução SQL declarada anteriormente substituindo o ? pela matrcula do carro
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, matricula);

                    //Tenta executar a query e guarda os seus resultados num ResultSet, seguidamente irá verificar se o utilizador
                    //pediu o ficheiro no formato XML ou JSON visto que o processo para guardar os dados irá ser diferente dependendo
                    //da extensão pedida.
                    try (ResultSet rs = stmt.executeQuery()) {
                        //Se os dados forem pedidos no formato XML começa-se por escrever o cabeçado de acordo com as normas de um ficheiro
                        //XML e abre-se a tag veiculo
                        if ("xml".equalsIgnoreCase(format)) {
                            response.setContentType("application/xml");
                            response.getWriter().println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
                            response.getWriter().println("<veiculo>");

                            //Por cada linha dos resultados da query feita anteriormente irão ser guardados os dados do veículo no formato XML,
                            //abrindo e fechando tags com as suas informações correspondentes, quando não houver mais informações sobre o veículo
                            //o while acaba e fecha-se a tag veiculo
                            while (rs.next()) {
                                response.getWriter().println("<dadosVeiculo>");
                                response.getWriter().println("<matricula>" + rs.getString("Matricula") + "</matricula>");
                                response.getWriter().println("<tipoMotor>" + rs.getString("TipoMotor") + "</tipoMotor>");
                                response.getWriter().println("<capacidadeCarga>" + rs.getString("CapacidadeCarga") + "</capacidadeCarga>");
                                response.getWriter().println("<potencia>" + rs.getString("Potencia") + "</potencia>");
                                response.getWriter().println("<quilometrosFeitos>" + rs.getInt("QuilometrosFeitos") + "</quilometrosFeitos>");
                                response.getWriter().println("<quantidadeLugares>" + rs.getInt("QuantidadeLugares") + "</quantidadeLugares>");
                                response.getWriter().println("<quantidadePortas>" + rs.getInt("QuantidadePortas") + "</quantidadePortas>");
                                response.getWriter().println("<idTipo>" + rs.getString("IDTipoVeiculo") + "</idTipo>");
                                response.getWriter().println("<localidadeVeiculo>" + rs.getString("LocalidadeVeiculo") + "</localidadeVeiculo>");
                                response.getWriter().println("<chassiVeiculo>" + rs.getString("ChassiVeiculo") + "</chassiVeiculo>");
                                response.getWriter().println("<modelo>" + rs.getString("Modelo") + "</modelo>");
                                response.getWriter().println("<marca>" + rs.getString("Marca") + "</marca>");
                                response.getWriter().println("<tipo>" + rs.getString("Tipo") + "</tipo>");
                                response.getWriter().println("<tipoIntervencao>" + rs.getString("TipoIntervencao") + "</tipoIntervencao>");
                                response.getWriter().println("<dataIntervencao>" + rs.getString("DataIntervencao") + "</dataIntervencao>");
                                response.getWriter().println("<tipoAluguer>" + rs.getString("TipoAluguer") + "</tipoAluguer>");
                                response.getWriter().println("<horaInicio>" + rs.getString("HoraInicio") + "</horaInicio>");
                                response.getWriter().println("<horaFim>" + rs.getString("HoraFim") + "</horaFim>");
                                response.getWriter().println("<custo>" + rs.getString("Custo") + "</custo>");
                                response.getWriter().println("</dadosVeiculo>");
                            }
                            response.getWriter().println("</veiculo>");

                        //Se os dados forem pedidos no formato JSON começa-se pot criar um array do tipo JSONArray onde irá ser guardada toda a informação
                        //do veículo por ordem.
                        } else if ("json".equalsIgnoreCase(format)) {
                            response.setContentType("application/json");
                            JSONArray jsonArray = new JSONArray();
                            
                            //Por cada linha dos resultados da query feita anteriormente irá ser criado um JSONObject que representa o veículo onde vão ser guardadas
                            //as informações por ordem de aparição na tabela, colocando o objeto no array criado anteriormente, quando todos os valores forem colocados 
                            //no array o while finaliza
                            while (rs.next()) {
                                JSONObject veiculoJson = new JSONObject();
                                veiculoJson.put("matricula", rs.getString("Matricula"));
                                veiculoJson.put("tipoMotor", rs.getString("TipoMotor"));
                                veiculoJson.put("capacidadeCarga", rs.getString("CapacidadeCarga"));
                                veiculoJson.put("potencia", rs.getString("Potencia"));
                                veiculoJson.put("quilometrosFeitos", rs.getInt("QuilometrosFeitos"));
                                veiculoJson.put("quantidadeLugares", rs.getInt("QuantidadeLugares"));
                                veiculoJson.put("quantidadePortas", rs.getInt("QuantidadePortas"));
                                veiculoJson.put("idTipo", rs.getString("IDTipoVeiculo"));
                                veiculoJson.put("localidadeVeiculo", rs.getString("LocalidadeVeiculo"));
                                veiculoJson.put("chassiVeiculo", rs.getString("ChassiVeiculo"));
                                veiculoJson.put("modelo", rs.getString("Modelo"));
                                veiculoJson.put("marca", rs.getString("Marca"));
                                veiculoJson.put("tipo", rs.getString("Tipo"));
                                veiculoJson.put("tipoIntervencao", rs.getString("TipoIntervencao"));
                                veiculoJson.put("dataIntervencao", rs.getString("DataIntervencao"));
                                veiculoJson.put("tipoAluguer", rs.getString("TipoAluguer"));
                                veiculoJson.put("horaInicio", rs.getString("HoraInicio"));
                                veiculoJson.put("horaFim", rs.getString("HoraFim"));
                                veiculoJson.put("custo", rs.getString("Custo"));

                                jsonArray.put(veiculoJson);
                            }

                            //Converte-se o array JSON para uma string e escreve-se a mesma como resposta
                            response.getWriter().print(jsonArray.toString(4));
                        }
                    }
                }
            }
        //Caso a conexão não seja estabelecida dá-se print do erro
        } catch (Exception e) {
            e.printStackTrace(response.getWriter());
        }
    }
}