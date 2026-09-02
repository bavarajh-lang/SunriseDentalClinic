package model;

import java.sql.Date;
import java.sql.Time;

public class AppointmentSearchResult {

    private int appointmentId;

    private String appointmentNo;

    private String patientNo;
    private String patientName;
    private String patientPhone;
    private String patientEmail;

    private String dentistName;
    private String dentistSpecialization;

    private String serviceCode;
    private String serviceName;

    private Date appointmentDate;
    private Time appointmentTime;

    private String reason;
    private String status;

    private Date suggestedDate;
    private Time suggestedTime;

    private String assistantNote;


    public AppointmentSearchResult() {
    }


    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
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


    public String getPatientPhone() {
        return patientPhone;
    }

    public void setPatientPhone(String patientPhone) {
        this.patientPhone = patientPhone;
    }


    public String getPatientEmail() {
        return patientEmail;
    }

    public void setPatientEmail(String patientEmail) {
        this.patientEmail = patientEmail;
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

    public void setDentistSpecialization(String dentistSpecialization) {
        this.dentistSpecialization = dentistSpecialization;
    }


    public String getServiceCode() {
        return serviceCode;
    }

    public void setServiceCode(String serviceCode) {
        this.serviceCode = serviceCode;
    }


    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }


    public Date getAppointmentDate() {
        return appointmentDate;
    }

    public void setAppointmentDate(Date appointmentDate) {
        this.appointmentDate = appointmentDate;
    }


    public Time getAppointmentTime() {
        return appointmentTime;
    }

    public void setAppointmentTime(Time appointmentTime) {
        this.appointmentTime = appointmentTime;
    }


    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }


    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }


    public Date getSuggestedDate() {
        return suggestedDate;
    }

    public void setSuggestedDate(Date suggestedDate) {
        this.suggestedDate = suggestedDate;
    }


    public Time getSuggestedTime() {
        return suggestedTime;
    }

    public void setSuggestedTime(Time suggestedTime) {
        this.suggestedTime = suggestedTime;
    }


    public String getAssistantNote() {
        return assistantNote;
    }

    public void setAssistantNote(String assistantNote) {
        this.assistantNote = assistantNote;
    }
}