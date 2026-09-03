package controller;

import facade.ClinicFacade;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/patient/Dashboard")
public class PatientDashboardServlet extends HttpServlet {

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
                    "Only patients can access this dashboard."
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

            ClinicFacade.PatientDashboardSummary summary =
                    clinicFacade
                            .getPatientDashboardSummary(
                                    patientUserId
                            );

            request.setAttribute(
                    "upcomingAppointments",
                    summary.getUpcomingAppointments()
            );

            request.setAttribute(
                    "pendingRequests",
                    summary.getPendingRequests()
            );

            request.setAttribute(
                    "completedTreatments",
                    summary.getCompletedTreatments()
            );

            request.setAttribute(
                    "unpaidBills",
                    summary.getUnpaidBills()
            );

            request.getRequestDispatcher(
                    "/patient/dashboard.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "dashboardError",
                    "Unable to load your dashboard information."
            );

            request.setAttribute(
                    "upcomingAppointments",
                    0
            );

            request.setAttribute(
                    "pendingRequests",
                    0
            );

            request.setAttribute(
                    "completedTreatments",
                    0
            );

            request.setAttribute(
                    "unpaidBills",
                    0
            );

            request.getRequestDispatcher(
                    "/patient/dashboard.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}