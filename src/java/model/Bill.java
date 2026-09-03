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


    private Bill(Builder builder) {

        this.billId =
                builder.billId;

        this.billNo =
                builder.billNo;

        this.appointmentId =
                builder.appointmentId;

        this.patientId =
                builder.patientId;

        this.subtotal =
                builder.subtotal != null
                ? builder.subtotal
                : BigDecimal.ZERO;

        this.discount =
                builder.discount != null
                ? builder.discount
                : BigDecimal.ZERO;

        this.totalAmount =
                builder.totalAmount != null
                ? builder.totalAmount
                : BigDecimal.ZERO;

        this.paymentStatus =
                builder.paymentStatus != null
                ? builder.paymentStatus
                : "UNPAID";

        this.qrToken =
                builder.qrToken;

        this.createdAt =
                builder.createdAt;

        this.updatedAt =
                builder.updatedAt;

        this.appointmentNo =
                builder.appointmentNo;

        this.patientNo =
                builder.patientNo;

        this.patientName =
                builder.patientName;

        this.dentistName =
                builder.dentistName;

        this.dentistSpecialization =
                builder.dentistSpecialization;

        this.requestedServiceName =
                builder.requestedServiceName;

        this.appointmentDate =
                builder.appointmentDate;

        this.appointmentTime =
                builder.appointmentTime;

        this.consultationFee =
                builder.consultationFee != null
                ? builder.consultationFee
                : BigDecimal.ZERO;

        if (builder.billItems != null) {

            this.billItems =
                    new ArrayList<>(
                            builder.billItems
                    );

        } else {

            this.billItems =
                    new ArrayList<>();
        }
    }


    public static Builder builder() {

        return new Builder();
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


    public static class Builder {

        private int billId;

        private String billNo;

        private int appointmentId;
        private int patientId;

        private BigDecimal subtotal =
                BigDecimal.ZERO;

        private BigDecimal discount =
                BigDecimal.ZERO;

        private BigDecimal totalAmount =
                BigDecimal.ZERO;

        private String paymentStatus =
                "UNPAID";

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

        private BigDecimal consultationFee =
                BigDecimal.ZERO;

        private List<BillItem> billItems =
                new ArrayList<>();


        public Builder billId(int billId) {

            this.billId =
                    billId;

            return this;
        }


        public Builder billNo(String billNo) {

            this.billNo =
                    billNo;

            return this;
        }


        public Builder appointmentId(
                int appointmentId) {

            this.appointmentId =
                    appointmentId;

            return this;
        }


        public Builder patientId(
                int patientId) {

            this.patientId =
                    patientId;

            return this;
        }


        public Builder subtotal(
                BigDecimal subtotal) {

            this.subtotal =
                    subtotal != null
                    ? subtotal
                    : BigDecimal.ZERO;

            return this;
        }


        public Builder discount(
                BigDecimal discount) {

            this.discount =
                    discount != null
                    ? discount
                    : BigDecimal.ZERO;

            return this;
        }


        public Builder totalAmount(
                BigDecimal totalAmount) {

            this.totalAmount =
                    totalAmount != null
                    ? totalAmount
                    : BigDecimal.ZERO;

            return this;
        }


        public Builder paymentStatus(
                String paymentStatus) {

            this.paymentStatus =
                    paymentStatus != null
                    ? paymentStatus
                    : "UNPAID";

            return this;
        }


        public Builder qrToken(
                String qrToken) {

            this.qrToken =
                    qrToken;

            return this;
        }


        public Builder createdAt(
                Timestamp createdAt) {

            this.createdAt =
                    createdAt;

            return this;
        }


        public Builder updatedAt(
                Timestamp updatedAt) {

            this.updatedAt =
                    updatedAt;

            return this;
        }


        public Builder appointmentNo(
                String appointmentNo) {

            this.appointmentNo =
                    appointmentNo;

            return this;
        }


        public Builder patientNo(
                String patientNo) {

            this.patientNo =
                    patientNo;

            return this;
        }


        public Builder patientName(
                String patientName) {

            this.patientName =
                    patientName;

            return this;
        }


        public Builder dentistName(
                String dentistName) {

            this.dentistName =
                    dentistName;

            return this;
        }


        public Builder dentistSpecialization(
                String dentistSpecialization) {

            this.dentistSpecialization =
                    dentistSpecialization;

            return this;
        }


        public Builder requestedServiceName(
                String requestedServiceName) {

            this.requestedServiceName =
                    requestedServiceName;

            return this;
        }


        public Builder appointmentDate(
                Date appointmentDate) {

            this.appointmentDate =
                    appointmentDate;

            return this;
        }


        public Builder appointmentTime(
                Time appointmentTime) {

            this.appointmentTime =
                    appointmentTime;

            return this;
        }


        public Builder consultationFee(
                BigDecimal consultationFee) {

            this.consultationFee =
                    consultationFee != null
                    ? consultationFee
                    : BigDecimal.ZERO;

            return this;
        }


        public Builder billItems(
                List<BillItem> billItems) {

            if (billItems == null) {

                this.billItems =
                        new ArrayList<>();

            } else {

                this.billItems =
                        new ArrayList<>(
                                billItems
                        );
            }

            return this;
        }


        public Builder addBillItem(
                BillItem billItem) {

            if (billItem != null) {

                this.billItems.add(
                        billItem
                );
            }

            return this;
        }


        public Bill build() {

            return new Bill(
                    this
            );
        }
    }
}