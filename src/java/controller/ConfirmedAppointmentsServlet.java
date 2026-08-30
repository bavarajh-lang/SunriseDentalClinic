package controller;

import dao.AppointmentDAO;
import model.Appointment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/assistant/ConfirmedAppointments")
public class ConfirmedAppointmentsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        /*
         * =====================================
         * SESSION CHECK
         * =====================================
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
         * =====================================
         * ROLE CHECK
         * =====================================
         */
        String role =
                (String) session.getAttribute("role");

        if (!"ASSISTANT".equals(role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only dentist assistants can access this page."
            );

            return;
        }

        try {

            /*
             * =====================================
             * GET LOGGED-IN ASSISTANT USER ID
             * =====================================
             */
            int assistantUserId =
                    (Integer) session.getAttribute("userId");

            /*
             * =====================================
             * LOAD CONFIRMED APPOINTMENTS
             * =====================================
             */
            AppointmentDAO appointmentDAO =
                    new AppointmentDAO();

            List<Appointment> confirmedAppointments =
                    appointmentDAO
                            .getConfirmedAppointmentsByAssistantUserId(
                                    assistantUserId
                            );

            /*
             * =====================================
             * SEND DATA TO JSP
             * =====================================
             */
            request.setAttribute(
                    "confirmedAppointments",
                    confirmedAppointments
            );

            /*
             * =====================================
             * FORWARD TO VIEW
             * =====================================
             */
            request.getRequestDispatcher(
                    "/assistant/confirmed-appointments.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "confirmedAppointmentError",
                    "Unable to load confirmed appointments."
            );

            request.getRequestDispatcher(
                    "/assistant/confirmed-appointments.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}