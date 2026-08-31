package dao;

import model.Cashier;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import java.util.ArrayList;
import java.util.List;

public class CashierDAO {

    public List<Cashier> getAllCashiers() {

        List<Cashier> cashiers =
                new ArrayList<>();

        String sql =
                "SELECT " +
                "user_id, " +
                "full_name, " +
                "username, " +
                "email, " +
                "phone, " +
                "status " +
                "FROM users " +
                "WHERE role = 'CASHIER' " +
                "ORDER BY created_at DESC";

        try (
            Connection connection =
                    DBConnection.getInstance()
                            .getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql);

            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            while (resultSet.next()) {

                Cashier cashier =
                        new Cashier();

                cashier.setUserId(
                        resultSet.getInt(
                                "user_id"
                        )
                );

                cashier.setFullName(
                        resultSet.getString(
                                "full_name"
                        )
                );

                cashier.setUsername(
                        resultSet.getString(
                                "username"
                        )
                );

                cashier.setEmail(
                        resultSet.getString(
                                "email"
                        )
                );

                cashier.setPhone(
                        resultSet.getString(
                                "phone"
                        )
                );

                cashier.setStatus(
                        resultSet.getString(
                                "status"
                        )
                );

                cashiers.add(
                        cashier
                );
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return cashiers;
    }


    public boolean hasActiveCashier() {

        String sql =
                "SELECT user_id " +
                "FROM users " +
                "WHERE role = 'CASHIER' " +
                "AND status = 'ACTIVE' " +
                "LIMIT 1";

        try (
            Connection connection =
                    DBConnection.getInstance()
                            .getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql);

            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            return resultSet.next();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return true;
    }


    public boolean addCashier(
            Cashier cashier,
            String password) {

        Connection connection = null;

        String checkSql =
                "SELECT user_id " +
                "FROM users " +
                "WHERE role = 'CASHIER' " +
                "AND status = 'ACTIVE' " +
                "LIMIT 1 " +
                "FOR UPDATE";

        String insertSql =
                "INSERT INTO users " +
                "(full_name, username, email, password, phone, role, status) " +
                "VALUES (?, ?, ?, ?, ?, 'CASHIER', 'ACTIVE')";

        try {

            connection =
                    DBConnection.getInstance()
                            .getConnection();

            connection.setAutoCommit(false);

            try (
                PreparedStatement checkStatement =
                        connection.prepareStatement(
                                checkSql
                        );

                ResultSet resultSet =
                        checkStatement.executeQuery()
            ) {

                if (resultSet.next()) {

                    connection.rollback();

                    return false;
                }
            }

            try (
                PreparedStatement insertStatement =
                        connection.prepareStatement(
                                insertSql
                        )
            ) {

                insertStatement.setString(
                        1,
                        cashier.getFullName()
                );

                insertStatement.setString(
                        2,
                        cashier.getUsername()
                );

                insertStatement.setString(
                        3,
                        cashier.getEmail()
                );

                insertStatement.setString(
                        4,
                        password
                );

                insertStatement.setString(
                        5,
                        cleanValue(
                                cashier.getPhone()
                        )
                );

                int result =
                        insertStatement.executeUpdate();

                if (result == 0) {

                    connection.rollback();

                    return false;
                }
            }

            connection.commit();

            cashier.setStatus(
                    "ACTIVE"
            );

            return true;

        } catch (Exception e) {

            e.printStackTrace();

            if (connection != null) {

                try {

                    connection.rollback();

                } catch (Exception rollbackException) {

                    rollbackException.printStackTrace();
                }
            }

            return false;

        } finally {

            if (connection != null) {

                try {

                    connection.setAutoCommit(true);
                    connection.close();

                } catch (Exception e) {

                    e.printStackTrace();
                }
            }
        }
    }


    public boolean updateCashierStatus(
            int userId,
            String status) {

        if (!"ACTIVE".equals(status)
                && !"INACTIVE".equals(status)) {

            return false;
        }

        Connection connection = null;

        try {

            connection =
                    DBConnection.getInstance()
                            .getConnection();

            connection.setAutoCommit(false);

            if ("ACTIVE".equals(status)) {

                String checkSql =
                        "SELECT user_id " +
                        "FROM users " +
                        "WHERE role = 'CASHIER' " +
                        "AND status = 'ACTIVE' " +
                        "AND user_id <> ? " +
                        "LIMIT 1 " +
                        "FOR UPDATE";

                try (
                    PreparedStatement checkStatement =
                            connection.prepareStatement(
                                    checkSql
                            )
                ) {

                    checkStatement.setInt(
                            1,
                            userId
                    );

                    try (
                        ResultSet resultSet =
                                checkStatement.executeQuery()
                    ) {

                        if (resultSet.next()) {

                            connection.rollback();

                            return false;
                        }
                    }
                }
            }

            String updateSql =
                    "UPDATE users " +
                    "SET status = ? " +
                    "WHERE user_id = ? " +
                    "AND role = 'CASHIER'";

            try (
                PreparedStatement updateStatement =
                        connection.prepareStatement(
                                updateSql
                        )
            ) {

                updateStatement.setString(
                        1,
                        status
                );

                updateStatement.setInt(
                        2,
                        userId
                );

                int result =
                        updateStatement.executeUpdate();

                if (result == 0) {

                    connection.rollback();

                    return false;
                }
            }

            connection.commit();

            return true;

        } catch (Exception e) {

            e.printStackTrace();

            if (connection != null) {

                try {

                    connection.rollback();

                } catch (Exception rollbackException) {

                    rollbackException.printStackTrace();
                }
            }

            return false;

        } finally {

            if (connection != null) {

                try {

                    connection.setAutoCommit(true);
                    connection.close();

                } catch (Exception e) {

                    e.printStackTrace();
                }
            }
        }
    }


    public boolean usernameExists(
            String username) {

        String sql =
                "SELECT user_id " +
                "FROM users " +
                "WHERE username = ?";

        try (
            Connection connection =
                    DBConnection.getInstance()
                            .getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    username
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                return resultSet.next();
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return true;
    }


    public boolean emailExists(
            String email) {

        String sql =
                "SELECT user_id " +
                "FROM users " +
                "WHERE email = ?";

        try (
            Connection connection =
                    DBConnection.getInstance()
                            .getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    email
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                return resultSet.next();
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return true;
    }


    private String cleanValue(
            String value) {

        if (value == null
                || value.trim().isEmpty()) {

            return null;
        }

        return value.trim();
    }
}