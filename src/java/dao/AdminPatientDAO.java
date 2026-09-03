package dao;

import model.AdminPatient;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import java.util.ArrayList;
import java.util.List;

public class AdminPatientDAO {

    public List<AdminPatient> getPatients(
            String search,
            String status) {

        List<AdminPatient> patients =
                new ArrayList<>();

        String cleanSearch =
                cleanValue(search);

        String cleanStatus =
                cleanValue(status);

        StringBuilder sql =
                new StringBuilder();

        sql.append(
                "SELECT " +
                "p.patient_id, " +
                "p.user_id, " +
                "p.patient_no, " +
                "p.date_of_birth AS dob, " +
                "p.gender, " +
                "p.address, " +
                "p.emergency_contact_name, " +
                "p.emergency_contact_phone, " +
                "p.created_at AS patient_created_at, " +

                "u.full_name, " +
                "u.username, " +
                "u.email, " +
                "u.phone, " +
                "u.status AS account_status, " +

                "(SELECT COUNT(*) " +
                "FROM appointments a " +
                "WHERE a.patient_id = p.patient_id) " +
                "AS total_appointments, " +

                "(SELECT COUNT(*) " +
                "FROM appointments a " +
                "WHERE a.patient_id = p.patient_id " +
                "AND a.status = 'COMPLETED') " +
                "AS completed_appointments " +

                "FROM patients p " +

                "INNER JOIN users u " +
                "ON p.user_id = u.user_id " +

                "WHERE u.role = 'PATIENT' "
        );

        List<Object> parameters =
                new ArrayList<>();

        if (cleanSearch != null) {

            sql.append(
                    "AND (" +
                    "p.patient_no LIKE ? " +
                    "OR u.full_name LIKE ? " +
                    "OR u.username LIKE ? " +
                    "OR u.email LIKE ? " +
                    "OR u.phone LIKE ? " +
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

        if (cleanStatus != null
                && isValidStatus(cleanStatus)) {

            sql.append(
                    "AND u.status = ? "
            );

            parameters.add(
                    cleanStatus
            );
        }

        sql.append(
                "ORDER BY " +
                "p.created_at DESC, " +
                "p.patient_id DESC"
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

                    patients.add(
                            mapPatient(
                                    resultSet
                            )
                    );
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return patients;
    }


    public AdminPatient getPatientById(
            int patientId) {

        if (patientId <= 0) {

            return null;
        }

        String sql =
                "SELECT " +
                "p.patient_id, " +
                "p.user_id, " +
                "p.patient_no, " +
                "p.date_of_birth AS dob, " +
                "p.gender, " +
                "p.address, " +
                "p.emergency_contact_name, " +
                "p.emergency_contact_phone, " +
                "p.created_at AS patient_created_at, " +

                "u.full_name, " +
                "u.username, " +
                "u.email, " +
                "u.phone, " +
                "u.status AS account_status, " +

                "(SELECT COUNT(*) " +
                "FROM appointments a " +
                "WHERE a.patient_id = p.patient_id) " +
                "AS total_appointments, " +

                "(SELECT COUNT(*) " +
                "FROM appointments a " +
                "WHERE a.patient_id = p.patient_id " +
                "AND a.status = 'COMPLETED') " +
                "AS completed_appointments " +

                "FROM patients p " +

                "INNER JOIN users u " +
                "ON p.user_id = u.user_id " +

                "WHERE p.patient_id = ? " +
                "AND u.role = 'PATIENT' " +

                "LIMIT 1";

        try (
            Connection connection =
                    DBConnection.getInstance()
                            .getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            sql
                    )
        ) {

            statement.setInt(
                    1,
                    patientId
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (resultSet.next()) {

                    return mapPatient(
                            resultSet
                    );
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }


    public int getTotalPatients() {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM patients p " +
                "INNER JOIN users u " +
                "ON p.user_id = u.user_id " +
                "WHERE u.role = 'PATIENT'";

        return getCount(
                sql
        );
    }


    public int getActivePatients() {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM patients p " +
                "INNER JOIN users u " +
                "ON p.user_id = u.user_id " +
                "WHERE u.role = 'PATIENT' " +
                "AND u.status = 'ACTIVE'";

        return getCount(
                sql
        );
    }


    public int getInactivePatients() {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM patients p " +
                "INNER JOIN users u " +
                "ON p.user_id = u.user_id " +
                "WHERE u.role = 'PATIENT' " +
                "AND u.status = 'INACTIVE'";

        return getCount(
                sql
        );
    }


    private int getCount(
            String sql) {

        try (
            Connection connection =
                    DBConnection.getInstance()
                            .getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            sql
                    );

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


    private AdminPatient mapPatient(
            ResultSet resultSet)
            throws Exception {

        AdminPatient patient =
                new AdminPatient();

        patient.setPatientId(
                resultSet.getInt(
                        "patient_id"
                )
        );

        patient.setUserId(
                resultSet.getInt(
                        "user_id"
                )
        );

        patient.setPatientNo(
                resultSet.getString(
                        "patient_no"
                )
        );

        patient.setFullName(
                resultSet.getString(
                        "full_name"
                )
        );

        patient.setUsername(
                resultSet.getString(
                        "username"
                )
        );

        patient.setEmail(
                resultSet.getString(
                        "email"
                )
        );

        patient.setPhone(
                resultSet.getString(
                        "phone"
                )
        );

        patient.setDob(
                resultSet.getDate(
                        "dob"
                )
        );

        patient.setGender(
                resultSet.getString(
                        "gender"
                )
        );

        patient.setAddress(
                resultSet.getString(
                        "address"
                )
        );

        patient.setEmergencyContactName(
                resultSet.getString(
                        "emergency_contact_name"
                )
        );

        patient.setEmergencyContactPhone(
                resultSet.getString(
                        "emergency_contact_phone"
                )
        );

        patient.setAccountStatus(
                resultSet.getString(
                        "account_status"
                )
        );

        patient.setCreatedAt(
                resultSet.getTimestamp(
                        "patient_created_at"
                )
        );

        patient.setTotalAppointments(
                resultSet.getInt(
                        "total_appointments"
                )
        );

        patient.setCompletedAppointments(
                resultSet.getInt(
                        "completed_appointments"
                )
        );

        return patient;
    }


    private boolean isValidStatus(
            String status) {

        return "ACTIVE".equals(status)
                || "INACTIVE".equals(status);
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