package dao;

import model.TreatmentItem;
import model.TreatmentRecord;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class PatientTreatmentDAO {

    public List<TreatmentRecord> getTreatmentHistoryByPatientUserId(
            int patientUserId) {

        List<TreatmentRecord> treatments =
                new ArrayList<>();

        if (patientUserId <= 0) {
            return treatments;
        }

        String sql =
                "SELECT " +
                "tr.treatment_record_id, " +
                "tr.appointment_id, " +
                "tr.diagnosis, " +
                "tr.treatment_notes, " +
                "tr.dentist_notes, " +
                "tr.completed_at, " +

                "a.appointment_no, " +
                "a.appointment_date, " +

                "p.patient_id, " +
                "p.patient_no, " +

                "u.full_name AS patient_name, " +

                "d.dentist_id, " +
                "d.full_name AS dentist_name, " +

                "ds.service_name AS requested_service_name, " +

                "ti.treatment_item_id, " +
                "ti.treatment_record_id AS item_treatment_record_id, " +
                "ti.service_id AS item_service_id, " +
                "ti.item_name, " +
                "ti.description AS item_description, " +
                "ti.quantity, " +
                "ti.unit_price, " +
                "ti.line_total " +

                "FROM treatment_records tr " +

                "INNER JOIN appointments a " +
                "ON tr.appointment_id = a.appointment_id " +

                "INNER JOIN patients p " +
                "ON a.patient_id = p.patient_id " +

                "INNER JOIN users u " +
                "ON p.user_id = u.user_id " +

                "INNER JOIN dentists d " +
                "ON a.dentist_id = d.dentist_id " +

                "LEFT JOIN dental_services ds " +
                "ON a.service_id = ds.service_id " +

                "LEFT JOIN treatment_items ti " +
                "ON tr.treatment_record_id = ti.treatment_record_id " +

                "WHERE p.user_id = ? " +
                "AND a.status = 'COMPLETED' " +

                "ORDER BY " +
                "tr.completed_at DESC, " +
                "tr.treatment_record_id DESC, " +
                "ti.treatment_item_id ASC";

        Map<Integer, TreatmentRecord> treatmentMap =
                new LinkedHashMap<>();

        try (
            Connection connection =
                    DBConnection.getInstance()
                            .getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    patientUserId
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                while (resultSet.next()) {

                    int treatmentRecordId =
                            resultSet.getInt(
                                    "treatment_record_id"
                            );

                    TreatmentRecord treatmentRecord =
                            treatmentMap.get(
                                    treatmentRecordId
                            );

                    if (treatmentRecord == null) {

                        treatmentRecord =
                                mapTreatmentRecord(
                                        resultSet
                                );

                        treatmentMap.put(
                                treatmentRecordId,
                                treatmentRecord
                        );
                    }

                    int treatmentItemId =
                            resultSet.getInt(
                                    "treatment_item_id"
                            );

                    if (!resultSet.wasNull()) {

                        TreatmentItem treatmentItem =
                                mapTreatmentItem(
                                        resultSet
                                );

                        treatmentRecord.addTreatmentItem(
                                treatmentItem
                        );
                    }
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        treatments.addAll(
                treatmentMap.values()
        );

        return treatments;
    }


    public int getCompletedTreatmentCount(
            int patientUserId) {

        if (patientUserId <= 0) {
            return 0;
        }

        String sql =
                "SELECT COUNT(*) AS total " +

                "FROM treatment_records tr " +

                "INNER JOIN appointments a " +
                "ON tr.appointment_id = a.appointment_id " +

                "INNER JOIN patients p " +
                "ON a.patient_id = p.patient_id " +

                "WHERE p.user_id = ? " +
                "AND a.status = 'COMPLETED'";

        try (
            Connection connection =
                    DBConnection.getInstance()
                            .getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    patientUserId
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

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return 0;
    }


    private TreatmentRecord mapTreatmentRecord(
            ResultSet resultSet)
            throws SQLException {

        TreatmentRecord treatmentRecord =
                new TreatmentRecord();

        treatmentRecord.setTreatmentRecordId(
                resultSet.getInt(
                        "treatment_record_id"
                )
        );

        treatmentRecord.setAppointmentId(
                resultSet.getInt(
                        "appointment_id"
                )
        );

        treatmentRecord.setAppointmentNo(
                resultSet.getString(
                        "appointment_no"
                )
        );

        treatmentRecord.setPatientId(
                resultSet.getInt(
                        "patient_id"
                )
        );

        treatmentRecord.setPatientNo(
                resultSet.getString(
                        "patient_no"
                )
        );

        treatmentRecord.setPatientName(
                resultSet.getString(
                        "patient_name"
                )
        );

        treatmentRecord.setDentistId(
                resultSet.getInt(
                        "dentist_id"
                )
        );

        treatmentRecord.setDentistName(
                resultSet.getString(
                        "dentist_name"
                )
        );

        treatmentRecord.setRequestedServiceName(
                resultSet.getString(
                        "requested_service_name"
                )
        );

        treatmentRecord.setAppointmentDate(
                resultSet.getDate(
                        "appointment_date"
                )
        );

        treatmentRecord.setDiagnosis(
                resultSet.getString(
                        "diagnosis"
                )
        );

        treatmentRecord.setTreatmentNotes(
                resultSet.getString(
                        "treatment_notes"
                )
        );

        treatmentRecord.setDentistNotes(
                resultSet.getString(
                        "dentist_notes"
                )
        );

        treatmentRecord.setCompletedAt(
                resultSet.getTimestamp(
                        "completed_at"
                )
        );

        return treatmentRecord;
    }


    private TreatmentItem mapTreatmentItem(
            ResultSet resultSet)
            throws SQLException {

        TreatmentItem treatmentItem =
                new TreatmentItem();

        treatmentItem.setTreatmentItemId(
                resultSet.getInt(
                        "treatment_item_id"
                )
        );

        treatmentItem.setTreatmentRecordId(
                resultSet.getInt(
                        "item_treatment_record_id"
                )
        );

        Object serviceId =
                resultSet.getObject(
                        "item_service_id"
                );

        if (serviceId != null) {

            treatmentItem.setServiceId(
                    ((Number) serviceId).intValue()
            );

        } else {

            treatmentItem.setServiceId(
                    null
            );
        }

        treatmentItem.setItemName(
                resultSet.getString(
                        "item_name"
                )
        );

        treatmentItem.setDescription(
                resultSet.getString(
                        "item_description"
                )
        );

        treatmentItem.setQuantity(
                resultSet.getInt(
                        "quantity"
                )
        );

        treatmentItem.setUnitPrice(
                resultSet.getDouble(
                        "unit_price"
                )
        );

        treatmentItem.setLineTotal(
                resultSet.getDouble(
                        "line_total"
                )
        );

        return treatmentItem;
    }
}