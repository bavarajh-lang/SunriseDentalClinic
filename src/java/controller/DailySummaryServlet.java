package controller;

import dao.DailySummaryDAO;
import model.Payment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/cashier/DailySummary")
public class DailySummaryServlet extends HttpServlet {

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
                    "Only cashiers can access the daily summary."
            );

            return;
        }

        try {

            DailySummaryDAO dailySummaryDAO =
                    new DailySummaryDAO();

            int todayPayments =
                    dailySummaryDAO.getTodayPaymentsCount();

            BigDecimal todayRevenue =
                    dailySummaryDAO.getTodayRevenue();

            BigDecimal cashTotal =
                    dailySummaryDAO.getTodayCashTotal();

            BigDecimal cardTotal =
                    dailySummaryDAO.getTodayCardTotal();

            BigDecimal bankTransferTotal =
                    dailySummaryDAO.getTodayBankTransferTotal();

            List<Payment> payments =
                    dailySummaryDAO.getTodayPayments();

            request.setAttribute(
                    "todayPayments",
                    todayPayments
            );

            request.setAttribute(
                    "todayRevenue",
                    todayRevenue
            );

            request.setAttribute(
                    "cashTotal",
                    cashTotal
            );

            request.setAttribute(
                    "cardTotal",
                    cardTotal
            );

            request.setAttribute(
                    "bankTransferTotal",
                    bankTransferTotal
            );

            request.setAttribute(
                    "payments",
                    payments
            );

            request.getRequestDispatcher(
                    "/cashier/daily-summary.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "todayPayments",
                    0
            );

            request.setAttribute(
                    "todayRevenue",
                    BigDecimal.ZERO
            );

            request.setAttribute(
                    "cashTotal",
                    BigDecimal.ZERO
            );

            request.setAttribute(
                    "cardTotal",
                    BigDecimal.ZERO
            );

            request.setAttribute(
                    "bankTransferTotal",
                    BigDecimal.ZERO
            );

            request.setAttribute(
                    "dailySummaryError",
                    "Unable to load today's payment summary."
            );

            request.getRequestDispatcher(
                    "/cashier/daily-summary.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}