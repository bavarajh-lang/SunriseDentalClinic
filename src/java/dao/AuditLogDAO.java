package dao;

import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class AuditLogDAO {

    public boolean logAction(
            Integer userId,
            String actionType,
            String description,
            String entityType,
            Long entityId) {

        String sql =
                "INSERT INTO audit_logs " +
                "(user_id, action_type, description, " +
                "entity_type, entity_id) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (
            Connection connection =
                    DBConnection.getInstance()
                            .getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            if (userId != null
                    && userId > 0) {

                statement.setInt(
                        1,
                        userId
                );

            } else {

                statement.setNull(
                        1,
                        java.sql.Types.INTEGER
                );
            }

            statement.setString(
                    2,
                    cleanValue(actionType)
            );

            statement.setString(
                    3,
                    cleanValue(description)
            );

            statement.setString(
                    4,
                    cleanValue(entityType)
            );

            if (entityId != null
                    && entityId > 0) {

                statement.setLong(
                        5,
                        entityId
                );

            } else {

                statement.setNull(
                        5,
                        java.sql.Types.BIGINT
                );
            }

            return statement.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();

            return false;
        }
    }


    public boolean logAction(
            int userId,
            String actionType,
            String description) {

        return logAction(
                userId,
                actionType,
                description,
                null,
                null
        );
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