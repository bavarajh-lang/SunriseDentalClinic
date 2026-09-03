package facade;

import dao.PatientBillDAO;
import dao.PatientDashboardDAO;
import dao.PatientTreatmentDAO;

import model.PatientBill;
import model.TreatmentRecord;

import java.util.List;

public class ClinicFacade {

    private final PatientDashboardDAO patientDashboardDAO;
    private final PatientBillDAO patientBillDAO;
    private final PatientTreatmentDAO patientTreatmentDAO;


    public ClinicFacade() {

        this.patientDashboardDAO =
                new PatientDashboardDAO();

        this.patientBillDAO =
                new PatientBillDAO();

        this.patientTreatmentDAO =
                new PatientTreatmentDAO();
    }


    public PatientDashboardSummary getPatientDashboardSummary(
            int patientUserId) {

        validateUserId(
                patientUserId
        );

        int upcomingAppointments =
                patientDashboardDAO
                        .getUpcomingAppointmentsCount(
                                patientUserId
                        );

        int pendingRequests =
                patientDashboardDAO
                        .getPendingRequestsCount(
                                patientUserId
                        );

        int completedTreatments =
                patientDashboardDAO
                        .getCompletedTreatmentsCount(
                                patientUserId
                        );

        int unpaidBills =
                patientDashboardDAO
                        .getUnpaidBillsCount(
                                patientUserId
                        );

        return new PatientDashboardSummary(
                upcomingAppointments,
                pendingRequests,
                completedTreatments,
                unpaidBills
        );
    }


    public List<PatientBill> getPatientBills(
            int patientUserId) {

        validateUserId(
                patientUserId
        );

        return patientBillDAO
                .getBillsByPatientUserId(
                        patientUserId
                );
    }


    public PatientBill getPatientBill(
            int billId,
            int patientUserId) {

        validateUserId(
                patientUserId
        );

        if (billId <= 0) {

            throw new IllegalArgumentException(
                    "Invalid bill ID."
            );
        }

        return patientBillDAO
                .getBillByIdForPatient(
                        billId,
                        patientUserId
                );
    }


    public int getPatientTotalBillsCount(
            int patientUserId) {

        validateUserId(
                patientUserId
        );

        return patientBillDAO
                .getTotalBillsCount(
                        patientUserId
                );
    }


    public int getPatientUnpaidBillsCount(
            int patientUserId) {

        validateUserId(
                patientUserId
        );

        return patientBillDAO
                .getUnpaidBillsCount(
                        patientUserId
                );
    }


    public int getPatientPaidBillsCount(
            int patientUserId) {

        validateUserId(
                patientUserId
        );

        return patientBillDAO
                .getPaidBillsCount(
                        patientUserId
                );
    }


    public List<TreatmentRecord> getPatientTreatmentHistory(
            int patientUserId) {

        validateUserId(
                patientUserId
        );

        return patientTreatmentDAO
                .getTreatmentHistoryByPatientUserId(
                        patientUserId
                );
    }


    public int getPatientCompletedTreatmentCount(
            int patientUserId) {

        validateUserId(
                patientUserId
        );

        return patientTreatmentDAO
                .getCompletedTreatmentCount(
                        patientUserId
                );
    }


    private void validateUserId(
            int userId) {

        if (userId <= 0) {

            throw new IllegalArgumentException(
                    "Invalid user ID."
            );
        }
    }


    public static class PatientDashboardSummary {

        private final int upcomingAppointments;
        private final int pendingRequests;
        private final int completedTreatments;
        private final int unpaidBills;


        public PatientDashboardSummary(
                int upcomingAppointments,
                int pendingRequests,
                int completedTreatments,
                int unpaidBills) {

            this.upcomingAppointments =
                    upcomingAppointments;

            this.pendingRequests =
                    pendingRequests;

            this.completedTreatments =
                    completedTreatments;

            this.unpaidBills =
                    unpaidBills;
        }


        public int getUpcomingAppointments() {
            return upcomingAppointments;
        }


        public int getPendingRequests() {
            return pendingRequests;
        }


        public int getCompletedTreatments() {
            return completedTreatments;
        }


        public int getUnpaidBills() {
            return unpaidBills;
        }
    }
}