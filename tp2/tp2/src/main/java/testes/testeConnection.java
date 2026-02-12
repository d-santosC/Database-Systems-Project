package testes;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class testeConnection {
    public static void main(String[] args) {
        String url = "jdbc:mysql://127.0.0.1:3306/tp_sbd";
        String user = "root";
        String password = "Teofilo123";

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            System.out.println("Conexão bem-sucedida com o banco de dados!");
        } catch (SQLException e) {
            System.err.println("Erro ao conectar ao banco de dados: " + e.getMessage());
            e.printStackTrace();
        }
    }
}