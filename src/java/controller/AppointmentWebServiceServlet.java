package controller;

import dao.AppointmentSearchDAO;
import model.AppointmentSearchResult;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/api/appointment")
public class AppointmentWebServiceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws IOException {

        response.setContentType(
                "application/json"
        );

        response.setCharacterEncoding(
                "UTF-8"
        );

        HttpSession session =
                request.getSession(false);

        if (session == null
                || session.getAttribute("userId") == null
                || session.getAttribute("role") == null) {

            response.setStatus(
                    HttpServletResponse.SC_UNAUTHORIZED
            );

            response.getWriter().write(
                    "{"
                    + "\"success\":false,"
                    + "\"message\":\"Authentication required.\""
                    + "}"
            );

            return;
        }

        String role =
                String.valueOf(
                        session.getAttribute(
                                "role"
                        )
                );

        if (!"ADMIN".equals(role)
                && !"CASHIER".equals(role)) {

            response.setStatus(
                    HttpServletResponse.SC_FORBIDDEN
            );

            response.getWriter().write(
                    "{"
                    + "\"success\":false,"
                    + "\"message\":\"You are not authorised to access this web service.\""
                    + "}"
            );

            return;
        }

        String appointmentNo =
                cleanValue(
                        request.getParameter(
                                "appointmentNo"
                        )
                );

        if (appointmentNo == null) {

            response.setStatus(
                    HttpServletResponse.SC_BAD_REQUEST
            );

            response.getWriter().write(
                    "{"
                    + "\"success\":false,"
                    + "\"message\":\"Appointment number is required.\""
                    + "}"
            );

            return;
        }

        if (appointmentNo.length() > 50) {

            response.setStatus(
                    HttpServletResponse.SC_BAD_REQUEST
            );

            response.getWriter().write(
                    "{"
                    + "\"success\":false,"
                    + "\"message\":\"Invalid appointment number.\""
                    + "}"
            );

            return;
        }

        try {

            AppointmentSearchDAO appointmentSearchDAO =
                    new AppointmentSearchDAO();

            AppointmentSearchResult appointment =
                    appointmentSearchDAO
                            .searchByAppointmentNo(
                                    appointmentNo
                            );

            if (appointment == null) {

                response.setStatus(
                        HttpServletResponse.SC_NOT_FOUND
                );

                response.getWriter().write(
                        "{"
                        + "\"success\":false,"
                        + "\"message\":\"Appointment not found.\""
                        + "}"
                );

                return;
            }

            String json =
                    "{"
                    + "\"success\":true,"
                    + "\"appointment\":{"

                    + "\"appointmentNo\":\""
                    + escapeJson(
                            appointment.getAppointmentNo()
                    )
                    + "\","

                    + "\"appointmentDate\":\""
                    + escapeJson(
                            appointment.getAppointmentDate()
                                    != null
                                    ? appointment
                                            .getAppointmentDate()
                                            .toString()
                                    : ""
                    )
                    + "\","

                    + "\"appointmentTime\":\""
                    + escapeJson(
                            appointment.getAppointmentTime()
                                    != null
                                    ? appointment
                                            .getAppointmentTime()
                                            .toString()
                                    : ""
                    )
                    + "\","

                    + "\"status\":\""
                    + escapeJson(
                            appointment.getStatus()
                    )
                    + "\","

                    + "\"serviceCode\":\""
                    + escapeJson(
                            appointment.getServiceCode()
                    )
                    + "\","

                    + "\"serviceName\":\""
                    + escapeJson(
                            appointment.getServiceName()
                    )
                    + "\","

                    + "\"dentistName\":\""
                    + escapeJson(
                            appointment.getDentistName()
                    )
                    + "\","

                    + "\"dentistSpecialization\":\""
                    + escapeJson(
                            appointment
                                    .getDentistSpecialization()
                    )
                    + "\","

                    + "\"suggestedDate\":\""
                    + escapeJson(
                            appointment.getSuggestedDate()
                                    != null
                                    ? appointment
                                            .getSuggestedDate()
                                            .toString()
                                    : ""
                    )
                    + "\","

                    + "\"suggestedTime\":\""
                    + escapeJson(
                            appointment.getSuggestedTime()
                                    != null
                                    ? appointment
                                            .getSuggestedTime()
                                            .toString()
                                    : ""
                    )
                    + "\""

                    + "}"
                    + "}";

            response.setStatus(
                    HttpServletResponse.SC_OK
            );

            response.getWriter().write(
                    json
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.setStatus(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR
            );

            response.getWriter().write(
                    "{"
                    + "\"success\":false,"
                    + "\"message\":\"Unable to retrieve appointment information.\""
                    + "}"
            );
        }
    }


    private String cleanValue(
            String value) {

        if (value == null
                || value.trim().isEmpty()) {

            return null;
        }

        return value.trim();
    }


    private String escapeJson(
            String value) {

        if (value == null) {

            return "";
        }

        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}