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

@WebServlet("/patient/MyAppointments")
public class MyAppointmentsServlet extends HttpServlet {

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

        if (!"PATIENT".equals(role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only patients can access this page."
            );

            return;
        }


        try {

            /*
             * =====================================
             * GET LOGGED-IN USER ID
             * =====================================
             */

            int userId =
                    (Integer) session.getAttribute("userId");


            /*
             * =====================================
             * LOAD PATIENT APPOINTMENTS
             * =====================================
             */

            AppointmentDAO appointmentDAO =
                    new AppointmentDAO();

            List<Appointment> appointments =
                    appointmentDAO.getAppointmentsByUserId(
                            userId
                    );


            /*
             * =====================================
             * SEND DATA TO JSP
             * =====================================
             */

            request.setAttribute(
                    "appointments",
                    appointments
            );


            /*
             * =====================================
             * FORWARD TO VIEW
             * =====================================
             */

            request.getRequestDispatcher(
                    "/patient/my-appointments.jsp"
            ).forward(
                    request,
                    response
            );


        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "appointmentListError",
                    "Unable to load your appointments."
            );

            request.getRequestDispatcher(
                    "/patient/my-appointments.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}