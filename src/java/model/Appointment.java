package model;

import java.sql.Date;
import java.sql.Time;

public class Appointment {

    private int appointmentId;
    private String appointmentNo;

    private int patientId;
    private int dentistId;
    private int serviceId;

    private Date appointmentDate;
    private Time appointmentTime;

    private String reason;
    private String status;

    private Date suggestedDate;
    private Time suggestedTime;

    private String assistantNote;

    /*
     * ======================================
     * DISPLAY FIELDS
     * ======================================
     */

    private String patientName;
    private String patientNo;

    private String dentistName;
    private String dentistSpecialization;

    private String serviceName;


    /*
     * ======================================
     * CONSTRUCTORS
     * ======================================
     */

    public Appointment() {
    }


    public Appointment(int patientId,
                       int dentistId,
                       int serviceId,
                       Date appointmentDate,
                       Time appointmentTime,
                       String reason) {

        this.patientId = patientId;
        this.dentistId = dentistId;
        this.serviceId = serviceId;
        this.appointmentDate = appointmentDate;
        this.appointmentTime = appointmentTime;
        this.reason = reason;
    }


    /*
     * ======================================
     * APPOINTMENT ID
     * ======================================
     */

    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }


    /*
     * ======================================
     * APPOINTMENT NUMBER
     * ======================================
     */

    public String getAppointmentNo() {
        return appointmentNo;
    }

    public void setAppointmentNo(String appointmentNo) {
        this.appointmentNo = appointmentNo;
    }


    /*
     * ======================================
     * PATIENT ID
     * ======================================
     */

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }


    /*
     * ======================================
     * DENTIST ID
     * ======================================
     */

    public int getDentistId() {
        return dentistId;
    }

    public void setDentistId(int dentistId) {
        this.dentistId = dentistId;
    }


    /*
     * ======================================
     * SERVICE ID
     * ======================================
     */

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }


    /*
     * ======================================
     * APPOINTMENT DATE
     * ======================================
     */

    public Date getAppointmentDate() {
        return appointmentDate;
    }

    public void setAppointmentDate(Date appointmentDate) {
        this.appointmentDate = appointmentDate;
    }


    /*
     * ======================================
     * APPOINTMENT TIME
     * ======================================
     */

    public Time getAppointmentTime() {
        return appointmentTime;
    }

    public void setAppointmentTime(Time appointmentTime) {
        this.appointmentTime = appointmentTime;
    }


    /*
     * ======================================
     * REASON
     * ======================================
     */

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }


    /*
     * ======================================
     * STATUS
     * ======================================
     */

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }


    /*
     * ======================================
     * SUGGESTED DATE
     * ======================================
     */

    public Date getSuggestedDate() {
        return suggestedDate;
    }

    public void setSuggestedDate(Date suggestedDate) {
        this.suggestedDate = suggestedDate;
    }


    /*
     * ======================================
     * SUGGESTED TIME
     * ======================================
     */

    public Time getSuggestedTime() {
        return suggestedTime;
    }

    public void setSuggestedTime(Time suggestedTime) {
        this.suggestedTime = suggestedTime;
    }


    /*
     * ======================================
     * ASSISTANT NOTE
     * ======================================
     */

    public String getAssistantNote() {
        return assistantNote;
    }

    public void setAssistantNote(String assistantNote) {
        this.assistantNote = assistantNote;
    }


    /*
     * ======================================
     * PATIENT NAME
     * ======================================
     */

    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }


    /*
     * ======================================
     * PATIENT NUMBER
     * ======================================
     */

    public String getPatientNo() {
        return patientNo;
    }

    public void setPatientNo(String patientNo) {
        this.patientNo = patientNo;
    }


    /*
     * ======================================
     * DENTIST NAME
     * ======================================
     */

    public String getDentistName() {
        return dentistName;
    }

    public void setDentistName(String dentistName) {
        this.dentistName = dentistName;
    }


    /*
     * ======================================
     * DENTIST SPECIALIZATION
     * ======================================
     */

    public String getDentistSpecialization() {
        return dentistSpecialization;
    }

    public void setDentistSpecialization(
            String dentistSpecialization) {

        this.dentistSpecialization =
                dentistSpecialization;
    }


    /*
     * ======================================
     * REQUESTED SERVICE NAME
     * ======================================
     */

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }
}