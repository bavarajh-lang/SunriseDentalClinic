package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL =
            "jdbc:mysql://localhost:3306/sunrise_dental_clinic"
            + "?useSSL=false"
            + "&allowPublicKeyRetrieval=true"
            + "&serverTimezone=Asia/Colombo";

    private static final String USER = "root";
    private static final String PASSWORD = "";

    private static DBConnection instance;

    private DBConnection() {

        try {

            Class.forName(
                    "com.mysql.cj.jdbc.Driver"
            );

        } catch (ClassNotFoundException e) {

            throw new RuntimeException(
                    "MySQL JDBC Driver not found. Check mysql-connector-j JAR.",
                    e
            );
        }
    }

    public static DBConnection getInstance() {

        if (instance == null) {

            instance =
                    new DBConnection();
        }

        return instance;
    }

    public Connection getConnection()
            throws SQLException {

        return DriverManager.getConnection(
                URL,
                USER,
                PASSWORD
        );
    }
}