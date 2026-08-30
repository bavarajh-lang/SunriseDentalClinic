package dao;

import model.DentalService;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class DentalServiceDAO {

    public List<DentalService> getActiveServices() {

        List<DentalService> services = new ArrayList<>();

        String sql =
                "SELECT service_id, service_code, service_name, " +
                "description, base_price, duration_minutes, status " +
                "FROM dental_services " +
                "WHERE status = 'ACTIVE' " +
                "ORDER BY service_name ASC";

        try (
            Connection connection =
                    DBConnection.getInstance().getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql);

            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            while (resultSet.next()) {

                DentalService service = new DentalService();

                service.setServiceId(
                        resultSet.getInt("service_id")
                );

                service.setServiceCode(
                        resultSet.getString("service_code")
                );

                service.setServiceName(
                        resultSet.getString("service_name")
                );

                service.setDescription(
                        resultSet.getString("description")
                );

                service.setBasePrice(
                        resultSet.getDouble("base_price")
                );

                service.setDurationMinutes(
                        resultSet.getInt("duration_minutes")
                );

                service.setStatus(
                        resultSet.getString("status")
                );

                services.add(service);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return services;
    }
}