package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import model.Patient;
import util.DBConnection;

public class PatientDAO {

    public boolean registerPatient(Patient patient) {

        Connection connection = null;

        String userSql =
                "INSERT INTO users " +
                "(full_name, username, email, password, phone, role, status) " +
                "VALUES (?, ?, ?, ?, ?, 'PATIENT', 'ACTIVE')";

        String patientSql =
                "INSERT INTO patients " +
                "(user_id, patient_no, date_of_birth, gender, address, " +
                "emergency_contact_name, emergency_contact_phone) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try {

            connection =
                    DBConnection.getInstance().getConnection();

            connection.setAutoCommit(false);

            PreparedStatement userStatement =
                    connection.prepareStatement(
                            userSql,
                            PreparedStatement.RETURN_GENERATED_KEYS
                    );

            userStatement.setString(1, patient.getFullName());
            userStatement.setString(2, patient.getUsername());
            userStatement.setString(3, patient.getEmail());
            userStatement.setString(4, patient.getPassword());
            userStatement.setString(5, patient.getPhone());

            int userResult = userStatement.executeUpdate();

            if (userResult == 0) {
                connection.rollback();
                return false;
            }

            ResultSet generatedKeys =
                    userStatement.getGeneratedKeys();

            if (!generatedKeys.next()) {
                connection.rollback();
                return false;
            }

            int userId = generatedKeys.getInt(1);

            String patientNo =
                    generatePatientNumber(connection);

            PreparedStatement patientStatement =
                    connection.prepareStatement(patientSql);

            patientStatement.setInt(1, userId);
            patientStatement.setString(2, patientNo);
            patientStatement.setString(3, patient.getDateOfBirth());
            patientStatement.setString(4, patient.getGender());
            patientStatement.setString(5, patient.getAddress());
            patientStatement.setString(
                    6,
                    patient.getEmergencyContactName()
            );
            patientStatement.setString(
                    7,
                    patient.getEmergencyContactPhone()
            );

            int patientResult =
                    patientStatement.executeUpdate();

            if (patientResult > 0) {

                connection.commit();
                return true;

            } else {

                connection.rollback();
                return false;
            }

        } catch (Exception e) {

            try {

                if (connection != null) {
                    connection.rollback();
                }

            } catch (Exception rollbackException) {
                rollbackException.printStackTrace();
            }

            e.printStackTrace();
            return false;

        } finally {

            try {

                if (connection != null) {
                    connection.setAutoCommit(true);
                    connection.close();
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private String generatePatientNumber(
            Connection connection) throws Exception {

        String sql =
                "SELECT MAX(patient_id) AS max_id FROM patients";

        PreparedStatement statement =
                connection.prepareStatement(sql);

        ResultSet resultSet =
                statement.executeQuery();

        int nextNumber = 1;

        if (resultSet.next()) {

            int maxId =
                    resultSet.getInt("max_id");

            nextNumber = maxId + 1;
        }

        return String.format(
                "PAT-%04d",
                nextNumber
        );
    }
}