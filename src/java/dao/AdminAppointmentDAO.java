package dao;

import model.AppointmentSearchResult;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import java.util.ArrayList;
import java.util.List;

public class AdminAppointmentDAO {

    public List<AppointmentSearchResult> getAppointments(
            String search,
            String status,
            String appointmentDate) {

        List<AppointmentSearchResult> appointments =
                new ArrayList<>();

        String cleanSearch =
                cleanValue(search);

        String cleanStatus =
                cleanValue(status);

        String cleanDate =
                cleanValue(appointmentDate);

        StringBuilder sql =
                new StringBuilder();

        sql.append(
                "SELECT " +
                "a.appointment_id, " +
                "a.appointment_no, " +
                "a.appointment_date, " +
                "a.appointment_time, " +
                "a.reason, " +
                "a.status, " +
                "a.suggested_date, " +
                "a.suggested_time, " +
                "a.assistant_note, " +
                "p.patient_no, " +
                "pu.full_name AS patient_name, " +
                "pu.phone AS patient_phone, " +
                "pu.email AS patient_email, " +
                "d.full_name AS dentist_name, " +
                "d.specialization AS dentist_specialization, " +
                "ds.service_code, " +
                "ds.service_name " +
                "FROM appointments a " +
                "INNER JOIN patients p " +
                "ON a.patient_id = p.patient_id " +
                "INNER JOIN users pu " +
                "ON p.user_id = pu.user_id " +
                "INNER JOIN dentists d " +
                "ON a.dentist_id = d.dentist_id " +
                "INNER JOIN dental_services ds " +
                "ON a.service_id = ds.service_id " +
                "WHERE 1 = 1 "
        );

        List<Object> parameters =
                new ArrayList<>();

        if (cleanSearch != null) {

            sql.append(
                    "AND (" +
                    "a.appointment_no LIKE ? " +
                    "OR p.patient_no LIKE ? " +
                    "OR pu.full_name LIKE ? " +
                    "OR d.full_name LIKE ? " +
                    "OR ds.service_name LIKE ? " +
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
                    "AND a.status = ? "
            );

            parameters.add(
                    cleanStatus
            );
        }

        if (cleanDate != null) {

            sql.append(
                    "AND a.appointment_date = ? "
            );

            parameters.add(
                    cleanDate
            );
        }

        sql.append(
                "ORDER BY " +
                "a.appointment_date DESC, " +
                "a.appointment_time DESC, " +
                "a.appointment_id DESC"
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

                    appointments.add(
                            mapAppointment(
                                    resultSet
                            )
                    );
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return appointments;
    }


    public int getTotalAppointments() {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM appointments";

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


    public int getPendingAppointments() {

        return getCountByStatus(
                "PENDING"
        );
    }


    public int getConfirmedAppointments() {

        return getCountByStatus(
                "CONFIRMED"
        );
    }


    public int getCompletedAppointments() {

        return getCountByStatus(
                "COMPLETED"
        );
    }


    private int getCountByStatus(
            String status) {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM appointments " +
                "WHERE status = ?";

        try (
            Connection connection =
                    DBConnection.getInstance()
                            .getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    status
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


    private AppointmentSearchResult mapAppointment(
            ResultSet resultSet)
            throws Exception {

        AppointmentSearchResult appointment =
                new AppointmentSearchResult();

        appointment.setAppointmentId(
                resultSet.getInt(
                        "appointment_id"
                )
        );

        appointment.setAppointmentNo(
                resultSet.getString(
                        "appointment_no"
                )
        );

        appointment.setAppointmentDate(
                resultSet.getDate(
                        "appointment_date"
                )
        );

        appointment.setAppointmentTime(
                resultSet.getTime(
                        "appointment_time"
                )
        );

        appointment.setReason(
                resultSet.getString(
                        "reason"
                )
        );

        appointment.setStatus(
                resultSet.getString(
                        "status"
                )
        );

        appointment.setSuggestedDate(
                resultSet.getDate(
                        "suggested_date"
                )
        );

        appointment.setSuggestedTime(
                resultSet.getTime(
                        "suggested_time"
                )
        );

        appointment.setAssistantNote(
                resultSet.getString(
                        "assistant_note"
                )
        );

        appointment.setPatientNo(
                resultSet.getString(
                        "patient_no"
                )
        );

        appointment.setPatientName(
                resultSet.getString(
                        "patient_name"
                )
        );

        appointment.setPatientPhone(
                resultSet.getString(
                        "patient_phone"
                )
        );

        appointment.setPatientEmail(
                resultSet.getString(
                        "patient_email"
                )
        );

        appointment.setDentistName(
                resultSet.getString(
                        "dentist_name"
                )
        );

        appointment.setDentistSpecialization(
                resultSet.getString(
                        "dentist_specialization"
                )
        );

        appointment.setServiceCode(
                resultSet.getString(
                        "service_code"
                )
        );

        appointment.setServiceName(
                resultSet.getString(
                        "service_name"
                )
        );

        return appointment;
    }


    private boolean isValidStatus(
            String status) {

        return "PENDING".equals(status)
                || "CONFIRMED".equals(status)
                || "RESCHEDULE_REQUESTED".equals(status)
                || "COMPLETED".equals(status)
                || "CANCELLED".equals(status);
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