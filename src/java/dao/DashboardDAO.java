package dao;

import util.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DashboardDAO {

    public int getTotalPatients() {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM patients";

        try (
            Connection connection =
                    DBConnection.getInstance().getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql);

            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            if (resultSet.next()) {

                return resultSet.getInt("total");
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return 0;
    }


    public int getActiveDentists() {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM dentists " +
                "WHERE status = 'ACTIVE'";

        try (
            Connection connection =
                    DBConnection.getInstance().getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql);

            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            if (resultSet.next()) {

                return resultSet.getInt("total");
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return 0;
    }


    public int getTodayAppointments() {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM appointments " +
                "WHERE appointment_date = CURRENT_DATE " +
                "AND status <> 'CANCELLED'";

        try (
            Connection connection =
                    DBConnection.getInstance().getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql);

            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            if (resultSet.next()) {

                return resultSet.getInt("total");
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
                "WHERE status = 'SUCCESS' " +
                "AND DATE(paid_at) = CURRENT_DATE";

        try (
            Connection connection =
                    DBConnection.getInstance().getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql);

            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            if (resultSet.next()) {

                BigDecimal total =
                        resultSet.getBigDecimal("total");

                if (total != null) {

                    return total;
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return BigDecimal.ZERO;
    }
}