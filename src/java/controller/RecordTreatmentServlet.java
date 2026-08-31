package controller;

import dao.DentalServiceDAO;
import dao.TreatmentDAO;

import model.Appointment;
import model.DentalService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/assistant/RecordTreatment")
public class RecordTreatmentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);


        /*
         * =========================================
         * SESSION CHECK
         * =========================================
         */
        if (session == null
                || session.getAttribute("userId") == null
                || session.getAttribute("role") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }


        /*
         * =========================================
         * ROLE CHECK
         * =========================================
         */
        String role =
                (String) session.getAttribute("role");

        if (!"ASSISTANT".equals(role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only dentist assistants can record treatment details."
            );

            return;
        }


        try {

            /*
             * =========================================
             * GET APPOINTMENT ID
             * =========================================
             */
            String appointmentIdValue =
                    request.getParameter("appointmentId");


            if (appointmentIdValue == null
                    || appointmentIdValue.trim().isEmpty()) {

                session.setAttribute(
                        "treatmentError",
                        "Invalid appointment selected."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/assistant/ConfirmedAppointments"
                );

                return;
            }


            int appointmentId =
                    Integer.parseInt(
                            appointmentIdValue.trim()
                    );


            if (appointmentId <= 0) {

                session.setAttribute(
                        "treatmentError",
                        "Invalid appointment selected."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/assistant/ConfirmedAppointments"
                );

                return;
            }


            /*
             * =========================================
             * LOGGED-IN ASSISTANT
             * =========================================
             */
            int assistantUserId =
                    (Integer) session.getAttribute("userId");


            /*
             * =========================================
             * LOAD CONFIRMED APPOINTMENT
             * =========================================
             *
             * TreatmentDAO itself verifies:
             *
             * assistant
             *      ↓
             * assigned dentist
             *      ↓
             * selected appointment
             *      ↓
             * CONFIRMED status
             */
            TreatmentDAO treatmentDAO =
                    new TreatmentDAO();


            Appointment appointment =
                    treatmentDAO
                            .getConfirmedAppointmentForTreatment(
                                    assistantUserId,
                                    appointmentId
                            );


            /*
             * Appointment missing / unauthorized /
             * already completed etc.
             */
            if (appointment == null) {

                session.setAttribute(
                        "treatmentError",
                        "This appointment cannot be used for treatment recording. "
                        + "It may already be completed or may not belong "
                        + "to your assigned dentist."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/assistant/ConfirmedAppointments"
                );

                return;
            }


            /*
             * =========================================
             * LOAD ACTIVE DENTAL SERVICES
             * =========================================
             *
             * Actual treatment items select panna
             * dropdown-ku use pannuvom.
             */
            DentalServiceDAO dentalServiceDAO =
                    new DentalServiceDAO();


            List<DentalService> services =
                    dentalServiceDAO
                            .getActiveServices();


            /*
             * =========================================
             * SEND DATA TO JSP
             * =========================================
             */
            request.setAttribute(
                    "appointment",
                    appointment
            );


            request.setAttribute(
                    "services",
                    services
            );


            /*
             * =========================================
             * OPEN TREATMENT FORM
             * =========================================
             */
            request.getRequestDispatcher(
                    "/assistant/record-treatment.jsp"
            ).forward(
                    request,
                    response
            );


        } catch (NumberFormatException e) {

            session.setAttribute(
                    "treatmentError",
                    "Invalid appointment ID."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/assistant/ConfirmedAppointments"
            );


        } catch (Exception e) {

            e.printStackTrace();


            session.setAttribute(
                    "treatmentError",
                    "Unable to open the treatment record."
            );


            response.sendRedirect(
                    request.getContextPath()
                    + "/assistant/ConfirmedAppointments"
            );
        }
    }
}