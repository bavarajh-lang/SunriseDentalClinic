package model;

import java.math.BigDecimal;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

import java.util.ArrayList;
import java.util.List;

public class Bill {

    private int billId;

    private String billNo;

    private int appointmentId;
    private int patientId;

    private BigDecimal subtotal;
    private BigDecimal discount;
    private BigDecimal totalAmount;

    private String paymentStatus;

    private String qrToken;

    private Timestamp createdAt;
    private Timestamp updatedAt;

    private String appointmentNo;

    private String patientNo;
    private String patientName;

    private String dentistName;
    private String dentistSpecialization;

    private String requestedServiceName;

    private Date appointmentDate;
    private Time appointmentTime;

    private BigDecimal consultationFee;

    private List<BillItem> billItems =
            new ArrayList<>();


    public Bill() {

        this.subtotal =
                BigDecimal.ZERO;

        this.discount =
                BigDecimal.ZERO;

        this.totalAmount =
                BigDecimal.ZERO;

        this.consultationFee =
                BigDecimal.ZERO;

        this.paymentStatus =
                "UNPAID";
    }


    public int getBillId() {
        return billId;
    }

    public void setBillId(int billId) {
        this.billId = billId;
    }


    public String getBillNo() {
        return billNo;
    }

    public void setBillNo(String billNo) {
        this.billNo = billNo;
    }


    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }


    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }


    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {

        this.subtotal =
                subtotal != null
                ? subtotal
                : BigDecimal.ZERO;
    }


    public BigDecimal getDiscount() {
        return discount;
    }

    public void setDiscount(BigDecimal discount) {

        this.discount =
                discount != null
                ? discount
                : BigDecimal.ZERO;
    }


    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {

        this.totalAmount =
                totalAmount != null
                ? totalAmount
                : BigDecimal.ZERO;
    }


    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }


    public String getQrToken() {
        return qrToken;
    }

    public void setQrToken(String qrToken) {
        this.qrToken = qrToken;
    }


    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }


    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }


    public String getAppointmentNo() {
        return appointmentNo;
    }

    public void setAppointmentNo(String appointmentNo) {
        this.appointmentNo = appointmentNo;
    }


    public String getPatientNo() {
        return patientNo;
    }

    public void setPatientNo(String patientNo) {
        this.patientNo = patientNo;
    }


    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }


    public String getDentistName() {
        return dentistName;
    }

    public void setDentistName(String dentistName) {
        this.dentistName = dentistName;
    }


    public String getDentistSpecialization() {
        return dentistSpecialization;
    }

    public void setDentistSpecialization(
            String dentistSpecialization) {

        this.dentistSpecialization =
                dentistSpecialization;
    }


    public String getRequestedServiceName() {
        return requestedServiceName;
    }

    public void setRequestedServiceName(
            String requestedServiceName) {

        this.requestedServiceName =
                requestedServiceName;
    }


    public Date getAppointmentDate() {
        return appointmentDate;
    }

    public void setAppointmentDate(
            Date appointmentDate) {

        this.appointmentDate =
                appointmentDate;
    }


    public Time getAppointmentTime() {
        return appointmentTime;
    }

    public void setAppointmentTime(
            Time appointmentTime) {

        this.appointmentTime =
                appointmentTime;
    }


    public BigDecimal getConsultationFee() {
        return consultationFee;
    }

    public void setConsultationFee(
            BigDecimal consultationFee) {

        this.consultationFee =
                consultationFee != null
                ? consultationFee
                : BigDecimal.ZERO;
    }


    public List<BillItem> getBillItems() {
        return billItems;
    }

    public void setBillItems(
            List<BillItem> billItems) {

        if (billItems == null) {

            this.billItems =
                    new ArrayList<>();

        } else {

            this.billItems =
                    billItems;
        }
    }


    public void addBillItem(
            BillItem billItem) {

        if (billItem != null) {

            billItems.add(
                    billItem
            );
        }
    }


    public BigDecimal calculateItemsTotal() {

        BigDecimal total =
                BigDecimal.ZERO;

        if (billItems != null) {

            for (BillItem item : billItems) {

                if (item != null
                        && item.getLineTotal() != null) {

                    total =
                            total.add(
                                    item.getLineTotal()
                            );
                }
            }
        }

        return total;
    }


    public BigDecimal calculateSubtotal() {

        subtotal =
                calculateItemsTotal();

        return subtotal;
    }


    public BigDecimal calculateTotalAmount() {

        BigDecimal currentSubtotal =
                calculateSubtotal();

        BigDecimal currentDiscount =
                discount != null
                ? discount
                : BigDecimal.ZERO;

        totalAmount =
                currentSubtotal.subtract(
                        currentDiscount
                );

        if (totalAmount.compareTo(
                BigDecimal.ZERO) < 0) {

            totalAmount =
                    BigDecimal.ZERO;
        }

        return totalAmount;
    }
}