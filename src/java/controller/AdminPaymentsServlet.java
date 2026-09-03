package controller;

import dao.AdminPaymentDAO;
import model.Payment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/Payments")
public class AdminPaymentsServlet extends HttpServlet {

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
                    "Only administrators can access payment management."
            );

            return;
        }

        String search =
                request.getParameter(
                        "search"
                );

        String method =
                request.getParameter(
                        "method"
                );

        String paymentDate =
                request.getParameter(
                        "paymentDate"
                );

        if (search != null) {
            search = search.trim();
        }

        if (method != null) {
            method = method.trim();
        }

        if (paymentDate != null) {
            paymentDate = paymentDate.trim();
        }

        try {

            AdminPaymentDAO paymentDAO =
                    new AdminPaymentDAO();

            List<Payment> payments =
                    paymentDAO.getPayments(
                            search,
                            method,
                            paymentDate
                    );

            int successfulPayments =
                    paymentDAO.getSuccessfulPaymentsCount();

            int todayPayments =
                    paymentDAO.getTodayPaymentsCount();

            BigDecimal totalRevenue =
                    paymentDAO.getTotalRevenue();

            BigDecimal todayRevenue =
                    paymentDAO.getTodayRevenue();

            request.setAttribute(
                    "payments",
                    payments
            );

            request.setAttribute(
                    "successfulPayments",
                    successfulPayments
            );

            request.setAttribute(
                    "todayPayments",
                    todayPayments
            );

            request.setAttribute(
                    "totalRevenue",
                    totalRevenue
            );

            request.setAttribute(
                    "todayRevenue",
                    todayRevenue
            );

            request.setAttribute(
                    "search",
                    search != null
                    ? search
                    : ""
            );

            request.setAttribute(
                    "selectedMethod",
                    method != null
                    ? method
                    : ""
            );

            request.setAttribute(
                    "selectedDate",
                    paymentDate != null
                    ? paymentDate
                    : ""
            );

            request.getRequestDispatcher(
                    "/admin/payments.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "paymentError",
                    "Unable to load payment information."
            );

            request.setAttribute(
                    "payments",
                    new ArrayList<Payment>()
            );

            request.setAttribute(
                    "successfulPayments",
                    0
            );

            request.setAttribute(
                    "todayPayments",
                    0
            );

            request.setAttribute(
                    "totalRevenue",
                    BigDecimal.ZERO
            );

            request.setAttribute(
                    "todayRevenue",
                    BigDecimal.ZERO
            );

            request.setAttribute(
                    "search",
                    search != null
                    ? search
                    : ""
            );

            request.setAttribute(
                    "selectedMethod",
                    method != null
                    ? method
                    : ""
            );

            request.setAttribute(
                    "selectedDate",
                    paymentDate != null
                    ? paymentDate
                    : ""
            );

            request.getRequestDispatcher(
                    "/admin/payments.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}