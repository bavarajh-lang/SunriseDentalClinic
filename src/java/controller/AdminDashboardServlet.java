package controller;

import dao.DashboardDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/admin/Dashboard")
public class AdminDashboardServlet extends HttpServlet {

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
                (String) session.getAttribute("role");

        if (!"ADMIN".equals(role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only administrators can access the admin dashboard."
            );

            return;
        }

        try {

            DashboardDAO dashboardDAO =
                    new DashboardDAO();

            int totalPatients =
                    dashboardDAO.getTotalPatients();

            int activeDentists =
                    dashboardDAO.getActiveDentists();

            int todayAppointments =
                    dashboardDAO.getTodayAppointments();

            BigDecimal todayRevenue =
                    dashboardDAO.getTodayRevenue();

            request.setAttribute(
                    "totalPatients",
                    totalPatients
            );

            request.setAttribute(
                    "activeDentists",
                    activeDentists
            );

            request.setAttribute(
                    "todayAppointments",
                    todayAppointments
            );

            request.setAttribute(
                    "todayRevenue",
                    todayRevenue
            );

            request.getRequestDispatcher(
                    "/admin/dashboard.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "dashboardError",
                    "Unable to load dashboard information."
            );

            request.setAttribute(
                    "totalPatients",
                    0
            );

            request.setAttribute(
                    "activeDentists",
                    0
            );

            request.setAttribute(
                    "todayAppointments",
                    0
            );

            request.setAttribute(
                    "todayRevenue",
                    BigDecimal.ZERO
            );

            request.getRequestDispatcher(
                    "/admin/dashboard.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}