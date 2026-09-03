package controller;

import dao.AdminPatientDAO;
import model.AdminPatient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/Patients")
public class AdminPatientsServlet extends HttpServlet {

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
                    "Only administrators can access patient management."
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

        if (search != null) {
            search = search.trim();
        }

        if (status != null) {
            status = status.trim();
        }

        try {

            AdminPatientDAO patientDAO =
                    new AdminPatientDAO();

            List<AdminPatient> patients =
                    patientDAO.getPatients(
                            search,
                            status
                    );

            int totalPatients =
                    patientDAO.getTotalPatients();

            int activePatients =
                    patientDAO.getActivePatients();

            int inactivePatients =
                    patientDAO.getInactivePatients();

            request.setAttribute(
                    "patients",
                    patients
            );

            request.setAttribute(
                    "totalPatients",
                    totalPatients
            );

            request.setAttribute(
                    "activePatients",
                    activePatients
            );

            request.setAttribute(
                    "inactivePatients",
                    inactivePatients
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

            request.getRequestDispatcher(
                    "/admin/patients.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "patientError",
                    "Unable to load patient information."
            );

            request.setAttribute(
                    "patients",
                    new ArrayList<AdminPatient>()
            );

            request.setAttribute(
                    "totalPatients",
                    0
            );

            request.setAttribute(
                    "activePatients",
                    0
            );

            request.setAttribute(
                    "inactivePatients",
                    0
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

            request.getRequestDispatcher(
                    "/admin/patients.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}