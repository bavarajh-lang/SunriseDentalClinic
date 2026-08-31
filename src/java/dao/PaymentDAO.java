package dao;

import model.Payment;
import util.DBConnection;

import java.math.BigDecimal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;

public class PaymentDAO {

    public Payment processPayment(
            int billId,
            int cashierUserId,
            String method,
            String reference) {

        if (billId <= 0
                || cashierUserId <= 0) {

            return null;
        }

        String cleanMethod =
                cleanValue(method);

        if (!isValidPaymentMethod(
                cleanMethod)) {

            return null;
        }

        String cleanReference =
                cleanValue(reference);

        if (!"CASH".equals(cleanMethod)
                && cleanReference == null) {

            return null;
        }

        if ("CASH".equals(cleanMethod)) {

            cleanReference = null;
        }

        Connection connection = null;

        try {

            connection =
                    DBConnection.getInstance()
                            .getConnection();

            connection.setAutoCommit(false);

            String cashierSql =
                    "SELECT user_id " +
                    "FROM users " +
                    "WHERE user_id = ? " +
                    "AND role = 'CASHIER' " +
                    "AND status = 'ACTIVE' " +
                    "FOR UPDATE";

            try (
                PreparedStatement cashierStatement =
                        connection.prepareStatement(
                                cashierSql
                        )
            ) {

                cashierStatement.setInt(
                        1,
                        cashierUserId
                );

                try (
                    ResultSet resultSet =
                            cashierStatement.executeQuery()
                ) {

                    if (!resultSet.next()) {

                        connection.rollback();

                        return null;
                    }
                }
            }

            String billSql =
                    "SELECT " +
                    "bill_id, " +
                    "total_amount, " +
                    "payment_status " +
                    "FROM bills " +
                    "WHERE bill_id = ? " +
                    "FOR UPDATE";

            BigDecimal officialAmount;

            try (
                PreparedStatement billStatement =
                        connection.prepareStatement(
                                billSql
                        )
            ) {

                billStatement.setInt(
                        1,
                        billId
                );

                try (
                    ResultSet resultSet =
                            billStatement.executeQuery()
                ) {

                    if (!resultSet.next()) {

                        connection.rollback();

                        return null;
                    }

                    String paymentStatus =
                            resultSet.getString(
                                    "payment_status"
                            );

                    if (!"UNPAID".equals(
                            paymentStatus)) {

                        connection.rollback();

                        return null;
                    }

                    officialAmount =
                            resultSet.getBigDecimal(
                                    "total_amount"
                            );

                    if (officialAmount == null
                            || officialAmount.compareTo(
                                    BigDecimal.ZERO) <= 0) {

                        connection.rollback();

                        return null;
                    }
                }
            }

            String existingPaymentSql =
                    "SELECT payment_id " +
                    "FROM payments " +
                    "WHERE bill_id = ? " +
                    "AND status = 'SUCCESS' " +
                    "LIMIT 1";

            try (
                PreparedStatement existingStatement =
                        connection.prepareStatement(
                                existingPaymentSql
                        )
            ) {

                existingStatement.setInt(
                        1,
                        billId
                );

                try (
                    ResultSet resultSet =
                            existingStatement.executeQuery()
                ) {

                    if (resultSet.next()) {

                        connection.rollback();

                        return null;
                    }
                }
            }

            String paymentSql =
                    "INSERT INTO payments " +
                    "(bill_id, cashier_user_id, amount, " +
                    "method, reference, status, paid_at) " +
                    "VALUES (?, ?, ?, ?, ?, 'SUCCESS', CURRENT_TIMESTAMP)";

            int paymentId;

            try (
                PreparedStatement paymentStatement =
                        connection.prepareStatement(
                                paymentSql,
                                Statement.RETURN_GENERATED_KEYS
                        )
            ) {

                paymentStatement.setInt(
                        1,
                        billId
                );

                paymentStatement.setInt(
                        2,
                        cashierUserId
                );

                paymentStatement.setBigDecimal(
                        3,
                        officialAmount
                );

                paymentStatement.setString(
                        4,
                        cleanMethod
                );

                paymentStatement.setString(
                        5,
                        cleanReference
                );

                int result =
                        paymentStatement.executeUpdate();

                if (result == 0) {

                    connection.rollback();

                    return null;
                }

                try (
                    ResultSet generatedKeys =
                            paymentStatement.getGeneratedKeys()
                ) {

                    if (!generatedKeys.next()) {

                        connection.rollback();

                        return null;
                    }

                    paymentId =
                            generatedKeys.getInt(1);
                }
            }

            String updateBillSql =
                    "UPDATE bills " +
                    "SET payment_status = 'PAID' " +
                    "WHERE bill_id = ? " +
                    "AND payment_status = 'UNPAID'";

            try (
                PreparedStatement updateStatement =
                        connection.prepareStatement(
                                updateBillSql
                        )
            ) {

                updateStatement.setInt(
                        1,
                        billId
                );

                int result =
                        updateStatement.executeUpdate();

                if (result != 1) {

                    connection.rollback();

                    return null;
                }
            }

            connection.commit();

            Payment payment =
                    getSuccessfulPaymentByBillId(
                            billId
                    );

            if (payment != null) {

                return payment;
            }

            Payment fallbackPayment =
                    new Payment();

            fallbackPayment.setPaymentId(
                    paymentId
            );

            fallbackPayment.setBillId(
                    billId
            );

            fallbackPayment.setCashierUserId(
                    cashierUserId
            );

            fallbackPayment.setAmount(
                    officialAmount
            );

            fallbackPayment.setMethod(
                    cleanMethod
            );

            fallbackPayment.setReference(
                    cleanReference
            );

            fallbackPayment.setStatus(
                    "SUCCESS"
            );

            fallbackPayment.setPaidAt(
                    new Timestamp(
                            System.currentTimeMillis()
                    )
            );

            return fallbackPayment;

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


    public Payment getSuccessfulPaymentByBillId(
            int billId) {

        if (billId <= 0) {

            return null;
        }

        String sql =
                "SELECT " +
                "payment_id, " +
                "bill_id, " +
                "cashier_user_id, " +
                "amount, " +
                "method, " +
                "reference, " +
                "status, " +
                "paid_at " +
                "FROM payments " +
                "WHERE bill_id = ? " +
                "AND status = 'SUCCESS' " +
                "ORDER BY paid_at DESC, payment_id DESC " +
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
                    billId
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (!resultSet.next()) {

                    return null;
                }

                return mapPayment(
                        resultSet
                );
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }


    public Payment getPaymentById(
            int paymentId) {

        if (paymentId <= 0) {

            return null;
        }

        String sql =
                "SELECT " +
                "payment_id, " +
                "bill_id, " +
                "cashier_user_id, " +
                "amount, " +
                "method, " +
                "reference, " +
                "status, " +
                "paid_at " +
                "FROM payments " +
                "WHERE payment_id = ?";

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
                    paymentId
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (!resultSet.next()) {

                    return null;
                }

                return mapPayment(
                        resultSet
                );
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }


    private Payment mapPayment(
            ResultSet resultSet)
            throws Exception {

        Payment payment =
                new Payment();

        payment.setPaymentId(
                resultSet.getInt(
                        "payment_id"
                )
        );

        payment.setBillId(
                resultSet.getInt(
                        "bill_id"
                )
        );

        payment.setCashierUserId(
                resultSet.getInt(
                        "cashier_user_id"
                )
        );

        payment.setAmount(
                resultSet.getBigDecimal(
                        "amount"
                )
        );

        payment.setMethod(
                resultSet.getString(
                        "method"
                )
        );

        payment.setReference(
                resultSet.getString(
                        "reference"
                )
        );

        payment.setStatus(
                resultSet.getString(
                        "status"
                )
        );

        payment.setPaidAt(
                resultSet.getTimestamp(
                        "paid_at"
                )
        );

        return payment;
    }


    private boolean isValidPaymentMethod(
            String method) {

        return "CASH".equals(method)
                || "CARD".equals(method)
                || "BANK_TRANSFER".equals(method);
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