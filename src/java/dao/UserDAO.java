package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import model.User;
import util.DBConnection;

public class UserDAO {

    public User login(String usernameOrEmail, String password) {

        String sql =
                "SELECT user_id, full_name, username, email, phone, role, status " +
                "FROM users " +
                "WHERE (username = ? OR email = ?) " +
                "AND password = ? " +
                "AND status = 'ACTIVE'";

        try (
            Connection connection =
                    DBConnection.getInstance().getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(1, usernameOrEmail);
            statement.setString(2, usernameOrEmail);
            statement.setString(3, password);

            try (ResultSet resultSet = statement.executeQuery()) {

                if (resultSet.next()) {

                    User user = new User();

                    user.setUserId(
                            resultSet.getInt("user_id")
                    );

                    user.setFullName(
                            resultSet.getString("full_name")
                    );

                    user.setUsername(
                            resultSet.getString("username")
                    );

                    user.setEmail(
                            resultSet.getString("email")
                    );

                    user.setPhone(
                            resultSet.getString("phone")
                    );

                    user.setRole(
                            resultSet.getString("role")
                    );

                    user.setStatus(
                            resultSet.getString("status")
                    );

                    System.out.println(
                            "LOGIN SUCCESS: " + user.getUsername()
                            + " | ROLE: " + user.getRole()
                    );

                    return user;
                }

                System.out.println(
                        "LOGIN FAILED: No matching active user found."
                );
            }

        } catch (Exception e) {

            System.out.println(
                    "DATABASE LOGIN ERROR: " + e.getMessage()
            );

            e.printStackTrace();
        }

        return null;
    }
}