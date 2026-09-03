package dao;

import model.PatientBill;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import java.util.ArrayList;
import java.util.List;

public class PatientBillDAO {

    public List<PatientBill> getBillsByPatientUserId(
            int patientUserId) {

        List<PatientBill> bills =
                new ArrayList<>();

        if (patientUserId <= 0) {
            return bills;
        }

        String sql =
                "SELECT " +
                "b.bill_id, " +
                "b.bill_no, " +
                "b.appointment_id, " +
                "b.patient_id, " +
                "b.subtotal, " +
                "b.discount, " +
                "b.total_amount, " +
                "b.payment_status, " +
                "b.qr_token, " +
                "a.appointment_no, " +
                "p.patient_no, " +
                "u.full_name AS patient_name " +

                "FROM bills b " +

                "INNER JOIN appointments a " +
                "ON b.appointment_id = a.appointment_id " +

                "INNER JOIN patients p " +
                "ON b.patient_id = p.patient_id " +

                "INNER JOIN users u " +
                "ON p.user_id = u.user_id " +

                "WHERE p.user_id = ? " +

                "ORDER BY " +
                "b.created_at DESC, " +
                "b.bill_id DESC";

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

                    bills.add(
                            mapBill(resultSet)
                    );
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return bills;
    }


    public PatientBill getBillByIdForPatient(
            int billId,
            int patientUserId) {

        if (billId <= 0
                || patientUserId <= 0) {

            return null;
        }

        String sql =
                "SELECT " +
                "b.bill_id, " +
                "b.bill_no, " +
                "b.appointment_id, " +
                "b.patient_id, " +
                "b.subtotal, " +
                "b.discount, " +
                "b.total_amount, " +
                "b.payment_status, " +
                "b.qr_token, " +
                "a.appointment_no, " +
                "p.patient_no, " +
                "u.full_name AS patient_name " +

                "FROM bills b " +

                "INNER JOIN appointments a " +
                "ON b.appointment_id = a.appointment_id " +

                "INNER JOIN patients p " +
                "ON b.patient_id = p.patient_id " +

                "INNER JOIN users u " +
                "ON p.user_id = u.user_id " +

                "WHERE b.bill_id = ? " +
                "AND p.user_id = ? " +

                "LIMIT 1";

        try (
            Connection connection =
                    DBConnection.getInstance()
                            .getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    billId
            );

            statement.setInt(
                    2,
                    patientUserId
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (resultSet.next()) {

                    return mapBill(
                            resultSet
                    );
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }


    public int getTotalBillsCount(
            int patientUserId) {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM bills b " +
                "INNER JOIN patients p " +
                "ON b.patient_id = p.patient_id " +
                "WHERE p.user_id = ?";

        return getCount(
                sql,
                patientUserId
        );
    }


    public int getUnpaidBillsCount(
            int patientUserId) {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM bills b " +
                "INNER JOIN patients p " +
                "ON b.patient_id = p.patient_id " +
                "WHERE p.user_id = ? " +
                "AND b.payment_status = 'UNPAID'";

        return getCount(
                sql,
                patientUserId
        );
    }


    public int getPaidBillsCount(
            int patientUserId) {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM bills b " +
                "INNER JOIN patients p " +
                "ON b.patient_id = p.patient_id " +
                "WHERE p.user_id = ? " +
                "AND b.payment_status = 'PAID'";

        return getCount(
                sql,
                patientUserId
        );
    }


    private int getCount(
            String sql,
            int patientUserId) {

        if (patientUserId <= 0) {
            return 0;
        }

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

        } catch (Exception e) {

            e.printStackTrace();
        }

        return 0;
    }


    private PatientBill mapBill(
            ResultSet resultSet)
            throws Exception {

        PatientBill bill =
                new PatientBill();

        bill.setBillId(
                resultSet.getInt(
                        "bill_id"
                )
        );

        bill.setBillNo(
                resultSet.getString(
                        "bill_no"
                )
        );

        bill.setAppointmentId(
                resultSet.getInt(
                        "appointment_id"
                )
        );

        bill.setAppointmentNo(
                resultSet.getString(
                        "appointment_no"
                )
        );

        bill.setPatientId(
                resultSet.getInt(
                        "patient_id"
                )
        );

        bill.setPatientNo(
                resultSet.getString(
                        "patient_no"
                )
        );

        bill.setPatientName(
                resultSet.getString(
                        "patient_name"
                )
        );

        bill.setSubtotal(
                resultSet.getBigDecimal(
                        "subtotal"
                )
        );

        bill.setDiscount(
                resultSet.getBigDecimal(
                        "discount"
                )
        );

        bill.setTotalAmount(
                resultSet.getBigDecimal(
                        "total_amount"
                )
        );

        bill.setPaymentStatus(
                resultSet.getString(
                        "payment_status"
                )
        );

        bill.setQrToken(
                resultSet.getString(
                        "qr_token"
                )
        );

        return bill;
    }
}