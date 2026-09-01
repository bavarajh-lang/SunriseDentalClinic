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

@WebServlet("/cashier/Receipts")
public class ReceiptsServlet extends HttpServlet {

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
                    "Only cashiers can access receipts."
            );

            return;
        }

        try {

            PaymentDAO paymentDAO =
                    new PaymentDAO();

            List<Payment> receipts =
                    paymentDAO.getSuccessfulPayments();

            request.setAttribute(
                    "receipts",
                    receipts
            );

            request.getRequestDispatcher(
                    "/cashier/receipts.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "receiptsError",
                    "Unable to load payment receipts."
            );

            request.getRequestDispatcher(
                    "/cashier/receipts.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}