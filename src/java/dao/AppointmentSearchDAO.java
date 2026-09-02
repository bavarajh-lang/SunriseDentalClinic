package dao;

import model.AppointmentSearchResult;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AppointmentSearchDAO {

    public AppointmentSearchResult searchByAppointmentNo(
            String appointmentNo) {

        if (appointmentNo == null
                || appointmentNo.trim().isEmpty()) {

            return null;
        }

        String cleanAppointmentNo =
                appointmentNo.trim();

        String sql =
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

                "WHERE UPPER(a.appointment_no) = UPPER(?) " +
                "LIMIT 1";

        try (
            Connection connection =
                    DBConnection.getInstance()
                            .getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    cleanAppointmentNo
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (!resultSet.next()) {

                    return null;
                }

                return mapAppointmentSearchResult(
                        resultSet
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            return null;
        }
    }


    private AppointmentSearchResult mapAppointmentSearchResult(
            ResultSet resultSet)
            throws Exception {

        AppointmentSearchResult result =
                new AppointmentSearchResult();

        result.setAppointmentId(
                resultSet.getInt(
                        "appointment_id"
                )
        );

        result.setAppointmentNo(
                resultSet.getString(
                        "appointment_no"
                )
        );

        result.setPatientNo(
                resultSet.getString(
                        "patient_no"
                )
        );

        result.setPatientName(
                resultSet.getString(
                        "patient_name"
                )
        );

        result.setPatientPhone(
                resultSet.getString(
                        "patient_phone"
                )
        );

        result.setPatientEmail(
                resultSet.getString(
                        "patient_email"
                )
        );

        result.setDentistName(
                resultSet.getString(
                        "dentist_name"
                )
        );

        result.setDentistSpecialization(
                resultSet.getString(
                        "dentist_specialization"
                )
        );

        result.setServiceCode(
                resultSet.getString(
                        "service_code"
                )
        );

        result.setServiceName(
                resultSet.getString(
                        "service_name"
                )
        );

        result.setAppointmentDate(
                resultSet.getDate(
                        "appointment_date"
                )
        );

        result.setAppointmentTime(
                resultSet.getTime(
                        "appointment_time"
                )
        );

        result.setReason(
                resultSet.getString(
                        "reason"
                )
        );

        result.setStatus(
                resultSet.getString(
                        "status"
                )
        );

        result.setSuggestedDate(
                resultSet.getDate(
                        "suggested_date"
                )
        );

        result.setSuggestedTime(
                resultSet.getTime(
                        "suggested_time"
                )
        );

        result.setAssistantNote(
                resultSet.getString(
                        "assistant_note"
                )
        );

        return result;
    }
}