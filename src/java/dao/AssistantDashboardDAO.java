package dao;

import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AssistantDashboardDAO {

    public int getPendingRequestsCount(
            int assistantUserId) {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM appointments a " +
                "WHERE a.status = 'PENDING' " +
                "AND EXISTS (" +
                "SELECT 1 " +
                "FROM dentist_assistants da " +
                "WHERE da.user_id = ? " +
                "AND da.dentist_id = a.dentist_id" +
                ")";

        return getCount(
                sql,
                assistantUserId
        );
    }


    public int getTodayConfirmedCount(
            int assistantUserId) {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM appointments a " +
                "WHERE a.status = 'CONFIRMED' " +
                "AND a.appointment_date = CURRENT_DATE " +
                "AND EXISTS (" +
                "SELECT 1 " +
                "FROM dentist_assistants da " +
                "WHERE da.user_id = ? " +
                "AND da.dentist_id = a.dentist_id" +
                ")";

        return getCount(
                sql,
                assistantUserId
        );
    }


    public int getCompletedTreatmentsCount(
            int assistantUserId) {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM appointments a " +
                "INNER JOIN treatment_records tr " +
                "ON tr.appointment_id = a.appointment_id " +
                "WHERE a.status = 'COMPLETED' " +
                "AND EXISTS (" +
                "SELECT 1 " +
                "FROM dentist_assistants da " +
                "WHERE da.user_id = ? " +
                "AND da.dentist_id = a.dentist_id" +
                ")";

        return getCount(
                sql,
                assistantUserId
        );
    }


    public int getBillsToGenerateCount(
            int assistantUserId) {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM appointments a " +
                "INNER JOIN treatment_records tr " +
                "ON tr.appointment_id = a.appointment_id " +
                "WHERE a.status = 'COMPLETED' " +

                "AND EXISTS (" +
                "SELECT 1 " +
                "FROM dentist_assistants da " +
                "WHERE da.user_id = ? " +
                "AND da.dentist_id = a.dentist_id" +
                ") " +

                "AND NOT EXISTS (" +
                "SELECT 1 " +
                "FROM bills b " +
                "WHERE b.appointment_id = a.appointment_id" +
                ")";

        return getCount(
                sql,
                assistantUserId
        );
    }


    private int getCount(
            String sql,
            int assistantUserId) {

        if (assistantUserId <= 0) {
            return 0;
        }

        try (
            Connection connection =
                    DBConnection.getInstance()
                            .getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    assistantUserId
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (resultSet.next()) {

                    return resultSet.getInt(
                            "total"
                    );
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return 0;
    }
}