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

import java.io.IOException;

@WebServlet("/DigitalReceipt")
public class DigitalReceiptServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String token =
                request.getParameter("token");

        if (token == null
                || token.trim().isEmpty()) {

            request.setAttribute(
                    "digitalReceiptError",
                    "Invalid or missing receipt token."
            );

            request.getRequestDispatcher(
                    "/digital-receipt.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }

        token =
                token.trim();

        if (token.length() > 100) {

            request.setAttribute(
                    "digitalReceiptError",
                    "Invalid receipt token."
            );

            request.getRequestDispatcher(
                    "/digital-receipt.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }

        try {

            BillDAO billDAO =
                    new BillDAO();

            Bill bill =
                    billDAO.getPaidBillByQrToken(
                            token
                    );

            if (bill == null) {

                request.setAttribute(
                        "digitalReceiptError",
                        "This digital receipt is invalid, unavailable, or the bill has not been paid."
                );

                request.getRequestDispatcher(
                        "/digital-receipt.jsp"
                ).forward(
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
                                    bill.getBillId()
                            );

            if (payment == null) {

                request.setAttribute(
                        "digitalReceiptError",
                        "Payment information could not be verified for this receipt."
                );

                request.getRequestDispatcher(
                        "/digital-receipt.jsp"
                ).forward(
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

            request.setAttribute(
                    "receiptVerified",
                    true
            );

            request.getRequestDispatcher(
                    "/digital-receipt.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "digitalReceiptError",
                    "Unable to load the digital receipt."
            );

            request.getRequestDispatcher(
                    "/digital-receipt.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}