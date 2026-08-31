package controller;

import dao.BillDAO;
import dao.PaymentDAO;

import model.Bill;
import model.Payment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/cashier/Receipt")
public class ReceiptServlet extends HttpServlet {

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
                    "Only cashiers can access payment receipts."
            );

            return;
        }

        String billIdValue =
                request.getParameter("billId");

        if (billIdValue == null
                || billIdValue.trim().isEmpty()) {

            setError(
                    session,
                    "Invalid bill selected."
            );

            redirectPendingBills(
                    request,
                    response
            );

            return;
        }

        int billId;

        try {

            billId =
                    Integer.parseInt(
                            billIdValue.trim()
                    );

        } catch (NumberFormatException e) {

            setError(
                    session,
                    "Invalid bill selected."
            );

            redirectPendingBills(
                    request,
                    response
            );

            return;
        }

        if (billId <= 0) {

            setError(
                    session,
                    "Invalid bill selected."
            );

            redirectPendingBills(
                    request,
                    response
            );

            return;
        }

        try {

            BillDAO billDAO =
                    new BillDAO();

            Bill bill =
                    billDAO.getBillById(
                            billId
                    );

            if (bill == null) {

                setError(
                        session,
                        "The selected bill could not be found."
                );

                redirectPendingBills(
                        request,
                        response
                );

                return;
            }

            if (!"PAID".equals(
                    bill.getPaymentStatus())) {

                setError(
                        session,
                        "A receipt cannot be issued because this bill has not been fully paid."
                );

                redirectPendingBills(
                        request,
                        response
                );

                return;
            }

            PaymentDAO paymentDAO =
                    new PaymentDAO();

            Payment payment =
                    paymentDAO
                            .getSuccessfulPaymentByBillId(
                                    billId
                            );

            if (payment == null) {

                setError(
                        session,
                        "Successful payment information could not be found for this bill."
                );

                redirectPendingBills(
                        request,
                        response
                );

                return;
            }

            request.setAttribute(
                    "bill",
                    bill
            );

            request.setAttribute(
                    "payment",
                    payment
            );

            request.getRequestDispatcher(
                    "/cashier/receipt.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            setError(
                    session,
                    "Unable to load the payment receipt."
            );

            redirectPendingBills(
                    request,
                    response
            );
        }
    }


    private void setError(
            HttpSession session,
            String message) {

        session.setAttribute(
                "paymentError",
                message
        );
    }


    private void redirectPendingBills(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/cashier/PendingBills"
        );
    }
}