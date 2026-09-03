package controller;

import dao.AdminAppointmentDAO;
import model.AppointmentSearchResult;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/Appointments")
public class AdminAppointmentsServlet extends HttpServlet {

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

        if (!"ADMIN".equals(role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only administrators can access appointment management."
            );

            return;
        }

        String search =
                request.getParameter(
                        "search"
                );

        String status =
                request.getParameter(
                        "status"
                );

        String appointmentDate =
                request.getParameter(
                        "appointmentDate"
                );

        if (search != null) {
            search = search.trim();
        }

        if (status != null) {
            status = status.trim();
        }

        if (appointmentDate != null) {
            appointmentDate = appointmentDate.trim();
        }

        try {

            AdminAppointmentDAO appointmentDAO =
                    new AdminAppointmentDAO();

            List<AppointmentSearchResult> appointments =
                    appointmentDAO.getAppointments(
                            search,
                            status,
                            appointmentDate
                    );

            int totalAppointments =
                    appointmentDAO.getTotalAppointments();

            int pendingAppointments =
                    appointmentDAO.getPendingAppointments();

            int confirmedAppointments =
                    appointmentDAO.getConfirmedAppointments();

            int completedAppointments =
                    appointmentDAO.getCompletedAppointments();

            request.setAttribute(
                    "appointments",
                    appointments
            );

            request.setAttribute(
                    "totalAppointments",
                    totalAppointments
            );

            request.setAttribute(
                    "pendingAppointments",
                    pendingAppointments
            );

            request.setAttribute(
                    "confirmedAppointments",
                    confirmedAppointments
            );

            request.setAttribute(
                    "completedAppointments",
                    completedAppointments
            );

            request.setAttribute(
                    "search",
                    search != null
                    ? search
                    : ""
            );

            request.setAttribute(
                    "selectedStatus",
                    status != null
                    ? status
                    : ""
            );

            request.setAttribute(
                    "selectedDate",
                    appointmentDate != null
                    ? appointmentDate
                    : ""
            );

            request.getRequestDispatcher(
                    "/admin/appointments.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "appointmentError",
                    "Unable to load clinic appointments."
            );

            request.setAttribute(
                    "search",
                    search != null
                    ? search
                    : ""
            );

            request.setAttribute(
                    "selectedStatus",
                    status != null
                    ? status
                    : ""
            );

            request.setAttribute(
                    "selectedDate",
                    appointmentDate != null
                    ? appointmentDate
                    : ""
            );

            request.getRequestDispatcher(
                    "/admin/appointments.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}