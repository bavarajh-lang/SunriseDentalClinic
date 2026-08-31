package model;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class TreatmentRecord {

    private int treatmentRecordId;
    private int appointmentId;

    private String diagnosis;
    private String treatmentNotes;
    private String dentistNotes;

    private Timestamp completedAt;

    private String appointmentNo;

    private int patientId;
    private String patientNo;
    private String patientName;

    private int dentistId;
    private String dentistName;

    private String requestedServiceName;

    private Date appointmentDate;

    private List<TreatmentItem> treatmentItems =
            new ArrayList<>();

    public TreatmentRecord() {
    }

    public TreatmentRecord(int appointmentId,
                           String diagnosis,
                           String treatmentNotes,
                           String dentistNotes) {

        this.appointmentId = appointmentId;
        this.diagnosis = diagnosis;
        this.treatmentNotes = treatmentNotes;
        this.dentistNotes = dentistNotes;
    }

    public int getTreatmentRecordId() {
        return treatmentRecordId;
    }

    public void setTreatmentRecordId(int treatmentRecordId) {
        this.treatmentRecordId = treatmentRecordId;
    }

    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }

    public String getDiagnosis() {
        return diagnosis;
    }

    public void setDiagnosis(String diagnosis) {
        this.diagnosis = diagnosis;
    }

    public String getTreatmentNotes() {
        return treatmentNotes;
    }

    public void setTreatmentNotes(String treatmentNotes) {
        this.treatmentNotes = treatmentNotes;
    }

    public String getDentistNotes() {
        return dentistNotes;
    }

    public void setDentistNotes(String dentistNotes) {
        this.dentistNotes = dentistNotes;
    }

    public Timestamp getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Timestamp completedAt) {
        this.completedAt = completedAt;
    }

    public String getAppointmentNo() {
        return appointmentNo;
    }

    public void setAppointmentNo(String appointmentNo) {
        this.appointmentNo = appointmentNo;
    }

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
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

    public int getDentistId() {
        return dentistId;
    }

    public void setDentistId(int dentistId) {
        this.dentistId = dentistId;
    }

    public String getDentistName() {
        return dentistName;
    }

    public void setDentistName(String dentistName) {
        this.dentistName = dentistName;
    }

    public String getRequestedServiceName() {
        return requestedServiceName;
    }

    public void setRequestedServiceName(String requestedServiceName) {
        this.requestedServiceName = requestedServiceName;
    }

    public Date getAppointmentDate() {
        return appointmentDate;
    }

    public void setAppointmentDate(Date appointmentDate) {
        this.appointmentDate = appointmentDate;
    }

    public List<TreatmentItem> getTreatmentItems() {
        return treatmentItems;
    }

    public void setTreatmentItems(List<TreatmentItem> treatmentItems) {

        if (treatmentItems == null) {
            this.treatmentItems = new ArrayList<>();
        } else {
            this.treatmentItems = treatmentItems;
        }
    }

    public void addTreatmentItem(TreatmentItem treatmentItem) {

        if (treatmentItem != null) {
            treatmentItems.add(treatmentItem);
        }
    }

    public double getTreatmentTotal() {

        double total = 0.00;

        if (treatmentItems != null) {

            for (TreatmentItem item : treatmentItems) {

                if (item != null) {
                    total += item.getLineTotal();
                }
            }
        }

        return total;
    }
}