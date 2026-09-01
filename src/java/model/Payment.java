package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Payment {

    private int paymentId;
    private int billId;
    private int cashierUserId;

    private BigDecimal amount;

    private String method;
    private String reference;
    private String status;

    private Timestamp paidAt;

    private String billNo;
    private String appointmentNo;
    private String patientNo;
    private String patientName;
    private String cashierName;


    public Payment() {

        this.amount =
                BigDecimal.ZERO;

        this.status =
                "SUCCESS";
    }


    public Payment(int billId,
                   int cashierUserId,
                   BigDecimal amount,
                   String method,
                   String reference) {

        this.billId =
                billId;

        this.cashierUserId =
                cashierUserId;

        this.amount =
                amount != null
                ? amount
                : BigDecimal.ZERO;

        this.method =
                method;

        this.reference =
                reference;

        this.status =
                "SUCCESS";
    }


    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(
            int paymentId) {

        this.paymentId =
                paymentId;
    }


    public int getBillId() {
        return billId;
    }

    public void setBillId(
            int billId) {

        this.billId =
                billId;
    }


    public int getCashierUserId() {
        return cashierUserId;
    }

    public void setCashierUserId(
            int cashierUserId) {

        this.cashierUserId =
                cashierUserId;
    }


    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(
            BigDecimal amount) {

        this.amount =
                amount != null
                ? amount
                : BigDecimal.ZERO;
    }


    public String getMethod() {
        return method;
    }

    public void setMethod(
            String method) {

        this.method =
                method;
    }


    public String getReference() {
        return reference;
    }

    public void setReference(
            String reference) {

        this.reference =
                reference;
    }


    public String getStatus() {
        return status;
    }

    public void setStatus(
            String status) {

        this.status =
                status;
    }


    public Timestamp getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(
            Timestamp paidAt) {

        this.paidAt =
                paidAt;
    }


    public String getBillNo() {
        return billNo;
    }

    public void setBillNo(
            String billNo) {

        this.billNo =
                billNo;
    }


    public String getAppointmentNo() {
        return appointmentNo;
    }

    public void setAppointmentNo(
            String appointmentNo) {

        this.appointmentNo =
                appointmentNo;
    }


    public String getPatientNo() {
        return patientNo;
    }

    public void setPatientNo(
            String patientNo) {

        this.patientNo =
                patientNo;
    }


    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(
            String patientName) {

        this.patientName =
                patientName;
    }


    public String getCashierName() {
        return cashierName;
    }

    public void setCashierName(
            String cashierName) {

        this.cashierName =
                cashierName;
    }
}