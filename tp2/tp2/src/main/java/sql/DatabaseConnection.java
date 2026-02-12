package sql;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

//Esta classe é responsável pela conexão com uma database MySQL utilizando JDBC (Java Database Connectivity)
public class DatabaseConnection {
    //Estas variáveis representam valores importantes na conectividade tal como o endereço URL da base de dados
    //ao qual a aplicação vai tentar estabelecer ligação, ao nome do user utilizado para a conexão e a sua
    //senha correspondente.
    private static final String URL = "jdbc:mysql://127.0.0.1:3306/tp_sbd";
    private static final String USER = "root";
    private static final String PASSWORD = "Teofilo123";

    //Tenta-se carregar a classe do driver JDBC do MySQL, este passo é extremamente importante para se conseguir
    //anotar o driver na JVM (Java Virtual Machine)
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            //Caso o driver não seja encontrado irá dar um erro
            throw new RuntimeException("Driver JDBC nÃ£o encontrado!", e);
        }
    }
    
    //Este método irá obter a conexão com a base de dados utilizando como parâmetros as variáveis definidas no inicio
    //caso a conexão não seja bem sucedida irá dar um erro do tipo SQLException 
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
    

}