package servlets;

import java.io.*;
import java.sql.*;
import org.json.*;
import javax.xml.parsers.*;
import org.w3c.dom.*;
import sql.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

//Anotação que permite ao servlet trabalhar com o upload de arquivos
@MultipartConfig

//Esta classe tem como objetivo importar informações sobre veículos armazenados na database, essa importação irá ser feita
//a partir de um ficheiro XML ou JSON. Esta classe herda do HttpServlet que é responsável por processar pedidos HTTP.
public class ImportarDadosServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    //Método que recebe um objeto do tipo Part e retorna-o como string
    private String getStringFromPart(Part part) throws IOException {

        //Tenta obter os dados enviados pelo objeto Part
        try (InputStream inputStream = part.getInputStream()) {
            //Utiliza-se o BufferedReader para facilitar a leitura linha a linha de um novo InputStreamReader, este novo stream reader
            //é utilizado para ler os byte como caractéres
            BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
            //Cria-se uma StringBuilder que vai ser utilizada para a construção de uma string com todas as linhas lidas
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            //Retorna-se a String com todas as linhas lidas do objeto Part
            return sb.toString();
        }
    }

    //Quando o servidor recebe um pedido HTTP (POST) este método irá ser chamado.
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //Cria-se variáveis "action" e "format" onde irão ser armazenados os dados de acordo com o request feito à página
        String action = null;
        String format = null;
        
        //Guarda-se a informação sobre a ação e o formato do request em objetos do tipo Part
        Part actionPart = request.getPart("action");
        Part formatPart = request.getPart("format");

        //Caso os objetos existam, a função auxiliar getStringFromPart para transformar as mesmas em Strings que irão
        //ter a informação da ação que se pretende fazer.
        if (actionPart != null) {
            action = getStringFromPart(actionPart);
        }
        if (formatPart != null) {
            format = getStringFromPart(formatPart);
        }

        //Tenta-se fazer uma conexão com a database
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);

            //Verifica-se se a "action" do request é do tipo import, se for pode-se continuar com o processo
            if ("import".equalsIgnoreCase(action)) {
                //Obtem-se o arquivo enviado pelo request que contém os dados que se quer importar,
                //verifica-se se o arquivo existe (nao é null e tem um tamanho maior que 0) e se sim
                //utiliza-se o mesmo raciocinio que se utilizou na função getStringFromPast() para se transformar todas
                //as linhas do ficheiro numa só string utilizando o StringBuilder
                Part filePart = request.getPart("file");
                if (filePart != null && filePart.getSize() > 0) {
                    InputStream fileContent = filePart.getInputStream();
                    BufferedReader reader = new BufferedReader(new InputStreamReader(fileContent));
                    StringBuilder sb = new StringBuilder();
                    String line;
                    while ((line = reader.readLine()) != null) {
                        sb.append(line);
                    }
                    
                    //Cria-se uma variável que começa a false e irá ser atualizada a true caso a importação
                    //for bem sucedida.
                    boolean success = false;
                    
                    //Como o ficheiro importado pode ser do tipo XML ou JSON o processo de importação de cada
                    //um irá ser diferente logo verifica-se qual a extensão do ficheiro e utiliza-se a função relativa
                    //ao mesmo. Caso esse processo seja bem sucedido altera-se o boolean success para true.
                    if ("xml".equalsIgnoreCase(format)) {
                        success = processXmlFile(conn, sb.toString());
                    } else if ("json".equalsIgnoreCase(format)) {
                        success = processJsonFile(conn, sb.toString());
                    }
                    
                    //Se o processo for bem sucedido confirmamos a transação redirecionamos o utilizador para o seguinte callback
                    if (success) {
                        conn.commit();
                        response.sendRedirect("administrador/dadosImportados.jsp?status=success");
                    //Caso contrário revertemos a transação irá ser redirecionado para este callback
                    } else {
                        conn.rollback();
                        response.sendRedirect("administrador/dadosImportados.jsp?status=error");
                    }
                }
            }
        //Caso a conexão não seja estabelecida dá-se um erro
        } catch (Exception e) {
            e.printStackTrace(response.getWriter());
            request.setAttribute("message", "Erro ao processar os dados. Por favor, tente novamente.");
            request.getRequestDispatcher("administrador/dadosImportados.jsp").forward(request, response);
        }
    }

    //Método que processa o ficheiro XML para a base de dados.
    private boolean processXmlFile(Connection conn, String xmlContent) {
        try {
            //Analisa o documento XML recebido e guarda uma lista de Nós com a tag "dadosVeiculo" numa variável veiculos.
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document doc = builder.parse(new ByteArrayInputStream(xmlContent.getBytes()));
            NodeList veiculos = doc.getElementsByTagName("dadosVeiculo");

            //Itera pelos elementos do Nó veiculos e guarda todas as infomações do nó e guarda-os em variáveis do
            //tipo String ou int
            for (int i = 0; i < veiculos.getLength(); i++) {
                Element element = (Element) veiculos.item(i);
                String matricula = element.getElementsByTagName("matricula").item(0).getTextContent();
                String tipoMotor = element.getElementsByTagName("tipoMotor").item(0).getTextContent();
                String capacidadeCarga = element.getElementsByTagName("capacidadeCarga").item(0).getTextContent();
                String potencia = element.getElementsByTagName("potencia").item(0).getTextContent();
                int quilometrosFeitos = Integer.parseInt(element.getElementsByTagName("quilometrosFeitos").item(0).getTextContent());
                int quantidadeLugares = Integer.parseInt(element.getElementsByTagName("quantidadeLugares").item(0).getTextContent());
                int quantidadePortas = Integer.parseInt(element.getElementsByTagName("quantidadePortas").item(0).getTextContent());
                int idTipoVeiculo = Integer.parseInt(element.getElementsByTagName("idTipo").item(0).getTextContent());
                String localidadeVeiculo = element.getElementsByTagName("localidadeVeiculo").item(0).getTextContent();
                String chassiVeiculo = element.getElementsByTagName("chassiVeiculo").item(0).getTextContent();
                String modelo = element.getElementsByTagName("modelo").item(0).getTextContent();
                String marca = element.getElementsByTagName("marca").item(0).getTextContent();
                String tipo = element.getElementsByTagName("tipo").item(0).getTextContent();

                //Cria-se uma query que vai inserir uma nova entrada na tabela TipoVeiculo com os dados que foram guardados anteriormente, substituido o ? na query
                //pelos valores
                String insertTipoVeiculoSQL = "INSERT INTO TipoVeiculo (Chassi, IDTipo, Modelo, Tipo, Marca) VALUES (?, ?, ?, ?, ?)";
                
                //Tenta executar a query substituido os ? pelos valores
                try (PreparedStatement stmtTipo = conn.prepareStatement(insertTipoVeiculoSQL)) {
                    stmtTipo.setString(1, chassiVeiculo);
                    stmtTipo.setInt(2, idTipoVeiculo);
                    stmtTipo.setString(3, modelo);
                    stmtTipo.setString(4, tipo);
                    stmtTipo.setString(5, marca);
                    stmtTipo.executeUpdate();
                    
                    //Cria-se uma query que vai inserir uma nova entrada na tabela Veiculo com os dados que foram guardados anteriormente, substituindo o ? na query
                    String insertVeiculoSQL = "INSERT INTO Veiculo (Matricula, TipoMotor, CapacidadeCarga, Potencia, QuilometrosFeitos, QuantidadeLugares, QuantidadePortas, IDTipoVeiculo, ChassiVeiculo, LocalidadeVeiculo) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                    //Tenta executar a query substituido os ? pelos valores
                    try (PreparedStatement stmtVeiculo = conn.prepareStatement(insertVeiculoSQL)) {
                        stmtVeiculo.setString(1, matricula);
                        stmtVeiculo.setString(2, tipoMotor);
                        stmtVeiculo.setString(3, capacidadeCarga);
                        stmtVeiculo.setString(4, potencia);
                        stmtVeiculo.setInt(5, quilometrosFeitos);
                        stmtVeiculo.setInt(6, quantidadeLugares);
                        stmtVeiculo.setInt(7, quantidadePortas);
                        stmtVeiculo.setInt(8, idTipoVeiculo);
                        stmtVeiculo.setString(9, chassiVeiculo);
                        stmtVeiculo.setString(10, localidadeVeiculo);
                        stmtVeiculo.executeUpdate();
                    }
                }
            }
            //Retorna true visto que a importação foi bem sucedida
            return true;
            //Caso haja algum problema com a obtenção dos dados do ficheiro XML dá-se um erro e retorna-se false
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    //Método que processa um ficheiro JSON para a base de dados
    private boolean processJsonFile(Connection conn, String jsonContent) {
        //Cria-se um novo JSONArray do mesmo tamanho que o ficheiro JSON que está a tentar ser importado
        try {
            JSONArray jsonArray = new JSONArray(jsonContent);
            //Enquanto não chegarmos ao fim do array, iremos percorrer o array e guardar no mesmo as informações
            //sobre o veiculo
            for (int i = 0; i < jsonArray.length(); i++) {
                JSONObject veiculoJson = jsonArray.getJSONObject(i);
                String matricula = veiculoJson.getString("matricula");
                String tipoMotor = veiculoJson.getString("tipoMotor");
                String capacidadeCarga = veiculoJson.getString("capacidadeCarga");
                String potencia = veiculoJson.getString("potencia");
                int quilometrosFeitos = veiculoJson.getInt("quilometrosFeitos");
                int quantidadeLugares = veiculoJson.getInt("quantidadeLugares");
                int quantidadePortas = veiculoJson.getInt("quantidadePortas");
                int idTipoVeiculo = veiculoJson.getInt("idTipoVeiculo");
                String localidadeVeiculo = veiculoJson.getString("localidadeVeiculo");
                String chassiVeiculo = veiculoJson.getString("chassiVeiculo");
                String modelo = veiculoJson.getString("modelo");
                String marca = veiculoJson.getString("marca");
                String tipo = veiculoJson.getString("tipo");
                
                //Cria-se uma query que vai inserir uma nova entrada na tabela TipoVeiculo com os dados que foram guardados anteriormente, substituido o ? na query
                //pelos valores
                String insertTipoVeiculoSQL = "INSERT INTO TipoVeiculo (Chassi, IDTipo, Modelo, Tipo, Marca) VALUES (?, ?, ?, ?, ?)";
                
                //Tenta executar a query substituido os ? pelos valores
                try (PreparedStatement stmtTipo = conn.prepareStatement(insertTipoVeiculoSQL)) {
                    stmtTipo.setString(1, chassiVeiculo);
                    stmtTipo.setInt(2, idTipoVeiculo);
                    stmtTipo.setString(3, modelo);
                    stmtTipo.setString(4, tipo);
                    stmtTipo.setString(5, marca);
                    stmtTipo.executeUpdate();

                    //Cria-se uma query que vai inserir uma nova entrada na tabela Veiculo com os dados que foram guardados anteriormente, substituindo o ? na query
                    String insertVeiculoSQL = "INSERT INTO Veiculo (Matricula, TipoMotor, CapacidadeCarga, Potencia, QuilometrosFeitos, QuantidadeLugares, QuantidadePortas, ChassiVeiculo, IDTipoVeiculo, LocalidadeVeiculo) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                    //Tenta executar a query substituido os ? pelos valores
                    try (PreparedStatement stmtVeiculo = conn.prepareStatement(insertVeiculoSQL)) {
                        stmtVeiculo.setString(1, matricula);
                        stmtVeiculo.setString(2, tipoMotor);
                        stmtVeiculo.setString(3, capacidadeCarga);
                        stmtVeiculo.setString(4, potencia);
                        stmtVeiculo.setInt(5, quilometrosFeitos);
                        stmtVeiculo.setInt(6, quantidadeLugares);
                        stmtVeiculo.setInt(7, quantidadePortas);
                        stmtVeiculo.setString(8, chassiVeiculo);
                        stmtVeiculo.setInt(9, idTipoVeiculo);
                        stmtVeiculo.setString(10, localidadeVeiculo);
                        stmtVeiculo.executeUpdate();
                    }
                }
            }
            //Retorna true visto que a importação foi bem sucedida
            return true;
        //Caso haja algum problema com a obtenção dos dados do ficheiro JSON dá-se um erro e retorna-se false
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}