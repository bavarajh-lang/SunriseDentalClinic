package model;

public class Assistant {

    private int assistantId;
    private int userId;
    private int dentistId;

    private String assistantNo;

    private String fullName;
    private String username;
    private String email;
    private String phone;

    private String status;

    private String dentistNo;
    private String dentistName;
    private String dentistSpecialization;


    public Assistant() {
    }


    public int getAssistantId() {
        return assistantId;
    }

    public void setAssistantId(int assistantId) {
        this.assistantId = assistantId;
    }


    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }


    public int getDentistId() {
        return dentistId;
    }

    public void setDentistId(int dentistId) {
        this.dentistId = dentistId;
    }


    public String getAssistantNo() {
        return assistantNo;
    }

    public void setAssistantNo(String assistantNo) {
        this.assistantNo = assistantNo;
    }


    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }


    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }


    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }


    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }


    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }


    public String getDentistNo() {
        return dentistNo;
    }

    public void setDentistNo(String dentistNo) {
        this.dentistNo = dentistNo;
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
}