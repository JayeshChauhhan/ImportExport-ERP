package db_config;

import java.sql.Connection;
import java.sql.DriverManager;

public class GetConnection {

    private static final String URL = "jdbc:mysql://localhost:3306/erp";
    private static final String USER = "root";
    private static final String PASSWORD = "@Piyush_s_11";

    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("com.mysql.jdbc.Driver"); // 5.1.x DRIVER
            con = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("✅ Database Connected Successfully");
        } catch (Exception e) {
            System.out.println("❌ Database Connection Failed");
            e.printStackTrace();
        }
        return con;
    }

    public static void main(String[] args) {
        Connection c = getConnection();
        if (c != null) {
            System.out.println("✅ Connection test passed");
        } else {
            System.out.println("❌ Connection test failed");
        }
    }
}