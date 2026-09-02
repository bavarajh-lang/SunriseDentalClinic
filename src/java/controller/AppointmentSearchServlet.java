package controller;

import dao.AppointmentSearchDAO;
import model.AppointmentSearchResult;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/AppointmentSearch")
public class AppointmentSearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (!isAuthorized(session)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        request.getRequestDispatcher(
                "/appointment-search.jsp"
        ).forward(
                request,
                response
        );
    }


    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (!isAuthorized(session)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        String appointmentNo =
                request.getParameter(
                        "appointmentNo"
                );

        if (appointmentNo == null
                || appointmentNo.trim().isEmpty()) {

            request.setAttribute(
                    "searchError",
                    "Please enter an appointment number."
            );

            request.getRequestDispatcher(
                    "/appointment-search.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }

        String cleanAppointmentNo =
                appointmentNo.trim()
                        .toUpperCase();

        if (cleanAppointmentNo.length() > 50) {

            request.setAttribute(
                    "searchError",
                    "Invalid appointment number."
            );

            request.setAttribute(
                    "searchedAppointmentNo",
                    cleanAppointmentNo
            );

            request.getRequestDispatcher(
                    "/appointment-search.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }

        try {

            AppointmentSearchDAO searchDAO =
                    new AppointmentSearchDAO();

            AppointmentSearchResult appointment =
                    searchDAO.searchByAppointmentNo(
                            cleanAppointmentNo
                    );

            request.setAttribute(
                    "searchedAppointmentNo",
                    cleanAppointmentNo
            );

            if (appointment == null) {

                request.setAttribute(
                        "searchError",
                        "No appointment was found for the entered appointment number."
                );

            } else {

                request.setAttribute(
                        "appointment",
                        appointment
                );
            }

            request.getRequestDispatcher(
                    "/appointment-search.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "searchedAppointmentNo",
                    cleanAppointmentNo
            );

            request.setAttribute(
                    "searchError",
                    "Unable to search for the appointment at this time."
            );

            request.getRequestDispatcher(
                    "/appointment-search.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }


    private boolean isAuthorized(
            HttpSession session) {

        if (session == null
                || session.getAttribute("userId") == null
                || session.getAttribute("role") == null) {

            return false;
        }

        String role =
                String.valueOf(
                        session.getAttribute("role")
                );

        return "ADMIN".equals(role)
                || "ASSISTANT".equals(role)
                || "CASHIER".equals(role);
    }
}