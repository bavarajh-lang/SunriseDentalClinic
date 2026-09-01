package controller;

import dao.CashierDashboardDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/cashier/Dashboard")
public class CashierDashboardServlet extends HttpServlet {

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

        if (!"CASHIER".equals(role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only cashiers can access this dashboard."
            );

            return;
        }

        try {

            CashierDashboardDAO dashboardDAO =
                    new CashierDashboardDAO();

            int pendingBills =
                    dashboardDAO.getPendingBillsCount();

            int todayPayments =
                    dashboardDAO.getTodayPaymentsCount();

            BigDecimal todayRevenue =
                    dashboardDAO.getTodayRevenue();

            int paidBills =
                    dashboardDAO.getPaidBillsCount();

            request.setAttribute(
                    "pendingBills",
                    pendingBills
            );

            request.setAttribute(
                    "todayPayments",
                    todayPayments
            );

            request.setAttribute(
                    "todayRevenue",
                    todayRevenue
            );

            request.setAttribute(
                    "paidBills",
                    paidBills
            );

            request.getRequestDispatcher(
                    "/cashier/dashboard.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "pendingBills",
                    0
            );

            request.setAttribute(
                    "todayPayments",
                    0
            );

            request.setAttribute(
                    "todayRevenue",
                    BigDecimal.ZERO
            );

            request.setAttribute(
                    "paidBills",
                    0
            );

            request.setAttribute(
                    "dashboardError",
                    "Unable to load cashier dashboard statistics."
            );

            request.getRequestDispatcher(
                    "/cashier/dashboard.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}