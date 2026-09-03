package dao;

import model.Payment;
import util.DBConnection;

import java.math.BigDecimal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import java.util.ArrayList;
import java.util.List;

public class AdminPaymentDAO {

    public List<Payment> getPayments(
            String search,
            String method,
            String paymentDate) {

        List<Payment> payments =
                new ArrayList<>();

        String cleanSearch =
                cleanValue(search);

        String cleanMethod =
                cleanValue(method);

        String cleanDate =
                cleanValue(paymentDate);

        StringBuilder sql =
                new StringBuilder();

        sql.append(
                "SELECT " +
                "p.payment_id, " +
                "p.bill_id, " +
                "p.cashier_user_id, " +
                "p.amount, " +
                "p.payment_method, " +
                "p.payment_reference, " +
                "p.payment_status, " +
                "p.paid_at, " +

                "b.bill_no, " +
                "a.appointment_no, " +
                "pt.patient_no, " +
                "pu.full_name AS patient_name, " +
                "cu.full_name AS cashier_name " +

                "FROM payments p " +

                "INNER JOIN bills b " +
                "ON p.bill_id = b.bill_id " +

                "INNER JOIN appointments a " +
                "ON b.appointment_id = a.appointment_id " +

                "INNER JOIN patients pt " +
                "ON b.patient_id = pt.patient_id " +

                "INNER JOIN users pu " +
                "ON pt.user_id = pu.user_id " +

                "INNER JOIN users cu " +
                "ON p.cashier_user_id = cu.user_id " +

                "WHERE 1 = 1 "
        );

        List<Object> parameters =
                new ArrayList<>();

        if (cleanSearch != null) {

            sql.append(
                    "AND (" +
                    "b.bill_no LIKE ? " +
                    "OR a.appointment_no LIKE ? " +
                    "OR pt.patient_no LIKE ? " +
                    "OR pu.full_name LIKE ? " +
                    "OR p.payment_reference LIKE ? " +
                    "OR cu.full_name LIKE ? " +
                    ") "
            );

            String likeValue =
                    "%" + cleanSearch + "%";

            parameters.add(likeValue);
            parameters.add(likeValue);
            parameters.add(likeValue);
            parameters.add(likeValue);
            parameters.add(likeValue);
            parameters.add(likeValue);
        }

        if (cleanMethod != null
                && isValidMethod(cleanMethod)) {

            sql.append(
                    "AND p.payment_method = ? "
            );

            parameters.add(
                    cleanMethod
            );
        }

        if (cleanDate != null) {

            sql.append(
                    "AND DATE(p.paid_at) = ? "
            );

            parameters.add(
                    cleanDate
            );
        }

        sql.append(
                "ORDER BY " +
                "p.paid_at DESC, " +
                "p.payment_id DESC"
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

                    payments.add(
                            mapPayment(
                                    resultSet
                            )
                    );
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return payments;
    }


    public int getSuccessfulPaymentsCount() {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM payments " +
                "WHERE payment_status = 'SUCCESS'";

        return getIntValue(
                sql
        );
    }


    public int getTodayPaymentsCount() {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM payments " +
                "WHERE payment_status = 'SUCCESS' " +
                "AND DATE(paid_at) = CURRENT_DATE";

        return getIntValue(
                sql
        );
    }


    public BigDecimal getTotalRevenue() {

        String sql =
                "SELECT COALESCE(SUM(amount), 0) AS total " +
                "FROM payments " +
                "WHERE payment_status = 'SUCCESS'";

        return getDecimalValue(
                sql
        );
    }


    public BigDecimal getTodayRevenue() {

        String sql =
                "SELECT COALESCE(SUM(amount), 0) AS total " +
                "FROM payments " +
                "WHERE payment_status = 'SUCCESS' " +
                "AND DATE(paid_at) = CURRENT_DATE";

        return getDecimalValue(
                sql
        );
    }


    private int getIntValue(
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


    private BigDecimal getDecimalValue(
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

                BigDecimal value =
                        resultSet.getBigDecimal(
                                "total"
                        );

                return value != null
                        ? value
                        : BigDecimal.ZERO;
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return BigDecimal.ZERO;
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
                        "payment_method"
                )
        );

        payment.setReference(
                resultSet.getString(
                        "payment_reference"
                )
        );

        payment.setStatus(
                resultSet.getString(
                        "payment_status"
                )
        );

        payment.setPaidAt(
                resultSet.getTimestamp(
                        "paid_at"
                )
        );

        payment.setBillNo(
                resultSet.getString(
                        "bill_no"
                )
        );

        payment.setAppointmentNo(
                resultSet.getString(
                        "appointment_no"
                )
        );

        payment.setPatientNo(
                resultSet.getString(
                        "patient_no"
                )
        );

        payment.setPatientName(
                resultSet.getString(
                        "patient_name"
                )
        );

        payment.setCashierName(
                resultSet.getString(
                        "cashier_name"
                )
        );

        return payment;
    }


    private boolean isValidMethod(
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