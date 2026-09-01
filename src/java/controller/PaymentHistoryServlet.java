package controller;

import dao.PaymentDAO;
import model.Payment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/cashier/PaymentHistory")
public class PaymentHistoryServlet extends HttpServlet {

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
                    "Only cashiers can access payment history."
            );

            return;
        }

        try {

            PaymentDAO paymentDAO =
                    new PaymentDAO();

            List<Payment> payments =
                    paymentDAO.getSuccessfulPayments();

            request.setAttribute(
                    "payments",
                    payments
            );

            request.getRequestDispatcher(
                    "/cashier/payment-history.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "paymentHistoryError",
                    "Unable to load payment history."
            );

            request.getRequestDispatcher(
                    "/cashier/payment-history.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}