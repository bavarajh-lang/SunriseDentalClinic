package dao;

import model.AdminAuditLog;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;

import java.util.ArrayList;
import java.util.List;

public class AdminAuditLogDAO {

    public List<AdminAuditLog> getLogs(
            String search,
            String entityType,
            String logDate) {

        List<AdminAuditLog> logs =
                new ArrayList<>();

        String cleanSearch =
                cleanValue(search);

        String cleanEntityType =
                cleanValue(entityType);

        String cleanDate =
                cleanValue(logDate);

        StringBuilder sql =
                new StringBuilder();

        sql.append(
                "SELECT " +
                "al.log_id, " +
                "al.user_id, " +
                "al.action_type, " +
                "al.description, " +
                "al.entity_type, " +
                "al.entity_id, " +
                "al.created_at, " +

                "u.full_name AS user_name, " +
                "u.username, " +
                "u.role AS user_role " +

                "FROM audit_logs al " +

                "LEFT JOIN users u " +
                "ON al.user_id = u.user_id " +

                "WHERE 1 = 1 "
        );

        List<Object> parameters =
                new ArrayList<>();

        if (cleanSearch != null) {

            sql.append(
                    "AND (" +
                    "al.action_type LIKE ? " +
                    "OR al.description LIKE ? " +
                    "OR al.entity_type LIKE ? " +
                    "OR u.full_name LIKE ? " +
                    "OR u.username LIKE ? " +
                    ") "
            );

            String likeValue =
                    "%" + cleanSearch + "%";

            parameters.add(likeValue);
            parameters.add(likeValue);
            parameters.add(likeValue);
            parameters.add(likeValue);
            parameters.add(likeValue);
        }

        if (cleanEntityType != null) {

            sql.append(
                    "AND al.entity_type LIKE ? "
            );

            parameters.add(
                    "%" + cleanEntityType + "%"
            );
        }

        if (cleanDate != null) {

            sql.append(
                    "AND DATE(al.created_at) = ? "
            );

            parameters.add(
                    cleanDate
            );
        }

        sql.append(
                "ORDER BY " +
                "al.created_at DESC, " +
                "al.log_id DESC"
        );

        try (
            Connection connection =
                    DBConnection.getInstance()
                            .getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            sql.toString()
                    )
        ) {

            for (int i = 0;
                 i < parameters.size();
                 i++) {

                statement.setObject(
                        i + 1,
                        parameters.get(i)
                );
            }

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                while (resultSet.next()) {

                    logs.add(
                            mapLog(
                                    resultSet
                            )
                    );
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return logs;
    }


    public int getTotalLogs() {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM audit_logs";

        return getCount(sql);
    }


    public int getTodayLogs() {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM audit_logs " +
                "WHERE DATE(created_at) = CURRENT_DATE";

        return getCount(sql);
    }


    public int getUsersWithActivity() {

        String sql =
                "SELECT COUNT(DISTINCT user_id) AS total " +
                "FROM audit_logs " +
                "WHERE user_id IS NOT NULL";

        return getCount(sql);
    }


    public boolean addLog(
            Integer userId,
            String actionType,
            String description,
            String entityType,
            Integer entityId) {

        String cleanAction =
                cleanValue(actionType);

        String cleanDescription =
                cleanValue(description);

        if (cleanAction == null
                || cleanDescription == null) {

            return false;
        }

        String sql =
                "INSERT INTO audit_logs (" +
                "user_id, " +
                "action_type, " +
                "description, " +
                "entity_type, " +
                "entity_id" +
                ") VALUES (?, ?, ?, ?, ?)";

        try (
            Connection connection =
                    DBConnection.getInstance()
                            .getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            if (userId != null) {

                statement.setInt(
                        1,
                        userId
                );

            } else {

                statement.setNull(
                        1,
                        Types.INTEGER
                );
            }

            statement.setString(
                    2,
                    cleanAction
            );

            statement.setString(
                    3,
                    cleanDescription
            );

            if (entityType != null
                    && !entityType.trim().isEmpty()) {

                statement.setString(
                        4,
                        entityType.trim()
                );

            } else {

                statement.setNull(
                        4,
                        Types.VARCHAR
                );
            }

            if (entityId != null) {

                statement.setInt(
                        5,
                        entityId
                );

            } else {

                statement.setNull(
                        5,
                        Types.INTEGER
                );
            }

            return statement.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();

            return false;
        }
    }


    private int getCount(
            String sql) {

        try (
            Connection connection =
                    DBConnection.getInstance()
                            .getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql);

            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            if (resultSet.next()) {

                return resultSet.getInt(
                        "total"
                );
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return 0;
    }


    private AdminAuditLog mapLog(
            ResultSet resultSet)
            throws Exception {

        AdminAuditLog log =
                new AdminAuditLog();

        log.setLogId(
                resultSet.getInt(
                        "log_id"
                )
        );

        int userId =
                resultSet.getInt(
                        "user_id"
                );

        if (resultSet.wasNull()) {

            log.setUserId(null);

        } else {

            log.setUserId(userId);
        }

        log.setActionType(
                resultSet.getString(
                        "action_type"
                )
        );

        log.setDescription(
                resultSet.getString(
                        "description"
                )
        );

        log.setEntityType(
                resultSet.getString(
                        "entity_type"
                )
        );

        int entityId =
                resultSet.getInt(
                        "entity_id"
                );

        if (resultSet.wasNull()) {

            log.setEntityId(null);

        } else {

            log.setEntityId(entityId);
        }

        log.setCreatedAt(
                resultSet.getTimestamp(
                        "created_at"
                )
        );

        log.setUserName(
                resultSet.getString(
                        "user_name"
                )
        );

        log.setUsername(
                resultSet.getString(
                        "username"
                )
        );

        log.setUserRole(
                resultSet.getString(
                        "user_role"
                )
        );

        return log;
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