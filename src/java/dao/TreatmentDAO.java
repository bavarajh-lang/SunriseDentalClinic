package dao;

import model.Appointment;
import model.TreatmentItem;
import model.TreatmentRecord;
import util.DBConnection;

import java.math.BigDecimal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class TreatmentDAO {

    public Appointment getConfirmedAppointmentForTreatment(
            int assistantUserId,
            int appointmentId) {

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
                "p.patient_no, " +
                "pu.full_name AS patient_name, " +
                "d.full_name AS dentist_name, " +
                "d.specialization AS dentist_specialization, " +
                "s.service_name " +
                "FROM appointments a " +
                "INNER JOIN dentist_assistants da " +
                "ON a.dentist_id = da.dentist_id " +
                "INNER JOIN patients p " +
                "ON a.patient_id = p.patient_id " +
                "INNER JOIN users pu " +
                "ON p.user_id = pu.user_id " +
                "INNER JOIN dentists d " +
                "ON a.dentist_id = d.dentist_id " +
                "INNER JOIN dental_services s " +
                "ON a.service_id = s.service_id " +
                "WHERE a.appointment_id = ? " +
                "AND da.user_id = ? " +
                "AND a.status = 'CONFIRMED'";

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

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (resultSet.next()) {

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

                    return appointment;
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }


    public boolean saveTreatment(
            int assistantUserId,
            TreatmentRecord treatmentRecord,
            List<TreatmentItem> treatmentItems) {

        Connection connection = null;

        try {

            connection =
                    DBConnection.getInstance()
                            .getConnection();

            connection.setAutoCommit(false);

            String verifySql =
                    "SELECT a.appointment_id " +
                    "FROM appointments a " +
                    "INNER JOIN dentist_assistants da " +
                    "ON a.dentist_id = da.dentist_id " +
                    "WHERE a.appointment_id = ? " +
                    "AND da.user_id = ? " +
                    "AND a.status = 'CONFIRMED' " +
                    "FOR UPDATE";

            try (
                PreparedStatement verifyStatement =
                        connection.prepareStatement(
                                verifySql
                        )
            ) {

                verifyStatement.setInt(
                        1,
                        treatmentRecord.getAppointmentId()
                );

                verifyStatement.setInt(
                        2,
                        assistantUserId
                );

                try (
                    ResultSet resultSet =
                            verifyStatement.executeQuery()
                ) {

                    if (!resultSet.next()) {

                        connection.rollback();

                        return false;
                    }
                }
            }

            String checkSql =
                    "SELECT treatment_record_id " +
                    "FROM treatment_records " +
                    "WHERE appointment_id = ?";

            try (
                PreparedStatement checkStatement =
                        connection.prepareStatement(
                                checkSql
                        )
            ) {

                checkStatement.setInt(
                        1,
                        treatmentRecord.getAppointmentId()
                );

                try (
                    ResultSet resultSet =
                            checkStatement.executeQuery()
                ) {

                    if (resultSet.next()) {

                        connection.rollback();

                        return false;
                    }
                }
            }

            String treatmentSql =
                    "INSERT INTO treatment_records " +
                    "(appointment_id, diagnosis, treatment_notes, " +
                    "dentist_notes, completed_at) " +
                    "VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)";

            int treatmentRecordId;

            try (
                PreparedStatement treatmentStatement =
                        connection.prepareStatement(
                                treatmentSql,
                                Statement.RETURN_GENERATED_KEYS
                        )
            ) {

                treatmentStatement.setInt(
                        1,
                        treatmentRecord.getAppointmentId()
                );

                treatmentStatement.setString(
                        2,
                        cleanValue(
                                treatmentRecord.getDiagnosis()
                        )
                );

                treatmentStatement.setString(
                        3,
                        cleanValue(
                                treatmentRecord.getTreatmentNotes()
                        )
                );

                treatmentStatement.setString(
                        4,
                        cleanValue(
                                treatmentRecord.getDentistNotes()
                        )
                );

                int result =
                        treatmentStatement.executeUpdate();

                if (result == 0) {

                    connection.rollback();

                    return false;
                }

                try (
                    ResultSet generatedKeys =
                            treatmentStatement.getGeneratedKeys()
                ) {

                    if (!generatedKeys.next()) {

                        connection.rollback();

                        return false;
                    }

                    treatmentRecordId =
                            generatedKeys.getInt(1);

                    treatmentRecord.setTreatmentRecordId(
                            treatmentRecordId
                    );
                }
            }

            if (treatmentItems == null
                    || treatmentItems.isEmpty()) {

                connection.rollback();

                return false;
            }

            String serviceSql =
                    "SELECT service_name, base_price " +
                    "FROM dental_services " +
                    "WHERE service_id = ? " +
                    "AND status = 'ACTIVE'";

            String itemSql =
                    "INSERT INTO treatment_items " +
                    "(treatment_record_id, service_id, item_name, " +
                    "description, quantity, unit_price, line_total) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";

            try (
                PreparedStatement serviceStatement =
                        connection.prepareStatement(
                                serviceSql
                        );

                PreparedStatement itemStatement =
                        connection.prepareStatement(
                                itemSql
                        )
            ) {

                for (TreatmentItem item : treatmentItems) {

                    if (item == null) {

                        connection.rollback();

                        return false;
                    }

                    if (item.getQuantity() <= 0
                            || item.getQuantity() > 100) {

                        connection.rollback();

                        return false;
                    }

                    String finalItemName;

                    BigDecimal finalUnitPrice;

                    if (item.getServiceId() != null) {

                        serviceStatement.setInt(
                                1,
                                item.getServiceId()
                        );

                        try (
                            ResultSet serviceResult =
                                    serviceStatement.executeQuery()
                        ) {

                            if (!serviceResult.next()) {

                                connection.rollback();

                                return false;
                            }

                            finalItemName =
                                    serviceResult.getString(
                                            "service_name"
                                    );

                            finalUnitPrice =
                                    serviceResult.getBigDecimal(
                                            "base_price"
                                    );
                        }

                    } else {

                        finalItemName =
                                cleanValue(
                                        item.getItemName()
                                );

                        if (finalItemName == null) {

                            connection.rollback();

                            return false;
                        }

                        if (item.getUnitPrice() < 0) {

                            connection.rollback();

                            return false;
                        }

                        finalUnitPrice =
                                BigDecimal.valueOf(
                                        item.getUnitPrice()
                                );
                    }

                    if (finalUnitPrice == null
                            || finalUnitPrice.compareTo(
                                    BigDecimal.ZERO
                            ) < 0) {

                        connection.rollback();

                        return false;
                    }

                    BigDecimal quantity =
                            BigDecimal.valueOf(
                                    item.getQuantity()
                            );

                    BigDecimal lineTotal =
                            finalUnitPrice.multiply(
                                    quantity
                            );

                    itemStatement.setInt(
                            1,
                            treatmentRecordId
                    );

                    if (item.getServiceId() != null) {

                        itemStatement.setInt(
                                2,
                                item.getServiceId()
                        );

                    } else {

                        itemStatement.setNull(
                                2,
                                Types.INTEGER
                        );
                    }

                    itemStatement.setString(
                            3,
                            finalItemName
                    );

                    itemStatement.setString(
                            4,
                            cleanValue(
                                    item.getDescription()
                            )
                    );

                    itemStatement.setInt(
                            5,
                            item.getQuantity()
                    );

                    itemStatement.setBigDecimal(
                            6,
                            finalUnitPrice
                    );

                    itemStatement.setBigDecimal(
                            7,
                            lineTotal
                    );

                    itemStatement.addBatch();

                    item.setTreatmentRecordId(
                            treatmentRecordId
                    );

                    item.setItemName(
                            finalItemName
                    );

                    item.setUnitPrice(
                            finalUnitPrice.doubleValue()
                    );

                    item.setLineTotal(
                            lineTotal.doubleValue()
                    );
                }

                int[] itemResults =
                        itemStatement.executeBatch();

                if (itemResults.length == 0) {

                    connection.rollback();

                    return false;
                }
            }

            String appointmentSql =
                    "UPDATE appointments " +
                    "SET status = 'COMPLETED' " +
                    "WHERE appointment_id = ? " +
                    "AND status = 'CONFIRMED'";

            try (
                PreparedStatement appointmentStatement =
                        connection.prepareStatement(
                                appointmentSql
                        )
            ) {

                appointmentStatement.setInt(
                        1,
                        treatmentRecord.getAppointmentId()
                );

                int result =
                        appointmentStatement.executeUpdate();

                if (result == 0) {

                    connection.rollback();

                    return false;
                }
            }

            connection.commit();

            return true;

        } catch (Exception e) {

            e.printStackTrace();

            if (connection != null) {

                try {

                    connection.rollback();

                } catch (Exception rollbackException) {

                    rollbackException.printStackTrace();
                }
            }

            return false;

        } finally {

            if (connection != null) {

                try {

                    connection.setAutoCommit(true);
                    connection.close();

                } catch (Exception e) {

                    e.printStackTrace();
                }
            }
        }
    }


    public List<TreatmentRecord>
            getTreatmentRecordsByAssistantUserId(
                    int assistantUserId) {

        Map<Integer, TreatmentRecord> treatmentMap =
                new LinkedHashMap<>();

        String treatmentSql =
                "SELECT " +
                "tr.treatment_record_id, " +
                "tr.appointment_id, " +
                "tr.diagnosis, " +
                "tr.treatment_notes, " +
                "tr.dentist_notes, " +
                "tr.completed_at, " +
                "a.appointment_no, " +
                "a.patient_id, " +
                "a.dentist_id, " +
                "a.appointment_date, " +
                "p.patient_no, " +
                "pu.full_name AS patient_name, " +
                "d.full_name AS dentist_name, " +
                "s.service_name AS requested_service_name " +
                "FROM treatment_records tr " +
                "INNER JOIN appointments a " +
                "ON tr.appointment_id = a.appointment_id " +
                "INNER JOIN dentist_assistants da " +
                "ON a.dentist_id = da.dentist_id " +
                "INNER JOIN patients p " +
                "ON a.patient_id = p.patient_id " +
                "INNER JOIN users pu " +
                "ON p.user_id = pu.user_id " +
                "INNER JOIN dentists d " +
                "ON a.dentist_id = d.dentist_id " +
                "INNER JOIN dental_services s " +
                "ON a.service_id = s.service_id " +
                "WHERE da.user_id = ? " +
                "ORDER BY tr.completed_at DESC, " +
                "tr.treatment_record_id DESC";

        String itemSql =
                "SELECT " +
                "ti.treatment_item_id, " +
                "ti.treatment_record_id, " +
                "ti.service_id, " +
                "ti.item_name, " +
                "ti.description, " +
                "ti.quantity, " +
                "ti.unit_price, " +
                "ti.line_total " +
                "FROM treatment_items ti " +
                "INNER JOIN treatment_records tr " +
                "ON ti.treatment_record_id = tr.treatment_record_id " +
                "INNER JOIN appointments a " +
                "ON tr.appointment_id = a.appointment_id " +
                "INNER JOIN dentist_assistants da " +
                "ON a.dentist_id = da.dentist_id " +
                "WHERE da.user_id = ? " +
                "ORDER BY ti.treatment_record_id ASC, " +
                "ti.treatment_item_id ASC";

        try (
            Connection connection =
                    DBConnection.getInstance()
                            .getConnection()
        ) {

            try (
                PreparedStatement treatmentStatement =
                        connection.prepareStatement(
                                treatmentSql
                        )
            ) {

                treatmentStatement.setInt(
                        1,
                        assistantUserId
                );

                try (
                    ResultSet resultSet =
                            treatmentStatement.executeQuery()
                ) {

                    while (resultSet.next()) {

                        TreatmentRecord record =
                                new TreatmentRecord();

                        record.setTreatmentRecordId(
                                resultSet.getInt(
                                        "treatment_record_id"
                                )
                        );

                        record.setAppointmentId(
                                resultSet.getInt(
                                        "appointment_id"
                                )
                        );

                        record.setDiagnosis(
                                resultSet.getString(
                                        "diagnosis"
                                )
                        );

                        record.setTreatmentNotes(
                                resultSet.getString(
                                        "treatment_notes"
                                )
                        );

                        record.setDentistNotes(
                                resultSet.getString(
                                        "dentist_notes"
                                )
                        );

                        record.setCompletedAt(
                                resultSet.getTimestamp(
                                        "completed_at"
                                )
                        );

                        record.setAppointmentNo(
                                resultSet.getString(
                                        "appointment_no"
                                )
                        );

                        record.setPatientId(
                                resultSet.getInt(
                                        "patient_id"
                                )
                        );

                        record.setPatientNo(
                                resultSet.getString(
                                        "patient_no"
                                )
                        );

                        record.setPatientName(
                                resultSet.getString(
                                        "patient_name"
                                )
                        );

                        record.setDentistId(
                                resultSet.getInt(
                                        "dentist_id"
                                )
                        );

                        record.setDentistName(
                                resultSet.getString(
                                        "dentist_name"
                                )
                        );

                        record.setRequestedServiceName(
                                resultSet.getString(
                                        "requested_service_name"
                                )
                        );

                        record.setAppointmentDate(
                                resultSet.getDate(
                                        "appointment_date"
                                )
                        );

                        treatmentMap.put(
                                record.getTreatmentRecordId(),
                                record
                        );
                    }
                }
            }

            if (!treatmentMap.isEmpty()) {

                try (
                    PreparedStatement itemStatement =
                            connection.prepareStatement(
                                    itemSql
                            )
                ) {

                    itemStatement.setInt(
                            1,
                            assistantUserId
                    );

                    try (
                        ResultSet resultSet =
                                itemStatement.executeQuery()
                    ) {

                        while (resultSet.next()) {

                            int treatmentRecordId =
                                    resultSet.getInt(
                                            "treatment_record_id"
                                    );

                            TreatmentRecord record =
                                    treatmentMap.get(
                                            treatmentRecordId
                                    );

                            if (record == null) {
                                continue;
                            }

                            TreatmentItem item =
                                    new TreatmentItem();

                            item.setTreatmentItemId(
                                    resultSet.getInt(
                                            "treatment_item_id"
                                    )
                            );

                            item.setTreatmentRecordId(
                                    treatmentRecordId
                            );

                            int serviceId =
                                    resultSet.getInt(
                                            "service_id"
                                    );

                            if (resultSet.wasNull()) {

                                item.setServiceId(
                                        null
                                );

                            } else {

                                item.setServiceId(
                                        serviceId
                                );
                            }

                            item.setItemName(
                                    resultSet.getString(
                                            "item_name"
                                    )
                            );

                            item.setDescription(
                                    resultSet.getString(
                                            "description"
                                    )
                            );

                            item.setQuantity(
                                    resultSet.getInt(
                                            "quantity"
                                    )
                            );

                            item.setUnitPrice(
                                    resultSet.getDouble(
                                            "unit_price"
                                    )
                            );

                            item.setLineTotal(
                                    resultSet.getDouble(
                                            "line_total"
                                    )
                            );

                            record.addTreatmentItem(
                                    item
                            );
                        }
                    }
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return new ArrayList<>(
                treatmentMap.values()
        );
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