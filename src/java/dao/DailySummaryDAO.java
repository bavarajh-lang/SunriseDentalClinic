package dao;

import model.Payment;
import util.DBConnection;

import java.math.BigDecimal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import java.util.ArrayList;
import java.util.List;

public class DailySummaryDAO {

    public int getTodayPaymentsCount() {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM payments " +
                "WHERE payment_status = 'SUCCESS' " +
                "AND DATE(paid_at) = CURRENT_DATE";

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


    public BigDecimal getTodayRevenue() {

        String sql =
                "SELECT COALESCE(SUM(amount), 0) AS total " +
                "FROM payments " +
                "WHERE payment_status = 'SUCCESS' " +
                "AND DATE(paid_at) = CURRENT_DATE";

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

                BigDecimal total =
                        resultSet.getBigDecimal(
                                "total"
                        );

                if (total != null) {

                    return total;
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return BigDecimal.ZERO;
    }


    public BigDecimal getTodayCashTotal() {

        return getTodayTotalByMethod(
                "CASH"
        );
    }


    public BigDecimal getTodayCardTotal() {

        return getTodayTotalByMethod(
                "CARD"
        );
    }


    public BigDecimal getTodayBankTransferTotal() {

        return getTodayTotalByMethod(
                "BANK_TRANSFER"
        );
    }


    private BigDecimal getTodayTotalByMethod(
            String paymentMethod) {

        String sql =
                "SELECT COALESCE(SUM(amount), 0) AS total " +
                "FROM payments " +
                "WHERE payment_status = 'SUCCESS' " +
                "AND payment_method = ? " +
                "AND DATE(paid_at) = CURRENT_DATE";

        try (
            Connection connection =
                    DBConnection.getInstance()
                            .getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    paymentMethod
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (resultSet.next()) {

                    BigDecimal total =
                            resultSet.getBigDecimal(
                                    "total"
                            );

                    if (total != null) {

                        return total;
                    }
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return BigDecimal.ZERO;
    }


    public List<Payment> getTodayPayments() {

        List<Payment> payments =
                new ArrayList<>();

        String sql =
                "SELECT " +
                "pay.payment_id, " +
                "pay.bill_id, " +
                "pay.cashier_user_id, " +
                "pay.amount, " +
                "pay.payment_method, " +
                "pay.payment_reference, " +
                "pay.payment_status, " +
                "pay.paid_at, " +
                "b.bill_no, " +
                "a.appointment_no, " +
                "p.patient_no, " +
                "pu.full_name AS patient_name, " +
                "cu.full_name AS cashier_name " +
                "FROM payments pay " +
                "INNER JOIN bills b " +
                "ON pay.bill_id = b.bill_id " +
                "INNER JOIN appointments a " +
                "ON b.appointment_id = a.appointment_id " +
                "INNER JOIN patients p " +
                "ON b.patient_id = p.patient_id " +
                "INNER JOIN users pu " +
                "ON p.user_id = pu.user_id " +
                "INNER JOIN users cu " +
                "ON pay.cashier_user_id = cu.user_id " +
                "WHERE pay.payment_status = 'SUCCESS' " +
                "AND DATE(pay.paid_at) = CURRENT_DATE " +
                "ORDER BY pay.paid_at DESC, " +
                "pay.payment_id DESC";

        try (
            Connection connection =
                    DBConnection.getInstance()
                            .getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql);

            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            while (resultSet.next()) {

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

                payments.add(
                        payment
                );
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return payments;
    }
}