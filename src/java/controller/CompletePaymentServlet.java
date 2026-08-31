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

@WebServlet("/cashier/CompletePayment")
public class CompletePaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
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
                    "Only cashiers can complete payments."
            );

            return;
        }

        String billIdValue =
                request.getParameter("billId");

        String method =
                request.getParameter("method");

        String reference =
                request.getParameter("reference");

        int billId;

        try {

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

            billId =
                    Integer.parseInt(
                            billIdValue.trim()
                    );

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

        if (method == null
                || method.trim().isEmpty()) {

            setError(
                    session,
                    "Please select a payment method."
            );

            redirectPaymentPage(
                    request,
                    response,
                    billId
            );

            return;
        }

        method =
                method.trim()
                        .toUpperCase();

        if (!"CASH".equals(method)
                && !"CARD".equals(method)
                && !"BANK_TRANSFER".equals(method)) {

            setError(
                    session,
                    "Invalid payment method selected."
            );

            redirectPaymentPage(
                    request,
                    response,
                    billId
            );

            return;
        }

        if (!"CASH".equals(method)) {

            if (reference == null
                    || reference.trim().isEmpty()) {

                setError(
                        session,
                        "Payment reference is required for "
                        + formatMethod(method)
                        + " payments."
                );

                redirectPaymentPage(
                        request,
                        response,
                        billId
                );

                return;
            }
        }

        if (reference != null) {

            reference =
                    reference.trim();

            if (reference.length() > 100) {

                setError(
                        session,
                        "Payment reference cannot exceed 100 characters."
                );

                redirectPaymentPage(
                        request,
                        response,
                        billId
                );

                return;
            }
        }

        try {

            int cashierUserId =
                    (Integer) session.getAttribute(
                            "userId"
                    );

            PaymentDAO paymentDAO =
                    new PaymentDAO();

            Payment payment =
                    paymentDAO.processPayment(
                            billId,
                            cashierUserId,
                            method,
                            reference
                    );

            if (payment == null) {

                setError(
                        session,
                        "Payment could not be completed. "
                        + "The bill may already be paid, "
                        + "the cashier account may be inactive, "
                        + "or the payment information may be invalid."
                );

                redirectPaymentPage(
                        request,
                        response,
                        billId
                );

                return;
            }

            session.setAttribute(
                    "paymentSuccess",
                    "Payment completed successfully."
            );

            session.setAttribute(
                    "completedPaymentId",
                    payment.getPaymentId()
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/cashier/Receipt?billId="
                    + payment.getBillId()
            );

        } catch (Exception e) {

            e.printStackTrace();

            setError(
                    session,
                    "Something went wrong while processing the payment."
            );

            redirectPaymentPage(
                    request,
                    response,
                    billId
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


    private void redirectPaymentPage(
            HttpServletRequest request,
            HttpServletResponse response,
            int billId)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/cashier/ProcessPayment?billId="
                + billId
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


    private String formatMethod(
            String method) {

        if ("BANK_TRANSFER".equals(method)) {

            return "bank transfer";
        }

        if ("CARD".equals(method)) {

            return "card";
        }

        return "cash";
    }
}