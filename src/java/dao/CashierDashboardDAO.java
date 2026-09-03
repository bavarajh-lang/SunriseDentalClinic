package dao;

import util.DBConnection;

import java.math.BigDecimal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class CashierDashboardDAO {

    public int getPendingBillsCount() {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM bills " +
                "WHERE payment_status = 'UNPAID'";

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


    public int getTodayPaymentsCount() {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM payments " +
                "WHERE payment_status = 'SUCCESS' " +
                "AND DATE(paid_at) = CURRENT_DATE";

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


    public BigDecimal getTodayRevenue() {

        String sql =
                "SELECT COALESCE(SUM(amount), 0) AS total " +
                "FROM payments " +
                "WHERE payment_status = 'SUCCESS' " +
                "AND DATE(paid_at) = CURRENT_DATE";

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

                BigDecimal total =
                        resultSet.getBigDecimal(
                                "total"
                        );

                if (total != null) {

                    return total;
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return BigDecimal.ZERO;
    }


    public int getPaidBillsCount() {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM bills " +
                "WHERE payment_status = 'PAID'";

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
}