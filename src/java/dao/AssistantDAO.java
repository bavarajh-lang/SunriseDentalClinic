package dao;

import model.Assistant;
import model.Dentist;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class AssistantDAO {

    public List<Assistant> getAllAssistants() {

        List<Assistant> assistants =
                new ArrayList<>();

        String sql =
                "SELECT " +
                "u.user_id, " +
                "u.full_name, " +
                "u.username, " +
                "u.email, " +
                "u.phone, " +
                "u.status, " +
                "da.assistant_id, " +
                "da.assistant_no, " +
                "da.dentist_id, " +
                "d.dentist_no, " +
                "d.full_name AS dentist_name, " +
                "d.specialization AS dentist_specialization " +
                "FROM users u " +
                "LEFT JOIN dentist_assistants da " +
                "ON u.user_id = da.user_id " +
                "LEFT JOIN dentists d " +
                "ON da.dentist_id = d.dentist_id " +
                "WHERE u.role = 'ASSISTANT' " +
                "ORDER BY u.full_name ASC";

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

                Assistant assistant =
                        new Assistant();

                assistant.setUserId(
                        resultSet.getInt(
                                "user_id"
                        )
                );

                assistant.setFullName(
                        resultSet.getString(
                                "full_name"
                        )
                );

                assistant.setUsername(
                        resultSet.getString(
                                "username"
                        )
                );

                assistant.setEmail(
                        resultSet.getString(
                                "email"
                        )
                );

                assistant.setPhone(
                        resultSet.getString(
                                "phone"
                        )
                );

                assistant.setStatus(
                        resultSet.getString(
                                "status"
                        )
                );

                assistant.setAssistantId(
                        resultSet.getInt(
                                "assistant_id"
                        )
                );

                assistant.setAssistantNo(
                        resultSet.getString(
                                "assistant_no"
                        )
                );

                assistant.setDentistId(
                        resultSet.getInt(
                                "dentist_id"
                        )
                );

                assistant.setDentistNo(
                        resultSet.getString(
                                "dentist_no"
                        )
                );

                assistant.setDentistName(
                        resultSet.getString(
                                "dentist_name"
                        )
                );

                assistant.setDentistSpecialization(
                        resultSet.getString(
                                "dentist_specialization"
                        )
                );

                assistants.add(
                        assistant
                );
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return assistants;
    }


    public List<Dentist> getUnassignedDentists() {

        List<Dentist> dentists =
                new ArrayList<>();

        String sql =
                "SELECT " +
                "d.dentist_id, " +
                "d.dentist_no, " +
                "d.full_name, " +
                "d.specialization, " +
                "d.phone, " +
                "d.email, " +
                "d.consultation_fee, " +
                "d.status " +
                "FROM dentists d " +
                "LEFT JOIN dentist_assistants da " +
                "ON d.dentist_id = da.dentist_id " +
                "WHERE d.status = 'ACTIVE' " +
                "AND da.assistant_id IS NULL " +
                "ORDER BY d.full_name ASC";

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

                Dentist dentist =
                        new Dentist();

                dentist.setDentistId(
                        resultSet.getInt(
                                "dentist_id"
                        )
                );

                dentist.setDentistNo(
                        resultSet.getString(
                                "dentist_no"
                        )
                );

                dentist.setFullName(
                        resultSet.getString(
                                "full_name"
                        )
                );

                dentist.setSpecialization(
                        resultSet.getString(
                                "specialization"
                        )
                );

                dentist.setPhone(
                        resultSet.getString(
                                "phone"
                        )
                );

                dentist.setEmail(
                        resultSet.getString(
                                "email"
                        )
                );

                dentist.setConsultationFee(
                        resultSet.getDouble(
                                "consultation_fee"
                        )
                );

                dentist.setStatus(
                        resultSet.getString(
                                "status"
                        )
                );

                dentists.add(
                        dentist
                );
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return dentists;
    }


    public boolean addAssistant(
            Assistant assistant,
            String password,
            int dentistId) {

        Connection connection = null;

        String dentistSql =
                "SELECT dentist_id " +
                "FROM dentists " +
                "WHERE dentist_id = ? " +
                "AND status = 'ACTIVE' " +
                "AND NOT EXISTS (" +
                "SELECT 1 " +
                "FROM dentist_assistants " +
                "WHERE dentist_id = ?" +
                ") " +
                "FOR UPDATE";

        String userSql =
                "INSERT INTO users " +
                "(full_name, username, email, password, phone, role, status) " +
                "VALUES (?, ?, ?, ?, ?, 'ASSISTANT', 'ACTIVE')";

        String assignmentSql =
                "INSERT INTO dentist_assistants " +
                "(user_id, dentist_id, assistant_no) " +
                "VALUES (?, ?, ?)";

        try {

            connection =
                    DBConnection.getInstance()
                            .getConnection();

            connection.setAutoCommit(false);

            try (
                PreparedStatement dentistStatement =
                        connection.prepareStatement(
                                dentistSql
                        )
            ) {

                dentistStatement.setInt(
                        1,
                        dentistId
                );

                dentistStatement.setInt(
                        2,
                        dentistId
                );

                try (
                    ResultSet resultSet =
                            dentistStatement.executeQuery()
                ) {

                    if (!resultSet.next()) {

                        connection.rollback();

                        return false;
                    }
                }
            }

            int userId;

            try (
                PreparedStatement userStatement =
                        connection.prepareStatement(
                                userSql,
                                Statement.RETURN_GENERATED_KEYS
                        )
            ) {

                userStatement.setString(
                        1,
                        assistant.getFullName()
                );

                userStatement.setString(
                        2,
                        assistant.getUsername()
                );

                userStatement.setString(
                        3,
                        assistant.getEmail()
                );

                userStatement.setString(
                        4,
                        password
                );

                userStatement.setString(
                        5,
                        cleanValue(
                                assistant.getPhone()
                        )
                );

                int userResult =
                        userStatement.executeUpdate();

                if (userResult == 0) {

                    connection.rollback();

                    return false;
                }

                try (
                    ResultSet generatedKeys =
                            userStatement.getGeneratedKeys()
                ) {

                    if (!generatedKeys.next()) {

                        connection.rollback();

                        return false;
                    }

                    userId =
                            generatedKeys.getInt(1);
                }
            }

            String assistantNo =
                    generateAssistantNumber();

            try (
                PreparedStatement assignmentStatement =
                        connection.prepareStatement(
                                assignmentSql,
                                Statement.RETURN_GENERATED_KEYS
                        )
            ) {

                assignmentStatement.setInt(
                        1,
                        userId
                );

                assignmentStatement.setInt(
                        2,
                        dentistId
                );

                assignmentStatement.setString(
                        3,
                        assistantNo
                );

                int assignmentResult =
                        assignmentStatement.executeUpdate();

                if (assignmentResult == 0) {

                    connection.rollback();

                    return false;
                }

                try (
                    ResultSet generatedKeys =
                            assignmentStatement.getGeneratedKeys()
                ) {

                    if (generatedKeys.next()) {

                        assistant.setAssistantId(
                                generatedKeys.getInt(1)
                        );
                    }
                }
            }

            assistant.setUserId(
                    userId
            );

            assistant.setDentistId(
                    dentistId
            );

            assistant.setAssistantNo(
                    assistantNo
            );

            assistant.setStatus(
                    "ACTIVE"
            );

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


    public boolean updateAssistantStatus(
            int userId,
            String status) {

        if (!"ACTIVE".equals(status)
                && !"INACTIVE".equals(status)) {

            return false;
        }

        String sql =
                "UPDATE users " +
                "SET status = ? " +
                "WHERE user_id = ? " +
                "AND role = 'ASSISTANT'";

        try (
            Connection connection =
                    DBConnection.getInstance()
                            .getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    status
            );

            statement.setInt(
                    2,
                    userId
            );

            return statement.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }


    private String generateAssistantNumber() {

        String randomPart =
                UUID.randomUUID()
                        .toString()
                        .replace("-", "")
                        .substring(0, 6)
                        .toUpperCase();

        return "AST-" + randomPart;
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