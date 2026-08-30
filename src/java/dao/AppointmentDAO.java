package dao;

import model.Appointment;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.sql.Time;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class AppointmentDAO {


    // =========================================================
    // GET PATIENT ID USING LOGGED-IN USER ID
    // =========================================================

    public int getPatientIdByUserId(int userId) {

        String sql =
                "SELECT patient_id " +
                "FROM patients " +
                "WHERE user_id = ?";

        try (
            Connection connection =
                    DBConnection.getInstance().getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setInt(1, userId);

            try (ResultSet resultSet = statement.executeQuery()) {

                if (resultSet.next()) {

                    return resultSet.getInt("patient_id");
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return -1;
    }


    // =========================================================
    // CHECK PATIENT BOOKING SLOT AVAILABILITY
    // =========================================================

    public boolean isSlotAvailable(
            int dentistId,
            Date appointmentDate,
            Time appointmentTime) {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM appointments " +
                "WHERE dentist_id = ? " +
                "AND (" +

                    "(" +
                        "appointment_date = ? " +
                        "AND appointment_time = ? " +
                        "AND status IN " +
                        "('PENDING','CONFIRMED','RESCHEDULE_REQUESTED')" +
                    ")" +

                    " OR " +

                    "(" +
                        "suggested_date = ? " +
                        "AND suggested_time = ? " +
                        "AND status = 'RESCHEDULE_REQUESTED'" +
                    ")" +

                ")";

        try (
            Connection connection =
                    DBConnection.getInstance().getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setInt(1, dentistId);

            statement.setDate(
                    2,
                    appointmentDate
            );

            statement.setTime(
                    3,
                    appointmentTime
            );

            statement.setDate(
                    4,
                    appointmentDate
            );

            statement.setTime(
                    5,
                    appointmentTime
            );


            try (ResultSet resultSet = statement.executeQuery()) {

                if (resultSet.next()) {

                    return resultSet.getInt("total") == 0;
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }

/*
 * =========================================================
 * ASSISTANT - GET CONFIRMED APPOINTMENTS
 * =========================================================
 *
 * Logged-in assistant-ku assign pannina
 * dentist-oda CONFIRMED appointments mattum.
 */
public List<Appointment> getConfirmedAppointmentsByAssistantUserId(
        int assistantUserId) {

    List<Appointment> appointments =
            new ArrayList<>();

    String sql =
            "SELECT " +

            "a.appointment_id, " +
            "a.appointment_no, " +
            "a.patient_id, " +
            "a.dentist_id, " +
            "a.service_id, " +

            "a.appointment_date, " +
            "a.appointment_time, " +

            "a.reason, " +
            "a.status, " +

            "a.suggested_date, " +
            "a.suggested_time, " +
            "a.assistant_note, " +

            "p.patient_no AS patient_no, " +
            "pu.full_name AS patient_name, " +

            "d.full_name AS dentist_name, " +
            "d.specialization AS dentist_specialization, " +

            "s.service_name AS service_name " +

            "FROM dentist_assistants da " +

            "INNER JOIN appointments a " +
            "ON da.dentist_id = a.dentist_id " +

            "INNER JOIN patients p " +
            "ON a.patient_id = p.patient_id " +

            "INNER JOIN users pu " +
            "ON p.user_id = pu.user_id " +

            "INNER JOIN dentists d " +
            "ON a.dentist_id = d.dentist_id " +

            "INNER JOIN dental_services s " +
            "ON a.service_id = s.service_id " +

            "WHERE da.user_id = ? " +

            "AND a.status = 'CONFIRMED' " +

            "ORDER BY " +
            "a.appointment_date ASC, " +
            "a.appointment_time ASC";


    try (
        Connection connection =
                DBConnection.getInstance().getConnection();

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

            while (resultSet.next()) {

                Appointment appointment =
                        new Appointment();


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

                appointment.setPatientId(
                        resultSet.getInt(
                                "patient_id"
                        )
                );

                appointment.setDentistId(
                        resultSet.getInt(
                                "dentist_id"
                        )
                );

                appointment.setServiceId(
                        resultSet.getInt(
                                "service_id"
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


                /*
                 * Patient
                 */

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


                /*
                 * Dentist
                 */

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


                /*
                 * Requested Service
                 */

                appointment.setServiceName(
                        resultSet.getString(
                                "service_name"
                        )
                );


                appointments.add(
                        appointment
                );
            }
        }

    } catch (Exception e) {

        e.printStackTrace();
    }


    return appointments;
}
    // =========================================================
    // CREATE NEW APPOINTMENT
    // =========================================================

    public boolean createAppointment(
            Appointment appointment) {

        String sql =
                "INSERT INTO appointments " +
                "(appointment_no, patient_id, dentist_id, service_id, " +
                "appointment_date, appointment_time, reason, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, 'PENDING')";

        String appointmentNo =
                generateAppointmentNumber();

        try (
            Connection connection =
                    DBConnection.getInstance().getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    appointmentNo
            );

            statement.setInt(
                    2,
                    appointment.getPatientId()
            );

            statement.setInt(
                    3,
                    appointment.getDentistId()
            );

            statement.setInt(
                    4,
                    appointment.getServiceId()
            );

            statement.setDate(
                    5,
                    appointment.getAppointmentDate()
            );

            statement.setTime(
                    6,
                    appointment.getAppointmentTime()
            );

            statement.setString(
                    7,
                    appointment.getReason()
            );


            int result =
                    statement.executeUpdate();


            if (result > 0) {

                appointment.setAppointmentNo(
                        appointmentNo
                );

                appointment.setStatus(
                        "PENDING"
                );

                return true;
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }


    // =========================================================
    // PATIENT - GET MY APPOINTMENTS
    // =========================================================

    public List<Appointment> getAppointmentsByUserId(
            int userId) {

        List<Appointment> appointments =
                new ArrayList<>();


        String sql =
                "SELECT " +

                "a.appointment_id, " +
                "a.appointment_no, " +
                "a.patient_id, " +
                "a.dentist_id, " +
                "a.service_id, " +

                "a.appointment_date, " +
                "a.appointment_time, " +

                "a.reason, " +
                "a.status, " +

                "a.suggested_date, " +
                "a.suggested_time, " +
                "a.assistant_note, " +

                "d.full_name AS dentist_name, " +
                "d.specialization AS dentist_specialization, " +

                "s.service_name AS service_name " +

                "FROM appointments a " +

                "INNER JOIN patients p " +
                "ON a.patient_id = p.patient_id " +

                "INNER JOIN dentists d " +
                "ON a.dentist_id = d.dentist_id " +

                "INNER JOIN dental_services s " +
                "ON a.service_id = s.service_id " +

                "WHERE p.user_id = ? " +

                "ORDER BY " +
                "a.appointment_date DESC, " +
                "a.appointment_time DESC";


        try (
            Connection connection =
                    DBConnection.getInstance().getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    userId
            );


            try (ResultSet resultSet = statement.executeQuery()) {

                while (resultSet.next()) {

                    Appointment appointment =
                            new Appointment();


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

                    appointment.setPatientId(
                            resultSet.getInt(
                                    "patient_id"
                            )
                    );

                    appointment.setDentistId(
                            resultSet.getInt(
                                    "dentist_id"
                            )
                    );

                    appointment.setServiceId(
                            resultSet.getInt(
                                    "service_id"
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


                    appointment.setServiceName(
                            resultSet.getString(
                                    "service_name"
                            )
                    );


                    appointments.add(
                            appointment
                    );
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return appointments;
    }


    // =========================================================
    // ASSISTANT - GET ASSIGNED DENTIST PENDING APPOINTMENTS
    // =========================================================

    public List<Appointment>
            getPendingAppointmentsByAssistantUserId(
                    int assistantUserId) {

        List<Appointment> appointments =
                new ArrayList<>();


        String sql =
                "SELECT " +

                "a.appointment_id, " +
                "a.appointment_no, " +
                "a.patient_id, " +
                "a.dentist_id, " +
                "a.service_id, " +

                "a.appointment_date, " +
                "a.appointment_time, " +

                "a.reason, " +
                "a.status, " +

                "a.suggested_date, " +
                "a.suggested_time, " +
                "a.assistant_note, " +

                "p.patient_no AS patient_no, " +
                "pu.full_name AS patient_name, " +

                "d.full_name AS dentist_name, " +
                "d.specialization AS dentist_specialization, " +

                "s.service_name AS service_name " +

                "FROM dentist_assistants da " +

                "INNER JOIN appointments a " +
                "ON da.dentist_id = a.dentist_id " +

                "INNER JOIN patients p " +
                "ON a.patient_id = p.patient_id " +

                "INNER JOIN users pu " +
                "ON p.user_id = pu.user_id " +

                "INNER JOIN dentists d " +
                "ON a.dentist_id = d.dentist_id " +

                "INNER JOIN dental_services s " +
                "ON a.service_id = s.service_id " +

                "WHERE da.user_id = ? " +

                "AND a.status = 'PENDING' " +

                "ORDER BY " +
                "a.appointment_date ASC, " +
                "a.appointment_time ASC";


        try (
            Connection connection =
                    DBConnection.getInstance().getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    assistantUserId
            );


            try (ResultSet resultSet = statement.executeQuery()) {

                while (resultSet.next()) {

                    Appointment appointment =
                            new Appointment();


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

                    appointment.setPatientId(
                            resultSet.getInt(
                                    "patient_id"
                            )
                    );

                    appointment.setDentistId(
                            resultSet.getInt(
                                    "dentist_id"
                            )
                    );

                    appointment.setServiceId(
                            resultSet.getInt(
                                    "service_id"
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


                    appointment.setServiceName(
                            resultSet.getString(
                                    "service_name"
                            )
                    );


                    appointments.add(
                            appointment
                    );
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }


        return appointments;
    }


    // =========================================================
    // ASSISTANT - CONFIRM APPOINTMENT
    // =========================================================

    public boolean confirmAppointmentByAssistant(
            int assistantUserId,
            int appointmentId) {

        String sql =
                "UPDATE appointments a " +

                "INNER JOIN dentist_assistants da " +
                "ON a.dentist_id = da.dentist_id " +

                "SET " +
                "a.status = 'CONFIRMED', " +
                "a.suggested_date = NULL, " +
                "a.suggested_time = NULL, " +
                "a.assistant_note = NULL " +

                "WHERE a.appointment_id = ? " +
                "AND da.user_id = ? " +
                "AND a.status = 'PENDING'";


        try (
            Connection connection =
                    DBConnection.getInstance().getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    appointmentId
            );

            statement.setInt(
                    2,
                    assistantUserId
            );


            return statement.executeUpdate() > 0;


        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }


    // =========================================================
    // ASSISTANT - CANCEL APPOINTMENT
    // =========================================================

    public boolean cancelAppointmentByAssistant(
            int assistantUserId,
            int appointmentId) {

        String sql =
                "UPDATE appointments a " +

                "INNER JOIN dentist_assistants da " +
                "ON a.dentist_id = da.dentist_id " +

                "SET " +
                "a.status = 'CANCELLED', " +
                "a.suggested_date = NULL, " +
                "a.suggested_time = NULL " +

                "WHERE a.appointment_id = ? " +
                "AND da.user_id = ? " +
                "AND a.status = 'PENDING'";


        try (
            Connection connection =
                    DBConnection.getInstance().getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    appointmentId
            );

            statement.setInt(
                    2,
                    assistantUserId
            );


            return statement.executeUpdate() > 0;


        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }


    // =========================================================
    // CHECK SUGGESTED RESCHEDULE SLOT
    // =========================================================

    public boolean isSuggestedSlotAvailable(
            int assistantUserId,
            int appointmentId,
            Date suggestedDate,
            Time suggestedTime) {

        /*
         * First appointment's dentist check pannuvom.
         * Assistant-ku assign aana dentist dhaana nu
         * verify pannuvom.
         */

        String dentistSql =
                "SELECT a.dentist_id " +

                "FROM appointments a " +

                "INNER JOIN dentist_assistants da " +
                "ON a.dentist_id = da.dentist_id " +

                "WHERE a.appointment_id = ? " +
                "AND da.user_id = ? " +
                "AND a.status = 'PENDING'";


        try (
            Connection connection =
                    DBConnection.getInstance().getConnection();

            PreparedStatement dentistStatement =
                    connection.prepareStatement(dentistSql)
        ) {

            dentistStatement.setInt(
                    1,
                    appointmentId
            );

            dentistStatement.setInt(
                    2,
                    assistantUserId
            );


            try (
                ResultSet dentistResult =
                        dentistStatement.executeQuery()
            ) {

                if (!dentistResult.next()) {

                    return false;
                }


                int dentistId =
                        dentistResult.getInt(
                                "dentist_id"
                        );


                /*
                 * Same dentist-ku requested/suggested slot
                 * already occupied-aa nu check.
                 */

                String slotSql =
                        "SELECT COUNT(*) AS total " +

                        "FROM appointments " +

                        "WHERE dentist_id = ? " +

                        "AND appointment_id <> ? " +

                        "AND (" +

                            "(" +
                                "appointment_date = ? " +
                                "AND appointment_time = ? " +
                                "AND status IN " +
                                "('PENDING','CONFIRMED','RESCHEDULE_REQUESTED')" +
                            ")" +

                            " OR " +

                            "(" +
                                "suggested_date = ? " +
                                "AND suggested_time = ? " +
                                "AND status = 'RESCHEDULE_REQUESTED'" +
                            ")" +

                        ")";


                try (
                    PreparedStatement slotStatement =
                            connection.prepareStatement(slotSql)
                ) {

                    slotStatement.setInt(
                            1,
                            dentistId
                    );

                    slotStatement.setInt(
                            2,
                            appointmentId
                    );

                    slotStatement.setDate(
                            3,
                            suggestedDate
                    );

                    slotStatement.setTime(
                            4,
                            suggestedTime
                    );

                    slotStatement.setDate(
                            5,
                            suggestedDate
                    );

                    slotStatement.setTime(
                            6,
                            suggestedTime
                    );


                    try (
                        ResultSet slotResult =
                                slotStatement.executeQuery()
                    ) {

                        if (slotResult.next()) {

                            return slotResult
                                    .getInt("total") == 0;
                        }
                    }
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }


    // =========================================================
    // ASSISTANT - SEND RESCHEDULE SUGGESTION
    // =========================================================

    public boolean rescheduleAppointmentByAssistant(
            int assistantUserId,
            int appointmentId,
            Date suggestedDate,
            Time suggestedTime,
            String assistantNote) {

        String sql =
                "UPDATE appointments a " +

                "INNER JOIN dentist_assistants da " +
                "ON a.dentist_id = da.dentist_id " +

                "SET " +
                "a.status = 'RESCHEDULE_REQUESTED', " +
                "a.suggested_date = ?, " +
                "a.suggested_time = ?, " +
                "a.assistant_note = ? " +

                "WHERE a.appointment_id = ? " +
                "AND da.user_id = ? " +
                "AND a.status = 'PENDING'";


        try (
            Connection connection =
                    DBConnection.getInstance().getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setDate(
                    1,
                    suggestedDate
            );

            statement.setTime(
                    2,
                    suggestedTime
            );

            statement.setString(
                    3,
                    assistantNote
            );

            statement.setInt(
                    4,
                    appointmentId
            );

            statement.setInt(
                    5,
                    assistantUserId
            );


            return statement.executeUpdate() > 0;


        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }


    // =========================================================
    // GENERATE UNIQUE APPOINTMENT NUMBER
    // =========================================================

    private String generateAppointmentNumber() {

        String randomPart =
                UUID.randomUUID()
                        .toString()
                        .replace("-", "")
                        .substring(0, 8)
                        .toUpperCase();

        return "APT-" + randomPart;
    }
}