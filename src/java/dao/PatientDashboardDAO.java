package dao;

import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class PatientDashboardDAO {

    public int getUpcomingAppointmentsCount(
            int patientUserId) {

        if (patientUserId <= 0) {
            return 0;
        }

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM appointments a " +
                "INNER JOIN patients p " +
                "ON a.patient_id = p.patient_id " +
                "WHERE p.user_id = ? " +
                "AND a.status = 'CONFIRMED' " +
                "AND a.appointment_date >= CURRENT_DATE";

        return getCount(
                sql,
                patientUserId
        );
    }


    public int getPendingRequestsCount(
            int patientUserId) {

        if (patientUserId <= 0) {
            return 0;
        }

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM appointments a " +
                "INNER JOIN patients p " +
                "ON a.patient_id = p.patient_id " +
                "WHERE p.user_id = ? " +
                "AND a.status = 'PENDING'";

        return getCount(
                sql,
                patientUserId
        );
    }


    public int getCompletedTreatmentsCount(
            int patientUserId) {

        if (patientUserId <= 0) {
            return 0;
        }

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM treatment_records tr " +
                "INNER JOIN appointments a " +
                "ON tr.appointment_id = a.appointment_id " +
                "INNER JOIN patients p " +
                "ON a.patient_id = p.patient_id " +
                "WHERE p.user_id = ? " +
                "AND a.status = 'COMPLETED'";

        return getCount(
                sql,
                patientUserId
        );
    }


    public int getUnpaidBillsCount(
            int patientUserId) {

        if (patientUserId <= 0) {
            return 0;
        }

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM bills b " +
                "INNER JOIN patients p " +
                "ON b.patient_id = p.patient_id " +
                "WHERE p.user_id = ? " +
                "AND b.payment_status = 'UNPAID'";

        return getCount(
                sql,
                patientUserId
        );
    }


    private int getCount(
            String sql,
            int patientUserId) {

        try (
            Connection connection =
                    DBConnection.getInstance()
                            .getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    patientUserId
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

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return 0;
    }
}