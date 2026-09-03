package dao;

import model.Bill;
import model.BillItem;
import util.DBConnection;

import java.math.BigDecimal;
import java.security.SecureRandom;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Time;

import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.UUID;

public class BillDAO {

    public Bill generateBillForAppointment(
            int appointmentId) {

        Connection connection = null;

        try {

            connection =
                    DBConnection.getInstance()
                            .getConnection();

            connection.setAutoCommit(false);

            String appointmentSql =
                    "SELECT " +
                    "a.appointment_id, " +
                    "a.appointment_no, " +
                    "a.patient_id, " +
                    "a.appointment_date, " +
                    "a.appointment_time, " +
                    "p.patient_no, " +
                    "pu.full_name AS patient_name, " +
                    "d.full_name AS dentist_name, " +
                    "d.specialization AS dentist_specialization, " +
                    "d.consultation_fee, " +
                    "ds.service_name AS requested_service_name, " +
                    "tr.treatment_record_id " +
                    "FROM appointments a " +
                    "INNER JOIN patients p " +
                    "ON a.patient_id = p.patient_id " +
                    "INNER JOIN users pu " +
                    "ON p.user_id = pu.user_id " +
                    "INNER JOIN dentists d " +
                    "ON a.dentist_id = d.dentist_id " +
                    "INNER JOIN dental_services ds " +
                    "ON a.service_id = ds.service_id " +
                    "INNER JOIN treatment_records tr " +
                    "ON a.appointment_id = tr.appointment_id " +
                    "WHERE a.appointment_id = ? " +
                    "AND a.status = 'COMPLETED' " +
                    "FOR UPDATE";

            int patientId;
            int treatmentRecordId;

            String appointmentNo;
            String patientNo;
            String patientName;
            String dentistName;
            String dentistSpecialization;
            String requestedServiceName;

            Date appointmentDate;
            Time appointmentTime;

            BigDecimal consultationFee;

            try (
                PreparedStatement appointmentStatement =
                        connection.prepareStatement(
                                appointmentSql
                        )
            ) {

                appointmentStatement.setInt(
                        1,
                        appointmentId
                );

                try (
                    ResultSet resultSet =
                            appointmentStatement.executeQuery()
                ) {

                    if (!resultSet.next()) {

                        connection.rollback();

                        return null;
                    }

                    appointmentNo =
                            resultSet.getString(
                                    "appointment_no"
                            );

                    patientId =
                            resultSet.getInt(
                                    "patient_id"
                            );

                    patientNo =
                            resultSet.getString(
                                    "patient_no"
                            );

                    patientName =
                            resultSet.getString(
                                    "patient_name"
                            );

                    dentistName =
                            resultSet.getString(
                                    "dentist_name"
                            );

                    dentistSpecialization =
                            resultSet.getString(
                                    "dentist_specialization"
                            );

                    requestedServiceName =
                            resultSet.getString(
                                    "requested_service_name"
                            );

                    appointmentDate =
                            resultSet.getDate(
                                    "appointment_date"
                            );

                    appointmentTime =
                            resultSet.getTime(
                                    "appointment_time"
                            );

                    consultationFee =
                            resultSet.getBigDecimal(
                                    "consultation_fee"
                            );

                    if (consultationFee == null) {

                        consultationFee =
                                BigDecimal.ZERO;
                    }

                    treatmentRecordId =
                            resultSet.getInt(
                                    "treatment_record_id"
                            );
                }
            }

            Bill existingBill =
                    getBillByAppointmentId(
                            connection,
                            appointmentId
                    );

            if (existingBill != null) {

                connection.rollback();

                return existingBill;
            }

            List<BillItem> billItems =
                    new ArrayList<>();

            if (consultationFee
                    .compareTo(BigDecimal.ZERO) > 0) {

                BillItem consultationItem =
                        new BillItem(
                                "Dentist Consultation Fee",
                                "Consultation fee for Dr. "
                                + dentistName,
                                1,
                                consultationFee
                        );

                billItems.add(
                        consultationItem
                );
            }

            String treatmentItemsSql =
                    "SELECT " +
                    "item_name, " +
                    "description, " +
                    "quantity, " +
                    "unit_price, " +
                    "line_total " +
                    "FROM treatment_items " +
                    "WHERE treatment_record_id = ? " +
                    "ORDER BY treatment_item_id ASC";

            try (
                PreparedStatement itemStatement =
                        connection.prepareStatement(
                                treatmentItemsSql
                        )
            ) {

                itemStatement.setInt(
                        1,
                        treatmentRecordId
                );

                try (
                    ResultSet resultSet =
                            itemStatement.executeQuery()
                ) {

                    while (resultSet.next()) {

                        BillItem billItem =
                                new BillItem();

                        billItem.setItemName(
                                resultSet.getString(
                                        "item_name"
                                )
                        );

                        billItem.setDescription(
                                resultSet.getString(
                                        "description"
                                )
                        );

                        billItem.setQuantity(
                                resultSet.getInt(
                                        "quantity"
                                )
                        );

                        billItem.setUnitPrice(
                                resultSet.getBigDecimal(
                                        "unit_price"
                                )
                        );

                        billItem.setLineTotal(
                                resultSet.getBigDecimal(
                                        "line_total"
                                )
                        );

                        billItems.add(
                                billItem
                        );
                    }
                }
            }

            if (billItems.isEmpty()) {

                connection.rollback();

                return null;
            }

            BigDecimal subtotal =
                    BigDecimal.ZERO;

            for (BillItem item : billItems) {

                if (item.getLineTotal() != null) {

                    subtotal =
                            subtotal.add(
                                    item.getLineTotal()
                            );
                }
            }

            Bill bill =
                    Bill.builder()
                            .appointmentId(
                                    appointmentId
                            )
                            .appointmentNo(
                                    appointmentNo
                            )
                            .patientId(
                                    patientId
                            )
                            .patientNo(
                                    patientNo
                            )
                            .patientName(
                                    patientName
                            )
                            .dentistName(
                                    dentistName
                            )
                            .dentistSpecialization(
                                    dentistSpecialization
                            )
                            .requestedServiceName(
                                    requestedServiceName
                            )
                            .appointmentDate(
                                    appointmentDate
                            )
                            .appointmentTime(
                                    appointmentTime
                            )
                            .consultationFee(
                                    consultationFee
                            )
                            .billItems(
                                    billItems
                            )
                            .subtotal(
                                    subtotal
                            )
                            .discount(
                                    BigDecimal.ZERO
                            )
                            .totalAmount(
                                    subtotal
                            )
                            .paymentStatus(
                                    "UNPAID"
                            )
                            .billNo(
                                    generateBillNumber()
                            )
                            .qrToken(
                                    generateSecureQrToken()
                            )
                            .build();

            String billSql =
                    "INSERT INTO bills " +
                    "(bill_no, appointment_id, patient_id, " +
                    "subtotal, discount, total_amount, " +
                    "payment_status, qr_token) " +
                    "VALUES (?, ?, ?, ?, ?, ?, 'UNPAID', ?)";

            int billId;

            try (
                PreparedStatement billStatement =
                        connection.prepareStatement(
                                billSql,
                                Statement.RETURN_GENERATED_KEYS
                        )
            ) {

                billStatement.setString(
                        1,
                        bill.getBillNo()
                );

                billStatement.setInt(
                        2,
                        bill.getAppointmentId()
                );

                billStatement.setInt(
                        3,
                        bill.getPatientId()
                );

                billStatement.setBigDecimal(
                        4,
                        bill.getSubtotal()
                );

                billStatement.setBigDecimal(
                        5,
                        bill.getDiscount()
                );

                billStatement.setBigDecimal(
                        6,
                        bill.getTotalAmount()
                );

                billStatement.setString(
                        7,
                        bill.getQrToken()
                );

                int result =
                        billStatement.executeUpdate();

                if (result == 0) {

                    connection.rollback();

                    return null;
                }

                try (
                    ResultSet generatedKeys =
                            billStatement.getGeneratedKeys()
                ) {

                    if (!generatedKeys.next()) {

                        connection.rollback();

                        return null;
                    }

                    billId =
                            generatedKeys.getInt(1);

                    bill.setBillId(
                            billId
                    );
                }
            }

            String billItemSql =
                    "INSERT INTO bill_items " +
                    "(bill_id, item_name, description, " +
                    "quantity, unit_price, line_total) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";

            try (
                PreparedStatement statement =
                        connection.prepareStatement(
                                billItemSql,
                                Statement.RETURN_GENERATED_KEYS
                        )
            ) {

                for (BillItem item : billItems) {

                    statement.setInt(
                            1,
                            billId
                    );

                    statement.setString(
                            2,
                            item.getItemName()
                    );

                    statement.setString(
                            3,
                            cleanValue(
                                    item.getDescription()
                            )
                    );

                    statement.setInt(
                            4,
                            item.getQuantity()
                    );

                    statement.setBigDecimal(
                            5,
                            item.getUnitPrice()
                    );

                    statement.setBigDecimal(
                            6,
                            item.getLineTotal()
                    );

                    int result =
                            statement.executeUpdate();

                    if (result == 0) {

                        connection.rollback();

                        return null;
                    }

                    try (
                        ResultSet generatedKeys =
                                statement.getGeneratedKeys()
                    ) {

                        if (generatedKeys.next()) {

                            item.setBillItemId(
                                    generatedKeys.getInt(1)
                            );
                        }
                    }

                    item.setBillId(
                            billId
                    );
                }
            }

            connection.commit();

            return bill;

        } catch (Exception e) {

            e.printStackTrace();

            if (connection != null) {

                try {

                    connection.rollback();

                } catch (Exception rollbackException) {

                    rollbackException.printStackTrace();
                }
            }

            return null;

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


    public List<Bill> getUnpaidBills() {

        List<Bill> bills =
                new ArrayList<>();

        String sql =
                getBillSelectSql()
                + "WHERE b.payment_status = 'UNPAID' "
                + "ORDER BY b.created_at ASC, b.bill_id ASC";

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

            while (resultSet.next()) {

                Bill bill =
                        mapBill(
                                resultSet
                        );

                bill.setBillItems(
                        getBillItems(
                                connection,
                                bill.getBillId()
                        )
                );

                bills.add(
                        bill
                );
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return bills;
    }


    public Bill getBillById(
            int billId) {

        if (billId <= 0) {

            return null;
        }

        String sql =
                getBillSelectSql()
                + "WHERE b.bill_id = ?";

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
                    billId
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (!resultSet.next()) {

                    return null;
                }

                Bill bill =
                        mapBill(
                                resultSet
                        );

                bill.setBillItems(
                        getBillItems(
                                connection,
                                bill.getBillId()
                        )
                );

                return bill;
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }


    public Bill getBillByAppointmentId(
            int appointmentId) {

        if (appointmentId <= 0) {

            return null;
        }

        try (
            Connection connection =
                    DBConnection.getInstance()
                            .getConnection()
        ) {

            return getBillByAppointmentId(
                    connection,
                    appointmentId
            );

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }


    public Bill getPaidBillByQrToken(
            String qrToken) {

        String cleanToken =
                cleanValue(
                        qrToken
                );

        if (cleanToken == null
                || cleanToken.length() > 100) {

            return null;
        }

        String sql =
                getBillSelectSql()
                + "WHERE b.qr_token = ? "
                + "AND b.payment_status = 'PAID' "
                + "LIMIT 1";

        try (
            Connection connection =
                    DBConnection.getInstance()
                            .getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            sql
                    )
        ) {

            statement.setString(
                    1,
                    cleanToken
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (!resultSet.next()) {

                    return null;
                }

                Bill bill =
                        mapBill(
                                resultSet
                        );

                bill.setBillItems(
                        getBillItems(
                                connection,
                                bill.getBillId()
                        )
                );

                return bill;
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }


    private Bill getBillByAppointmentId(
            Connection connection,
            int appointmentId) {

        String sql =
                getBillSelectSql()
                + "WHERE b.appointment_id = ?";

        try (
            PreparedStatement statement =
                    connection.prepareStatement(
                            sql
                    )
        ) {

            statement.setInt(
                    1,
                    appointmentId
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (!resultSet.next()) {

                    return null;
                }

                Bill bill =
                        mapBill(
                                resultSet
                        );

                bill.setBillItems(
                        getBillItems(
                                connection,
                                bill.getBillId()
                        )
                );

                return bill;
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }


    private String getBillSelectSql() {

        return "SELECT " +
                "b.bill_id, " +
                "b.bill_no, " +
                "b.appointment_id, " +
                "b.patient_id, " +
                "b.subtotal, " +
                "b.discount, " +
                "b.total_amount, " +
                "b.payment_status, " +
                "b.qr_token, " +
                "b.created_at, " +
                "b.updated_at, " +
                "a.appointment_no, " +
                "a.appointment_date, " +
                "a.appointment_time, " +
                "p.patient_no, " +
                "pu.full_name AS patient_name, " +
                "d.full_name AS dentist_name, " +
                "d.specialization AS dentist_specialization, " +
                "d.consultation_fee, " +
                "ds.service_name AS requested_service_name " +
                "FROM bills b " +
                "INNER JOIN appointments a " +
                "ON b.appointment_id = a.appointment_id " +
                "INNER JOIN patients p " +
                "ON b.patient_id = p.patient_id " +
                "INNER JOIN users pu " +
                "ON p.user_id = pu.user_id " +
                "INNER JOIN dentists d " +
                "ON a.dentist_id = d.dentist_id " +
                "INNER JOIN dental_services ds " +
                "ON a.service_id = ds.service_id ";
    }


    private Bill mapBill(
            ResultSet resultSet)
            throws Exception {

        return Bill.builder()
                .billId(
                        resultSet.getInt(
                                "bill_id"
                        )
                )
                .billNo(
                        resultSet.getString(
                                "bill_no"
                        )
                )
                .appointmentId(
                        resultSet.getInt(
                                "appointment_id"
                        )
                )
                .patientId(
                        resultSet.getInt(
                                "patient_id"
                        )
                )
                .subtotal(
                        resultSet.getBigDecimal(
                                "subtotal"
                        )
                )
                .discount(
                        resultSet.getBigDecimal(
                                "discount"
                        )
                )
                .totalAmount(
                        resultSet.getBigDecimal(
                                "total_amount"
                        )
                )
                .paymentStatus(
                        resultSet.getString(
                                "payment_status"
                        )
                )
                .qrToken(
                        resultSet.getString(
                                "qr_token"
                        )
                )
                .createdAt(
                        resultSet.getTimestamp(
                                "created_at"
                        )
                )
                .updatedAt(
                        resultSet.getTimestamp(
                                "updated_at"
                        )
                )
                .appointmentNo(
                        resultSet.getString(
                                "appointment_no"
                        )
                )
                .appointmentDate(
                        resultSet.getDate(
                                "appointment_date"
                        )
                )
                .appointmentTime(
                        resultSet.getTime(
                                "appointment_time"
                        )
                )
                .patientNo(
                        resultSet.getString(
                                "patient_no"
                        )
                )
                .patientName(
                        resultSet.getString(
                                "patient_name"
                        )
                )
                .dentistName(
                        resultSet.getString(
                                "dentist_name"
                        )
                )
                .dentistSpecialization(
                        resultSet.getString(
                                "dentist_specialization"
                        )
                )
                .consultationFee(
                        resultSet.getBigDecimal(
                                "consultation_fee"
                        )
                )
                .requestedServiceName(
                        resultSet.getString(
                                "requested_service_name"
                        )
                )
                .build();
    }


    private List<BillItem> getBillItems(
            Connection connection,
            int billId) {

        List<BillItem> items =
                new ArrayList<>();

        String sql =
                "SELECT " +
                "bill_item_id, " +
                "bill_id, " +
                "item_name, " +
                "description, " +
                "quantity, " +
                "unit_price, " +
                "line_total " +
                "FROM bill_items " +
                "WHERE bill_id = ? " +
                "ORDER BY bill_item_id ASC";

        try (
            PreparedStatement statement =
                    connection.prepareStatement(
                            sql
                    )
        ) {

            statement.setInt(
                    1,
                    billId
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                while (resultSet.next()) {

                    BillItem item =
                            new BillItem();

                    item.setBillItemId(
                            resultSet.getInt(
                                    "bill_item_id"
                            )
                    );

                    item.setBillId(
                            resultSet.getInt(
                                    "bill_id"
                            )
                    );

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
                            resultSet.getBigDecimal(
                                    "unit_price"
                            )
                    );

                    item.setLineTotal(
                            resultSet.getBigDecimal(
                                    "line_total"
                            )
                    );

                    items.add(
                            item
                    );
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return items;
    }


    private String generateBillNumber() {

        return "BILL-"
                + UUID.randomUUID()
                        .toString()
                        .replace("-", "")
                        .substring(0, 8)
                        .toUpperCase();
    }


    private String generateSecureQrToken() {

        byte[] randomBytes =
                new byte[32];

        SecureRandom secureRandom =
                new SecureRandom();

        secureRandom.nextBytes(
                randomBytes
        );

        return Base64.getUrlEncoder()
                .withoutPadding()
                .encodeToString(
                        randomBytes
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