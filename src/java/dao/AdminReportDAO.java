package dao;

import util.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AdminReportDAO {

    public int getTotalPatients() {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM patients";

        return getCount(sql);
    }


    public int getActiveDentists() {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM dentists " +
                "WHERE status = 'ACTIVE'";

        return getCount(sql);
    }


    public int getAppointmentCount(
            Date fromDate,
            Date toDate) {

        StringBuilder sql =
                new StringBuilder(
                        "SELECT COUNT(*) AS total " +
                        "FROM appointments " +
                        "WHERE 1 = 1 "
                );

        if (fromDate != null) {
            sql.append(
                    "AND appointment_date >= ? "
            );
        }

        if (toDate != null) {
            sql.append(
                    "AND appointment_date <= ? "
            );
        }

        return getAppointmentCount(
                sql.toString(),
                null,
                fromDate,
                toDate
        );
    }


    public int getAppointmentCountByStatus(
            String status,
            Date fromDate,
            Date toDate) {

        StringBuilder sql =
                new StringBuilder(
                        "SELECT COUNT(*) AS total " +
                        "FROM appointments " +
                        "WHERE status = ? "
                );

        if (fromDate != null) {
            sql.append(
                    "AND appointment_date >= ? "
            );
        }

        if (toDate != null) {
            sql.append(
                    "AND appointment_date <= ? "
            );
        }

        return getAppointmentCount(
                sql.toString(),
                status,
                fromDate,
                toDate
        );
    }


    public int getSuccessfulPaymentCount(
            Date fromDate,
            Date toDate) {

        StringBuilder sql =
                new StringBuilder(
                        "SELECT COUNT(*) AS total " +
                        "FROM payments " +
                        "WHERE payment_status = 'SUCCESS' "
                );

        if (fromDate != null) {
            sql.append(
                    "AND DATE(paid_at) >= ? "
            );
        }

        if (toDate != null) {
            sql.append(
                    "AND DATE(paid_at) <= ? "
            );
        }

        return getPaymentCount(
                sql.toString(),
                fromDate,
                toDate
        );
    }


    public BigDecimal getRevenue(
            Date fromDate,
            Date toDate) {

        StringBuilder sql =
                new StringBuilder(
                        "SELECT COALESCE(SUM(amount), 0) AS total " +
                        "FROM payments " +
                        "WHERE payment_status = 'SUCCESS' "
                );

        if (fromDate != null) {
            sql.append(
                    "AND DATE(paid_at) >= ? "
            );
        }

        if (toDate != null) {
            sql.append(
                    "AND DATE(paid_at) <= ? "
            );
        }

        return getPaymentTotal(
                sql.toString(),
                null,
                fromDate,
                toDate
        );
    }


    public BigDecimal getRevenueByMethod(
            String method,
            Date fromDate,
            Date toDate) {

        StringBuilder sql =
                new StringBuilder(
                        "SELECT COALESCE(SUM(amount), 0) AS total " +
                        "FROM payments " +
                        "WHERE payment_status = 'SUCCESS' " +
                        "AND payment_method = ? "
                );

        if (fromDate != null) {
            sql.append(
                    "AND DATE(paid_at) >= ? "
            );
        }

        if (toDate != null) {
            sql.append(
                    "AND DATE(paid_at) <= ? "
            );
        }

        return getPaymentTotal(
                sql.toString(),
                method,
                fromDate,
                toDate
        );
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


    private int getAppointmentCount(
            String sql,
            String status,
            Date fromDate,
            Date toDate) {

        try (
            Connection connection =
                    DBConnection.getInstance()
                            .getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            int index = 1;

            if (status != null) {

                statement.setString(
                        index++,
                        status
                );
            }

            if (fromDate != null) {

                statement.setDate(
                        index++,
                        fromDate
                );
            }

            if (toDate != null) {

                statement.setDate(
                        index,
                        toDate
                );
            }

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


    private int getPaymentCount(
            String sql,
            Date fromDate,
            Date toDate) {

        try (
            Connection connection =
                    DBConnection.getInstance()
                            .getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            int index = 1;

            if (fromDate != null) {

                statement.setDate(
                        index++,
                        fromDate
                );
            }

            if (toDate != null) {

                statement.setDate(
                        index,
                        toDate
                );
            }

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


    private BigDecimal getPaymentTotal(
            String sql,
            String method,
            Date fromDate,
            Date toDate) {

        try (
            Connection connection =
                    DBConnection.getInstance()
                            .getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            int index = 1;

            if (method != null) {

                statement.setString(
                        index++,
                        method
                );
            }

            if (fromDate != null) {

                statement.setDate(
                        index++,
                        fromDate
                );
            }

            if (toDate != null) {

                statement.setDate(
                        index,
                        toDate
                );
            }

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (resultSet.next()) {

                    BigDecimal total =
                            resultSet.getBigDecimal(
                                    "total"
                            );

                    return total != null
                            ? total
                            : BigDecimal.ZERO;
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return BigDecimal.ZERO;
    }
}