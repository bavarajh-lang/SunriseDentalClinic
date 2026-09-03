package controller;

import facade.ClinicFacade;
import model.TreatmentRecord;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/patient/TreatmentHistory")
public class PatientTreatmentHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null
                || session.getAttribute("userId") == null
                || session.getAttribute("role") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        String role =
                String.valueOf(
                        session.getAttribute("role")
                );

        if (!"PATIENT".equals(role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only patients can access treatment history."
            );

            return;
        }

        int patientUserId;

        try {

            patientUserId =
                    Integer.parseInt(
                            String.valueOf(
                                    session.getAttribute(
                                            "userId"
                                    )
                            )
                    );

        } catch (Exception e) {

            session.invalidate();

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        try {

            ClinicFacade clinicFacade =
                    new ClinicFacade();

            List<TreatmentRecord> treatments =
                    clinicFacade
                            .getPatientTreatmentHistory(
                                    patientUserId
                            );

            int completedTreatmentCount =
                    clinicFacade
                            .getPatientCompletedTreatmentCount(
                                    patientUserId
                            );

            request.setAttribute(
                    "treatments",
                    treatments
            );

            request.setAttribute(
                    "completedTreatmentCount",
                    completedTreatmentCount
            );

            request.getRequestDispatcher(
                    "/patient/treatment-history.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "treatmentHistoryError",
                    "Unable to load your treatment history."
            );

            request.setAttribute(
                    "treatments",
                    new ArrayList<TreatmentRecord>()
            );

            request.setAttribute(
                    "completedTreatmentCount",
                    0
            );

            request.getRequestDispatcher(
                    "/patient/treatment-history.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}